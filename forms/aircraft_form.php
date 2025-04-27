<?php
// Assumes $crud_data (aircraft details for edit), $aircraft_types, $aircraft_statuses, $formErrors, $formOldInput from index.php
$aircraft = $crud_data ?? [];
$oldInput = $formOldInput ?? [];
$errors = $formErrors ?? [];
$isEdit = !empty($aircraft);
$action = $isEdit ? 'do_update_aircraft' : 'do_create_aircraft';
$title = $isEdit ? 'Edit Aircraft: ' . htmlspecialchars($aircraft['registreerimisnumber'] ?? 'N/A') : 'Add Aircraft';
?>

<h2><?= $title ?></h2>

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
    <input type="hidden" name="action" value="<?= htmlspecialchars($action) ?>">
    <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . ($isEdit ? '?action=edit_aircraft&reg_nr=' . urlencode($aircraft['registreerimisnumber'] ?? '') : '?action=add_aircraft')) ?>">

    <?php if ($isEdit): ?>
        <input type="hidden" name="registreerimisnumber" value="<?= htmlspecialchars($aircraft['registreerimisnumber'] ?? '') ?>">
    <?php else: ?>
        <div>
            <label for="registreerimisnumber">Registration Number:</label>
            <input type="text" id="registreerimisnumber" name="registreerimisnumber" value="<?= htmlspecialchars($oldInput['registreerimisnumber'] ?? '') ?>" required>
            <?php if (isset($errors['registreerimisnumber'])): ?>
                <span class="error"><?= htmlspecialchars($errors['registreerimisnumber']) ?></span>
            <?php endif; ?>
        </div>
    <?php endif; ?>

    <div>
        <label for="lennukituup_kood">Type:</label>
        <select id="lennukituup_kood" name="lennukituup_kood" required>
            <option value="">Select Type</option>
            <?php foreach ($aircraft_types as $code => $name): ?>
                <option value="<?= htmlspecialchars($code) ?>" <?= ($oldInput['lennukituup_kood'] ?? ($aircraft['lennukituup_kood'] ?? '')) === $code ? 'selected' : '' ?>>
                    <?= htmlspecialchars($code) ?>
                </option>
            <?php endforeach; ?>
        </select>
        <?php if (isset($errors['lennukituup_kood'])): ?>
            <span class="error"><?= htmlspecialchars($errors['lennukituup_kood']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="seisund_kood">Status:</label>
        <select id="seisund_kood" name="seisund_kood" required>
            <option value="">Select Status</option>
            <?php foreach ($aircraft_statuses as $code => $name): ?>
                <option value="<?= htmlspecialchars($code) ?>" <?= ($oldInput['seisund_kood'] ?? ($aircraft['seisund_kood'] ?? '')) === $code ? 'selected' : '' ?>>
                    <?= htmlspecialchars($name) ?>
                </option>
            <?php endforeach; ?>
        </select>
        <?php if (isset($errors['seisund_kood'])): ?>
            <span class="error"><?= htmlspecialchars($errors['seisund_kood']) ?></span>
        <?php endif; ?>
    </div>

    <button type="submit"><?= $isEdit ? 'Update Aircraft' : 'Add Aircraft' ?></button>
</form>