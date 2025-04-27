-- ========================================================================== --
--            SCHEMA SETUP (Lennude Haldur Perspective) v2.2              --
-- ========================================================================== --
-- Modified to remove Estonian letters (e.g., ä, ö, ü) for UTF-8 compatibility
-- Added _read_all functions for classifier tables to align with PHP fetch logic

DROP SCHEMA IF EXISTS lennufirma CASCADE;
CREATE SCHEMA lennufirma;
SET search_path TO lennufirma;

-- =========================================
-- Classifier Tables (Full Definition)
-- =========================================
CREATE TABLE lennu_seisund_liik (kood VARCHAR(20) PRIMARY KEY, nimetus VARCHAR(100) NOT NULL UNIQUE, kirjeldus TEXT);
CREATE TABLE lennujaama_seisund_liik (kood VARCHAR(20) PRIMARY KEY, nimetus VARCHAR(100) NOT NULL UNIQUE, kirjeldus TEXT);
CREATE TABLE lennuki_seisund_liik (kood VARCHAR(20) PRIMARY KEY, nimetus VARCHAR(100) NOT NULL UNIQUE, kirjeldus TEXT);
CREATE TABLE hoolduse_seisund_liik (kood VARCHAR(20) PRIMARY KEY, nimetus VARCHAR(100) NOT NULL UNIQUE, kirjeldus TEXT);
CREATE TABLE tootaja_seisund_liik (kood VARCHAR(20) PRIMARY KEY, nimetus VARCHAR(100) NOT NULL UNIQUE, kirjeldus TEXT);
CREATE TABLE kliendi_seisund_liik (kood VARCHAR(20) PRIMARY KEY, nimetus VARCHAR(100) NOT NULL UNIQUE, kirjeldus TEXT);
CREATE TABLE litsentsi_seisund_liik (kood VARCHAR(20) PRIMARY KEY, nimetus VARCHAR(100) NOT NULL UNIQUE, kirjeldus TEXT);
CREATE TABLE broneeringu_seisund_liik (kood VARCHAR(20) PRIMARY KEY, nimetus VARCHAR(100) NOT NULL UNIQUE, kirjeldus TEXT);
CREATE TABLE tootaja_roll (kood VARCHAR(20) PRIMARY KEY, nimetus VARCHAR(100) NOT NULL UNIQUE, kirjeldus TEXT);
CREATE TABLE lennuki_tootja (kood VARCHAR(20) PRIMARY KEY, nimetus VARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE ajavoond (kood VARCHAR(50) PRIMARY KEY, nimetus VARCHAR(100) NOT NULL, utc_nihe INTERVAL);

-- =========================================
-- Core Entity Tables (Full Definition)
-- =========================================
CREATE TABLE lennujaam (
    kood VARCHAR(3) PRIMARY KEY,
    nimi VARCHAR(100) NOT NULL,
    koordinaadid_laius DECIMAL(9, 6),
    koordinaadid_pikkus DECIMAL(9, 6),
    ajavoond_kood VARCHAR(50) REFERENCES ajavoond(kood),
    seisund_kood VARCHAR(20) NOT NULL REFERENCES lennujaama_seisund_liik(kood),
    reg_aeg TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    viimase_muutm_aeg TIMESTAMPTZ
);
CREATE TABLE lennukituup (
    kood VARCHAR(20) PRIMARY KEY,
    nimetus VARCHAR(100) NOT NULL,
    lennuki_tootja_kood VARCHAR(20) NOT NULL REFERENCES lennuki_tootja(kood),
    maksimaalne_lennukaugus INT CHECK (maksimaalne_lennukaugus > 0),
    maksimaalne_reisijate_arv INT CHECK (maksimaalne_reisijate_arv >= 0),
    pardapersonali_arv INT CHECK (pardapersonali_arv >= 0),
    pilootide_arv INT CHECK (pilootide_arv > 0)
);
CREATE TABLE lennuk (
    registreerimisnumber VARCHAR(10) PRIMARY KEY,
    lennukituup_kood VARCHAR(20) NOT NULL REFERENCES lennukituup(kood),
    seisund_kood VARCHAR(20) NOT NULL REFERENCES lennuki_seisund_liik(kood),
    reg_aeg TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    viimase_muutm_aeg TIMESTAMPTZ
);
CREATE TABLE isik (
    isik_id SERIAL PRIMARY KEY,
    isikukood VARCHAR(20) UNIQUE,
    eesnimi VARCHAR(50),
    perenimi VARCHAR(50),
    synni_kp DATE,
    elukoht TEXT,
    e_meil VARCHAR(254) UNIQUE NOT NULL,
    parool VARCHAR(255) NULL,
    on_aktiivne BOOLEAN DEFAULT TRUE,
    reg_aeg TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    viimase_muutm_aeg TIMESTAMPTZ,
    CHECK (eesnimi IS NOT NULL OR perenimi IS NOT NULL)
);
CREATE TABLE tootaja (
    isik_id INT PRIMARY KEY REFERENCES isik(isik_id) ON DELETE CASCADE,
    tootaja_kood VARCHAR(20) UNIQUE,
    seisund_kood VARCHAR(20) NOT NULL REFERENCES tootaja_seisund_liik(kood)
);
CREATE TABLE klient (
    isik_id INT PRIMARY KEY REFERENCES isik(isik_id) ON DELETE CASCADE,
    kliendi_kood VARCHAR(20) UNIQUE,
    seisund_kood VARCHAR(20) NOT NULL REFERENCES kliendi_seisund_liik(kood)
);
CREATE TABLE litsents (
    litsents_id SERIAL PRIMARY KEY,
    tootaja_isik_id INT NOT NULL REFERENCES tootaja(isik_id),
    lennukituup_kood VARCHAR(20) NOT NULL REFERENCES lennukituup(kood),
    tootaja_roll_kood VARCHAR(20) NOT NULL REFERENCES tootaja_roll(kood),
    kehtivuse_algus TIMESTAMPTZ NOT NULL,
    kehtivuse_lopp TIMESTAMPTZ NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL REFERENCES litsentsi_seisund_liik(kood),
    CHECK (kehtivuse_lopp > kehtivuse_algus),
    UNIQUE (tootaja_isik_id, lennukituup_kood, tootaja_roll_kood)
);
CREATE TABLE lend (
    kood VARCHAR(10) PRIMARY KEY,
    lahtelennujaam_kood VARCHAR(3) NOT NULL REFERENCES lennujaam(kood),
    sihtlennujaam_kood VARCHAR(3) NOT NULL REFERENCES lennujaam(kood),
    lennukituup_kood VARCHAR(20),
    lennuk_reg_nr VARCHAR(10) REFERENCES lennuk(registreerimisnumber),
    eeldatav_lahkumisaeg TIMESTAMPTZ NOT NULL,
    eeldatav_saabumisaeg TIMESTAMPTZ NOT NULL,
    tegelik_lahkumisaeg TIMESTAMPTZ,
    tegelik_saabumisaeg TIMESTAMPTZ,
    seisund_kood VARCHAR(20) NOT NULL REFERENCES lennu_seisund_liik(kood),
    kaugus_linnulennult DECIMAL(10, 2),
    tuhistamise_pohjus TEXT,
    reg_aeg TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    viimase_muutm_aeg TIMESTAMPTZ,
    CONSTRAINT fk_lend_lennukituup FOREIGN KEY (lennukituup_kood) REFERENCES lennukituup(kood),
    CHECK (sihtlennujaam_kood != lahtelennujaam_kood),
    CHECK (eeldatav_saabumisaeg > eeldatav_lahkumisaeg),
    CHECK (tegelik_saabumisaeg IS NULL OR tegelik_lahkumisaeg IS NULL OR tegelik_saabumisaeg > tegelik_lahkumisaeg),
    CONSTRAINT lend_lennuk_xor CHECK ( (lennukituup_kood IS NOT NULL) OR (lennuk_reg_nr IS NOT NULL) )
);
CREATE TABLE tootaja_lennus (
    tootaja_lennus_id SERIAL PRIMARY KEY,
    lend_kood VARCHAR(10) NOT NULL REFERENCES lend(kood) ON DELETE CASCADE,
    tootaja_isik_id INT NOT NULL REFERENCES tootaja(isik_id),
    tootaja_roll_kood VARCHAR(20) NOT NULL REFERENCES tootaja_roll(kood),
    UNIQUE (lend_kood, tootaja_isik_id)
);
CREATE TABLE hooldus (
    hooldus_id SERIAL PRIMARY KEY,
    lennuk_reg_nr VARCHAR(10) NOT NULL REFERENCES lennuk(registreerimisnumber),
    alguse_aeg TIMESTAMPTZ NOT NULL,
    lopu_aeg TIMESTAMPTZ,
    seisund_kood VARCHAR(20) NOT NULL REFERENCES hoolduse_seisund_liik(kood),
    kirjeldus TEXT,
    CHECK (lopu_aeg IS NULL OR lopu_aeg > alguse_aeg)
);
CREATE TABLE broneering (
    broneering_id SERIAL PRIMARY KEY,
    lend_kood VARCHAR(10) NOT NULL REFERENCES lend(kood) ON DELETE RESTRICT,
    klient_isik_id INT NOT NULL REFERENCES klient(isik_id),
    seisund_kood VARCHAR(20) NOT NULL REFERENCES broneeringu_seisund_liik(kood),
    broneerimise_aeg TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    viimase_muutm_aeg TIMESTAMPTZ
);

-- =========================================
-- Indexes (Full Definition)
-- =========================================
CREATE INDEX idx_lend_lahkumis_aeg ON lend(eeldatav_lahkumisaeg);
CREATE INDEX idx_lend_saabumis_aeg ON lend(eeldatav_saabumisaeg);
CREATE INDEX idx_lend_seisund ON lend(seisund_kood);
CREATE INDEX idx_lend_lahtelennujaam ON lend(lahtelennujaam_kood);
CREATE INDEX idx_lend_sihtlennujaam ON lend(sihtlennujaam_kood);
CREATE INDEX idx_lend_lennuk ON lend(lennuk_reg_nr);
CREATE INDEX idx_lend_lennukituup ON lend(lennukituup_kood);
CREATE INDEX idx_lennuk_tuup ON lennuk(lennukituup_kood);
CREATE INDEX idx_litsents_tootaja ON litsents(tootaja_isik_id);
CREATE INDEX idx_litsents_tuup ON litsents(lennukituup_kood);
CREATE INDEX idx_tootaja_lennus_lend ON tootaja_lennus(lend_kood);
CREATE INDEX idx_tootaja_lennus_tootaja ON tootaja_lennus(tootaja_isik_id);
CREATE INDEX idx_hooldus_lennuk ON hooldus(lennuk_reg_nr);
CREATE INDEX idx_broneering_lend ON broneering(lend_kood);
CREATE INDEX idx_broneering_klient ON broneering(klient_isik_id);
CREATE INDEX idx_isik_email ON isik(e_meil);
CREATE INDEX idx_lennujaam_nimi ON lennujaam(nimi);
CREATE INDEX idx_lennukituup_nimi ON lennukituup(nimetus);

-- ========================================================================== --
--                                HELPER FUNCTIONS                            --
-- ========================================================================== --

-- Helper to update viimase_muutm_aeg
CREATE OR REPLACE FUNCTION fn_update_viimase_muutm_aeg()
RETURNS TRIGGER AS $$
BEGIN
  NEW.viimase_muutm_aeg = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to tables needing automatic timestamp updates
CREATE TRIGGER trg_lend_update_viimase_muutm_aeg BEFORE UPDATE ON lend FOR EACH ROW EXECUTE FUNCTION fn_update_viimase_muutm_aeg();
CREATE TRIGGER trg_lennujaam_update_viimase_muutm_aeg BEFORE UPDATE ON lennujaam FOR EACH ROW EXECUTE FUNCTION fn_update_viimase_muutm_aeg();
CREATE TRIGGER trg_lennuk_update_viimase_muutm_aeg BEFORE UPDATE ON lennuk FOR EACH ROW EXECUTE FUNCTION fn_update_viimase_muutm_aeg();
CREATE TRIGGER trg_isik_update_viimase_muutm_aeg BEFORE UPDATE ON isik FOR EACH ROW EXECUTE FUNCTION fn_update_viimase_muutm_aeg();
CREATE TRIGGER trg_broneering_update_viimase_muutm_aeg BEFORE UPDATE ON broneering FOR EACH ROW EXECUTE FUNCTION fn_update_viimase_muutm_aeg();

-- ========================================================================== --
--                 LENNUDE HALDUR SPECIFIC FUNCTIONS                          --
-- ========================================================================== --

-- === Lend Table Operations ===

-- OP1: Registreeri lend
CREATE OR REPLACE FUNCTION fn_op1_registreeri_lend(
  p_kood VARCHAR(10), p_lahtelennujaam_kood VARCHAR(3), p_sihtlennujaam_kood VARCHAR(3),
  p_eeldatav_lahkumisaeg TIMESTAMPTZ, p_eeldatav_saabumisaeg TIMESTAMPTZ,
  p_lennukituup_kood VARCHAR(20) DEFAULT NULL, p_lennuk_reg_nr VARCHAR(10) DEFAULT NULL
) RETURNS VARCHAR(10) LANGUAGE plpgsql AS $$
DECLARE v_created_kood VARCHAR(10);
BEGIN
  IF p_sihtlennujaam_kood = p_lahtelennujaam_kood THEN RAISE EXCEPTION 'Departure and destination airport cannot be the same (%).', p_lahtelennujaam_kood; END IF;
  IF p_eeldatav_saabumisaeg <= p_eeldatav_lahkumisaeg THEN RAISE EXCEPTION 'Expected arrival time (%) must be later than departure time (%).', p_eeldatav_saabumisaeg, p_eeldatav_lahkumisaeg; END IF;
  IF p_lennukituup_kood IS NULL AND p_lennuk_reg_nr IS NULL THEN RAISE EXCEPTION 'Must specify either aircraft type or specific aircraft.'; END IF;
  -- Validate foreign keys before insert
  IF NOT EXISTS (SELECT 1 FROM lennujaam WHERE kood = p_lahtelennujaam_kood) THEN RAISE EXCEPTION 'Departure airport % not found.', p_lahtelennujaam_kood; END IF;
  IF NOT EXISTS (SELECT 1 FROM lennujaam WHERE kood = p_sihtlennujaam_kood) THEN RAISE EXCEPTION 'Destination airport % not found.', p_sihtlennujaam_kood; END IF;
  IF p_lennukituup_kood IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennukituup WHERE kood = p_lennukituup_kood) THEN RAISE EXCEPTION 'Aircraft type % not found.', p_lennukituup_kood; END IF;
  IF p_lennuk_reg_nr IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennuk WHERE registreerimisnumber = p_lennuk_reg_nr) THEN RAISE EXCEPTION 'Aircraft % not found.', p_lennuk_reg_nr; END IF;

  INSERT INTO lend (kood, lahtelennujaam_kood, sihtlennujaam_kood, lennukituup_kood, lennuk_reg_nr, eeldatav_lahkumisaeg, eeldatav_saabumisaeg, seisund_kood, reg_aeg, viimase_muutm_aeg)
  VALUES (upper(p_kood), p_lahtelennujaam_kood, p_sihtlennujaam_kood, p_lennukituup_kood, p_lennuk_reg_nr, p_eeldatav_lahkumisaeg, p_eeldatav_saabumisaeg, 'PLANNED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
  RETURNING kood INTO v_created_kood;
  RETURN v_created_kood;
END; $$;
COMMENT ON FUNCTION fn_op1_registreeri_lend IS 'OP1: Registers a new flight with status PLANNED.';

-- OP3: Cancel flight
CREATE OR REPLACE FUNCTION fn_op3_tuhista_lend(p_lennu_kood VARCHAR(10), p_pohjus TEXT)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE v_current_seisund VARCHAR(20);
BEGIN
  SELECT seisund_kood INTO v_current_seisund FROM lend WHERE kood = upper(p_lennu_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'Flight with code % not found.', upper(p_lennu_kood); END IF;
  IF v_current_seisund NOT IN ('PLANNED', 'CONFIRMED', 'DELAYED', 'BOARDING', 'GATE DEPARTED') THEN RAISE EXCEPTION 'Flight % cannot be canceled in status %.', upper(p_lennu_kood), v_current_seisund; END IF;
  IF p_pohjus IS NULL OR TRIM(p_pohjus) = '' THEN RAISE EXCEPTION 'Cancellation reason is required.'; END IF;
  UPDATE lend SET seisund_kood = 'CANCELED', tuhistamise_pohjus = p_pohjus WHERE kood = upper(p_lennu_kood);
END; $$;
COMMENT ON FUNCTION fn_op3_tuhista_lend IS 'OP3: Changes flight status to CANCELED and adds reason.';

-- OP4: Mark flight as delayed
CREATE OR REPLACE FUNCTION fn_op4_maara_hilinenuks(p_lennu_kood VARCHAR(10), p_uus_lahkumisaeg TIMESTAMPTZ, p_uus_saabumisaeg TIMESTAMPTZ)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE v_lend lend%ROWTYPE;
BEGIN
  SELECT * INTO v_lend FROM lend WHERE kood = upper(p_lennu_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'Flight with code % not found.', upper(p_lennu_kood); END IF;
  IF v_lend.seisund_kood NOT IN ('PLANNED', 'CONFIRMED', 'DELAYED') THEN RAISE EXCEPTION 'Flight % cannot be marked delayed in status %.', upper(p_lennu_kood), v_lend.seisund_kood; END IF;
  IF p_uus_saabumisaeg <= p_uus_lahkumisaeg THEN RAISE EXCEPTION 'New arrival time (%) must be later than departure time (%).', p_uus_saabumisaeg, p_uus_lahkumisaeg; END IF;
  IF p_uus_lahkumisaeg <= v_lend.eeldatav_lahkumisaeg THEN RAISE EXCEPTION 'New departure time must be later than original.'; END IF;
  UPDATE lend SET seisund_kood = 'DELAYED', eeldatav_lahkumisaeg = p_uus_lahkumisaeg, eeldatav_saabumisaeg = p_uus_saabumisaeg WHERE kood = upper(p_lennu_kood);
END; $$;
COMMENT ON FUNCTION fn_op4_maara_hilinenuks IS 'OP4: Changes flight status to DELAYED and updates times.';

-- OP13: Delete flight
CREATE OR REPLACE FUNCTION fn_op13_kustuta_lend(p_lennu_kood VARCHAR(10))
RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE v_lend lend%ROWTYPE; v_count INT;
BEGIN
  SELECT * INTO v_lend FROM lend WHERE kood = upper(p_lennu_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'Flight with code % not found.', upper(p_lennu_kood); END IF;
  IF v_lend.seisund_kood != 'PLANNED' THEN RAISE EXCEPTION 'Flight % cannot be deleted as it is not in planned status.', upper(p_lennu_kood); END IF;
  IF EXISTS (SELECT 1 FROM broneering WHERE lend_kood = upper(p_lennu_kood)) THEN RAISE EXCEPTION 'Flight % cannot be deleted as it has bookings.', upper(p_lennu_kood); END IF;
  IF EXISTS (SELECT 1 FROM tootaja_lennus WHERE lend_kood = upper(p_lennu_kood)) THEN RAISE EXCEPTION 'Flight % cannot be deleted as it has assigned employees.', upper(p_lennu_kood); END IF;
  DELETE FROM lend WHERE kood = upper(p_lennu_kood);
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count > 0;
END; $$;
COMMENT ON FUNCTION fn_op13_kustuta_lend IS 'OP13: Deletes a flight if it is in PLANNED status and has no dependencies.';

-- OP14: Update flight
CREATE OR REPLACE FUNCTION fn_op14_muuda_lendu(
  p_kood VARCHAR(10), p_uus_lahkumisaeg TIMESTAMPTZ DEFAULT NULL, p_uus_saabumisaeg TIMESTAMPTZ DEFAULT NULL,
  p_uus_lennukituup_kood VARCHAR(20) DEFAULT NULL, p_uus_lennuk_reg_nr VARCHAR(10) DEFAULT NULL,
  p_uus_sihtkoht_kood VARCHAR(3) DEFAULT NULL, p_uus_lahtekoht_kood VARCHAR(3) DEFAULT NULL
) RETURNS lend LANGUAGE plpgsql AS $$
DECLARE v_lend lend%ROWTYPE; v_lennuk lennuk%ROWTYPE; v_rec lend%ROWTYPE;
BEGIN
  SELECT * INTO v_lend FROM lend WHERE kood = upper(p_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'Flight with code % not found.', upper(p_kood); END IF;
  IF v_lend.seisund_kood NOT IN ('PLANNED', 'CONFIRMED', 'DELAYED') THEN RAISE EXCEPTION 'Flight % data cannot be modified in status %.', upper(p_kood), v_lend.seisund_kood; END IF;

  -- Validate new foreign keys if provided
  IF p_uus_lahtekoht_kood IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennujaam WHERE kood = p_uus_lahtekoht_kood) THEN RAISE EXCEPTION 'New departure airport % not found.', p_uus_lahtekoht_kood; END IF;
  IF p_uus_sihtkoht_kood IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennujaam WHERE kood = p_uus_sihtkoht_kood) THEN RAISE EXCEPTION 'New destination airport % not found.', p_uus_sihtkoht_kood; END IF;
  IF p_uus_lennukituup_kood IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennukituup WHERE kood = p_uus_lennukituup_kood) THEN RAISE EXCEPTION 'New aircraft type % not found.', p_uus_lennukituup_kood; END IF;
  IF p_uus_lennuk_reg_nr IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennuk WHERE registreerimisnumber = p_uus_lennuk_reg_nr) THEN RAISE EXCEPTION 'New aircraft % not found.', p_uus_lennuk_reg_nr; END IF;

  -- Validate time logic if times are changed
  IF p_uus_lahkumisaeg IS NOT NULL AND p_uus_saabumisaeg IS NOT NULL AND p_uus_saabumisaeg <= p_uus_lahkumisaeg THEN RAISE EXCEPTION 'New arrival time (%) must be later than new departure time (%).', p_uus_saabumisaeg, p_uus_lahkumisaeg; END IF;
  IF p_uus_lahkumisaeg IS NOT NULL AND p_uus_saabumisaeg IS NULL AND v_lend.eeldatav_saabumisaeg <= p_uus_lahkumisaeg THEN RAISE EXCEPTION 'Existing arrival time (%) must be later than new departure time (%).', v_lend.eeldatav_saabumisaeg, p_uus_lahkumisaeg; END IF;
  IF p_uus_lahkumisaeg IS NULL AND p_uus_saabumisaeg IS NOT NULL AND p_uus_saabumisaeg <= v_lend.eeldatav_lahkumisaeg THEN RAISE EXCEPTION 'New arrival time (%) must be later than existing departure time (%).', p_uus_saabumisaeg, v_lend.eeldatav_lahkumisaeg; END IF;

  -- Validate airport logic if changed
  IF p_uus_lahtekoht_kood IS NOT NULL AND p_uus_sihtkoht_kood IS NOT NULL AND p_uus_lahtekoht_kood = p_uus_sihtkoht_kood THEN RAISE EXCEPTION 'New departure and destination airport cannot be the same (%).', p_uus_lahtekoht_kood; END IF;
  IF p_uus_lahtekoht_kood IS NOT NULL AND p_uus_sihtkoht_kood IS NULL AND p_uus_lahtekoht_kood = v_lend.sihtlennujaam_kood THEN RAISE EXCEPTION 'New departure airport (%) cannot be the same as existing destination airport (%).', p_uus_lahtekoht_kood, v_lend.sihtlennujaam_kood; END IF;
  IF p_uus_lahtekoht_kood IS NULL AND p_uus_sihtkoht_kood IS NOT NULL AND v_lend.lahtelennujaam_kood = p_uus_sihtkoht_kood THEN RAISE EXCEPTION 'Existing departure airport (%) cannot be the same as new destination airport (%).', v_lend.lahtelennujaam_kood, p_uus_sihtkoht_kood; END IF;

  UPDATE lend SET
    lahtelennujaam_kood = COALESCE(p_uus_lahtekoht_kood, lahtelennujaam_kood),
    sihtlennujaam_kood = COALESCE(p_uus_sihtkoht_kood, sihtlennujaam_kood),
    eeldatav_lahkumisaeg = COALESCE(p_uus_lahkumisaeg, eeldatav_lahkumisaeg),
    eeldatav_saabumisaeg = COALESCE(p_uus_saabumisaeg, eeldatav_saabumisaeg),
    lennukituup_kood = COALESCE(p_uus_lennukituup_kood, lennukituup_kood),
    lennuk_reg_nr = COALESCE(p_uus_lennuk_reg_nr, lennuk_reg_nr)
  WHERE kood = upper(p_kood) RETURNING * INTO v_rec;

  -- After update, re-check constraints that might be affected by COALESCE
  IF v_rec.sihtlennujaam_kood = v_rec.lahtelennujaam_kood THEN RAISE EXCEPTION 'Update resulted in same departure and destination airport (%).', v_rec.lahtelennujaam_kood; END IF;
  IF v_rec.eeldatav_saabumisaeg <= v_rec.eeldatav_lahkumisaeg THEN RAISE EXCEPTION 'Update resulted in arrival time (%) earlier or equal to departure time (%).', v_rec.eeldatav_saabumisaeg, v_rec.eeldatav_lahkumisaeg; END IF;
  IF v_rec.lennukituup_kood IS NULL AND v_rec.lennuk_reg_nr IS NULL THEN RAISE EXCEPTION 'Update resulted in no aircraft type or specific aircraft assigned.'; END IF;

  RETURN v_rec;
END; $$;
COMMENT ON FUNCTION fn_op14_muuda_lendu IS 'OP14: Updates selected flight data with validations.';

-- OP18: Assign aircraft to flight
CREATE OR REPLACE FUNCTION fn_op18_maara_lennuk_lennule(p_lennu_kood VARCHAR(10), p_lennuk_reg_nr VARCHAR(10))
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE v_lend lend%ROWTYPE; v_lennuk lennuk%ROWTYPE;
BEGIN
  SELECT * INTO v_lend FROM lend WHERE kood = upper(p_lennu_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'Flight with code % not found.', upper(p_lennu_kood); END IF;
  SELECT * INTO v_lennuk FROM lennuk WHERE registreerimisnumber = upper(p_lennuk_reg_nr);
  IF NOT FOUND THEN RAISE EXCEPTION 'Aircraft with reg nr % not found.', upper(p_lennuk_reg_nr); END IF;

  -- Allow assigning plane if status is PLANNED or DELAYED, but not CONFIRMED or later.
  IF v_lend.seisund_kood NOT IN ('PLANNED', 'DELAYED') THEN RAISE EXCEPTION 'Aircraft cannot be assigned to flight % in status %.', upper(p_lennu_kood), v_lend.seisund_kood; END IF;
  IF v_lennuk.seisund_kood != 'ACTIVE' THEN RAISE EXCEPTION 'Aircraft % is not active (status: %).', upper(p_lennuk_reg_nr), v_lennuk.seisund_kood; END IF;
  IF v_lend.lennukituup_kood IS NOT NULL AND v_lennuk.lennukituup_kood != v_lend.lennukituup_kood THEN RAISE EXCEPTION 'Aircraft % type (%) does not match flight % required type (%).', upper(p_lennuk_reg_nr), v_lennuk.lennukituup_kood, upper(p_lennu_kood), v_lend.lennukituup_kood; END IF;

  -- Check for conflicting assignments (simplified check: plane not assigned to another overlapping flight)
  IF EXISTS (
      SELECT 1 FROM lend l
      WHERE l.lennuk_reg_nr = upper(p_lennuk_reg_nr)
      AND l.kood != upper(p_lennu_kood)
      AND l.seisund_kood NOT IN ('COMPLETED', 'CANCELED', 'LANDED', 'DEBOARDING')
      AND TSTZRANGE(l.eeldatav_lahkumisaeg - INTERVAL '2 hour', l.eeldatav_saabumisaeg + INTERVAL '2 hour', '[]')
      && TSTZRANGE(v_lend.eeldatav_lahkumisaeg, v_lend.eeldatav_saabumisaeg, '[]')
  ) THEN
      RAISE EXCEPTION 'Aircraft % is already assigned to another flight with overlapping times.', upper(p_lennuk_reg_nr);
  END IF;

  UPDATE lend SET lennuk_reg_nr = upper(p_lennuk_reg_nr), lennukituup_kood = v_lennuk.lennukituup_kood WHERE kood = upper(p_lennu_kood);
END; $$;
COMMENT ON FUNCTION fn_op18_maara_lennuk_lennule IS 'OP18: Assigns an active aircraft to a flight, checking type and time conflicts.';

-- === Tootaja_lennus Table Operations ===

-- OP16: Add employee to flight
CREATE OR REPLACE FUNCTION fn_op16_lisa_tootaja_lennule(p_lennu_kood VARCHAR(10), p_tootaja_isik_id INT, p_rolli_kood VARCHAR(20))
RETURNS INT LANGUAGE plpgsql AS $$
DECLARE v_lend lend%ROWTYPE; v_tootaja tootaja%ROWTYPE; v_tootaja_lennus_id INT; v_litsents_olemas BOOLEAN;
BEGIN
  SELECT * INTO v_lend FROM lend WHERE kood = upper(p_lennu_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'Flight with code % not found.', upper(p_lennu_kood); END IF;
  SELECT * INTO v_tootaja FROM tootaja WHERE isik_id = p_tootaja_isik_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Employee with ID % not found.', p_tootaja_isik_id; END IF;
  IF NOT EXISTS (SELECT 1 FROM tootaja_roll WHERE kood = p_rolli_kood) THEN RAISE EXCEPTION 'Employee role with code % not found.', p_rolli_kood; END IF;
  IF v_lend.seisund_kood NOT IN ('PLANNED', 'DELAYED') THEN RAISE EXCEPTION 'Employee cannot be added to flight % in status %.', upper(p_lennu_kood), v_lend.seisund_kood; END IF;
  IF v_tootaja.seisund_kood != 'WORKING' THEN RAISE EXCEPTION 'Employee % is not active (status: %).', p_tootaja_isik_id, v_tootaja.seisund_kood; END IF;

  IF p_rolli_kood IN ('CAPTAIN', 'PILOT') THEN
    IF v_lend.lennukituup_kood IS NULL THEN
        RAISE EXCEPTION 'Flight % has no assigned aircraft type, cannot add pilot/captain.', upper(p_lennu_kood);
    END IF;
    SELECT EXISTS (
        SELECT 1 FROM litsents
        WHERE tootaja_isik_id = p_tootaja_isik_id
        AND lennukituup_kood = v_lend.lennukituup_kood
        AND tootaja_roll_kood = p_rolli_kood
        AND seisund_kood = 'VALID'
        AND kehtivuse_lopp >= v_lend.eeldatav_lahkumisaeg
    ) INTO v_litsents_olemas;
    IF NOT v_litsents_olemas THEN
        RAISE EXCEPTION 'Employee % lacks a valid % license for aircraft type % for flight %.', p_tootaja_isik_id, p_rolli_kood, v_lend.lennukituup_kood, upper(p_lennu_kood);
    END IF;
  END IF;

  IF EXISTS (
      SELECT 1 FROM tootaja_lennus tl
      JOIN lend l ON tl.lend_kood = l.kood
      WHERE tl.tootaja_isik_id = p_tootaja_isik_id
      AND l.kood != upper(p_lennu_kood)
      AND l.seisund_kood NOT IN ('COMPLETED', 'CANCELED', 'LANDED', 'DEBOARDING')
      AND TSTZRANGE(l.eeldatav_lahkumisaeg - INTERVAL '3 hour', l.eeldatav_saabumisaeg + INTERVAL '3 hour', '[]')
      && TSTZRANGE(v_lend.eeldatav_lahkumisaeg, v_lend.eeldatav_saabumisaeg, '[]')
  ) THEN
      RAISE EXCEPTION 'Employee % is already assigned to another flight with overlapping times.', p_tootaja_isik_id;
  END IF;

  INSERT INTO tootaja_lennus (lend_kood, tootaja_isik_id, tootaja_roll_kood) VALUES (upper(p_lennu_kood), p_tootaja_isik_id, p_rolli_kood) RETURNING tootaja_lennus_id INTO v_tootaja_lennus_id;
  RETURN v_tootaja_lennus_id;
END; $$;
COMMENT ON FUNCTION fn_op16_lisa_tootaja_lennule IS 'OP16: Adds an active employee to a flight, checking role, license (if needed), and time conflicts.';

-- OP17: Remove employee from flight
CREATE OR REPLACE FUNCTION fn_op17_eemalda_tootaja_lennult(p_lennu_kood VARCHAR(10), p_tootaja_isik_id INT)
RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE v_lend_seisund VARCHAR(20); v_deleted_count INT;
BEGIN
  SELECT seisund_kood INTO v_lend_seisund FROM lend WHERE kood = upper(p_lennu_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'Flight with code % not found.', upper(p_lennu_kood); END IF;
  IF v_lend_seisund NOT IN ('PLANNED', 'DELAYED') THEN RAISE EXCEPTION 'Employee cannot be removed from flight % in status %.', upper(p_lennu_kood), v_lend_seisund; END IF;
  DELETE FROM tootaja_lennus WHERE lend_kood = upper(p_lennu_kood) AND tootaja_isik_id = p_tootaja_isik_id;
  GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
  IF v_deleted_count = 0 THEN
      RAISE WARNING 'Employee % not found on flight % or could not be removed.', p_tootaja_isik_id, upper(p_lennu_kood);
      RETURN FALSE;
  END IF;
  RETURN TRUE;
END; $$;
COMMENT ON FUNCTION fn_op17_eemalda_tootaja_lennult IS 'OP17: Removes an employee from a flight if the flight is not yet confirmed.';

-- === Read Functions for Supporting Data ===
CREATE OR REPLACE FUNCTION fn_lend_read_by_kood(p_kood VARCHAR(10)) RETURNS SETOF lend LANGUAGE sql STABLE AS $$ SELECT * FROM lend WHERE kood = upper(p_kood); $$;
CREATE OR REPLACE FUNCTION fn_lend_read_all(p_limit INT DEFAULT NULL, p_offset INT DEFAULT 0) RETURNS SETOF lend LANGUAGE sql STABLE AS $$ SELECT * FROM lend ORDER BY eeldatav_lahkumisaeg DESC LIMIT p_limit OFFSET p_offset; $$;
CREATE OR REPLACE FUNCTION fn_lennujaam_read_all() RETURNS SETOF lennujaam LANGUAGE sql STABLE AS $$ SELECT * FROM lennujaam WHERE seisund_kood = 'OPEN' ORDER BY nimi; $$;
CREATE OR REPLACE FUNCTION fn_lennukituup_read_all() RETURNS SETOF lennukituup LANGUAGE sql STABLE AS $$ SELECT * FROM lennukituup ORDER BY kood; $$;
CREATE OR REPLACE FUNCTION fn_lennuk_read_all(p_aktiivsed_ainult BOOLEAN DEFAULT FALSE) RETURNS SETOF lennuk LANGUAGE sql STABLE AS $$ SELECT * FROM lennuk WHERE (NOT p_aktiivsed_ainult OR seisund_kood = 'ACTIVE') ORDER BY registreerimisnumber; $$;
CREATE OR REPLACE FUNCTION fn_tootaja_read_active() RETURNS TABLE(isik_id INT, eesnimi VARCHAR, perenimi VARCHAR, tootaja_kood VARCHAR) LANGUAGE sql STABLE AS $$ SELECT t.isik_id, i.eesnimi, i.perenimi, t.tootaja_kood FROM tootaja t JOIN isik i ON t.isik_id = i.isik_id WHERE t.seisund_kood = 'WORKING' AND i.on_aktiivne = TRUE ORDER BY i.perenimi, i.eesnimi; $$;
CREATE OR REPLACE FUNCTION fn_tootaja_roll_read_all() RETURNS SETOF tootaja_roll LANGUAGE sql STABLE AS $$ SELECT * FROM tootaja_roll ORDER BY nimetus; $$;
CREATE OR REPLACE FUNCTION fn_litsents_read_by_tootaja(p_tootaja_id INT) RETURNS SETOF litsents LANGUAGE sql STABLE AS $$ SELECT * FROM litsents WHERE tootaja_isik_id = p_tootaja_id AND seisund_kood = 'VALID' AND kehtivuse_lopp >= CURRENT_TIMESTAMP ORDER BY lennukituup_kood, tootaja_roll_kood; $$;
CREATE OR REPLACE FUNCTION fn_lend_read_tootajad(p_lennu_kood VARCHAR(10)) RETURNS TABLE(isik_id INT, eesnimi VARCHAR, perenimi VARCHAR, roll_kood VARCHAR, roll_nimetus VARCHAR) LANGUAGE sql STABLE AS $$ SELECT tl.tootaja_isik_id, i.eesnimi, i.perenimi, tl.tootaja_roll_kood, tr.nimetus FROM tootaja_lennus tl JOIN isik i ON tl.tootaja_isik_id = i.isik_id JOIN tootaja_roll tr ON tl.tootaja_roll_kood = tr.kood WHERE tl.lend_kood = upper(p_lennu_kood) ORDER BY tr.nimetus, i.perenimi, i.eesnimi; $$;

-- === Read Functions for Classifiers ===
CREATE OR REPLACE FUNCTION fn_lennujaama_seisund_liik_read_all() RETURNS SETOF lennujaama_seisund_liik LANGUAGE sql STABLE AS $$ SELECT * FROM lennujaama_seisund_liik ORDER BY kood; $$;
CREATE OR REPLACE FUNCTION fn_lennuki_seisund_liik_read_all() RETURNS SETOF lennuki_seisund_liik LANGUAGE sql STABLE AS $$ SELECT * FROM lennuki_seisund_liik ORDER BY kood; $$;
CREATE OR REPLACE FUNCTION fn_lennuki_tootja_read_all() RETURNS SETOF lennuki_tootja LANGUAGE sql STABLE AS $$ SELECT * FROM lennuki_tootja ORDER BY kood; $$;
CREATE OR REPLACE FUNCTION fn_tootaja_seisund_liik_read_all() RETURNS SETOF tootaja_seisund_liik LANGUAGE sql STABLE AS $$ SELECT * FROM tootaja_seisund_liik ORDER BY kood; $$;
CREATE OR REPLACE FUNCTION fn_ajavoond_read_all() RETURNS SETOF ajavoond LANGUAGE sql STABLE AS $$ SELECT * FROM ajavoond ORDER BY kood; $$;
CREATE OR REPLACE FUNCTION fn_lennu_seisund_liik_read_all() RETURNS SETOF lennu_seisund_liik LANGUAGE sql STABLE AS $$ SELECT * FROM lennu_seisund_liik ORDER BY kood; $$;
CREATE OR REPLACE FUNCTION fn_hoolduse_seisund_liik_read_all() RETURNS SETOF hoolduse_seisund_liik LANGUAGE sql STABLE AS $$ SELECT * FROM hoolduse_seisund_liik ORDER BY kood; $$;
CREATE OR REPLACE FUNCTION fn_kliendi_seisund_liik_read_all() RETURNS SETOF kliendi_seisund_liik LANGUAGE sql STABLE AS $$ SELECT * FROM kliendi_seisund_liik ORDER BY kood; $$;
CREATE OR REPLACE FUNCTION fn_litsentsi_seisund_liik_read_all() RETURNS SETOF litsentsi_seisund_liik LANGUAGE sql STABLE AS $$ SELECT * FROM litsentsi_seisund_liik ORDER BY kood; $$;
CREATE OR REPLACE FUNCTION fn_broneeringu_seisund_liik_read_all() RETURNS SETOF broneeringu_seisund_liik LANGUAGE sql STABLE AS $$ SELECT * FROM broneeringu_seisund_liik ORDER BY kood; $$;

-- === CRUD for Foundational Entities ===
-- Lennujaam CRUD
CREATE OR REPLACE FUNCTION fn_lennujaam_create(p_kood VARCHAR(3), p_nimi VARCHAR(100), p_laius DECIMAL(9,6), p_pikkus DECIMAL(9,6), p_ajavoond VARCHAR(50), p_seisund VARCHAR(20)) RETURNS VARCHAR(3) LANGUAGE plpgsql AS $$
DECLARE v_kood VARCHAR(3);
BEGIN
  IF NOT EXISTS (SELECT 1 FROM ajavoond WHERE kood = p_ajavoond) THEN RAISE EXCEPTION 'Timezone % not found.', p_ajavoond; END IF;
  IF NOT EXISTS (SELECT 1 FROM lennujaama_seisund_liik WHERE kood = p_seisund) THEN RAISE EXCEPTION 'Airport status % not found.', p_seisund; END IF;
  INSERT INTO lennujaam (kood, nimi, koordinaadid_laius, koordinaadid_pikkus, ajavoond_kood, seisund_kood)
  VALUES (upper(p_kood), p_nimi, p_laius, p_pikkus, p_ajavoond, p_seisund) RETURNING kood INTO v_kood;
  RETURN v_kood;
END; $$;

CREATE OR REPLACE FUNCTION fn_lennujaam_read_by_kood(p_kood VARCHAR(3)) RETURNS SETOF lennujaam LANGUAGE sql STABLE AS $$ SELECT * FROM lennujaam WHERE kood = upper(p_kood); $$;

CREATE OR REPLACE FUNCTION fn_lennujaam_update(p_kood VARCHAR(3), p_nimi VARCHAR(100) DEFAULT NULL, p_laius DECIMAL(9,6) DEFAULT NULL, p_pikkus DECIMAL(9,6) DEFAULT NULL, p_ajavoond VARCHAR(50) DEFAULT NULL, p_seisund VARCHAR(20) DEFAULT NULL) RETURNS lennujaam LANGUAGE plpgsql AS $$
DECLARE v_rec lennujaam%ROWTYPE;
BEGIN
  IF p_ajavoond IS NOT NULL AND NOT EXISTS (SELECT 1 FROM ajavoond WHERE kood = p_ajavoond) THEN RAISE EXCEPTION 'Timezone % not found.', p_ajavoond; END IF;
  IF p_seisund IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennujaama_seisund_liik WHERE kood = p_seisund) THEN RAISE EXCEPTION 'Airport status % not found.', p_seisund; END IF;
  UPDATE lennujaam SET
    nimi = COALESCE(p_nimi, nimi),
    koordinaadid_laius = COALESCE(p_laius, koordinaadid_laius),
    koordinaadid_pikkus = COALESCE(p_pikkus, koordinaadid_pikkus),
    ajavoond_kood = COALESCE(p_ajavoond, ajavoond_kood),
    seisund_kood = COALESCE(p_seisund, seisund_kood)
  WHERE kood = upper(p_kood) RETURNING * INTO v_rec;
  IF NOT FOUND THEN RAISE EXCEPTION 'Airport % not found.', upper(p_kood); END IF;
  RETURN v_rec;
END; $$;

CREATE OR REPLACE FUNCTION fn_lennujaam_delete(p_kood VARCHAR(3)) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE v_count INT;
BEGIN
  IF EXISTS (SELECT 1 FROM lend WHERE lahtelennujaam_kood = upper(p_kood) OR sihtlennujaam_kood = upper(p_kood)) THEN RAISE EXCEPTION 'Airport % cannot be deleted as it is associated with flights.', upper(p_kood); END IF;
  DELETE FROM lennujaam WHERE kood = upper(p_kood);
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count > 0;
END; $$;

-- Lennukituup CRUD
CREATE OR REPLACE FUNCTION fn_lennukituup_create(p_kood VARCHAR(20), p_nimetus VARCHAR(100), p_tootja_kood VARCHAR(20), p_kaugus INT, p_reisijad INT, p_pardapersonal INT, p_piloodid INT) RETURNS VARCHAR(20) LANGUAGE plpgsql AS $$
DECLARE v_kood VARCHAR(20);
BEGIN
  IF NOT EXISTS (SELECT 1 FROM lennuki_tootja WHERE kood = upper(p_tootja_kood)) THEN RAISE EXCEPTION 'Aircraft manufacturer % not found.', upper(p_tootja_kood); END IF;
  INSERT INTO lennukituup (kood, nimetus, lennuki_tootja_kood, maksimaalne_lennukaugus, maksimaalne_reisijate_arv, pardapersonali_arv, pilootide_arv)
  VALUES (upper(p_kood), p_nimetus, upper(p_tootja_kood), p_kaugus, p_reisijad, p_pardapersonal, p_piloodid) RETURNING kood INTO v_kood;
  RETURN v_kood;
END; $$;

CREATE OR REPLACE FUNCTION fn_lennukituup_read_by_kood(p_kood VARCHAR(20)) RETURNS SETOF lennukituup LANGUAGE sql STABLE AS $$ SELECT * FROM lennukituup WHERE kood = upper(p_kood); $$;

CREATE OR REPLACE FUNCTION fn_lennukituup_update(p_kood VARCHAR(20), p_nimetus VARCHAR(100) DEFAULT NULL, p_tootja_kood VARCHAR(20) DEFAULT NULL, p_kaugus INT DEFAULT NULL, p_reisijad INT DEFAULT NULL, p_pardapersonal INT DEFAULT NULL, p_piloodid INT DEFAULT NULL) RETURNS lennukituup LANGUAGE plpgsql AS $$
DECLARE v_rec lennukituup%ROWTYPE;
BEGIN
  IF p_tootja_kood IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennuki_tootja WHERE kood = upper(p_tootja_kood)) THEN RAISE EXCEPTION 'Aircraft manufacturer % not found.', upper(p_tootja_kood); END IF;
  UPDATE lennukituup SET
    nimetus = COALESCE(p_nimetus, nimetus),
    lennuki_tootja_kood = COALESCE(upper(p_tootja_kood), lennuki_tootja_kood),
    maksimaalne_lennukaugus = COALESCE(p_kaugus, maksimaalne_lennukaugus),
    maksimaalne_reisijate_arv = COALESCE(p_reisijad, maksimaalne_reisijate_arv),
    pardapersonali_arv = COALESCE(p_pardapersonal, pardapersonali_arv),
    pilootide_arv = COALESCE(p_piloodid, pilootide_arv)
  WHERE kood = upper(p_kood) RETURNING * INTO v_rec;
  IF NOT FOUND THEN RAISE EXCEPTION 'Aircraft type % not found.', upper(p_kood); END IF;
  RETURN v_rec;
END; $$;

CREATE OR REPLACE FUNCTION fn_lennukituup_delete(p_kood VARCHAR(20)) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE v_count INT;
BEGIN
  IF EXISTS (SELECT 1 FROM lennuk WHERE lennukituup_kood = upper(p_kood)) THEN RAISE EXCEPTION 'Aircraft type % cannot be deleted as it is associated with aircraft.', upper(p_kood); END IF;
  IF EXISTS (SELECT 1 FROM lend WHERE lennukituup_kood = upper(p_kood)) THEN RAISE EXCEPTION 'Aircraft type % cannot be deleted as it is associated with flights.', upper(p_kood); END IF;
  IF EXISTS (SELECT 1 FROM litsents WHERE lennukituup_kood = upper(p_kood)) THEN RAISE EXCEPTION 'Aircraft type % cannot be deleted as it is associated with licenses.', upper(p_kood); END IF;
  DELETE FROM lennukituup WHERE kood = upper(p_kood);
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count > 0;
END; $$;

-- Lennuk CRUD
CREATE OR REPLACE FUNCTION fn_lennuk_create(p_reg_nr VARCHAR(10), p_tuup_kood VARCHAR(20), p_seisund VARCHAR(20)) RETURNS VARCHAR(10) LANGUAGE plpgsql AS $$
DECLARE v_reg_nr VARCHAR(10);
BEGIN
  IF NOT EXISTS (SELECT 1 FROM lennukituup WHERE kood = upper(p_tuup_kood)) THEN RAISE EXCEPTION 'Aircraft type % not found.', upper(p_tuup_kood); END IF;
  IF NOT EXISTS (SELECT 1 FROM lennuki_seisund_liik WHERE kood = p_seisund) THEN RAISE EXCEPTION 'Aircraft status % not found.', p_seisund; END IF;
  INSERT INTO lennuk (registreerimisnumber, lennukituup_kood, seisund_kood)
  VALUES (upper(p_reg_nr), upper(p_tuup_kood), p_seisund) RETURNING registreerimisnumber INTO v_reg_nr;
  RETURN v_reg_nr;
END; $$;

CREATE OR REPLACE FUNCTION fn_lennuk_read_by_reg_nr(p_reg_nr VARCHAR(10)) RETURNS SETOF lennuk LANGUAGE sql STABLE AS $$ SELECT * FROM lennuk WHERE registreerimisnumber = upper(p_reg_nr); $$;

CREATE OR REPLACE FUNCTION fn_lennuk_update(p_reg_nr VARCHAR(10), p_tuup_kood VARCHAR(20) DEFAULT NULL, p_seisund VARCHAR(20) DEFAULT NULL) RETURNS lennuk LANGUAGE plpgsql AS $$
DECLARE v_rec lennuk%ROWTYPE;
BEGIN
  IF p_tuup_kood IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennukituup WHERE kood = upper(p_tuup_kood)) THEN RAISE EXCEPTION 'Aircraft type % not found.', upper(p_tuup_kood); END IF;
  IF p_seisund IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennuki_seisund_liik WHERE kood = p_seisund) THEN RAISE EXCEPTION 'Aircraft status % not found.', p_seisund; END IF;
  UPDATE lennuk SET
    lennukituup_kood = COALESCE(upper(p_tuup_kood), lennukituup_kood),
    seisund_kood = COALESCE(p_seisund, seisund_kood)
  WHERE registreerimisnumber = upper(p_reg_nr) RETURNING * INTO v_rec;
  IF NOT FOUND THEN RAISE EXCEPTION 'Aircraft % not found.', upper(p_reg_nr); END IF;
  RETURN v_rec;
