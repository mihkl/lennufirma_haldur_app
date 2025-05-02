<?php
// Assumes $crud_data (flight details), $aircraft, $formErrors, $formOldInput from index.php
$flight = $crud_data ?? [];
$oldInput = $formOldInput ?? [];
$errors = $formErrors ?? [];

// Determine the active tab based on a GET parameter or default to 'details'
$activeTab = $_GET['tab'] ?? 'details';

// Function to check if a tab is active
function isActiveTab($tabName, $activeTab) {
    return $tabName === $activeTab ? 'active' : '';
}
$booked_count = $flight['booked_count'] ?? 0; // Get the count passed from controller

// Check flight status for conditional display
$isFlightCanceled = ($flight['seisund_kood'] ?? '') === 'CANCELED'; // Use your actual code
$canDelete = ($flight['seisund_kood'] ?? '') === 'PLANNED'; // Use your actual code

// Get booking info
$max_passengers = $flight['maksimaalne_reisijate_arv'] ?? null; // Get max passengers

// Check if flight is canceled
$isFlightCanceled = ($flight['seisund_kood'] ?? '') === 'CANCELED';
?>

<style>
    /* Basic styling for the page */
    body {
        font-family: sans-serif;
        line-height: 1.6;
        margin: 20px;
    }
    h2, h3 {
        color: #333;
    }
    .error {
        color: red;
        margin-bottom: 15px;
    }
    .error ul {
        list-style: none;
        padding: 0;
    }
    .error li {
        margin-bottom: 5px;
    }
    form div {
        margin-bottom: 15px;
    }
    label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
    }
    input[type="text"],
    input[type="datetime-local"],
    select,
    textarea {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box; /* Include padding and border in the element's total width and height */
    }
    textarea {
        height: 100px;
        resize: vertical; /* Allow vertical resizing */
    }
    button {
        background-color: #0EA5E9; /* Updated button color */
        color: white;
        padding: 10px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
    }
    button:hover {
        background-color: #0B4F72; /* Darker shade for hover */
    }

    /* Tab styling */
    .tabs {
        display: flex;
        margin-bottom: 20px;
        border-bottom: 1px solid #ddd;
    }
    .tab-button {
        padding: 10px 15px;
        cursor: pointer;
        border: none;
        outline: none;
        font-size: 16px;
        margin-right: 5px;
        border-bottom: 2px solid transparent;
        transition: border-bottom 0.3s ease;
    }
    .tab-button:hover {
        border-bottom-color: #aaa;
    }
    .tab-button.active {
        border-bottom-color: #0B4F72; /* Updated active tab border color */
        font-weight: bold;
        color: #0B4F72; /* Updated active tab text color */
    }

    /* Tab content styling */
    .tab-content {
        display: none; /* Hide inactive tab content */
        padding-top: 15px;
    }
    .tab-content.active {
        display: block; /* Show active tab content */
    }
</style>

<h2>Manage Flight: <?= htmlspecialchars($flight['lend_kood'] ?? 'N/A') ?></h2>

<?php if (empty($flight)): ?>
    <p>Flight not found.</p>
