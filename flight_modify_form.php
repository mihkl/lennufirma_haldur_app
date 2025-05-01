<?php
/**
 * Formats a date/time string (like from PostgreSQL TIMESTAMPTZ)
 * into the format required by HTML datetime-local input.
 *
 * @param string|null $dateTimeString The date/time string from the database.
 * @return string The formatted string or empty string on failure/null input.
 */
function format_datetime_local(?string $dateTimeString): string {
    if (empty($dateTimeString)) {
        return '';
    }
    try {
        // Create DateTimeImmutable object to avoid modifying the original if passed by ref later
        $date = new DateTimeImmutable($dateTimeString);
        // Format for datetime-local input (YYYY-MM-DDTHH:MM)
        return $date->format('Y-m-d\TH:i');
    } catch (Exception $e) {
        // Optional: Log the error if parsing fails
        // error_log("Error parsing date for datetime-local input: " . $e->getMessage() . " | Input: " . $dateTimeString);
        return ''; // Return empty string if input is invalid
    }
}

// Assumes $crud_data (flight details), $airports, $aircraft_types, $aircraft, $formErrors, $formOldInput from index.php
$flight = $crud_data ?? [];
$oldInput = $formOldInput ?? [];
$errors = $formErrors ?? [];

// --- Get Current Values (with fallback for safety) ---
$current_dep_airport = $flight['lahtelennujaam_kood'] ?? null;
$current_arr_airport = $flight['sihtlennujaam_kood'] ?? null;
$current_dep_time_str = $flight['eeldatav_lahkumis_aeg'] ?? null;
$current_arr_time_str = $flight['eeldatav_saabumis_aeg'] ?? null;
$current_ac_type = $flight['lennukituup_kood'] ?? null;
$current_ac_reg = $flight['lennuk_reg_nr'] ?? null;

// --- Determine Values for Form Fields (prioritize old input, then current flight data) ---
$dep_airport_value = $oldInput['uus_lahtelennujaam_kood'] ?? $current_dep_airport; // Corrected key name
$arr_airport_value = $oldInput['uus_sihtlennujaam_kood'] ?? $current_arr_airport; // Corrected key name
$dep_time_value = $oldInput['uus_lahkumis_aeg'] ?? format_datetime_local($current_dep_time_str);
$arr_time_value = $oldInput['uus_saabumis_aeg'] ?? format_datetime_local($current_arr_time_str);
$ac_type_value = $oldInput['uus_lennukituup_kood'] ?? $current_ac_type;
$ac_reg_value = $oldInput['uus_lennuk_reg_nr'] ?? $current_ac_reg;

?>

<h2>Modify Flight: <?= htmlspecialchars($flight['kood'] ?? 'N/A') ?></h2>

<?php if (empty($flight)): ?>
    <p>Flight not found.</p>
<?php else: ?>
    <?php if (!empty($errors)): ?>
        <div class="message error">  <strong>Please correct the following errors:</strong>
            <ul>
                <?php foreach ($errors as $field => $message): ?>
                    <li><?= htmlspecialchars($message) ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <form method="post" action="<?= htmlspecialchars($_SERVER['PHP_SELF']) ?>"> <input type="hidden" name="action" value="do_modify_flight">
        <input type="hidden" name="kood" value="<?= htmlspecialchars($flight['kood'] ?? '') ?>">
        <div>
            <label for="uus_lahtelennujaam_kood">Departure Airport:</label> <select id="uus_lahtelennujaam_kood" name="uus_lahtelennujaam_kood">
                <?php foreach ($airports as $code => $name): ?>
                    <option value="<?= htmlspecialchars($code) ?>" <?= ($dep_airport_value === $code) ? 'selected' : '' ?>>
                        <?= htmlspecialchars($name) ?> (<?= htmlspecialchars($code) ?>) </option>
                <?php endforeach; ?>
            </select>
            <?php if (isset($errors['uus_lahtelennujaam_kood'])): ?>
                <span class="error-message"><?= htmlspecialchars($errors['uus_lahtelennujaam_kood']) ?></span> <?php endif; ?>
        </div>

        <div>
            <label for="uus_sihtlennujaam_kood">Destination Airport:</label> <select id="uus_sihtlennujaam_kood" name="uus_sihtlennujaam_kood">
                <?php foreach ($airports as $code => $name): ?>
                    <option value="<?= htmlspecialchars($code) ?>" <?= ($arr_airport_value === $code) ? 'selected' : '' ?>>
                         <?= htmlspecialchars($name) ?> (<?= htmlspecialchars($code) ?>) </option>
                <?php endforeach; ?>
            </select>
            <?php if (isset($errors['uus_sihtlennujaam_kood'])): ?>
                <span class="error-message"><?= htmlspecialchars($errors['uus_sihtlennujaam_kood']) ?></span>
            <?php endif; ?>
        </div>

        <div>
            <label for="uus_lahkumis_aeg">Departure Time:</label> <input type="datetime-local" id="uus_lahkumis_aeg" name="uus_lahkumis_aeg"
                   value="<?= htmlspecialchars($dep_time_value) ?>">
            <?php if (isset($errors['uus_lahkumis_aeg'])): ?>
                <span class="error-message"><?= htmlspecialchars($errors['uus_lahkumis_aeg']) ?></span>
            <?php endif; ?>
        </div>

        <div>
            <label for="uus_saabumis_aeg">Arrival Time:</label> <input type="datetime-local" id="uus_saabumis_aeg" name="uus_saabumis_aeg"
                   value="<?= htmlspecialchars($arr_time_value) ?>">
            <?php if (isset($errors['uus_saabumis_aeg'])): ?>
                <span class="error-message"><?= htmlspecialchars($errors['uus_saabumis_aeg']) ?></span>
            <?php endif; ?>
        </div>

        <div>
            <label for="uus_lennukituup_kood">Aircraft Type:</label>
            <select id="uus_lennukituup_kood" name="uus_lennukituup_kood">
                 <option value="">-- Select Type --</option> <?php foreach ($aircraft_types as $code => $name): ?>
                    <option value="<?= htmlspecialchars($code) ?>" <?= ($ac_type_value === $code) ? 'selected' : '' ?>>
                        <?= htmlspecialchars($name) ?> (<?= htmlspecialchars($code) ?>)
                    </option>
                <?php endforeach; ?>
            </select>
             <?php if (isset($errors['uus_lennukituup_kood'])): ?>
                <span class="error-message"><?= htmlspecialchars($errors['uus_lennukituup_kood']) ?></span>
            <?php endif; ?>
        </div>

        <div>
            <label for="uus_lennuk_reg_nr">Aircraft (Registration):</label>
            <select id="uus_lennuk_reg_nr" name="uus_lennuk_reg_nr">
                <option value="">-- Select Aircraft --</option> <?php foreach ($aircraft as $reg => $name): ?>
                    <option value="<?= htmlspecialchars($reg) ?>" <?= ($ac_reg_value === $reg) ? 'selected' : '' ?>>
                        <?= htmlspecialchars($reg) ?>
                    </option>
                <?php endforeach; ?>
            </select>
            <?php if (isset($errors['uus_lennuk_reg_nr'])): ?>
                <span class="error-message"><?= htmlspecialchars($errors['uus_lennuk_reg_nr']) ?></span>
            <?php endif; ?>
        </div>

        <button type="submit">Update Flight</button>
    </form>
<?php endif; ?>