END; $$;

CREATE OR REPLACE FUNCTION fn_lennuk_delete(p_reg_nr VARCHAR(10)) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE v_count INT;
BEGIN
  IF EXISTS (SELECT 1 FROM lend WHERE lennuk_reg_nr = upper(p_reg_nr)) THEN RAISE EXCEPTION 'Aircraft % cannot be deleted as it is associated with flights.', upper(p_reg_nr); END IF;
  IF EXISTS (SELECT 1 FROM hooldus WHERE lennuk_reg_nr = upper(p_reg_nr)) THEN RAISE EXCEPTION 'Aircraft % cannot be deleted as it is associated with maintenance.', upper(p_reg_nr); END IF;
  DELETE FROM lennuk WHERE registreerimisnumber = upper(p_reg_nr);
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count > 0;
END; $$;

-- Tootaja CRUD
CREATE OR REPLACE FUNCTION fn_tootaja_create(p_isik_id INT, p_seisund VARCHAR(20), p_tootaja_kood VARCHAR(20) DEFAULT NULL) RETURNS INT LANGUAGE plpgsql AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM isik WHERE isik_id = p_isik_id) THEN RAISE EXCEPTION 'Person with ID % not found.', p_isik_id; END IF;
  IF NOT EXISTS (SELECT 1 FROM tootaja_seisund_liik WHERE kood = p_seisund) THEN RAISE EXCEPTION 'Employee status % not found.', p_seisund; END IF;
  INSERT INTO tootaja (isik_id, seisund_kood, tootaja_kood) VALUES (p_isik_id, p_seisund, p_tootaja_kood);
  RETURN p_isik_id;
