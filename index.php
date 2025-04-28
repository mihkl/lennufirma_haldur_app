<?php
session_start(); // Start session FIRST
require_once __DIR__ . '/db_connect.php';
require_once __DIR__ . '/functions.php'; // Assumed to contain fetchDropdownData, redirect, log_error, etc.

$pdo = getDbConnection();

if (!$pdo) {
    log_error("Database connection failed. Check configuration.");
    $message = ['type' => 'error', 'text' => 'Database connection error. The application cannot function.'];
    // Consider a dedicated error view if 'views/db_error_page.php' exists
    echo "<div class='message error'>Database connection error. Please check server logs.</div>";
    exit;
}

// Get messages, errors, and old input from session, then clear them
$message = $_SESSION['message'] ?? null;
$errors = $_SESSION['errors'] ?? [];
$oldInput = $_SESSION['old_input'] ?? [];
unset($_SESSION['message'], $_SESSION['errors'], $_SESSION['old_input']);

// Determine the action from request, default to 'view_flights'
$action = $_REQUEST['action'] ?? 'view_flights';

// --- Data Fetching for Forms & Views ---
$airports = $aircraft_types = $aircraft = $employees = $employee_roles = [];
$crud_data = null; // For holding data of a single flight being managed/viewed
$list_data = []; // For holding lists (e.g., list of flights, list of crew)
$validation_context = [];

try {
    // --- Fetch Dropdown Data Needed for Flight Operations ---
    // These functions are assumed to exist based on the simplified SQL script's sample data section
    $airports = fetchDropdownData($pdo, 'fn_lennujaam_read_all', 'kood', 'nimi'); // Needs function in DB
    $aircraft_types = fetchDropdownData($pdo, 'fn_lennukituup_read_all', 'lennukituup_kood', 'nimetus'); // Needs function in DB
    $aircraft = fetchDropdownData($pdo, 'fn_lennuk_read_all', 'registreerimisnumber', 'registreerimisnumber'); // Needs function in DB
    $employees = fetchDropdownData($pdo, 'fn_tootaja_read_active', 'isik_id', null, function($row) { // Needs function in DB
        return trim(($row['eesnimi'] ?? '') . ' ' . ($row['perenimi'] ?? '')) . " (ID: {$row['isik_id']})";
    });
    $employee_roles = fetchDropdownData($pdo, 'fn_tootaja_roll_read_all', 'roll_kood', 'nimetus'); // Needs function in DB

    // --- Populate Validation Context (Reduced) ---
    $validation_context = [
        'airport_codes' => array_keys($airports),
        'aircraft_type_codes' => array_keys($aircraft_types),
        'aircraft_reg_numbers' => array_keys($aircraft),
        'employee_ids' => array_keys($employees),
        'employee_role_codes' => array_keys($employee_roles),
        // Removed contexts for entities no longer managed via CRUD
    ];

    // --- Fetch Data for Specific Flight Record ---
    $flight_code = $_GET['flight_code'] ?? $_POST['lennu_kood'] ?? null; // Consolidate getting flight code

    // Actions operating on a specific flight
    $flight_actions = ['modify_flight', 'view_flight_details', 'delete_flight', 'manage_flights', 'manage_staffing'];

    if ($flight_code !== null && in_array($action, $flight_actions)) {
        // Fetch flight details
        $stmt = $pdo->prepare("SELECT * FROM lennufirma.fn_lend_read_by_kood(?)"); // Needs function in DB
        $stmt->execute([$flight_code]);
        $crud_data = $stmt->fetch(PDO::FETCH_ASSOC);

        // If managing staffing, fetch current crew
        if ($crud_data && $action === 'manage_staffing') {
            $stmt_crew = $pdo->prepare("SELECT * FROM lennufirma.fn_lend_read_tootajad(?)"); // Needs function in DB
            $stmt_crew->execute([$flight_code]);
            $list_data['crew'] = $stmt_crew->fetchAll(PDO::FETCH_ASSOC);
        }

        if (!$crud_data && !in_array($action, ['register_flight'])) { // Check if data expected but not found
             log_error("Flight record not found for action '{$action}' with flight_code '{$flight_code}'");
             $message = ['type' => 'error', 'text' => 'The requested flight record could not be found.'];
             $action = 'view_flights'; // Redirect to list view if specific flight not found
             $flight_code = null; // Clear identifier
        }
    }

    // --- Fetch List Data (Only Flights) ---
    if ($action === 'view_flights' && $flight_code === null) { // Only fetch list if viewing all flights
         $stmt_list = $pdo->query("SELECT * FROM lennufirma.fn_lend_read_all()"); // Needs function in DB
         $list_data = $stmt_list ? $stmt_list->fetchAll(PDO::FETCH_ASSOC) : [];
         if (empty($list_data) && $stmt_list === false) {
             log_error("Failed to execute query to fetch list for action '{$action}'.");
             $message = ['type' => 'warning', 'text' => "Could not load {$action} list."];
         }
    }

} catch (PDOException $e) {
    log_error("Database Error: " . $e->getMessage() . " Code: " . $e->getCode());
    $message = ['type' => 'error', 'text' => 'A database error occurred during data fetching. Please check the logs.'];
    // Optionally include a more user-friendly error page or message
} catch (Exception $e) {
    log_error("General Error: " . $e->getMessage());
    $message = ['type' => 'error', 'text' => 'An unexpected error occurred. Please try again later.'];
}

