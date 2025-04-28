<?php
// Assumes $pdo, $airports, $aircraft_types, $aircraft are available from index.php
if (!isset($pdo, $airports, $aircraft_types, $aircraft)) { die('Required variables not available'); }
?>

<h2>Registreeri Uus Lend (OP1)</h2>

<form action="index.php" method="post">
    <input type="hidden" name="action" value="do_register_flight">

    <label for="kood">Lennu Kood:</label>
    <input type="text" id="kood" name="kood" required maxlength="10">

    <label for="lahtelennujaam_kood">Lähtelennujaam:</label>
    <select id="lahtelennujaam_kood" name="lahtelennujaam_kood" required>
        <option value="">-- Vali --</option>
        <?php foreach ($airports as $code => $name): ?>
            <option value="<?= htmlspecialchars($code) ?>"><?= htmlspecialchars($name) ?> (<?= htmlspecialchars($code) ?>)</option>
        <?php endforeach; ?>
    </select>

    <label for="sihtlennujaam_kood">Sihtlennujaam:</label>
    <select id="sihtlennujaam_kood" name="sihtlennujaam_kood" required>
        <option value="">-- Vali --</option>
         <?php foreach ($airports as $code => $name): ?>
            <option value="<?= htmlspecialchars($code) ?>"><?= htmlspecialchars($name) ?> (<?= htmlspecialchars($code) ?>)</option>
        <?php endforeach; ?>
    </select>

    <label for="eeldatav_lahkumis_aeg">Eeldatav Lahkumisaeg:</label>
    <input type="datetime-local" id="eeldatav_lahkumis_aeg" name="eeldatav_lahkumis_aeg" required>

    <label for="eeldatav_saabumis_aeg">Eeldatav Saabumisaeg:</label>
    <input type="datetime-local" id="eeldatav_saabumis_aeg" name="eeldatav_saabumis_aeg" required>

    <p>Määra <strong>kas</strong> lennukitüüp <strong>või</strong> konkreetne lennuk:</p>

    <label for="lennukitüüp_kood">Lennukitüüp (valikuline):</label>
    <select id="lennukitüüp_kood" name="lennukitüüp_kood">
        <option value="">-- Vali tüüp (kui lennuk pole teada) --</option>
        <?php foreach ($aircraft_types as $code => $name): ?>
            <option value="<?= htmlspecialchars($code) ?>"><?= htmlspecialchars($name) ?> (<?= htmlspecialchars($code) ?>)</option>
        <?php endforeach; ?>
    </select>

     <label for="lennuk_reg_nr">Konkreetne Lennuk (valikuline):</label>
    <select id="lennuk_reg_nr" name="lennuk_reg_nr">
        <option value="">-- Vali konkreetne lennuk --</option>
         <?php foreach ($aircraft as $reg_nr => $text): ?>
            <option value="<?= htmlspecialchars($reg_nr) ?>"><?= htmlspecialchars($text) ?></option>
        <?php endforeach; ?>
    </select>

    <button type="submit">Registreeri Lend</button>
</form>