END; $$;

CREATE OR REPLACE FUNCTION fn_tootaja_read_by_id(p_isik_id INT) RETURNS SETOF tootaja LANGUAGE sql STABLE AS $$ SELECT * FROM tootaja WHERE isik_id = p_isik_id; $$;

CREATE OR REPLACE FUNCTION fn_tootaja_update(p_isik_id INT, p_seisund VARCHAR(20) DEFAULT NULL, p_tootaja_kood VARCHAR(20) DEFAULT NULL) RETURNS tootaja LANGUAGE plpgsql AS $$
DECLARE v_rec tootaja%ROWTYPE;
BEGIN
  IF p_seisund IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tootaja_seisund_liik WHERE kood = p_seisund) THEN RAISE EXCEPTION 'Employee status % not found.', p_seisund; END IF;
  UPDATE tootaja SET
    seisund_kood = COALESCE(p_seisund, seisund_kood),
    tootaja_kood = COALESCE(p_tootaja_kood, tootaja_kood)
  WHERE isik_id = p_isik_id RETURNING * INTO v_rec;
  IF NOT FOUND THEN RAISE EXCEPTION 'Employee with ID % not found.', p_isik_id; END IF;
  RETURN v_rec;
END; $$;

CREATE OR REPLACE FUNCTION fn_tootaja_delete(p_isik_id INT) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE v_count INT;
BEGIN
  IF EXISTS (SELECT 1 FROM litsents WHERE tootaja_isik_id = p_isik_id) THEN RAISE EXCEPTION 'Employee % cannot be deleted as they have licenses.', p_isik_id; END IF;
  IF EXISTS (SELECT 1 FROM tootaja_lennus WHERE tootaja_isik_id = p_isik_id) THEN RAISE EXCEPTION 'Employee % cannot be deleted as they are assigned to flights.', p_isik_id; END IF;
  DELETE FROM tootaja WHERE isik_id = p_isik_id;
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count > 0;
END; $$;

