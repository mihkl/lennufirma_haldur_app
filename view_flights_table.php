<?php
// Use the variable passed from index.php
if (!isset($flightsList)) {
    $flightsList = []; // Initialize if not set, although it should be by index.php
}

// --- Filtering Logic ---
// Operate on the passed $flightsList
$filtered_data = $flightsList;
$filter_status = $_GET['filter_status'] ?? '';
$filter_type = $_GET['filter_type'] ?? '';

// Get unique statuses and types for dropdowns from the *original* list ($flightsList)
$statuses = [];
$types = [];
if (!empty($flightsList)) { // Check if $flightsList is not empty before using array_column
    // Use try-catch in case array_column fails on unexpected data structure
    try {
        $statuses = array_unique(array_column($flightsList, 'seisund_kood'));
        sort($statuses); // Optional: sort alphabetically
        $types = array_unique(array_column($flightsList, 'lennukituup_kood'));
        sort($types); // Optional: sort alphabetically
    } catch (Exception $e) {
        // Handle error if array structure is not as expected
        error_log("Error getting filter options: " . $e->getMessage());
        $statuses = [];
        $types = [];
    }
}


// Apply Status Filter
if (!empty($filter_status)) {
    $filtered_data = array_filter($filtered_data, function($item) use ($filter_status) {
        // Use null coalescing for safety, though keys should exist from the query
        return ($item['seisund_kood'] ?? null) === $filter_status;
    });
}

// Apply Aircraft Type Filter
if (!empty($filter_type)) {
    $filtered_data = array_filter($filtered_data, function($item) use ($filter_type) {
           // Use null coalescing for safety
         return ($item['lennukituup_kood'] ?? null) === $filter_type;
    });
}
// --- End Filtering Logic ---

?>

<style>
    /* Basic styling for the table and form */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    th, td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }
    th {
        background-color: #f2f2f2;
    }
    tr:nth-child(even) {
        background-color: #f9f9f9;
    }
    tr:hover {
        background-color: #f1f1f1;
    }
    form {
        margin-bottom: 20px;
    }
    label, select, input[type="text"], button {
        margin-right: 10px;
    }

    /* Styles for the custom tooltip */
    .status-cell {
        position: relative; /* Needed for absolute positioning of the tooltip */
        cursor: pointer; /* Indicate that the cell is interactive */
    }

    .status-text {
        /* Optional: style the status text itself if needed */
    }

    .cancellation-tooltip {
        display: none; /* Hidden by default */
        position: absolute;
        background-color: #f9edbe; /* Light yellow background */
        color: #333;
        border: 1px solid #f0c36d;
        padding: 10px;
        border-radius: 5px;
        z-index: 100; /* Ensure it's above other content */
        max-width: 300px; /* Make the tooltip wider */
        box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
        top: 100%; /* Position below the cell */
        left: 0;
        margin-top: 5px; /* Space between cell and tooltip */
        white-space: normal; /* Allow text to wrap */
        word-wrap: break-word; /* Break long words */
    }

    /* Show tooltip on hover */
    .status-cell:hover .cancellation-tooltip {
        display: block;
    }

    /* Show tooltip when 'active' class is added by JavaScript (on click) */
    .status-cell.active .cancellation-tooltip {
        display: block;
    }
</style>

<h2>Lennud</h2>

<form method="GET" action="">
    <?php // Preserve existing GET parameters like 'action' ?>
    <?php foreach ($_GET as $key => $value): ?>
        <?php if ($key !== 'filter_status' && $key !== 'filter_type'): ?>
            <input type="hidden" name="<?= htmlspecialchars($key) ?>" value="<?= htmlspecialchars($value) ?>">
        <?php endif; ?>
    <?php endforeach; ?>
    <?php // Ensure action=view_flights is present if missing ?>
    <?php if (!isset($_GET['action'])): ?>
           <input type="hidden" name="action" value="view_flights">
    <?php endif; ?>


    <label for="filter_status">Filtreeri staatuse järgi:</label>
    <select name="filter_status" id="filter_status">
        <option value="">-- Kõik staatused --</option>
        <?php foreach ($statuses as $status): ?>
            <?php if (!empty($status)): // Avoid empty status options ?>
            <option value="<?= htmlspecialchars($status) ?>" <?= ($filter_status === $status) ? 'selected' : '' ?>>
                <?= htmlspecialchars($status) ?>
            </option>
            <?php endif; ?>
        <?php endforeach; ?>
    </select>

    <label for="filter_type">Filtreeri lennukitüübi järgi:</label>
    <select name="filter_type" id="filter_type">
        <option value="">-- Kõik tüübid --</option>
        <?php foreach ($types as $type): ?>
            <?php if (!empty($type)): // Avoid empty type options ?>
            <option value="<?= htmlspecialchars($type) ?>" <?= ($filter_type === $type) ? 'selected' : '' ?>>
                <?= htmlspecialchars($type) ?>
            </option>
            <?php endif; ?>
        <?php endforeach; ?>
    </select>

    <button type="submit">Filtreeri</button>
    <?php // Ensure Clear Filters link keeps the action parameter ?>
    <a href="?action=<?= htmlspecialchars($_GET['action'] ?? 'view_flights') ?>">Clear Filters</a>
