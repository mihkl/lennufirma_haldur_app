<?php
session_start(); // Start session FIRST
require_once __DIR__ . '/includes/db_connect.php';
require_once __DIR__ . '/includes/functions.php';
require_once __DIR__ . '/includes/validation_rules.php';

$pdo = getDbConnection();

if (!$pdo) {
    log_error("Database connection failed. Check configuration.");
    $message = ['type' => 'error', 'text' => 'Database connection error. The application cannot function.'];
    include 'views/db_error_page.php';
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
$airport_statuses = $aircraft_statuses = $aircraft_manufacturers = [];
$employee_statuses = $timezones = $flight_statuses = [];
$hoolduse_seisund = $kliendi_seisund = $litsentsi_seisund = $broneeringu_seisund = [];
$crud_data = null;
$list_data = [];
$validation_context = [];

try {
    // --- Fetch Common Dropdown Data ---
    $airports = fetchDropdownData($pdo, 'fn_lennujaam_read_all', 'kood', 'nimi');
    $aircraft_types = fetchDropdownData($pdo, 'fn_lennukituup_read_all', 'kood', 'nimetus');
    $aircraft = fetchDropdownData($pdo, 'fn_lennuk_read_all', 'registreerimisnumber', 'registreerimisnumber');
    $employees = fetchDropdownData($pdo, 'fn_tootaja_read_active', 'isik_id', null, function($row) {
        return trim(($row['eesnimi'] ?? '') . ' ' . ($row['perenimi'] ?? '')) . " (ID: {$row['isik_id']})";
    });
    $employee_roles = fetchDropdownData($pdo, 'fn_tootaja_roll_read_all', 'kood', 'nimetus');

    // Fetch classifier data
    $airport_statuses = fetchDropdownData($pdo, 'fn_lennujaama_seisund_liik_read_all', 'kood', 'nimetus');
    $aircraft_statuses = fetchDropdownData($pdo, 'fn_lennuki_seisund_liik_read_all', 'kood', 'nimetus');
    $aircraft_manufacturers = fetchDropdownData($pdo, 'fn_lennuki_tootja_read_all', 'kood', 'nimetus');
    $employee_statuses = fetchDropdownData($pdo, 'fn_tootaja_seisund_liik_read_all', 'kood', 'nimetus');
    $timezones = fetchDropdownData($pdo, 'fn_ajavoond_read_all', 'kood', 'kood');
    $flight_statuses = fetchDropdownData($pdo, 'fn_lennu_seisund_liik_read_all', 'kood', 'nimetus');
    $hoolduse_seisund = fetchDropdownData($pdo, 'fn_hoolduse_seisund_liik_read_all', 'kood', 'nimetus');
    $kliendi_seisund = fetchDropdownData($pdo, 'fn_kliendi_seisund_liik_read_all', 'kood', 'nimetus');
    $litsentsi_seisund = fetchDropdownData($pdo, 'fn_litsentsi_seisund_liik_read_all', 'kood', 'nimetus');
    $broneeringu_seisund = fetchDropdownData($pdo, 'fn_broneeringu_seisund_liik_read_all', 'kood', 'nimetus');

    // --- Populate Validation Context ---
    $validation_context = [
        'airport_codes' => array_keys($airports),
        'aircraft_type_codes' => array_keys($aircraft_types),
        'aircraft_reg_numbers' => array_keys($aircraft),
        'employee_ids' => array_keys($employees),
        'employee_role_codes' => array_keys($employee_roles),
        'airport_status_codes' => array_keys($airport_statuses),
        'aircraft_status_codes' => array_keys($aircraft_statuses),
        'aircraft_manufacturer_codes' => array_keys($aircraft_manufacturers),
        'employee_status_codes' => array_keys($employee_statuses),
        'timezone_codes' => array_keys($timezones),
        'flight_status_codes' => array_keys($flight_statuses),
    ];

    // --- Fetch Data for Specific Record ---
    $id = $_GET['id'] ?? null;
    $reg_nr = $_GET['reg_nr'] ?? null;
    $flight_code = $_GET['flight_code'] ?? null;

    $identifier = null;
    if (in_array($action, ['edit_aircraft', 'view_aircraft_details', 'delete_aircraft'])) {
        $identifier = $reg_nr;
    } elseif ($id !== null && in_array($action, [
        'edit_airport', 'view_airport_details', 'delete_airport',
        'edit_aircraft_type', 'view_aircraft_type_details', 'delete_aircraft_type',
        'edit_employee', 'view_employee_details', 'delete_employee',
        'modify_flight', 'view_flight_details', 'delete_flight',
    ])) {
        $identifier = $id;
    } elseif ($flight_code !== null && in_array($action, ['manage_flights', 'manage_staffing'])) {
        $identifier = $flight_code;
    }

    if ($identifier !== null) {
        switch ($action) {
            case 'edit_airport':
            case 'view_airport_details':
            case 'delete_airport':
                $stmt = $pdo->prepare("SELECT * FROM lennufirma.fn_lennujaam_read_by_kood(?)");
                $stmt->execute([$identifier]);
                $crud_data = $stmt->fetch(PDO::FETCH_ASSOC);
                break;
            case 'edit_aircraft_type':
            case 'view_aircraft_type_details':
            case 'delete_aircraft_type':
                $stmt = $pdo->prepare("SELECT * FROM lennufirma.fn_lennukituup_read_by_kood(?)");
                $stmt->execute([$identifier]);
                $crud_data = $stmt->fetch(PDO::FETCH_ASSOC);
                break;
            case 'edit_aircraft':
            case 'view_aircraft_details':
            case 'delete_aircraft':
                $stmt = $pdo->prepare("SELECT * FROM lennufirma.fn_lennuk_read_by_reg_nr(?)");
                $stmt->execute([$identifier]);
                $crud_data = $stmt->fetch(PDO::FETCH_ASSOC);
                break;
            case 'edit_employee':
            case 'view_employee_details':
            case 'delete_employee':
                $stmt = $pdo->prepare("SELECT t.isik_id, t.tootaja_kood, t.seisund_kood,
                                        i.eesnimi, i.perenimi, i.isikukood, i.synni_kp, i.elukoht, i.e_meil, i.on_aktiivne
                                      FROM lennufirma.tootaja t
                                      JOIN lennufirma.isik i ON t.isik_id = i.isik_id
                                      WHERE t.isik_id = ?");
                $stmt->execute([$identifier]);
                $crud_data = $stmt->fetch(PDO::FETCH_ASSOC);
                break;
            case 'modify_flight':
            case 'view_flight_details':
            case 'delete_flight':
                $stmt = $pdo->prepare("SELECT * FROM lennufirma.fn_lend_read_by_kood(?)");
                $stmt->execute([$identifier]);
                $crud_data = $stmt->fetch(PDO::FETCH_ASSOC);
                break;
            case 'manage_flights':
            case 'manage_staffing':
                $stmt = $pdo->prepare("SELECT * FROM lennufirma.fn_lend_read_by_kood(?)");
                $stmt->execute([$identifier]);
                $crud_data = $stmt->fetch(PDO::FETCH_ASSOC);
                if ($action === 'manage_staffing') {
                    $stmt_crew = $pdo->prepare("SELECT * FROM lennufirma.fn_lend_read_tootajad(?)");
                    $stmt_crew->execute([$identifier]);
                    $list_data['crew'] = $stmt_crew->fetchAll(PDO::FETCH_ASSOC);
                }
                break;
        }

        if (!$crud_data && !in_array($action, ['add_airport', 'add_aircraft_type', 'add_aircraft', 'add_employee', 'register_flight'])) {
            log_error("Record not found for action '{$action}' with identifier '{$identifier}'");
            $message = ['type' => 'error', 'text' => 'The requested record could not be found.'];
        }
    }

    // --- Fetch List Data ---
    if (in_array($action, ['view_flights', 'view_airports', 'view_aircraft_types', 'view_aircraft', 'view_employees']) && empty($crud_data)) {
        switch ($action) {
            case 'view_flights':
                $stmt_list = $pdo->query("SELECT * FROM lennufirma.fn_lend_read_all()");
                $list_data = $stmt_list ? $stmt_list->fetchAll(PDO::FETCH_ASSOC) : [];
                break;
            case 'view_airports':
                $stmt_list = $pdo->query("SELECT * FROM lennufirma.fn_lennujaam_read_all()");
                $list_data = $stmt_list ? $stmt_list->fetchAll(PDO::FETCH_ASSOC) : [];
                break;
            case 'view_aircraft_types':
                $stmt_list = $pdo->query("SELECT * FROM lennufirma.fn_lennukituup_read_all()");
                $list_data = $stmt_list ? $stmt_list->fetchAll(PDO::FETCH_ASSOC) : [];
                break;
            case 'view_aircraft':
                $stmt_list = $pdo->query("SELECT * FROM lennufirma.fn_lennuk_read_all()");
                $list_data = $stmt_list ? $stmt_list->fetchAll(PDO::FETCH_ASSOC) : [];
                break;
            case 'view_employees':
                $stmt_list = $pdo->query("SELECT t.isik_id, t.tootaja_kood, t.seisund_kood,
                                         i.eesnimi, i.perenimi, i.e_meil
                                  FROM lennufirma.tootaja t
                                  JOIN lennufirma.isik i ON t.isik_id = i.isik_id
                                  ORDER BY i.perenimi, i.eesnimi");
                $list_data = $stmt_list ? $stmt_list->fetchAll(PDO::FETCH_ASSOC) : [];
                break;
        }
        if (empty($list_data) && $stmt_list === false) {
            log_error("Failed to execute query to fetch list for action '{$action}'.");
            $message = ['type' => 'warning', 'text' => "Could not load {$action} list."];
        }
    }

} catch (PDOException $e) {
    log_error("Database Error: " . $e->getMessage() . " Code: " . $e->getCode());
    $message = ['type' => 'error', 'text' => 'A database error occurred. Please check the logs or contact support.'];
} catch (Exception $e) {
    log_error("General Error: " . $e->getMessage());
    $message = ['type' => 'error', 'text' => 'An unexpected error occurred. Please try again later.'];
}

// --- Action Handling (POST requests) ---
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $post_action = $_POST['action'] ?? '';
    $post_data = $_POST;

    $rules = getValidationRules($post_action, $validation_context);
    $errors = validate($post_data, $rules);

    if (!empty($errors)) {
        $redirect_url = $_POST['redirect_back'] ?? $_SERVER['PHP_SELF'];
        $action_map = [
            'do_register_flight' => '?action=register_flight',
            'do_modify_flight' => '?action=modify_flight&id=' . urlencode($post_data['kood'] ?? ''),
            'do_cancel_flight' => '?action=manage_flights&flight_code=' . urlencode($post_data['lennu_kood'] ?? ''),
            'do_delay_flight' => '?action=manage_flights&flight_code=' . urlencode($post_data['lennu_kood'] ?? ''),
            'do_delete_flight' => '?action=manage_flights',
            'do_assign_aircraft' => '?action=manage_flights&flight_code=' . urlencode($post_data['lennu_kood'] ?? ''),
            'do_add_employee' => '?action=manage_staffing&flight_code=' . urlencode($post_data['lennu_kood'] ?? ''),
            'do_remove_employee' => '?action=manage_staffing&flight_code=' . urlencode($post_data['lennu_kood'] ?? ''),
            'do_create_airport' => '?action=add_airport',
            'do_update_airport' => '?action=edit_airport&id=' . urlencode($post_data['kood'] ?? ''),
            'do_delete_airport' => '?action=view_airports',
            'do_create_aircraft_type' => '?action=add_aircraft_type',
            'do_update_aircraft_type' => '?action=edit_aircraft_type&id=' . urlencode($post_data['kood'] ?? ''),
            'do_delete_aircraft_type' => '?action=view_aircraft_types',
            'do_create_aircraft' => '?action=add_aircraft',
            'do_update_aircraft' => '?action=edit_aircraft&reg_nr=' . urlencode($post_data['registreerimisnumber'] ?? ''),
            'do_delete_aircraft' => '?action=view_aircraft',
            'do_create_employee' => '?action=add_employee',
            'do_update_employee' => '?action=edit_employee&id=' . urlencode($post_data['isik_id'] ?? ''),
            'do_delete_employee' => '?action=view_employees',
        ];
        $redirect_url = $_SERVER['PHP_SELF'] . ($action_map[$post_action] ?? '?action=view_flights');
        redirect($redirect_url, null, $errors, $post_data);
    }

    try {
        $pdo->beginTransaction();
        $success_message = "Operation completed successfully.";
        $redirect_to = $_SERVER['PHP_SELF'];

        switch ($post_action) {
            case 'do_register_flight':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op1_registreeri_lend(?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([
                    $post_data['kood'],
                    $post_data['lahtelennujaam_kood'],
                    $post_data['sihtlennujaam_kood'],
                    $post_data['eeldatav_lahkumisaeg'],
                    $post_data['eeldatav_saabumisaeg'],
                    empty($post_data['lennukituup_kood']) ? null : $post_data['lennukituup_kood'],
                    empty($post_data['lennuk_reg_nr']) ? null : $post_data['lennuk_reg_nr']
                ]);
                $new_kood = $stmt->fetchColumn();
                $success_message = "Flight '{$new_kood}' successfully registered.";
                $redirect_to .= '?action=view_flights';
                break;

            case 'do_cancel_flight':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op3_tuhista_lend(?, ?)");
                $stmt->execute([$post_data['lennu_kood'], $post_data['pohjus']]);
                $success_message = "Flight '{$post_data['lennu_kood']}' canceled.";
                $redirect_to .= '?action=manage_flights&flight_code=' . urlencode($post_data['lennu_kood']);
                break;

            case 'do_delay_flight':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op4_maara_hilinenuks(?, ?, ?)");
                $stmt->execute([
                    $post_data['lennu_kood'],
                    $post_data['uus_lahkumisaeg'],
                    $post_data['uus_saabumisaeg']
                ]);
                $success_message = "Flight '{$post_data['lennu_kood']}' marked as delayed.";
                $redirect_to .= '?action=manage_flights&flight_code=' . urlencode($post_data['lennu_kood']);
                break;

            case 'do_delete_flight':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op13_kustuta_lend(?)");
                $stmt->execute([$post_data['lennu_kood']]);
                $deleted = $stmt->fetchColumn();
                if ($deleted) {
                    $success_message = "Flight '{$post_data['lennu_kood']}' deleted.";
                } else {
                    throw new Exception("Flight '{$post_data['lennu_kood']}' could not be deleted (conditions not met).");
                }
                $redirect_to .= '?action=view_flights';
                break;

            case 'do_modify_flight':
                $stmt = $pdo->prepare("SELECT * FROM lennufirma.fn_op14_muuda_lendu(?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([
                    $post_data['kood'],
                    empty($post_data['uus_lahkumisaeg']) ? null : $post_data['uus_lahkumisaeg'],
                    empty($post_data['uus_saabumisaeg']) ? null : $post_data['uus_saabumisaeg'],
                    empty($post_data['uus_lennukituup_kood']) ? null : $post_data['uus_lennukituup_kood'],
                    empty($post_data['uus_lennuk_reg_nr']) ? null : $post_data['uus_lennuk_reg_nr'],
                    empty($post_data['uus_sihtkoht_kood']) ? null : $post_data['uus_sihtkoht_kood'],
                    empty($post_data['uus_lahtekoht_kood']) ? null : $post_data['uus_lahtekoht_kood']
                ]);
                $updated_flight = $stmt->fetch();
                $success_message = "Flight '{$post_data['kood']}' data updated.";
                $redirect_to .= '?action=manage_flights&flight_code=' . urlencode($post_data['kood']);
                break;

            case 'do_assign_aircraft':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op18_maara_lennuk_lennule(?, ?)");
                $stmt->execute([$post_data['lennu_kood'], $post_data['lennuk_reg_nr']]);
                $success_message = "Aircraft '{$post_data['lennuk_reg_nr']}' assigned to flight '{$post_data['lennu_kood']}'.";
                $redirect_to .= '?action=manage_flights&flight_code=' . urlencode($post_data['lennu_kood']);
                break;

            case 'do_add_employee':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op16_lisa_tootaja_lennule(?, ?, ?)");
                $stmt->execute([
                    $post_data['lennu_kood'],
                    $post_data['tootaja_isik_id'],
                    $post_data['rolli_kood']
                ]);
                $assignment_id = $stmt->fetchColumn();
                $success_message = "Employee (ID: {$post_data['tootaja_isik_id']}) added to flight '{$post_data['lennu_kood']}' in role '{$post_data['rolli_kood']}'.";
                $redirect_to .= '?action=manage_staffing&flight_code=' . urlencode($post_data['lennu_kood']);
                break;

            case 'do_remove_employee':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_op17_eemalda_tootaja_lennult(?, ?)");
                $stmt->execute([$post_data['lennu_kood'], $post_data['tootaja_isik_id']]);
                $removed = $stmt->fetchColumn();
                if ($removed) {
                    $success_message = "Employee (ID: {$post_data['tootaja_isik_id']}) removed from flight '{$post_data['lennu_kood']}'.";
                } else {
                    throw new Exception("Employee (ID: {$post_data['tootaja_isik_id']}) could not be removed from flight '{$post_data['lennu_kood']}'.");
                }
                $redirect_to .= '?action=manage_staffing&flight_code=' . urlencode($post_data['lennu_kood']);
                break;

            case 'do_create_airport':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_lennujaam_create(?, ?, ?, ?, ?, ?)");
                $stmt->execute([
                    $post_data['kood'],
                    $post_data['nimi'],
                    empty($post_data['koordinaadid_laius']) ? null : $post_data['koordinaadid_laius'],
                    empty($post_data['koordinaadid_pikkus']) ? null : $post_data['koordinaadid_pikkus'],
                    $post_data['ajavoond_kood'],
                    $post_data['seisund_kood']
                ]);
                $new_code = $stmt->fetchColumn();
                $success_message = "Airport '{$new_code}' added.";
                $redirect_to .= '?action=view_airports';
                break;

            case 'do_update_airport':
                $stmt = $pdo->prepare("SELECT * FROM lennufirma.fn_lennujaam_update(?, ?, ?, ?, ?, ?)");
                $stmt->execute([
                    $post_data['kood'],
                    $post_data['nimi'],
                    empty($post_data['koordinaadid_laius']) ? null : $post_data['koordinaadid_laius'],
                    empty($post_data['koordinaadid_pikkus']) ? null : $post_data['koordinaadid_pikkus'],
                    $post_data['ajavoond_kood'],
                    $post_data['seisund_kood']
                ]);
                $success_message = "Airport '{$post_data['kood']}' data updated.";
                $redirect_to .= '?action=view_airports';
                break;

            case 'do_delete_airport':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_lennujaam_delete(?)");
                $stmt->execute([$post_data['kood']]);
                $deleted = $stmt->fetchColumn();
                if ($deleted) {
                    $success_message = "Airport '{$post_data['kood']}' deleted.";
                } else {
                    throw new Exception("Airport '{$post_data['kood']}' could not be deleted (possible dependencies).");
                }
                $redirect_to .= '?action=view_airports';
                break;

            case 'do_create_aircraft_type':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_lennukituup_create(?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([
                    $post_data['kood'],
                    $post_data['nimetus'],
                    $post_data['lennuki_tootja_kood'],
                    $post_data['maksimaalne_lennukaugus'],
                    $post_data['maksimaalne_reisijate_arv'],
                    $post_data['pardapersonali_arv'],
                    $post_data['pilootide_arv']
                ]);
                $new_code = $stmt->fetchColumn();
                $success_message = "Aircraft type '{$new_code}' added.";
                $redirect_to .= '?action=view_aircraft_types';
                break;

            case 'do_update_aircraft_type':
                $stmt = $pdo->prepare("SELECT * FROM lennufirma.fn_lennukituup_update(?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([
                    $post_data['kood'],
                    $post_data['nimetus'],
                    $post_data['lennuki_tootja_kood'],
                    $post_data['maksimaalne_lennukaugus'],
                    $post_data['maksimaalne_reisijate_arv'],
                    $post_data['pardapersonali_arv'],
                    $post_data['pilootide_arv']
                ]);
                $success_message = "Aircraft type '{$post_data['kood']}' data updated.";
                $redirect_to .= '?action=view_aircraft_types';
                break;

            case 'do_delete_aircraft_type':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_lennukituup_delete(?)");
                $stmt->execute([$post_data['kood']]);
                $deleted = $stmt->fetchColumn();
                if ($deleted) {
                    $success_message = "Aircraft type '{$post_data['kood']}' deleted.";
                } else {
                    throw new Exception("Aircraft type '{$post_data['kood']}' could not be deleted (possible dependencies).");
                }
                $redirect_to .= '?action=view_aircraft_types';
                break;

            case 'do_create_aircraft':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_lennuk_create(?, ?, ?)");
                $stmt->execute([
                    $post_data['registreerimisnumber'],
                    $post_data['lennukituup_kood'],
                    $post_data['seisund_kood']
                ]);
                $new_reg = $stmt->fetchColumn();
                $success_message = "Aircraft '{$new_reg}' added.";
                $redirect_to .= '?action=view_aircraft';
                break;

            case 'do_update_aircraft':
                $stmt = $pdo->prepare("SELECT * FROM lennufirma.fn_lennuk_update(?, ?, ?)");
                $stmt->execute([
                    $post_data['registreerimisnumber'],
                    $post_data['lennukituup_kood'],
                    $post_data['seisund_kood']
                ]);
                $success_message = "Aircraft '{$post_data['registreerimisnumber']}' data updated.";
                $redirect_to .= '?action=view_aircraft';
                break;

            case 'do_delete_aircraft':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_lennuk_delete(?)");
                $stmt->execute([$post_data['registreerimisnumber']]);
                $deleted = $stmt->fetchColumn();
                if ($deleted) {
                    $success_message = "Aircraft '{$post_data['registreerimisnumber']}' deleted.";
                } else {
                    throw new Exception("Aircraft '{$post_data['registreerimisnumber']}' could not be deleted (possible dependencies).");
                }
                $redirect_to .= '?action=view_aircraft';
                break;

            case 'do_create_employee':
                $stmt_isik = $pdo->prepare("SELECT lennufirma.fn_isik_create(?, ?, ?, ?, ?, ?, ?, ?)");
                $stmt_isik->execute([
                    $post_data['eesnimi'],
                    $post_data['perenimi'],
                    $post_data['e_meil'],
                    empty($post_data['isikukood']) ? null : $post_data['isikukood'],
                    empty($post_data['synni_kp']) ? null : $post_data['synni_kp'],
                    empty($post_data['elukoht']) ? null : $post_data['elukoht'],
                    empty($post_data['parool']) ? null : $post_data['parool'],
                    isset($post_data['on_aktiivne']) ? (bool)$post_data['on_aktiivne'] : true
                ]);
                $new_isik_id = $stmt_isik->fetchColumn();

                $stmt_tootaja = $pdo->prepare("SELECT lennufirma.fn_tootaja_create(?, ?, ?)");
                $stmt_tootaja->execute([
                    $new_isik_id,
                    $post_data['seisund_kood'],
                    empty($post_data['tootaja_kood']) ? null : $post_data['tootaja_kood']
                ]);
                $success_message = "Employee '{$post_data['eesnimi']} {$post_data['perenimi']}' (ID: {$new_isik_id}) added.";
                $redirect_to .= '?action=view_employees';
                break;

            case 'do_update_employee':
                $stmt_isik = $pdo->prepare("SELECT * FROM lennufirma.fn_isik_update(?, ?, ?, ?, ?, ?, ?, ?)");
                $stmt_isik->execute([
                    $post_data['isik_id'],
                    empty($post_data['eesnimi']) ? null : $post_data['eesnimi'],
                    empty($post_data['perenimi']) ? null : $post_data['perenimi'],
                    empty($post_data['e_meil']) ? null : $post_data['e_meil'],
                    empty($post_data['isikukood']) ? null : $post_data['isikukood'],
                    empty($post_data['synni_kp']) ? null : $post_data['synni_kp'],
                    empty($post_data['elukoht']) ? null : $post_data['elukoht'],
                    isset($post_data['on_aktiivne']) ? (bool)$post_data['on_aktiivne'] : null
                ]);
                $stmt_tootaja = $pdo->prepare("SELECT * FROM lennufirma.fn_tootaja_update(?, ?, ?)");
                $stmt_tootaja->execute([
                    $post_data['isik_id'],
                    $post_data['seisund_kood'],
                    empty($post_data['tootaja_kood']) ? null : $post_data['tootaja_kood']
                ]);
                $success_message = "Employee (ID: {$post_data['isik_id']}) data updated.";
                $redirect_to .= '?action=view_employees';
                break;

            case 'do_delete_employee':
                $stmt = $pdo->prepare("SELECT lennufirma.fn_tootaja_delete(?)");
                $stmt->execute([$post_data['isik_id']]);
                $deleted = $stmt->fetchColumn();
                if ($deleted) {
                    $success_message = "Employee (ID: {$post_data['isik_id']}) deleted.";
                } else {
                    throw new Exception("Employee (ID: {$post_data['isik_id']}) could not be deleted (possible dependencies).");
                }
                $redirect_to .= '?action=view_employees';
                break;

            default:
                throw new Exception('Unknown POST action.');
        }

        $pdo->commit();
        redirect($redirect_to, ['type' => 'success', 'text' => $success_message]);

    } catch (Exception $e) {
        $pdo->rollBack();
        log_error("Database Operation Error ({$post_action}): " . $e->getMessage());
        $redirect_url = $_POST['redirect_back'] ?? $_SERVER['PHP_SELF'] . ($action_map[$post_action] ?? '?action=view_flights');
        redirect($redirect_url, ['type' => 'error', 'text' => htmlspecialchars($e->getMessage())], null, $post_data);
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Airline Management</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h1>Airline Management Interface</h1>

    <?php if ($message): ?>
        <div class="message <?= htmlspecialchars($message['type']) ?>">
            <?= htmlspecialchars($message['text']) ?>
        </div>
    <?php endif; ?>

    <nav>
        <ul>
            <li><a href="?action=view_flights">View Flights</a></li>
            <li><a href="?action=register_flight">Register Flight</a></li>
            <li><a href="?action=manage_flights">Manage Flights</a></li>
            <li><a href="?action=manage_staffing">Manage Crew</a></li>
            <li><a href="?action=view_airports">Manage Airports</a></li>
            <li><a href="?action=view_aircraft_types">Manage Aircraft Types</a></li>
            <li><a href="?action=view_aircraft">Manage Aircraft</a></li>
            <li><a href="?action=view_employees">Manage Employees</a></li>
        </ul>
    </nav>

    <div class="container">
        <?php
        $formErrors = $errors;
        $formOldInput = $oldInput;

        switch ($action) {
            case 'register_flight': include 'views/register_flight_form.php'; break;
            case 'manage_flights': include 'views/manage_flights_view.php'; break;
            case 'manage_staffing': include 'views/manage_staffing_view.php'; break;
            case 'modify_flight': include 'forms/flight_modify_form.php'; break;
            case 'view_flights': include 'views/view_flights_table.php'; break;
            case 'view_airports': include 'views/airports_list.php'; break;
            case 'add_airport':
            case 'edit_airport': include 'forms/airport_form.php'; break;
            case 'view_aircraft_types': include 'views/aircraft_types_list.php'; break;
            case 'add_aircraft_type':
            case 'edit_aircraft_type': include 'forms/aircraft_type_form.php'; break;
            case 'view_aircraft': include 'views/aircraft_list.php'; break;
            case 'add_aircraft':
            case 'edit_aircraft': include 'forms/aircraft_form.php'; break;
            case 'view_employees': include 'views/employees_list.php'; break;
            case 'add_employee':
            case 'edit_employee': include 'forms/employee_form.php'; break;
            default: include 'views/view_flights_table.php'; break;
        }
        ?>
    </div>
</body>
</html>