-- Isik CRUD
CREATE OR REPLACE FUNCTION fn_isik_create(p_eesnimi VARCHAR, p_perenimi VARCHAR, p_email VARCHAR, p_isikukood VARCHAR DEFAULT NULL, p_synni_kp DATE DEFAULT NULL, p_elukoht TEXT DEFAULT NULL, p_parool VARCHAR DEFAULT NULL, p_on_aktiivne BOOLEAN DEFAULT TRUE) RETURNS INT LANGUAGE plpgsql AS $$
DECLARE v_isik_id INT;
BEGIN
  INSERT INTO isik (eesnimi, perenimi, e_meil, isikukood, synni_kp, elukoht, parool, on_aktiivne)
  VALUES (p_eesnimi, p_perenimi, p_email, p_isikukood, p_synni_kp, p_elukoht, p_parool, p_on_aktiivne) RETURNING isik_id INTO v_isik_id;
  RETURN v_isik_id;
END; $$;

CREATE OR REPLACE FUNCTION fn_isik_read_by_id(p_isik_id INT) RETURNS SETOF isik LANGUAGE sql STABLE AS $$ SELECT * FROM isik WHERE isik_id = p_isik_id; $$;
CREATE OR REPLACE FUNCTION fn_isik_read_by_email(p_email VARCHAR) RETURNS SETOF isik LANGUAGE sql STABLE AS $$ SELECT * FROM isik WHERE e_meil = p_email; $$;