</form>
<hr>


<?php if (empty($filtered_data)): ?>
    <p>Ühtegi lendi ei leitud<?= (!empty($filter_status) || !empty($filter_type)) ? ' mis vastaks sinu filtreeringutele' : '' ?>.</p>
<?php else: ?>
    <table>
        <thead>
            <tr>
                <th>Kood</th>
                <th>Lähtekoht</th>
                <th>Sihtkoht</th>
                <th>Tüüp</th>
                <th>Vahemaa (km)</th>
                <th>Broneeringud</th>
                <th>Lennuki registratsioon</th>
                <th>Eeldatav lahkumisaeg</th>
                <th>Eeldatav saabumisaeg</th>
                <th>Staatus</th> <th>Tegevused</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($filtered_data as $item): ?>
                <tr>
                    <td><?= htmlspecialchars($item['kood'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['lahtelennujaam_kood'] ?? 'N/A') ?></td>
                    <td><?= htmlspecialchars($item['sihtlennujaam_kood'] ?? 'N/A') ?></td>
                    <td><?= htmlspecialchars($item['lennukituup_kood'] ?? 'N/A') ?></td>
                    <td><?= htmlspecialchars($item['kaugus_linnulennult'] ?? 'N/A') ?></td>
                    <td>
                        <?php
                            // Assumes 'booked_count' and 'maksimaalne_reisijate_arv' keys exist in $item
                            // You MUST modify your database query to provide 'booked_count'
                            $booked = $item['booked_count'] ?? 0; // Default to 0 if not set
                            $max = $item['maksimaalne_reisijate_arv'] ?? '?'; // Default to '?' if not set
                            echo htmlspecialchars($booked) . ' / ' . htmlspecialchars($max);
                        ?>
                    </td>
                    <td><?= htmlspecialchars($item['lennuk_reg_nr'] ?? 'N/A') ?></td>
                    <td><?= htmlspecialchars($item['eeldatav_lahkumis_aeg'] ?? '') ?></td>
                    <td><?= htmlspecialchars($item['eeldatav_saabumis_aeg'] ?? '') ?></td>
                    <?php
                        $status = htmlspecialchars($item['seisund_kood'] ?? '');
                        $cancellationReason = htmlspecialchars($item['tuhistamise_pohjus'] ?? '');
                    ?>
                    <td class="status-cell"> <span class="status-text"><?= $status ?></span> <?php if ($status === 'CANCELED' && !empty($cancellationReason)): ?>
                            <div class="cancellation-tooltip"> <?= $cancellationReason ?>
                            </div>
                        <?php endif; ?>
                    </td>
                    <td>
                        <a href="?action=manage_flights&flight_code=<?= urlencode($item['kood'] ?? '') ?>">Halda</a> |
                        <a href="?action=manage_staffing&flight_code=<?= urlencode($item['kood'] ?? '') ?>">Meeskond</a> |
                        <a href="?action=modify_flight&flight_code=<?= urlencode($item['kood'] ?? '') ?>">Muuda</a>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>

    <script>
        // Add JavaScript for click functionality
        document.addEventListener('DOMContentLoaded', function() {
            // Get all status cells that might have a tooltip
            const statusCells = document.querySelectorAll('.status-cell');

            statusCells.forEach(cell => {
                // Find the status text and tooltip within the cell
                const statusText = cell.querySelector('.status-text');
                const tooltip = cell.querySelector('.cancellation-tooltip');

                // Add click listener if a tooltip exists
                if (statusText && tooltip) {
                    statusText.addEventListener('click', function() {
                        // Toggle the 'active' class on the parent cell
                        cell.classList.toggle('active');
                    });

                    // Optional: Hide tooltip when clicking outside (basic implementation)
                    document.addEventListener('click', function(event) {
                        if (!cell.contains(event.target) && cell.classList.contains('active')) {
                            cell.classList.remove('active');
                        }
                    });
                }
            });
        });
    </script>

<?php endif; ?>
