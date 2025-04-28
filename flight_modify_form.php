<?php
// Assumes $crud_data (flight details), $airports, $aircraft_types, $aircraft, $formErrors, $formOldInput from index.php
$flight = $crud_data ?? [];
$oldInput = $formOldInput ?? [];
$errors = $formErrors ?? [];
?>

<h2>Modify Flight: <?= htmlspecialchars($flight['kood'] ?? 'N/A') ?></h2>

<?php if (empty($flight)): ?>
    <p>Flight not found.</p>
<?php else: ?>
    <?php if (!empty($errors)): ?>
        <div class="error">
            <ul>
                <?php foreach ($errors as $field => $message): ?>
                    <li><?= htmlspecialchars($message) ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <form method="post" action="">
        <input type="hidden" name="action" value="do_modify_flight">
        <input type="hidden" name="kood" value="<?= htmlspecialchars($flight['kood'] ?? '') ?>">
        <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=modify_flight&id=' . urlencode($flight['kood'] ?? '')) ?>">

        <div>
            <label for="uus_lahtekoht_kood">New Departure Airport:</label>
            <select id="uus_lahtekoht_kood" name="uus_lahtekoht_kood">
                <option value="">Keep Current (<?= htmlspecialchars($flight['lahtelennujaam_kood'] ?? 'N/A') ?>)</option>
                <?php foreach ($airports as $code => $name): ?>
                    <option value="<?= htmlspecialchars($code) ?>" <?= ($oldInput['uus_lahtekoht_kood'] ?? '') === $code ? 'selected' : '' ?>>
                        <?= htmlspecialchars($code) ?>
                    </option>
                <?php endforeach; ?>
            </select>
            <?php if (isset($errors['uus_lahtekoht_kood'])): ?>
                <span class="error"><?= htmlspecialchars($errors['uus_lahtekoht_kood']) ?></span>
            <?php endif; ?>
        </div>

        <div>
            <label for="uus_sihtkoht_kood">New Destination Airport:</label>
            <select id="uus_sihtkoht_kood" name="uus_sihtkoht_kood">
                <option value="">Keep Current (<?= htmlspecialchars($flight['sihtlennujaam_kood'] ?? 'N/A') ?>)</option>
                <?php foreach ($airports as $code => $name): ?>
                    <option value="<?= htmlspecialchars($code) ?>" <?= ($oldInput['uus_sihtkoht_kood'] ?? '') === $code ? 'selected' : '' ?>>
                        <?= htmlspecialchars($code) ?>
                    </option>
                <?php endforeach; ?>
            </select>
            <?php if (isset($errors['uus_sihtkoht_kood'])): ?>
                <span class="error"><?= htmlspecialchars($errors['uus_sihtkoht_kood']) ?></span>
            <?php endif; ?>
        </div>

        <div>
            <label for="uus_lahkumisaeg">New Departure Time:</label>
            <input type="datetime-local" id="uus_lahkumisaeg" name="uus_lahkumisaeg" value="<?= htmlspecialchars($oldInput['uus_lahkumisaeg'] ?? '') ?>">
            <?php if (isset($errors['uus_lahkumisaeg'])): ?>
                <span class="error"><?= htmlspecialchars($errors['uus_lahkumisaeg']) ?></span>
            <?php endif; ?>
        </div>

        <div>
            <label for="uus_saabumisaeg">New Arrival Time:</label>
            <input type="datetime-local" id="uus_saabumisaeg" name="uus_saabumisaeg" value="<?= htmlspecialchars($oldInput['uus_saabumisaeg'] ?? '') ?>">
            <?php if (isset($errors['uus_saabumisaeg'])): ?>
                <span class="error"><?= htmlspecialchars($errors['uus_saabumisaeg']) ?></span>
            <?php endif; ?>
        </div>

        <div>
            <label for="uus_lennukituup_kood">New Aircraft Type:</label>
            <select id="uus_lennukituup_kood" name="uus_lennukituup_kood">
                <option value="">Keep Current (<?= htmlspecialchars($flight['lennukituup_kood'] ?? 'N/A') ?>)</option>
                <?php foreach ($aircraft_types as $code => $name): ?>
                    <option value="<?= htmlspecialchars($code) ?>" <?= ($oldInput['uus_lennukituup_kood'] ?? '') === $code ? 'selected' : '' ?>>
                        <?= htmlspecialchars($code) ?>
                    </option>
                <?php endforeach; ?>
            </select>
            <?php if (isset($errors['uus_lennukituup_kood'])): ?>
                <span class="error"><?= htmlspecialchars($errors['uus_lennukituup_kood']) ?></span>
            <?php endif; ?>
        </div>

        <div>
            <label for="uus_lennuk_reg_nr">New Aircraft:</label>
            <select id="uus_lennuk_reg_nr" name="uus_lennuk_reg_nr">
                <option value="">Keep Current (<?= htmlspecialchars($flight['lennuk_reg_nr'] ?? 'N/A') ?>)</option>
                <?php foreach ($aircraft as $reg => $name): ?>
                    <option value="<?= htmlspecialchars($reg) ?>" <?= ($oldInput['uus_lennuk_reg_nr'] ?? '') === $reg ? 'selected' : '' ?>>
                        <?= htmlspecialchars($reg) ?>
                    </option>
                <?php endforeach; ?>
            </select>
            <?php if (isset($errors['uus_lennuk_reg_nr'])): ?>
                <span class="error"><?= htmlspecialchars($errors['uus_lennuk_reg_nr']) ?></span>
            <?php endif; ?>
        </div>

        <button type="submit">Update Flight</button>
    </form>
<?php endif; ?>