CREATE OR REPLACE FUNCTION fn_isik_update(p_isik_id INT, p_eesnimi VARCHAR DEFAULT NULL, p_perenimi VARCHAR DEFAULT NULL, p_email VARCHAR DEFAULT NULL, p_isikukood VARCHAR DEFAULT NULL, p_synni_kp DATE DEFAULT NULL, p_elukoht TEXT DEFAULT NULL, p_parool VARCHAR DEFAULT NULL, p_on_aktiivne BOOLEAN DEFAULT NULL) RETURNS isik LANGUAGE plpgsql AS $$
DECLARE v_rec isik%ROWTYPE;
BEGIN
  UPDATE isik SET
    eesnimi = COALESCE(p_eesnimi, eesnimi),
    perenimi = COALESCE(p_perenimi, perenimi),
    e_meil = COALESCE(p_email, e_meil),
    isikukood = COALESCE(p_isikukood, isikukood),
    synni_kp = COALESCE(p_synni_kp, synni_kp),
    elukoht = COALESCE(p_elukoht, elukoht),
    parool = COALESCE(p_parool, parool),
    on_aktiivne = COALESCE(p_on_aktiivne, on_aktiivne)
  WHERE isik_id = p_isik_id RETURNING * INTO v_rec;
  IF NOT FOUND THEN RAISE EXCEPTION 'Person with ID % not found.', p_isik_id; END IF;
  RETURN v_rec;
