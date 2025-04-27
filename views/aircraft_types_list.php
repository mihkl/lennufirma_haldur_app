<?php
// Assumes $list_data (aircraft types from fn_lennukituup_read_all) from index.php
if (!isset($list_data)) {
    $list_data = [];
}
?>

<h2>Aircraft Types</h2>

<?php if (empty($list_data)): ?>
    <p>No aircraft types found.</p>
<?php else: ?>
    <table>
        <thead>
            <tr>
                <th>Code</th>
                <th>Name</th>
                <th>Manufacturer</th>
                <th>Max Range (km)</th>
                <th>Max Passengers</th>
                <th>Cabin Crew</th>
                <th>Pilots</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($list_data as $item): ?>
                <tr>
                    <td><?= htmlspecialchars($item['kood'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['nimetus'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['lennuki_tootja_kood'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['maksimaalne_lennukaugus'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['maksimaalne_reisijate_arv'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['pardapersonali_arv'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['pilootide_arv'] ?? '') ?></td>
                    <td>
                        <a href="?action=edit_aircraft_type&id=<?= htmlspecialchars($item['kood'] ?? '') ?>">Edit</a> |
                        <form method="post" action="" style="display:inline;">
                            <input type="hidden" name="action" value="do_delete_aircraft_type">
                            <input type="hidden" name="kood" value="<?= htmlspecialchars($item['kood'] ?? '') ?>">
                            <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=view_aircraft_types') ?>">
                            <button type="submit" onclick="return confirm('Delete this aircraft type?')">Delete</button>
                        </form>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
<?php endif; ?>

<p><a href="?action=add_aircraft_type">Add New Aircraft Type</a></p>