// --- Action Handling (POST requests) ---
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $post_action = $_POST['action'] ?? '';
    $post_data = $_POST;

    // Define redirect URLs for validation errors or success
    // Simplified map focusing on flight actions
    $action_map = [
        'do_register_flight' => '?action=register_flight',
        'do_modify_flight' => '?action=modify_flight&flight_code=' . urlencode($post_data['kood'] ?? ''), // 'kood' is used in modify form
        'do_cancel_flight' => '?action=manage_flights&flight_code=' . urlencode($post_data['lennu_kood'] ?? ''),
        'do_delay_flight' => '?action=manage_flights&flight_code=' . urlencode($post_data['lennu_kood'] ?? ''),
        'do_delete_flight' => '?action=view_flights', // Redirect to list after delete
        'do_assign_aircraft' => '?action=manage_flights&flight_code=' . urlencode($post_data['lennu_kood'] ?? ''),
        'do_add_employee' => '?action=manage_staffing&flight_code=' . urlencode($post_data['lennu_kood'] ?? ''),
        'do_remove_employee' => '?action=manage_staffing&flight_code=' . urlencode($post_data['lennu_kood'] ?? ''),
    ];
    $redirect_on_error = $_SERVER['PHP_SELF'] . ($action_map[$post_action] ?? '?action=view_flights');
    $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=view_flights'; // Default success redirect

    if (!empty($errors)) {
        // Redirect back with errors and old input
        redirect($redirect_on_error, null, $errors, $post_data);
    }

    // Proceed with database operation if validation passes
    try {
        $pdo->beginTransaction();
        $success_message = "Operation completed successfully.";

        switch ($post_action) {
            case 'do_register_flight': // OP1
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op1_registreeri_lend(?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([
                    $post_data['kood'],
                    $post_data['lahtelennujaam_kood'],
                    $post_data['sihtlennujaam_kood'],
                    $post_data['eeldatav_lahkumis_aeg'], // Ensure name matches form and DB function
                    $post_data['eeldatav_saabumis_aeg'], // Ensure name matches form and DB function
                    empty($post_data['lennukituup_kood']) ? null : $post_data['lennukituup_kood'],
                    empty($post_data['lennuk_reg_nr']) ? null : $post_data['lennuk_reg_nr']
                ]);
                $new_kood = $stmt->fetchColumn();
                $success_message = "Flight '{$new_kood}' successfully registered.";
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=view_flights';
                break;

            case 'do_cancel_flight': // OP3
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op3_tuhista_lend(?, ?)");
                $stmt->execute([$post_data['lennu_kood'], $post_data['pohjus']]);
                $success_message = "Flight '{$post_data['lennu_kood']}' canceled.";
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($post_data['lennu_kood']);
                break;

            case 'do_delay_flight': // OP4
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op4_maara_hilinenuks(?, ?, ?)");
                $stmt->execute([
                    $post_data['lennu_kood'],
                    $post_data['uus_lahkumis_aeg'], // Ensure name matches form and DB function
                    $post_data['uus_saabumis_aeg']  // Ensure name matches form and DB function
                ]);
                $success_message = "Flight '{$post_data['lennu_kood']}' marked as delayed.";
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($post_data['lennu_kood']);
                break;

            case 'do_delete_flight': // OP13
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op13_kustuta_lend(?)");
                $stmt->execute([$post_data['lennu_kood']]);
                $deleted = $stmt->fetchColumn();
                if ($deleted) {
                    $success_message = "Flight '{$post_data['lennu_kood']}' deleted.";
                } else {
                    // The function raises an exception on failure, so this might not be reached
                    // unless the function is changed to return false instead of raising error.
                    throw new Exception("Flight '{$post_data['lennu_kood']}' could not be deleted (conditions not met or already deleted).");
                }
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=view_flights';
                break;

            case 'do_modify_flight': // OP14
                $stmt = $pdo->prepare("SELECT * FROM lennufirma.fn_op14_muuda_lendu(?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([
                    $post_data['kood'], // Original flight code
                    empty($post_data['uus_lahkumis_aeg']) ? null : $post_data['uus_lahkumis_aeg'],
                    empty($post_data['uus_saabumis_aeg']) ? null : $post_data['uus_saabumis_aeg'],
                    empty($post_data['uus_lennukituup_kood']) ? null : $post_data['uus_lennukituup_kood'],
                    empty($post_data['uus_lennuk_reg_nr']) ? null : $post_data['uus_lennuk_reg_nr'],
                    empty($post_data['uus_sihtlennujaam_kood']) ? null : $post_data['uus_sihtlennujaam_kood'],
                    empty($post_data['uus_lahtelennujaam_kood']) ? null : $post_data['uus_lahtelennujaam_kood']
                ]);
                $updated_flight = $stmt->fetch(); // Fetch the returned updated record
                if (!$updated_flight) {
                     throw new Exception("Failed to update flight '{$post_data['kood']}'. Function did not return data.");
                }
                $success_message = "Flight '{$post_data['kood']}' data updated.";
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($post_data['kood']);
                break;

            case 'do_assign_aircraft': // OP18
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op18_maara_lennuk_lennule(?, ?)");
                $stmt->execute([$post_data['lennu_kood'], $post_data['lennuk_reg_nr']]);
                $success_message = "Aircraft '{$post_data['lennuk_reg_nr']}' assigned to flight '{$post_data['lennu_kood']}'.";
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($post_data['lennu_kood']);
                break;

            case 'do_add_employee': // OP16
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op16_lisa_tootaja_lennule(?, ?, ?)");
                $stmt->execute([
                    $post_data['lennu_kood'],
                    $post_data['tootaja_isik_id'],
                    $post_data['rolli_kood']
                ]);
                $assignment_id = $stmt->fetchColumn();
                if ($assignment_id === false) { // Check if function failed (might raise exception instead)
                     throw new Exception("Failed to add employee to flight '{$post_data['lennu_kood']}'.");
                }
                $success_message = "Employee (ID: {$post_data['tootaja_isik_id']}) added to flight '{$post_data['lennu_kood']}' in role '{$post_data['rolli_kood']}'.";
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=manage_staffing&flight_code=' . urlencode($post_data['lennu_kood']);
                break;

            case 'do_remove_employee': // OP17
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op17_eemalda_tootaja_lennult(?, ?)");
                $stmt->execute([$post_data['lennu_kood'], $post_data['tootaja_isik_id']]);
                $removed = $stmt->fetchColumn();
                if ($removed) {
                    $success_message = "Employee (ID: {$post_data['tootaja_isik_id']}) removed from flight '{$post_data['lennu_kood']}'.";
                } else {
                    // Function raises WARNING on failure but returns false. We catch it here.
                    // Or it might raise an exception if conditions aren't met.
                    $success_message = "Employee (ID: {$post_data['tootaja_isik_id']}) was not found on flight '{$post_data['lennu_kood']}' or could not be removed.";
                    // Redirect with a warning message instead of success
                    $pdo->commit(); // Commit even if warning occurred
                    redirect(
                        $_SERVER['PHP_SELF'] . '?action=manage_staffing&flight_code=' . urlencode($post_data['lennu_kood']),
                        ['type' => 'warning', 'text' => $success_message]
                    );
                    exit; // Stop further processing
                }
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=manage_staffing&flight_code=' . urlencode($post_data['lennu_kood']);
                break;

            default:
                throw new Exception('Unknown POST action: ' . htmlspecialchars($post_action));
        }

        $pdo->commit();
        redirect($redirect_on_success, ['type' => 'success', 'text' => $success_message]);

    } catch (Exception $e) {
        $pdo->rollBack();
        // Log the detailed error
        log_error("Database Operation Error ({$post_action}): " . $e->getMessage() . " | SQLSTATE: " . ($e instanceof PDOException ? $e->getCode() : 'N/A') . " | Trace: " . $e->getTraceAsString());

        // Provide a user-friendly message, potentially extracting info from PDOException
        $error_text = 'An error occurred during the operation.';
        if ($e instanceof PDOException && $e->errorInfo[1] == 7) { // Check for PostgreSQL RAISE EXCEPTION (SQLSTATE P0001) or NOTICE (01P01) etc.
            // Extract the message from the PostgreSQL error string if possible
            preg_match('/DETAIL:\s*(.*)/', $e->getMessage(), $matches_detail);
            preg_match('/HINT:\s*(.*)/', $e->getMessage(), $matches_hint);
            preg_match('/ERROR:\s*(.*)\s*CONTEXT:/s', $e->getMessage(), $matches_error); // More robust extraction
             $db_message = $matches_error[1] ?? $matches_detail[1] ?? $e->getMessage();
             $db_hint = $matches_hint[1] ?? null;
            $error_text = "Database error: " . htmlspecialchars(trim($db_message));
             if ($db_hint) {
                 $error_text .= " Hint: " . htmlspecialchars(trim($db_hint));
             }
        } else {
            // Generic error for other exception types
            $error_text = 'An unexpected application error occurred: ' . htmlspecialchars($e->getMessage());
        }

        redirect($redirect_on_error, ['type' => 'error', 'text' => $error_text], null, $post_data);
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Airline Flight Management</title>
    <link rel="stylesheet" href="style.css"> </head>
<body>
    <h1>Airline Flight Management</h1>

    <?php if ($message): ?>
        <div class="message <?= htmlspecialchars($message['type']) ?>">
            <?= htmlspecialchars($message['text']) ?>
        </div>
    <?php endif; ?>

    <nav>
        <ul>
            <li><a href="?action=view_flights">View Flights</a></li>
            <li><a href="?action=register_flight">Register New Flight</a></li>
            </ul>
    </nav>

    <div class="container">
        <?php
        // Pass necessary variables to the views
        $formErrors = $errors;
        $formOldInput = $oldInput;
        $flightData = $crud_data; // Specific flight data for modify/manage views
        $flightsList = ($action === 'view_flights') ? $list_data : []; // List of all flights
        $crewList = $list_data['crew'] ?? []; // Crew list for staffing view

        // Load the appropriate view based on the action
        // Simplified switch statement
        switch ($action) {
            case 'register_flight':
                // Pass necessary dropdown data to the registration form
                include 'register_flight_form.php'; // Assumes this view exists
                break;
            case 'manage_flights':
                // Pass flight data and dropdowns for assigning aircraft, delaying, canceling
                if ($flightData) {
                    include 'manage_flights_view.php'; // Assumes this view exists
                } else {
                     echo "<p>Select a flight to manage from the <a href='?action=view_flights'>flight list</a>.</p>";
                     // Or include a search/selection form here
                }
                break;
            case 'manage_staffing':
                // Pass flight data, crew list, and employee/role dropdowns
                 if ($flightData) {
                    include 'manage_staffing_view.php'; // Assumes this view exists
                 } else {
                     echo "<p>Select a flight to manage staffing from the <a href='?action=view_flights'>flight list</a>.</p>";
                 }
                break;
            case 'modify_flight':
                // Pass flight data and dropdowns for modification
                 if ($flightData) {
                    include 'flight_modify_form.php'; // Assumes this view exists
                 } else {
                     echo "<p>Select a flight to modify from the <a href='?action=view_flights'>flight list</a>.</p>";
                 }
                break;
            case 'view_flights':
            default: // Default action
                // Pass the list of flights to the table view
                include 'view_flights_table.php'; // Assumes this view exists
                break;
        }
        ?>
    </div>
</body>
</html>
