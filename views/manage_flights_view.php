<?php
// Assumes $crud_data (flight details), $aircraft, $formErrors, $formOldInput from index.php
$flight = $crud_data ?? [];
$oldInput = $formOldInput ?? [];
$errors = $formErrors ?? [];
?>

<h2>Manage Flight: <?= htmlspecialchars($flight['kood'] ?? 'N/A') ?></h2>

<?php if (empty($flight)): ?>
    <p>Flight not found.</p>
<?php else: ?>
    <p>
        <strong>Departure:</strong> <?= htmlspecialchars($flight['lahtelennujaam_kood'] ?? 'N/A') ?><br>
        <strong>Destination:</strong> <?= htmlspecialchars($flight['sihtlennujaam_kood'] ?? 'N/A') ?><br>
        <strong>Aircraft Type:</strong> <?= htmlspecialchars($flight['lennukituup_kood'] ?? 'N/A') ?><br>
        <strong>Aircraft:</strong> <?= htmlspecialchars($flight['lennuk_reg_nr'] ?? 'N/A') ?><br>
        <strong>Expected Departure:</strong> <?= htmlspecialchars($flight['eeldatav_lahkumisaeg'] ?? 'N/A') ?><br>
        <strong>Expected Arrival:</strong> <?= htmlspecialchars($flight['eeldatav_saabumisaeg'] ?? 'N/A') ?><br>
        <strong>Status:</strong> <?= htmlspecialchars($flight['seisund_kood'] ?? 'N/A') ?>
    </p>

    <?php if (!empty($errors)): ?>
        <div class="error">
            <ul>
                <?php foreach ($errors as $field => $message): ?>
                    <li><?= htmlspecialchars($message) ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <!-- Cancel Flight Form -->
    <h3>Cancel Flight</h3>
    <form method="post" action="">
        <input type="hidden" name="action" value="do_cancel_flight">
        <input type="hidden" name="lennu_kood" value="<?= htmlspecialchars($flight['kood'] ?? '') ?>">
        <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($flight['kood'] ?? '')) ?>">

        <div>
            <label for="pohjus">Reason:</label>
            <textarea id="pohjus" name="pohjus" required><?= htmlspecialchars($oldInput['pohjus'] ?? '') ?></textarea>
            <?php if (isset($errors['pohjus'])): ?>
                <span class="error"><?= htmlspecialchars($errors['pohjus']) ?></span>
            <?php endif; ?>
        </div>

        <button type="submit">Cancel Flight</button>
    </form>

    <!-- Delay Flight Form -->
    <h3>Delay Flight</h3>
    <form method="post" action="">
        <input type="hidden" name="action" value="do_delay_flight">
        <input type="hidden" name="lennu_kood" value="<?= htmlspecialchars($flight['kood'] ?? '') ?>">
        <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($flight['kood'] ?? '')) ?>">

        <div>
            <label for="uus_lahkumisaeg">New Departure Time:</label>
            <input type="datetime-local" id="uus_lahkumisaeg" name="uus_lahkumisaeg" value="<?= htmlspecialchars($oldInput['uus_lahkumisaeg'] ?? '') ?>" required>
            <?php if (isset($errors['uus_lahkumisaeg'])): ?>
                <span class="error"><?= htmlspecialchars($errors['uus_lahkumisaeg']) ?></span>
            <?php endif; ?>
        </div>

        <div>
            <label for="uus_saabumisaeg">New Arrival Time:</label>
            <input type="datetime-local" id="uus_saabumisaeg" name="uus_saabumisaeg" value="<?= htmlspecialchars($oldInput['uus_saabumisaeg'] ?? '') ?>" required>
            <?php if (isset($errors['uus_saabumisaeg'])): ?>
                <span class="error"><?= htmlspecialchars($errors['uus_saabumisaeg']) ?></span>
            <?php endif; ?>
        </div>

        <button type="submit">Delay Flight</button>
    </form>

    <!-- Assign Aircraft Form -->
    <h3>Assign Aircraft</h3>
    <form method="post" action="">
        <input type="hidden" name="action" value="do_assign_aircraft">
        <input type="hidden" name="lennu_kood" value="<?= htmlspecialchars($flight['kood'] ?? '') ?>">
        <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($flight['kood'] ?? '')) ?>">

        <div>
            <label for="lennuk_reg_nr">Aircraft:</label>
            <select id="lennuk_reg_nr" name="lennuk_reg_nr" required>
                <option value="">Select Aircraft</option>
                <?php foreach ($aircraft as $reg => $name): ?>
                    <option value="<?= htmlspecialchars($reg) ?>" <?= ($oldInput['lennuk_reg_nr'] ?? '') === $reg ? 'selected' : '' ?>>
                        <?= htmlspecialchars($reg) ?>
                    </option>
                <?php endforeach; ?>
            </select>
            <?php if (isset($errors['lennuk_reg_nr'])): ?>
                <span class="error"><?= htmlspecialchars($errors['lennuk_reg_nr']) ?></span>
            <?php endif; ?>
        </div>

        <button type="submit">Assign Aircraft</button>
    </form>

    <!-- Delete Flight Form -->
    <h3>Delete Flight</h3>
    <form method="post" action="">
        <input type="hidden" name="action" value="do_delete_flight">
        <input type="hidden" name="lennu_kood" value="<?= htmlspecialchars($flight['kood'] ?? '') ?>">
        <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($flight['kood'] ?? '')) ?>">

        <button type="submit" onclick="return confirm('Are you sure you want to delete this flight?')">Delete Flight</button>
    </form>

    <!-- Link to Modify Flight -->
    <p>
        <a href="?action=modify_flight&id=<?= htmlspecialchars($flight['kood'] ?? '') ?>">Modify Flight Details</a>
    </p>
<?php endif; ?>