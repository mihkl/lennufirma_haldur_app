<?php
// Assumes $pdo, $airports, $aircraft_types, $aircraft are available from index.php
if (!isset($pdo, $airports, $aircraft_types, $aircraft)) { die('Required variables not available'); }
?>

<h2>Register a new flight</h2>

<form action="index.php" method="post">
    <input type="hidden" name="action" value="do_register_flight">

    <label for="lend_kood">Flight code:</label>
    <input type="text" id="lend_kood" name="lend_kood" required maxlength="10">

    <label for="lahtelennujaam_kood">Departure airport:</label>
    <select id="lahtelennujaam_kood" name="lahtelennujaam_kood" required>
        <option value="">-- Select --</option>
        <?php foreach ($airports as $code => $name): ?>
            <option value="<?= htmlspecialchars($code) ?>"><?= htmlspecialchars($name) ?> (<?= htmlspecialchars($code) ?>)</option>
        <?php endforeach; ?>
    </select>

    <label for="sihtlennujaam_kood">Arrival airport:</label>
    <select id="sihtlennujaam_kood" name="sihtlennujaam_kood" required>
        <option value="">-- Select --</option>
         <?php foreach ($airports as $code => $name): ?>
            <option value="<?= htmlspecialchars($code) ?>"><?= htmlspecialchars($name) ?> (<?= htmlspecialchars($code) ?>)</option>
        <?php endforeach; ?>
    </select>

    <label for="eeldatav_lahkumis_aeg">Expected departure (UTC):</label>
    <input type="datetime-local" id="eeldatav_lahkumis_aeg" name="eeldatav_lahkumis_aeg" required placeholder="YYYY-MM-DD HH:MM">

    <label for="eeldatav_saabumis_aeg">Expected arrival (UTC):</label>
    <input type="datetime-local" id="eeldatav_saabumis_aeg" name="eeldatav_saabumis_aeg" required placeholder="YYYY-MM-DD HH:MM">

    <p>Choose <strong>either</strong> aircraft type <strong>or</strong> specific aircraft:</p>

    <label for="lennukituup_kood">Aircraft type (optional):</label>
    <select id="lennukituup_kood" name="lennukituup_kood">
        <option value="">-- Choose type --</option>
        <?php foreach ($aircraft_types as $code => $name): ?>
            <option value="<?= htmlspecialchars($code) ?>"><?= htmlspecialchars($name) ?> (<?= htmlspecialchars($code) ?>)</option>
        <?php endforeach; ?>
    </select>

     <label for="lennuk_reg_nr">Specific aircraft (optional):</label>
    <select id="lennuk_reg_nr" name="lennuk_reg_nr">
        <option value="">-- Choose a specific aircraft --</option>
         <?php foreach ($aircraft as $reg_nr => $text): ?>
            <option value="<?= htmlspecialchars($reg_nr) ?>"><?= htmlspecialchars($text) ?></option>
        <?php endforeach; ?>
    </select>

    <button type="submit">Register flight</button>
</form>

<!-- In includes/header.php or your main layout file -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://npmcdn.com/flatpickr/dist/l10n/en.js"></script>

<!-- In flight_form.php or includes/footer.php -->
<script>
    // Wait for the document to be ready
    document.addEventListener('DOMContentLoaded', function() {

        // Configuration options
        const flatpickrConfig = {
            enableTime: true,       // Enable time selection
            dateFormat: "Y-m-d H:i", // The format displayed *and submitted*
            time_24hr: true,        // Use 24-hour format
            // --- Crucial for UTC ---
            timeZone: 'UTC',        // Treat selected time as UTC (Flatpickr internal)
            // Note: Flatpickr itself doesn't force the *picker UI* to UTC,
            // but it helps format the output string correctly assuming UTC input.
            // You still need to label clearly.
            // --- Optional: Estonian Locale ---
            locale: "en",           
            // --- Optional: Set default time if needed ---
            // defaultDate: new Date(), // Example: Set to current time
            // --- Optional: Min/Max dates ---
            // minDate: "today",
        };

        // Initialize for departure time
        flatpickr("#eeldatav_lahkumis_aeg", {
            ...flatpickrConfig // Spread the common config
            // Add specific options for departure if needed
        });

        // Initialize for arrival time
        flatpickr("#eeldatav_saabumis_aeg", {
            ...flatpickrConfig // Spread the common config
            // Add specific options for arrival if needed
        });

    });
</script>