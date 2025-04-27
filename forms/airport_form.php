<?php
// Assumes $crud_data (airport details for edit), $timezones, $airport_statuses, $formErrors, $formOldInput from index.php
$airport = $crud_data ?? [];
$oldInput = $formOldInput ?? [];
$errors = $formErrors ?? [];
$isEdit = !empty($airport);
$action = $isEdit ? 'do_update_airport' : 'do_create_airport';
$title = $isEdit ? 'Edit Airport: ' . htmlspecialchars($airport['kood'] ?? 'N/A') : 'Add Airport';
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
    <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . ($isEdit ? '?action=edit_airport&id=' . urlencode($airport['kood'] ?? '') : '?action=add_airport')) ?>">

    <?php if ($isEdit): ?>
        <input type="hidden" name="kood" value="<?= htmlspecialchars($airport['kood'] ?? '') ?>">
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
        <label for="nimi">Name:</label>
        <input type="text" id="nimi" name="nimi" value="<?= htmlspecialchars($oldInput['nimi'] ?? ($airport['nimi'] ?? '')) ?>" required>
        <?php if (isset($errors['nimi'])): ?>
            <span class="error"><?= htmlspecialchars($errors['nimi']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="koordinaadid_laius">Latitude:</label>
        <input type="number" step="any" id="koordinaadid_laius" name="koordinaadid_laius" value="<?= htmlspecialchars($oldInput['koordinaadid_laius'] ?? ($airport['koordinaadid_laius'] ?? '')) ?>">
        <?php if (isset($errors['koordinaadid_laius'])): ?>
            <span class="error"><?= htmlspecialchars($errors['koordinaadid_laius']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="koordinaadid_pikkus">Longitude:</label>
        <input type="number" step="any" id="koordinaadid_pikkus" name="koordinaadid_pikkus" value="<?= htmlspecialchars($oldInput['koordinaadid_pikkus'] ?? ($airport['koordinaadid_pikkus'] ?? '')) ?>">
        <?php if (isset($errors['koordinaadid_pikkus'])): ?>
            <span class="error"><?= htmlspecialchars($errors['koordinaadid_pikkus']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="ajavoond_kood">Timezone:</label>
        <select id="ajavoond_kood" name="ajavoond_kood" required>
            <option value="">Select Timezone</option>
            <?php foreach ($timezones as $code => $name): ?>
                <option value="<?= htmlspecialchars($code) ?>" <?= ($oldInput['ajavoond_kood'] ?? ($airport['ajavoond_kood'] ?? '')) === $code ? 'selected' : '' ?>>
                    <?= htmlspecialchars($code) ?>
                </option>
            <?php endforeach; ?>
        </select>
        <?php if (isset($errors['ajavoond_kood'])): ?>
            <span class="error"><?= htmlspecialchars($errors['ajavoond_kood']) ?></span>
        <?php endif; ?>
    </div>

    <div>
        <label for="seisund_kood">Status:</label>
        <select id="seisund_kood" name="seisund_kood" required>
            <option value="">Select Status</option>
            <?php foreach ($airport_statuses as $code => $name): ?>
                <option value="<?= htmlspecialchars($code) ?>" <?= ($oldInput['seisund_kood'] ?? ($airport['seisund_kood'] ?? '')) === $code ? 'selected' : '' ?>>
                    <?= htmlspecialchars($name) ?>
                </option>
            <?php endforeach; ?>
        </select>
        <?php if (isset($errors['seisund_kood'])): ?>
            <span class="error"><?= htmlspecialchars($errors['seisund_kood']) ?></span>
        <?php endif; ?>
    </div>

    <button type="submit"><?= $isEdit ? 'Update Airport' : 'Add Airport' ?></button>
</form>