<?php else: ?>
    <?php if (!empty($errors)): ?>
        <div class="error">
            <ul>
                <?php foreach ($errors as $field => $message): ?>
                    <li><?= htmlspecialchars($message) ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <div class="tabs">
        <button class="tab-button <?= isActiveTab('details', $activeTab) ?>" onclick="openTab(event, 'details')">Details</button>
        <button class="tab-button <?= isActiveTab('cancel', $activeTab) ?>" onclick="openTab(event, 'cancel')">Cancel Flight</button>
        <?php if (!$isFlightCanceled): ?>
        <button class="tab-button <?= isActiveTab('delay', $activeTab) ?>" onclick="openTab(event, 'delay')">Delay Flight</button>
        <?php endif; ?>
        <button class="tab-button <?= isActiveTab('assign', $activeTab) ?>" onclick="openTab(event, 'assign')">Assign Aircraft</button>
        <?php if ($canDelete): ?>
            <button class="tab-button <?= isActiveTab('delete', $activeTab) ?>" onclick="openTab(event, 'delete')">Delete Flight</button>
        <?php endif; ?>
    </div>

    <div id="details" class="tab-content <?= isActiveTab('details', $activeTab) ?>">
        <h3>Flight Details</h3>
        <p>
            <strong>Departure:</strong> <?= htmlspecialchars($flight['lahtelennujaam_kood'] ?? 'N/A') ?><br>
            <strong>Destination:</strong> <?= htmlspecialchars($flight['sihtlennujaam_kood'] ?? 'N/A') ?><br>
            <strong>Aircraft Type:</strong> <?= htmlspecialchars($flight['lennukituup_kood'] ?? 'N/A') ?><br>
            <strong>Aircraft:</strong> <?= htmlspecialchars($flight['lennuk_reg_nr'] ?? 'N/A') ?><br>
            <strong>Booked Passengers:</strong> <?= htmlspecialchars($booked_count) ?> / <?= htmlspecialchars($max_passengers) ?><br>
            <strong>Max Passengers:</strong> <?= htmlspecialchars($flight['maksimaalne_reisijate_arv'] ?? 'N/A') ?><br>
            <strong>Expected Departure:</strong> <?= htmlspecialchars($flight['eeldatav_lahkumis_aeg'] ?? 'N/A') ?><br>
            <strong>Expected Arrival:</strong> <?= htmlspecialchars($flight['eeldatav_saabumis_aeg'] ?? 'N/A') ?><br>
            <strong>Status:</strong> <?= htmlspecialchars($flight['seisund_kood'] ?? 'N/A') ?>
            <?php if ($isFlightCanceled && !empty($flight['tuhistamise_pohjus'] ?? '')): ?>
                <br><strong>Cancellation Reason:</strong> <?= htmlspecialchars($flight['tuhistamise_pohjus']) ?>
            <?php endif; ?>
        </p>
    </div>

    <div id="cancel" class="tab-content <?= isActiveTab('cancel', $activeTab) ?>">
        <h3>Cancel Flight</h3>
        <?php if ($isFlightCanceled): ?>
            <p>This flight is already canceled.</p>
        <?php else: ?>
            <form method="post" action="">
                <input type="hidden" name="action" value="do_cancel_flight">
                <input type="hidden" name="lend_kood" value="<?= htmlspecialchars($flight['lend_kood'] ?? '') ?>">
                <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($flight['lend_kood'] ?? '')) ?>">
                <input type="hidden" name="redirect_tab" value="cancel">

                <div>
                    <label for="pohjus">Reason:</label>
                    <textarea id="pohjus" name="pohjus" required><?= htmlspecialchars($oldInput['pohjus'] ?? '') ?></textarea>
                    <?php if (isset($errors['pohjus'])): ?>
                        <span class="error"><?= htmlspecialchars($errors['pohjus']) ?></span>
                    <?php endif; ?>
                </div>

                <button type="submit">Cancel Flight</button>
            </form>
        <?php endif; ?>
    </div>

    <?php if (!$isFlightCanceled): ?>
    <div id="delay" class="tab-content <?= isActiveTab('delay', $activeTab) ?>">
        <h3>Delay Flight</h3>
        <form method="post" action="">
            <input type="hidden" name="action" value="do_delay_flight">
            <input type="hidden" name="lend_kood" value="<?= htmlspecialchars($flight['lend_kood'] ?? '') ?>">
            <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($flight['lend_kood'] ?? '')) ?>">
            <input type="hidden" name="redirect_tab" value="delay">

            <div>
                <label for="uus_lahkumis_aeg">New Departure Time:</label>
                <input type="datetime-local" id="uus_lahkumis_aeg" name="uus_lahkumis_aeg" value="<?= htmlspecialchars($oldInput['uus_lahkumis_aeg'] ?? '') ?>" required>
                <?php if (isset($errors['uus_lahkumis_aeg'])): ?>
                    <span class="error"><?= htmlspecialchars($errors['uus_lahkumis_aeg']) ?></span>
                <?php endif; ?>
            </div>

            <div>
                <label for="uus_saabumis_aeg">New Arrival Time:</label>
                <input type="datetime-local" id="uus_saabumis_aeg" name="uus_saabumis_aeg" value="<?= htmlspecialchars($oldInput['uus_saabumis_aeg'] ?? '') ?>" required>
                <?php if (isset($errors['uus_saabumis_aeg'])): ?>
                    <span class="error"><?= htmlspecialchars($errors['uus_saabumis_aeg']) ?></span>
                <?php endif; ?>
            </div>

            <button type="submit">Delay Flight</button>
        </form>
    </div>
    <?php endif; ?>

    <div id="assign" class="tab-content <?= isActiveTab('assign', $activeTab) ?>">
        <h3>Assign Aircraft</h3>
        <?php if (!empty($flight['lennuk_reg_nr'])): ?>
            <p>An aircraft (<?= htmlspecialchars($flight['lennuk_reg_nr']) ?>) is already assigned to this flight.</p>
        <?php else: ?>
            <form method="post" action="">
                <input type="hidden" name="action" value="do_assign_aircraft">
                <input type="hidden" name="lend_kood" value="<?= htmlspecialchars($flight['lend_kood'] ?? '') ?>">
                <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($flight['lend_kood'] ?? '')) ?>">
                <input type="hidden" name="redirect_tab" value="assign">

                <div>
                    <label for="lennuk_reg_nr">Aircraft:</label>
                    <select id="lennuk_reg_nr" name="lennuk_reg_nr" required>
                        <option value="">Select Aircraft</option>
                        <?php foreach ($aircraft as $reg => $name): ?>
                            <option value="<?= htmlspecialchars($reg) ?>" <?= ($oldInput['lennuk_reg_nr'] ?? '') === $reg ? 'selected' : '' ?>>
                                <?= htmlspecialchars($reg) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                    <?php if (isset($errors['lennuk_reg_nr'])): ?>
                        <span class="error"><?= htmlspecialchars($errors['lennuk_reg_nr']) ?></span>
                    <?php endif; ?>
                </div>

                <button type="submit">Assign Aircraft</button>
            </form>
        <?php endif; ?>
    </div>
    
    <?php if ($canDelete): ?>
    <div id="delete" class="tab-content <?= isActiveTab('delete', $activeTab) ?>">
        <h3>Delete Flight</h3>
        <form method="post" action="">
            <input type="hidden" name="action" value="do_delete_flight">
            <input type="hidden" name="lend_kood" value="<?= htmlspecialchars($flight['lend_kood'] ?? '') ?>">
            <input type="hidden" name="redirect_back" value="<?= htmlspecialchars($_SERVER['PHP_SELF'] . '?action=manage_flights&flight_code=' . urlencode($flight['lend_kood'] ?? '')) ?>">
            <input type="hidden" name="redirect_tab" value="delete">

            <button type="submit" onclick="return confirm('Are you sure you want to delete this flight?')">Delete Flight</button>
        </form>
    </div>
    <?php endif; ?>

    <script>
        // JavaScript for tab functionality
        function openTab(evt, tabName) {
            // Declare all variables
            var i, tabcontent, tabbuttons;

            // Get all elements with class="tab-content" and hide them
            tabcontent = document.getElementsByClassName("tab-content");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }

            // Get all elements with class="tab-button" and remove the class "active"
            tabbuttons = document.getElementsByClassName("tab-button");
            for (i = 0; i < tabbuttons.length; i++) {
                tabbuttons[i].className = tabbuttons[i].className.replace(" active", "");
            }

            // Show the current tab, and add an "active" class to the button that opened the tab
            document.getElementById(tabName).style.display = "block";
            evt.currentTarget.className += " active";

            // Update the URL hash to remember the active tab (optional but good for usability)
            history.replaceState(null, null, '?action=manage_flights&flight_code=<?= urlencode($flight['lend_kood'] ?? '') ?>&tab=' + tabName);
        }

        // Automatically open the default or specified tab on page load
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const activeTab = urlParams.get('tab') || 'details'; // Default to 'details'
            
            // Check if the active tab exists, especially important for 'delay' which may be hidden
            if (document.getElementById(activeTab)) {
                const initialTabButton = document.querySelector(`.tab-button[onclick*="'${activeTab}'"]`);
                if (initialTabButton) {
                    // Simulate a click on the button to activate the tab
                    initialTabButton.click();
                } else {
                    // If the specified tab doesn't exist, activate the default 'details' tab
                    document.querySelector('.tab-button[onclick*="\'details\'"]').click();
                }
            } else {
                // If the tab content doesn't exist, default to 'details'
                document.querySelector('.tab-button[onclick*="\'details\'"]').click();
            }
        });
    </script>

<?php endif; ?>