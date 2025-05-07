<?php
session_start(); // Start session FIRST
require_once __DIR__ . '/db_connect.php';
require_once __DIR__ . '/functions.php'; // Assumed to contain fetchDropdownData, redirect, log_error, etc.

// Check login status from SESSION
$is_logged_in = $_SESSION['is_logged_in'] ?? false;

// Process client-side login submission
if (isset($_POST['login_submit'])) {
    $_SESSION['is_logged_in'] = true;
    header('Location: ' . $_SERVER['PHP_SELF']);
    exit;
}

// Handle logout
if (isset($_GET['logout'])) {
    $_SESSION['is_logged_in'] = false;
    header('Location: ' . $_SERVER['PHP_SELF']);
    exit;
}

// If not logged in, show login form and exit
if (!$is_logged_in) {
    // Display login page
    include_login_form();
    exit;
}

// Continue with the original application logic if logged in
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
// Use filter parameters from GET if present for view_flights action
$action = $_GET['action'] ?? $_POST['action'] ?? 'view_flights';

// --- Data Fetching for Forms & Views ---
$airports = $aircraft_types = $aircraft = $employees = $employee_roles = [];
$crud_data = null; // For holding data of a single flight being managed/viewed
$list_data = []; // For holding lists (e.g., list of flights, list of crew)
$validation_context = [];

