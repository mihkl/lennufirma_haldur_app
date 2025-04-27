<?php
// Assumes $crud_data (employee details for edit), $employee_statuses, $formErrors, $formOldInput from index.php
$employee = $crud_data ?? [];
$oldInput = $formOldInput ?? [];
$errors = $formErrors ?? [];
$isEdit = !empty($employee);
$action = $isEdit ? 'do_update_employee' : 'do_create_employee';
$title = $isEdit ? 'Edit Employee: ' . htmlspecialchars(($employee['eesnimi'] ?? '') . ' ' . ($employee['perenimi'] ?? '')) : 'Add Employee';
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
    <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . ($isEdit ? '?action=edit_employee&id=' . urlencode($employee['isik_id'] ?? '') : '?action=add_employee')) ?>">

    <?php if ($isEdit): ?>
        <input type="hidden" name="isik_id" value="<?= htmlspecialchars($employee['isik_id'] ?? '') ?>">
    <?php endif; ?>

    <div>
        <label for="eesnimi">First Name:</label>
        <input type="text" id="eesnimi" name="eesnimi" value="<?= htmlspecialchars($oldInput['eesnimi'] ?? ($employee['eesnimi'] ?? '')) ?>" required>
        <?php if (isset($errors['eesnimi'])): ?>
            <span class="error"><?= htmlspecialchars($errors['eesnimi']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="perenimi">Last Name:</label>
        <input type="text" id="perenimi" name="perenimi" value="<?= htmlspecialchars($oldInput['perenimi'] ?? ($employee['perenimi'] ?? '')) ?>" required>
        <?php if (isset($errors['perenimi'])): ?>
            <span class="error"><?= htmlspecialchars($errors['perenimi']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="e_meil">Email:</label>
        <input type="email" id="e_meil" name="e_meil" value="<?= htmlspecialchars($oldInput['e_meil'] ?? ($employee['e_meil'] ?? '')) ?>" required>
        <?php if (isset($errors['e_meil'])): ?>
            <span class="error"><?= htmlspecialchars($errors['e_meil']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="isikukood">Personal Code:</label>
        <input type="text" id="isikukood" name="isikukood" value="<?= htmlspecialchars($oldInput['isikukood'] ?? ($employee['isikukood'] ?? '')) ?>">
        <?php if (isset($errors['isikukood'])): ?>
            <span class="error"><?= htmlspecialchars($errors['isikukood']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="synni_kp">Date of Birth:</label>
        <input type="date" id="synni_kp" name="synni_kp" value="<?= htmlspecialchars($oldInput['synni_kp'] ?? ($employee['synni_kp'] ?? '')) ?>">
        <?php if (isset($errors['synni_kp'])): ?>
            <span class="error"><?= htmlspecialchars($errors['synni_kp']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="elukoht">Address:</label>
        <input type="text" id="elukoht" name="elukoht" value="<?= htmlspecialchars($oldInput['elukoht'] ?? ($employee['elukoht'] ?? '')) ?>">
        <?php if (isset($errors['elukoht'])): ?>
            <span class="error"><?= htmlspecialchars($errors['elukoht']) ?></span>
        <?php endif; ?>
    </div>

    <?php if (!$isEdit): ?>
        <div>
            <label for="parool">Password:</label>
            <input type="password" id="parool" name="parool" value="">
            <?php if (isset($errors['parool'])): ?>
                <span class="error"><?= htmlspecialchars($errors['parool']) ?></span>
            <?php endif; ?>
        </div>
    <?php endif; ?>

    <div>
        <label for="tootaja_kood">Employee Code:</label>
        <input type="text" id="tootaja_kood" name="tootaja_kood" value="<?= htmlspecialchars($oldInput['tootaja_kood'] ?? ($employee['tootaja_kood'] ?? '')) ?>">
        <?php if (isset($errors['tootaja_kood'])): ?>
            <span class="error"><?= htmlspecialchars($errors['tootaja_kood']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="seisund_kood">Status:</label>
        <select id="seisund_kood" name="seisund_kood" required>
            <option value="">Select Status</option>
            <?php foreach ($employee_statuses as $code => $name): ?>
                <option value="<?= htmlspecialchars($code) ?>" <?= ($oldInput['seisund_kood'] ?? ($employee['seisund_kood'] ?? '')) === $code ? 'selected' : '' ?>>
                    <?= htmlspecialchars($name) ?>
                </option>
            <?php endforeach; ?>
        </select>
        <?php if (isset($errors['seisund_kood'])): ?>
            <span class="error"><?= htmlspecialchars($errors['seisund_kood']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="on_aktiivne">Active:</label>
        <input type="checkbox" id="on_aktiivne" name="on_aktiivne" value="1" <?= isset($oldInput['on_aktiivne']) || (!empty($employee) && $employee['on_aktiivne']) ? 'checked' : '' ?>>
    </div>

    <button type="submit"><?= $isEdit ? 'Update Employee' : 'Add Employee' ?></button>
</form>