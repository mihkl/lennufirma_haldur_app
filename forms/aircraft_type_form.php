<?php
// Assumes $crud_data (aircraft type details for edit), $aircraft_manufacturers, $formErrors, $formOldInput from index.php
$type = $crud_data ?? [];
$oldInput = $formOldInput ?? [];
$errors = $formErrors ?? [];
$isEdit = !empty($type);
$action = $isEdit ? 'do_update_aircraft_type' : 'do_create_aircraft_type';
$title = $isEdit ? 'Edit Aircraft Type: ' . htmlspecialchars($type['kood'] ?? 'N/A') : 'Add Aircraft Type';
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
    <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . ($isEdit ? '?action=edit_aircraft_type&id=' . urlencode($type['kood'] ?? '') : '?action=add_aircraft_type')) ?>">

    <?php if ($isEdit): ?>
        <input type="hidden" name="kood" value="<?= htmlspecialchars($type['kood'] ?? '') ?>">
    <?php else: ?>
        <div>
            <label for="kood">Code:</label>
            <input type="text" id="kood" name="kood" value="<?= htmlspecialchars($oldInput['kood'] ?? '') ?>" required>
            <?php if (isset($errors['kood'])): ?>
                <span class="error"><?= htmlspecialchars($errors['kood']) ?></span>
            <?php endif; ?>
        </div>
    <?php endif; ?>

    <div>
        <label for="nimetus">Name:</label>
        <input type="text" id="nimetus" name="nimetus" value="<?= htmlspecialchars($oldInput['nimetus'] ?? ($type['nimetus'] ?? '')) ?>" required>
        <?php if (isset($errors['nimetus'])): ?>
            <span class="error"><?= htmlspecialchars($errors['nimetus']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="lennuki_tootja_kood">Manufacturer:</label>
        <select id="lennuki_tootja_kood" name="lennuki_tootja_kood" required>
            <option value="">Select Manufacturer</option>
            <?php foreach ($aircraft_manufacturers as $code => $name): ?>
                <option value="<?= htmlspecialchars($code) ?>" <?= ($oldInput['lennuki_tootja_kood'] ?? ($type['lennuki_tootja_kood'] ?? '')) === $code ? 'selected' : '' ?>>
                    <?= htmlspecialchars($name) ?>
                </option>
            <?php endforeach; ?>
        </select>
        <?php if (isset($errors['lennuki_tootja_kood'])): ?>
            <span class="error"><?= htmlspecialchars($errors['lennuki_tootja_kood']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="maksimaalne_lennukaugus">Max Range (km):</label>
        <input type="number" id="maksimaalne_lennukaugus" name="maksimaalne_lennukaugus" value="<?= htmlspecialchars($oldInput['maksimaalne_lennukaugus'] ?? ($type['maksimaalne_lennukaugus'] ?? '')) ?>" required>
        <?php if (isset($errors['maksimaalne_lennukaugus'])): ?>
            <span class="error"><?= htmlspecialchars($errors['maksimaalne_lennukaugus']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="maksimaalne_reisijate_arv">Max Passengers:</label>
        <input type="number" id="maksimaalne_reisijate_arv" name="maksimaalne_reisijate_arv" value="<?= htmlspecialchars($oldInput['maksimaalne_reisijate_arv'] ?? ($type['maksimaalne_reisijate_arv'] ?? '')) ?>" required>
        <?php if (isset($errors['maksimaalne_reisijate_arv'])): ?>
            <span class="error"><?= htmlspecialchars($errors['maksimaalne_reisijate_arv']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="pardapersonali_arv">Cabin Crew:</label>
        <input type="number" id="pardapersonali_arv" name="pardapersonali_arv" value="<?= htmlspecialchars($oldInput['pardapersonali_arv'] ?? ($type['pardapersonali_arv'] ?? '')) ?>" required>
        <?php if (isset($errors['pardapersonali_arv'])): ?>
            <span class="error"><?= htmlspecialchars($errors['pardapersonali_arv']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="pilootide_arv">Pilots:</label>
        <input type="number" id="pilootide_arv" name="pilootide_arv" value="<?= htmlspecialchars($oldInput['pilootide_arv'] ?? ($type['pilootide_arv'] ?? '')) ?>" required>
        <?php if (isset($errors['pilootide_arv'])): ?>
            <span class="error"><?= htmlspecialchars($errors['pilootide_arv']) ?></span>
        <?php endif; ?>
    </div>

    <button type="submit"><?= $isEdit ? 'Update Aircraft Type' : 'Add Aircraft Type' ?></button>
</form>