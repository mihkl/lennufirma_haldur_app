<?php
// Assumes $list_data (aircraft from fn_lennuk_read_all) from index.php
if (!isset($list_data)) {
    $list_data = [];
}
?>

<h2>Aircraft</h2>

<?php if (empty($list_data)): ?>
    <p>No aircraft found.</p>
<?php else: ?>
    <table>
        <thead>
            <tr>
                <th>Registration Number</th>
                <th>Type</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($list_data as $item): ?>
                <tr>
                    <td><?= htmlspecialchars($item['registreerimisnumber'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['lennukituup_kood'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['seisund_kood'] ?? '') ?></td>
                    <td>
                        <a href="?action=edit_aircraft&reg_nr=<?= htmlspecialchars($item['registreerimisnumber'] ?? '') ?>">Edit</a> |
                        <form method="post" action="" style="display:inline;">
                            <input type="hidden" name="action" value="do_delete_aircraft">
                            <input type="hidden" name="registreerimisnumber" value="<?= htmlspecialchars($item['registreerimisnumber'] ?? '') ?>">
                            <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=view_aircraft') ?>">
                            <button type="submit" onclick="return confirm('Delete this aircraft?')">Delete</button>
                        </form>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
<?php endif; ?>

<p><a href="?action=add_aircraft">Add New Aircraft</a></p>