try {
    // --- Fetch Dropdown Data Needed for Flight Operations ---
    $airports = fetchDropdownData($pdo, 'fn_lennujaam_read_all', 'lennujaam_kood', 'lj_nimetus');
    $aircraft_types = fetchDropdownData($pdo, 'fn_lennukituup_read_all', 'lennukituup_kood', 'lt_nimetus');
    $aircraft = fetchDropdownData($pdo, 'fn_lennuk_read_all', 'registreerimisnumber', 'registreerimisnumber');
    $employees = fetchDropdownData($pdo, 'fn_tootaja_read_active', 'isik_id', null, function($row) {
        return ($row['eesnimi'] ?? '') . ' ' . ($row['perenimi'] ?? '') . ' ' . ($row['e_meil'] ?? '');
    });
    
    $employee_roles = fetchDropdownData($pdo, 'fn_tootaja_roll_read_all', 'r_kood', 'tr_nimetus');

    // --- Populate Validation Context (Reduced) ---
    $validation_context = [
        'airport_codes' => array_keys($airports),
        'aircraft_type_codes' => array_keys($aircraft_types),
        'aircraft_reg_numbers' => array_keys($aircraft),
        'employee_ids' => array_keys($employees),
        'employee_role_codes' => array_keys($employee_roles),
    ];

    // --- Fetch Data for Specific Flight Record ---
    $flight_code = $_GET['flight_code'] ?? $_POST['lend_kood'] ?? $_POST['lend_kood'] ?? null; // Consolidate getting flight code

    // Actions operating on a specific flight
    $flight_actions = ['modify_flight', 'view_flight_details', 'delete_flight', 'manage_flights', 'manage_staffing'];

    if ($flight_code !== null && in_array($action, $flight_actions)) {
        // *** MODIFICATION START: Fetch single flight details AND booking count ***
        $sql_single_flight = "SELECT
                                l.*, -- Select all columns from lend table
                                lt.maksimaalne_reisijate_arv,
                                COUNT(b.broneering_id) FILTER (WHERE b.seisund_kood = 'ACTIVE') AS booked_count -- Count only active bookings
                            FROM lennufirma.lend l
                            -- Join to get max passengers (might be on lennuk or lennukituup)
                            LEFT JOIN lennufirma.lennuk ln ON l.lennuk_reg_nr = ln.registreerimisnumber
                            LEFT JOIN lennufirma.lennukituup lt ON COALESCE(ln.lennukituup_kood, l.lennukituup_kood) = lt.lennukituup_kood
                            -- Join with bookings table to count
                            LEFT JOIN lennufirma.broneering b ON l.lend_kood = b.lend_kood
                            WHERE l.lend_kood = :flight_code -- Filter by the specific flight code
                            GROUP BY l.lend_kood, lt.maksimaalne_reisijate_arv -- Group by flight code and max passengers
                            "; // Grouping by PK implicitly groups by all columns of l
        $stmt = $pdo->prepare($sql_single_flight);
        $stmt->bindParam(':flight_code', $flight_code);
        $stmt->execute();
        $crud_data = $stmt->fetch(PDO::FETCH_ASSOC);
        // *** MODIFICATION END ***

        // If managing staffing, fetch current crew (keep this logic)
        if ($crud_data && $action === 'manage_staffing') {
            // Assuming fn_lend_read_tootajad exists or use a direct query:
             $stmt_crew = $pdo->prepare("SELECT i.isik_id, i.e_meil, i.eesnimi, i.perenimi, tr.tr_nimetus as rolli_nimetus
                                        FROM lennufirma.tootaja_lennus tl
                                        JOIN lennufirma.isik i ON tl.tootaja_isik_id = i.isik_id
                                        JOIN lennufirma.tootaja_roll tr ON tl.r_kood = tr.r_kood
                                        WHERE tl.lend_kood = :flight_code");
            $stmt_crew->bindParam(':flight_code', $flight_code);
            $stmt_crew->execute();
            $list_data['crew'] = $stmt_crew->fetchAll(PDO::FETCH_ASSOC);
        }

        if (!$crud_data && !in_array($action, ['register_flight'])) { // Check if data expected but not found
             log_error("Flight record not found for action '{$action}' with flight_code '{$flight_code}'");
             $_SESSION['message'] = ['type' => 'error', 'text' => 'The requested flight record could not be found.']; // Use session for redirect
             redirect($_SERVER['PHP_SELF'] . '?action=view_flights'); // Redirect to list view
        }
    }

   // --- Fetch List Data (Only Flights) ---
    // Keep the existing logic for fetching the list for view_flights
    if ($action === 'view_flights' && $flight_code === null) {
        $sql_list = "SELECT
                    l.*,
                    lt.maksimaalne_reisijate_arv,
                    COUNT(b.broneering_id) FILTER (WHERE b.seisund_kood = 'ACTIVE') AS booked_count
                FROM lennufirma.lend l
                LEFT JOIN lennufirma.lennuk ln ON l.lennuk_reg_nr = ln.registreerimisnumber
                LEFT JOIN lennufirma.lennukituup lt ON COALESCE(ln.lennukituup_kood, l.lennukituup_kood) = lt.lennukituup_kood
                LEFT JOIN lennufirma.broneering b ON l.lend_kood = b.lend_kood
                GROUP BY l.lend_kood, lt.maksimaalne_reisijate_arv
                ORDER BY l.eeldatav_lahkumis_aeg DESC";
        $stmt_list = $pdo->query($sql_list);

        $list_data = $stmt_list ? $stmt_list->fetchAll(PDO::FETCH_ASSOC) : [];
        if ($stmt_list === false) {
            log_error("Failed to execute query to fetch flight list for action '{$action}'. PDO Error: " . implode(" - ", $pdo->errorInfo()));
            $message = ['type' => 'warning', 'text' => "Could not load flight list."];
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

     // Perform Validation Here (Example - you would add more comprehensive validation)
     $errors = []; // Reset errors for POST request
     // Example validation (replace with your actual validation logic)
     /*
     if ($post_action === 'do_register_flight' && empty($post_data['kood'])) {
         $errors['kood'] = 'Flight code is required.';
     }
     // ... more validation rules ...
     */


    // Define redirect URLs for validation errors or success
    // Simplified map focusing on flight actions
    $action_map = [
        'do_register_flight' => '?action=register_flight',
        'do_modify_flight' => '?action=modify_flight&flight_code=' . urlencode($post_data['lend_kood'] ?? ''), // 'kood' is used in modify form
        'do_cancel_flight' => '?action=manage_flights&flight_code=' . urlencode($post_data['lend_kood'] ?? ''),
        'do_delay_flight' => '?action=manage_flights&flight_code=' . urlencode($post_data['lend_kood'] ?? ''),
        'do_delete_flight' => '?action=view_flights', // Redirect to list after delete
        'do_assign_aircraft' => '?action=manage_flights&flight_code=' . urlencode($post_data['lend_kood'] ?? ''),
        'do_add_employee' => '?action=manage_staffing&flight_code=' . urlencode($post_data['lend_kood'] ?? ''),
        'do_remove_employee' => '?action=manage_staffing&flight_code=' . urlencode($post_data['lend_kood'] ?? ''),
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
                    $post_data['lend_kood'],
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
                $stmt->execute([$post_data['lend_kood'], $post_data['pohjus']]);
                $success_message = "Flight '{$post_data['lend_kood']}' canceled.";
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($post_data['lend_kood']);
                break;

            case 'do_delay_flight': // OP4
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op4_maara_hilinenuks(?, ?, ?)");
                $stmt->execute([
                    $post_data['lend_kood'],
                    $post_data['uus_lahkumis_aeg'], // Ensure name matches form and DB function
                    $post_data['uus_saabumis_aeg']  // Ensure name matches form and DB function
                ]);
                $success_message = "Flight '{$post_data['lend_kood']}' marked as delayed.";
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($post_data['lend_kood']);
                break;

            case 'do_delete_flight': // OP13
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op13_kustuta_lend(?)");
                $stmt->execute([$post_data['lend_kood']]);
                $deleted = $stmt->fetchColumn();
                if ($deleted) {
                    $success_message = "Flight '{$post_data['lend_kood']}' deleted.";
                } else {
                    // The function raises an exception on failure, so this might not be reached
                    // unless the function is changed to return false instead of raising error.
                    throw new Exception("Flight '{$post_data['lend_kood']}' could not be deleted (conditions not met or already deleted).");
                }
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=view_flights';
                break;

            case 'do_modify_flight': // OP14
                $stmt = $pdo->prepare("SELECT * FROM lennufirma.fn_op14_muuda_lendu(?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([
                    $post_data['lend_kood'], // Original flight code
                    empty($post_data['uus_lahkumis_aeg']) ? null : $post_data['uus_lahkumis_aeg'],
                    empty($post_data['uus_saabumis_aeg']) ? null : $post_data['uus_saabumis_aeg'],
                    empty($post_data['uus_lennukituup_kood']) ? null : $post_data['uus_lennukituup_kood'],
                    empty($post_data['uus_lennuk_reg_nr']) ? null : $post_data['uus_lennuk_reg_nr'],
                    empty($post_data['uus_sihtlennujaam_kood']) ? null : $post_data['uus_sihtlennujaam_kood'],
                    empty($post_data['uus_lahtelennujaam_kood']) ? null : $post_data['uus_lahtelennujaam_kood']
                ]);
                $updated_flight = $stmt->fetch(); // Fetch the returned updated record
                if (!$updated_flight) {
                     throw new Exception("Failed to update flight '{$post_data['lend_kood']}'. Function did not return data.");
                }
                $success_message = "Flight '{$post_data['lend_kood']}' data updated.";
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($post_data['lend_kood']);
                break;

            case 'do_assign_aircraft': // OP18
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op18_maara_lennuk_lennule(?, ?)");
                $stmt->execute([$post_data['lend_kood'], $post_data['lennuk_reg_nr']]);
                $success_message = "Aircraft '{$post_data['lennuk_reg_nr']}' assigned to flight '{$post_data['lend_kood']}'.";
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($post_data['lend_kood']);
                break;

            case 'do_add_employee': // OP16
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op16_lisa_tootaja_lennule(?, ?, ?)");
                $stmt->execute([
                    $post_data['lend_kood'],
                    $post_data['tootaja_isik_id'],
                    $post_data['rolli_kood']
                ]);
                $assignment_id = $stmt->fetchColumn();
                if ($assignment_id === false) { // Check if function failed (might raise exception instead)
                     throw new Exception("Failed to add employee to flight '{$post_data['lend_kood']}'.");
                }
                $success_message = "Employee (ID: {$post_data['tootaja_isik_id']}) added to flight '{$post_data['lend_kood']}' in role '{$post_data['rolli_kood']}'.";
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=manage_staffing&flight_code=' . urlencode($post_data['lend_kood']);
                break;

            case 'do_remove_employee': // OP17
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op17_eemalda_tootaja_lennult(?, ?)");
                $stmt->execute([$post_data['lend_kood'], $post_data['tootaja_isik_id']]);
                $removed = $stmt->fetchColumn();
                if ($removed) {
                    $success_message = "Employee (ID: {$post_data['tootaja_isik_id']}) removed from flight '{$post_data['lend_kood']}'.";
                } else {
                    // Function raises WARNING on failure but returns false. We catch it here.
                    $success_message = "Employee (ID: {$post_data['tootaja_isik_id']}) was not found on flight '{$post_data['lend_kood']}' or could not be removed.";
                    // Redirect with a warning message instead of success
                    $pdo->commit(); // Commit even if warning occurred
                    redirect(
                        $_SERVER['PHP_SELF'] . '?action=manage_staffing&flight_code=' . urlencode($post_data['lend_kood']),
                        ['type' => 'warning', 'text' => $success_message]
                    );
                    exit; // Stop further processing
                }
                $redirect_on_success = $_SERVER['PHP_SELF'] . '?action=manage_staffing&flight_code=' . urlencode($post_data['lend_kood']);
                break;

            default:
                // It's better to check for valid actions earlier, but catchall just in case
                throw new Exception('Unknown or invalid POST action: ' . htmlspecialchars($post_action));
        }

        $pdo->commit();
        redirect($redirect_on_success, ['type' => 'success', 'text' => $success_message]);

    } catch (Exception $e) {
        $pdo->rollBack();
        // Log the detailed error
        log_error("Database Operation Error ({$post_action}): " . $e->getMessage() . " | SQLSTATE: " . ($e instanceof PDOException ? $e->getCode() : 'N/A') . " | Trace: " . $e->getTraceAsString());

        // Provide a user-friendly message, potentially extracting info from PDOException
        $error_text = 'An error occurred during the operation.';
        if ($e instanceof PDOException && $e->errorInfo[1] == 7) { // Check for PostgreSQL RAISE EXCEPTION/NOTICE etc.
             // Extract the message from the PostgreSQL error string if possible
             preg_match('/ERROR:\s*(.*?)\s*(?:DETAIL:|CONTEXT:|$)/s', $e->getMessage(), $matches_error);
             preg_match('/DETAIL:\s*(.*?)\s*(?:HINT:|CONTEXT:|$)/s', $e->getMessage(), $matches_detail);
             preg_match('/HINT:\s*(.*?)\s*(?:CONTEXT:|$)/s', $e->getMessage(), $matches_hint);

             $db_message = $matches_error[1] ?? $matches_detail[1] ?? $e->getMessage(); // Prioritize ERROR message
             $db_hint = $matches_hint[1] ?? null;
             $error_text = "Database error: " . htmlspecialchars(trim(preg_replace('/\s+/', ' ', $db_message))); // Clean whitespace
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

// Function to display login form
function include_login_form() {
    ?>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Airline System Login</title>
        <link rel="stylesheet" href="style.css">
        <style>
            .login-container {
                max-width: 400px;
                margin: 100px auto;
                padding: 20px;
                background-color: #f8f9fa;
                border-radius: 5px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .login-field {
                margin-bottom: 15px;
            }
            .login-field label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            .login-field input {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            .login-error {
                color: red;
                margin-bottom: 15px;
                display: none;
            }
            .login-button {
                background-color: #0EA5E9;
                color: white;
                padding: 10px 15px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
            }
            .login-button:hover {
                background-color: #0B85D1;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <h2>Airline Management System</h2>
            <div id="login-error" class="login-error">Invalid username or password</div>
            <form id="login-form" method="post">
                <div class="login-field">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="login-field">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <button type="submit" name="login_submit" class="login-button">Login</button>
                <!-- Hidden field for client-side auth success -->
                <input type="hidden" id="auth-success" name="login_submit" value="1">
            </form>
        </div>

        <script>
            // Client-side login validation
            document.getElementById('login-form').addEventListener('submit', function(e) {
                e.preventDefault();
                
                const username = document.getElementById('username').value;
                const password = document.getElementById('password').value;
                const errorDiv = document.getElementById('login-error');
                
                // Check against hardcoded credentials
                if (username === 'haldur@email.com' && password === 'haldur') {
                    // Success - submit the form with hidden field
                    this.submit();
                } else {
                    // Show error message
                    errorDiv.style.display = 'block';
                }
            });
        </script>
    </body>
    </html>
    <?php
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

    <!-- Show logout link if logged in -->
    <div class="user-info">
        Logged in as: haldur | <a href="?logout=1">Logout</a>
    </div>

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
        $formErrors = $errors; // Use a more specific name in the view context if preferred
        $formOldInput = $oldInput;
        $flightData = $crud_data; // Specific flight data for modify/manage views

        // Pass the correct list data to the view
        // $list_data fetched above now contains flights with max passengers when $action is 'view_flights'
        $flightsList = ($action === 'view_flights') ? $list_data : []; // Full list for the table view

        $crewList = $list_data['crew'] ?? []; // Crew list for staffing view

        // Load the appropriate view based on the action
        $view_path = null;
        switch ($action) {
            case 'register_flight':
                $view_path = 'register_flight_form.php'; // Standardized path
                break;
            case 'manage_flights':
                if ($flightData) {
                     $view_path = 'manage_flights_view.php'; // Standardized path
                } else {
                    $_SESSION['message'] = ['type' => 'info', 'text' => 'Please select a flight to manage.'];
                    redirect($_SERVER['PHP_SELF'] . '?action=view_flights');
                }
                break;
            case 'manage_staffing':
                 if ($flightData) {
                     $view_path = 'manage_staffing_view.php'; // Standardized path
                 } else {
                     $_SESSION['message'] = ['type' => 'info', 'text' => 'Please select a flight to manage staffing.'];
                     redirect($_SERVER['PHP_SELF'] . '?action=view_flights');
                 }
                break;
            case 'modify_flight':
                 if ($flightData) {
                     $view_path = 'flight_modify_form.php'; // Standardized path
                 } else {
                    $_SESSION['message'] = ['type' => 'info', 'text' => 'Please select a flight to modify.'];
                    redirect($_SERVER['PHP_SELF'] . '?action=view_flights');
                 }
                break;
            case 'view_flights':
            default: // Default action
                 $view_path = 'view_flights_table.php'; // Standardized path
                break;
        }

        // Include the view file if path is set
        if ($view_path && file_exists(__DIR__ . '/' . $view_path)) {
            // Make variables available to the included view file
            // (already done above by defining them in this scope)
            include __DIR__ . '/' . $view_path;
        } elseif($view_path) {
            echo "<div class='message error'>Error: View file not found: " . htmlspecialchars($view_path) . "</div>";
            log_error("View file not found: " . $view_path);
        } elseif(!isset($_SESSION['message'])) { // Avoid showing duplicate errors if redirect message exists
             // This condition might occur if $flightData was expected but not found, and redirect didn't happen
             echo "<div class='message error'>An error occurred determining the correct view.</div>";
             // Optionally redirect to a default page
             // redirect($_SERVER['PHP_SELF'] . '?action=view_flights');
        }

        ?>
    </div>
</body>
</html>