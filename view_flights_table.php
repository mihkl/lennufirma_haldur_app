<?php
// Assumes $list_data is passed from index.php, containing flights from fn_lend_read_all
if (!isset($list_data)) {
    $list_data = [];
}
?>

<h2>Flights</h2>

<?php if (empty($list_data)): ?>
    <p>No flights found.</p>
<?php else: ?>
    <table>
        <thead>
            <tr>
                <th>Code</th>
                <th>Departure</th>
                <th>Destination</th>
                <th>Type</th>
                <th>Aircraft</th>
                <th>Expected Departure</th>
                <th>Expected Arrival</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($list_data as $item): ?>
                <tr>
                    <td><?= htmlspecialchars($item['kood'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['lahtelennujaam_kood'] ?? 'N/A') ?></td>
                    <td><?= htmlspecialchars($item['sihtlennujaam_kood'] ?? 'N/A') ?></td>
                    <td><?= htmlspecialchars($item['lennukituup_kood'] ?? 'N/A') ?></td>
                    <td><?= htmlspecialchars($item['lennuk_reg_nr'] ?? 'N/A') ?></td>
                    <td><?= htmlspecialchars($item['eeldatav_lahkumis_aeg'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['eeldatav_saabumis_aeg'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['seisund_kood'] ?? '') ?></td>
                    <td>
                        <a href="?action=manage_flights&flight_code=<?= htmlspecialchars($item['kood'] ?? '') ?>">Manage</a> |
                        <a href="?action=manage_staffing&flight_code=<?= htmlspecialchars($item['kood'] ?? '') ?>">Staffing</a> |
                        <a href="?action=modify_flight&flight_code=<?= htmlspecialchars($item['kood'] ?? '') ?>">Modify</a>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
<?php endif; ?>