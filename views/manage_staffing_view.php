<?php
// Assumes $crud_data (flight details), $list_data['crew'] (crew members), $employees, $employee_roles, $formErrors, $formOldInput from index.php
$flight = $crud_data ?? [];
$crew = $list_data['crew'] ?? [];
$oldInput = $formOldInput ?? [];
$errors = $formErrors ?? [];
?>

<h2>Manage Staffing: <?= htmlspecialchars($flight['kood'] ?? 'N/A') ?></h2>

<?php if (empty($flight)): ?>
    <p>Flight not found.</p>
<?php else: ?>
    <p>
        <strong>Departure:</strong> <?= htmlspecialchars($flight['lahtelennujaam_kood'] ?? 'N/A') ?><br>
        <strong>Destination:</strong> <?= htmlspecialchars($flight['sihtlennujaam_kood'] ?? 'N/A') ?><br>
        <strong>Status:</strong> <?= htmlspecialchars($flight['seisund_kood'] ?? 'N/A') ?>
    </p>

    <h3>Current Crew</h3>
    <?php if (empty($crew)): ?>
        <p>No crew assigned.</p>
    <?php else: ?>
        <table>
            <thead>
                <tr>
                    <th>Employee ID</th>
                    <th>Name</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($crew as $member): ?>
                    <tr>
                        <td><?= htmlspecialchars($member['tootaja_isik_id'] ?? '') ?></td>
                        <td><?= htmlspecialchars(($member['eesnimi'] ?? '') . ' ' . ($member['perenimi'] ?? '')) ?></td>
                        <td><?= htmlspecialchars($member['rolli_kood'] ?? '') ?></td>
                        <td>
                            <form method="post" action="">
                                <input type="hidden" name="action" value="do_remove_employee">
                                <input type="hidden" name="lennu_kood" value="<?= htmlspecialchars($flight['kood'] ?? '') ?>">
                                <input type="hidden" name="tootaja_isik_id" value="<?= htmlspecialchars($member['tootaja_isik_id'] ?? '') ?>">
                                <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=manage_staffing&flight_code=' . urlencode($flight['kood'] ?? '')) ?>">
                                <button type="submit" onclick="return confirm('Remove this employee?')">Remove</button>
                            </form>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php endif; ?>

    <?php if (!empty($errors)): ?>
        <div class="error">
            <ul>
                <?php foreach ($errors as $field => $message): ?>
                    <li><?= htmlspecialchars($message) ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <h3>Add Employee to Crew</h3>
    <form method="post" action="">
        <input type="hidden" name="action" value="do_add_employee">
        <input type="hidden" name="lennu_kood" value="<?= htmlspecialchars($flight['kood'] ?? '') ?>">
        <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=manage_staffing&flight_code=' . urlencode($flight['kood'] ?? '')) ?>">

        <div>
            <label for="tootaja_isik_id">Employee:</label>
            <select id="tootaja_isik_id" name="tootaja_isik_id" required>
                <option value="">Select Employee</option>
                <?php foreach ($employees as $id => $name): ?>
                    <option value="<?= htmlspecialchars($id) ?>" <?= ($oldInput['tootaja_isik_id'] ?? '') === $id ? 'selected' : '' ?>>
                        <?= htmlspecialchars($name) ?>
                    </option>
                <?php endforeach; ?>
            </select>
            <?php if (isset($errors['tootaja_isik_id'])): ?>
                <span class="error"><?= htmlspecialchars($errors['tootaja_isik_id']) ?></span>
            <?php endif; ?>
        </div>

        <div>
            <label for="rolli_kood">Role:</label>
            <select id="rolli_kood" name="rolli_kood" required>
                <option value="">Select Role</option>
                <?php foreach ($employee_roles as $code => $name): ?>
                    <option value="<?= htmlspecialchars($code) ?>" <?= ($oldInput['rolli_kood'] ?? '') === $code ? 'selected' : '' ?>>
                        <?= htmlspecialchars($name) ?>
                    </option>
                <?php endforeach; ?>
            </select>
            <?php if (isset($errors['rolli_kood'])): ?>
                <span class="error"><?= htmlspecialchars($errors['rolli_kood']) ?></span>
            <?php endif; ?>
        </div>

        <button type="submit">Add Employee</button>
    </form>
<?php endif; ?>