END; $$;

-- ========================================================================== --
--                                SAMPLE DATA                                 --
-- ========================================================================== --

-- Classifiers
INSERT INTO lennu_seisund_liik (kood, nimetus) VALUES
('PLANNED', 'Planned'),
('CONFIRMED', 'Confirmed'),
('DELAYED', 'Delayed'),
('BOARDING', 'Boarding'),
('GATE DEPARTED', 'Gate Departed'),
('IN FLIGHT', 'In Flight'),
('LANDED', 'Landed'),
('DEBOARDING', 'Deboarding'),
('COMPLETED', 'Completed'),
('CANCELED', 'Canceled'),
('REDIRECTED', 'Redirected'),
('CRASHED', 'Crashed');

INSERT INTO lennujaama_seisund_liik (kood, nimetus) VALUES
('OPEN', 'Open'),
('CLOSED', 'Closed');

INSERT INTO lennuki_seisund_liik (kood, nimetus) VALUES
('ACTIVE', 'Active'),
('MAINTENANCE', 'Maintenance'),
('DECOMMISSIONED', 'Decommissioned');

INSERT INTO hoolduse_seisund_liik (kood, nimetus) VALUES
('PLANNED', 'Planned'),
('COMPLETED', 'Completed'),
('CANCELED', 'Canceled');

