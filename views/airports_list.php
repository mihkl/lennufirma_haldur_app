<?php
// Assumes $list_data (airports from fn_lennujaam_read_all) from index.php
if (!isset($list_data)) {
    $list_data = [];
}
?>

<h2>Airports</h2>

<?php if (empty($list_data)): ?>
    <p>No airports found.</p>
<?php else: ?>
    <table>
        <thead>
            <tr>
                <th>Code</th>
                <th>Name</th>
                <th>Latitude</th>
                <th>Longitude</th>
                <th>Timezone</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($list_data as $item): ?>
                <tr>
                    <td><?= htmlspecialchars($item['kood'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['nimi'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['koordinaadid_laius'] ?? 'N/A') ?></td>
                    <td><?= htmlspecialchars($item['koordinaadid_pikkus'] ?? 'N/A') ?></td>
                    <td><?= htmlspecialchars($item['ajavoond_kood'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['seisund_kood'] ?? '') ?></td>
                    <td>
                        <a href="?action=edit_airport&id=<?= htmlspecialchars($item['kood'] ?? '') ?>">Edit</a> |
                        <form method="post" action="" style="display:inline;">
                            <input type="hidden" name="action" value="do_delete_airport">
                            <input type="hidden" name="kood" value="<?= htmlspecialchars($item['kood'] ?? '') ?>">
                            <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=view_airports') ?>">
                            <button type="submit" onclick="return confirm('Delete this airport?')">Delete</button>
                        </form>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
<?php endif; ?>

<p><a href="?action=add_airport">Add New Airport</a></p>