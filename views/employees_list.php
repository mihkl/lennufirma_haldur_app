<?php
// Assumes $list_data (employees from tootaja/isik join) from index.php
if (!isset($list_data)) {
    $list_data = [];
}
?>

<h2>Employees</h2>

<?php if (empty($list_data)): ?>
    <p>No employees found.</p>
<?php else: ?>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Code</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($list_data as $item): ?>
                <tr>
                    <td><?= htmlspecialchars($item['isik_id'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['tootaja_kood'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['eesnimi'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['perenimi'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['e_meil'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['seisund_kood'] ?? '') ?></td>
                    <td>
                        <a href="?action=edit_employee&id=<?= htmlspecialchars($item['isik_id'] ?? '') ?>">Edit</a> |
                        <form method="post" action="" style="display:inline;">
                            <input type="hidden" name="action" value="do_delete_employee">
                            <input type="hidden" name="isik_id" value="<?= htmlspecialchars($item['isik_id'] ?? '') ?>">
                            <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=view_employees') ?>">
                            <button type="submit" onclick="return confirm('Delete this employee?')">Delete</button>
                        </form>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
<?php endif; ?>

<p><a href="?action=add_employee">Add New Employee</a></p>