INSERT INTO tootaja_seisund_liik (kood, nimetus) VALUES
('WORKING', 'Working'),
('SUSPENDED', 'Suspended'),
('TERMINATED', 'Terminated');

INSERT INTO kliendi_seisund_liik (kood, nimetus) VALUES
('ACTIVE', 'Active'),
('BLACKLISTED', 'Blacklisted');

INSERT INTO litsentsi_seisund_liik (kood, nimetus) VALUES
('VALID', 'Valid'),
('EXPIRED', 'Expired'),
('SUSPENDED', 'Suspended');

INSERT INTO broneeringu_seisund_liik (kood, nimetus) VALUES
('ACTIVE', 'Active'),
('CANCELED', 'Canceled');

INSERT INTO tootaja_roll (kood, nimetus, kirjeldus) VALUES
('MANAGER', 'Flight Manager', 'Responsible for flight planning and management'),
('CAPTAIN', 'Captain', 'Responsible pilot of the aircraft'),
('PILOT', 'Pilot', 'Second pilot / first officer'),
('CABIN_CREW', 'Cabin Crew', 'Cabin personnel');

INSERT INTO lennuki_tootja (kood, nimetus) VALUES
('AIRBUS', 'Airbus'),
('BOEING', 'Boeing');

INSERT INTO ajavoond (kood, nimetus, utc_nihe) VALUES
('Europe/Tallinn', 'Eastern European Time', '02:00:00'),
('Europe/Helsinki', 'Eastern European Time', '02:00:00'),
('Europe/Stockholm', 'Central European Time', '01:00:00');

-- Core Entities
INSERT INTO lennujaam (kood, nimi, koordinaadid_laius, koordinaadid_pikkus, ajavoond_kood, seisund_kood) VALUES
('TLL', 'Tallinn Airport', 59.413333, 24.8325, 'Europe/Tallinn', 'OPEN'),
('HEL', 'Helsinki Vantaa Airport', 60.317222, 24.963333, 'Europe/Helsinki', 'OPEN'),
('ARN', 'Stockholm Arlanda Airport', 59.651944, 17.918611, 'Europe/Stockholm', 'OPEN');

INSERT INTO lennukituup (kood, nimetus, lennuki_tootja_kood, maksimaalne_lennukaugus, maksimaalne_reisijate_arv, pardapersonali_arv, pilootide_arv) VALUES
('A320', 'Airbus A320', 'AIRBUS', 6000, 180, 4, 2),
('B737', 'Boeing 737-800', 'BOEING', 5500, 189, 4, 2);

INSERT INTO lennuk (registreerimisnumber, lennukituup_kood, seisund_kood) VALUES
('ES-ABC', 'A320', 'ACTIVE'),
('ES-DEF', 'B737', 'ACTIVE'),
('ES-GHI', 'A320', 'MAINTENANCE');

-- Sample Employees
DO $$
DECLARE
  v_haldur_id INT;
  v_kapten_id INT;
  v_parda_id INT;
BEGIN
  v_haldur_id := fn_isik_create('Mart', 'Manager', 'manager@lennufirma.ee');
  PERFORM fn_tootaja_create(v_haldur_id, 'WORKING');

  v_kapten_id := fn_isik_create('Kalle', 'Captain', 'captain@lennufirma.ee');
  PERFORM fn_tootaja_create(v_kapten_id, 'WORKING');

  v_parda_id := fn_isik_create('Pille', 'CabinCrew', 'pille@lennufirma.ee');
  PERFORM fn_tootaja_create(v_parda_id, 'WORKING');

  INSERT INTO litsents (tootaja_isik_id, lennukituup_kood, tootaja_roll_kood, kehtivuse_algus, kehtivuse_lopp, seisund_kood)
  VALUES (v_kapten_id, 'A320', 'CAPTAIN', '2023-01-01', '2025-12-31', 'VALID');
END $$;

-- Sample Flights
SELECT * FROM fn_op1_registreeri_lend('LF101', 'TLL', 'HEL', '2025-04-29 18:02:00', '2025-04-29 19:02:00', p_lennukituup_kood => 'A320', p_lennuk_reg_nr => 'ES-ABC');
SELECT * FROM fn_op1_registreeri_lend('LF202', 'TLL', 'ARN', '2025-04-30 18:02:00', '2025-04-30 19:32:00', p_lennukituup_kood => 'B737', p_lennuk_reg_nr => 'ES-DEF');