-- ========================================================================== --
--      SIMPLIFIED SCHEMA SETUP (Lennufirma Database) v2.6 - CLARIFIED CHECKS --
-- ========================================================================== --
-- This script creates the schema, initializes sample data, and includes
-- essential flight operation functions and triggers.
-- Incorporates fixes based on the analysis report, adds operational checks,
-- and clarifies existing status checks in OP16.
-- ========================================================================== --

-- Drop the schema if it exists to ensure a clean setup
DROP SCHEMA IF EXISTS lennufirma CASCADE;

-- Create the schema
CREATE SCHEMA lennufirma;

-- Set the search path to the new schema
SET search_path TO lennufirma;

-- =========================================
-- Classifier Tables
-- =========================================
CREATE TABLE lennu_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus VARCHAR(1000),
    CONSTRAINT pk_lennu_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_lennu_seisund_liik_nimetus UNIQUE (nimetus),
    -- Added Format Check (Example: Uppercase letters, underscore, space allowed)
    CONSTRAINT chk_lennu_seisund_liik_kood_format CHECK (seisund_kood ~ '^[A-Z_ ]+$'),
    CONSTRAINT chk_lennu_seisund_liik_seisund_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennu_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennu_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$')
);
COMMENT ON TABLE lennu_seisund_liik IS 'Classifier for flight statuses (Planned, In Flight, Canceled, etc.).';

CREATE TABLE lennujaama_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus VARCHAR(1000),
    CONSTRAINT pk_lennujaama_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_lennujaama_seisund_liik_nimetus UNIQUE (nimetus),
    -- Added Format Check (Example: Uppercase letters, underscore, space allowed)
    CONSTRAINT chk_lennujaama_seisund_liik_kood_format CHECK (seisund_kood ~ '^[A-Z_ ]+$'),
    CONSTRAINT chk_lennujaama_seisund_liik_seisund_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennujaama_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennujaama_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$')
);
COMMENT ON TABLE lennujaama_seisund_liik IS 'Classifier for airport statuses (Open, Closed).';

CREATE TABLE lennuki_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus VARCHAR(1000),
    CONSTRAINT pk_lennuki_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_lennuki_seisund_liik_nimetus UNIQUE (nimetus),
    -- Added Format Check (Example: Uppercase letters, underscore, space allowed)
    CONSTRAINT chk_lennuki_seisund_liik_kood_format CHECK (seisund_kood ~ '^[A-Z_ ]+$'),
    CONSTRAINT chk_lennuki_seisund_liik_seisund_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennuki_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennuki_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$')
);
COMMENT ON TABLE lennuki_seisund_liik IS 'Classifier for aircraft statuses (Active, Maintenance, etc.).';

CREATE TABLE hoolduse_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus VARCHAR(1000),
    CONSTRAINT pk_hoolduse_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_hoolduse_seisund_liik_nimetus UNIQUE (nimetus),
    -- Added Format Check (Example: Uppercase letters, underscore, space allowed)
    CONSTRAINT chk_hoolduse_seisund_liik_kood_format CHECK (seisund_kood ~ '^[A-Z_ ]+$'),
    CONSTRAINT chk_hoolduse_seisund_liik_seisund_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_hoolduse_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_hoolduse_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$')
);
COMMENT ON TABLE hoolduse_seisund_liik IS 'Classifier for maintenance statuses (Planned, Completed, etc.).';

CREATE TABLE tootaja_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus VARCHAR(1000),
    CONSTRAINT pk_tootaja_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_tootaja_seisund_liik_nimetus UNIQUE (nimetus),
    -- Added Format Check (Example: Uppercase letters, underscore, space allowed)
    CONSTRAINT chk_tootaja_seisund_liik_kood_format CHECK (seisund_kood ~ '^[A-Z_ ]+$'),
    CONSTRAINT chk_tootaja_seisund_liik_seisund_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_tootaja_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_tootaja_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$')
);
COMMENT ON TABLE tootaja_seisund_liik IS 'Classifier for employee statuses (Working, Terminated, etc.).';

CREATE TABLE kliendi_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus VARCHAR(1000),
    CONSTRAINT pk_kliendi_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_kliendi_seisund_liik_nimetus UNIQUE (nimetus),
    -- Added Format Check (Example: Uppercase letters, underscore, space allowed)
    CONSTRAINT chk_kliendi_seisund_liik_kood_format CHECK (seisund_kood ~ '^[A-Z_ ]+$'),
    CONSTRAINT chk_kliendi_seisund_liik_seisund_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'), -- Renamed in previous step
    CONSTRAINT chk_kliendi_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_kliendi_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$')
);
COMMENT ON TABLE kliendi_seisund_liik IS 'Classifier for client statuses (Active, Blacklisted).';

CREATE TABLE litsentsi_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus VARCHAR(1000),
    CONSTRAINT pk_litsentsi_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_litsentsi_seisund_liik_nimetus UNIQUE (nimetus),
    -- Added Format Check (Example: Uppercase letters, underscore, space allowed)
    CONSTRAINT chk_litsentsi_seisund_liik_kood_format CHECK (seisund_kood ~ '^[A-Z_ ]+$'),
    CONSTRAINT chk_litsentsi_seisund_liik_seisund_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_litsentsi_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_litsentsi_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$')
);
COMMENT ON TABLE litsentsi_seisund_liik IS 'Classifier for license statuses (Valid, Expired, etc.).';

CREATE TABLE broneeringu_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus VARCHAR(1000),
    CONSTRAINT pk_broneeringu_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_broneeringu_seisund_liik_nimetus UNIQUE (nimetus),
    -- Added Format Check (Example: Uppercase letters, underscore, space allowed)
    CONSTRAINT chk_broneeringu_seisund_liik_kood_format CHECK (seisund_kood ~ '^[A-Z_ ]+$'),
    CONSTRAINT chk_broneeringu_seisund_liik_seisund_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_broneeringu_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_broneeringu_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$')
);
COMMENT ON TABLE broneeringu_seisund_liik IS 'Classifier for booking statuses (Active, Canceled).';

CREATE TABLE tootaja_roll (
    r_kood VARCHAR(20) NOT NULL,
    tr_nimetus VARCHAR(100) NOT NULL, -- Renamed in previous step
    kirjeldus VARCHAR(1000),
    CONSTRAINT pk_tootaja_roll PRIMARY KEY (r_kood),
    CONSTRAINT uq_tootaja_roll_nimetus UNIQUE (tr_nimetus), -- Updated in previous step
    -- Added Format Check (Example: Uppercase letters, underscore, space allowed)
    CONSTRAINT chk_tootaja_roll_kood_format CHECK (r_kood ~ '^[A-Z_ ]+$'),
	CONSTRAINT chk_tootaja_roll_r_kood_not_empty CHECK (r_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_tootaja_roll_tr_nimetus_not_empty CHECK (tr_nimetus !~ '^[[:space:]]*$'), -- Updated in previous step
    CONSTRAINT chk_tootaja_roll_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$')
);
COMMENT ON TABLE tootaja_roll IS 'Classifier for employee roles (Captain, Cabin Crew, etc.).';

-- =========================================
-- Core Entity Tables
-- =========================================
CREATE TABLE lennukituup (
    lennukituup_kood VARCHAR(20) NOT NULL,
    lt_nimetus VARCHAR(100) NOT NULL, -- Original had 'lt_nimetus'
    maksimaalne_lennukaugus SMALLINT NOT NULL,
    maksimaalne_reisijate_arv SMALLINT NOT NULL,
    pardapersonali_arv SMALLINT NOT NULL,
    pilootide_arv SMALLINT NOT NULL,
    CONSTRAINT pk_lennukituup PRIMARY KEY (lennukituup_kood),
    -- Added Format Check (Example: Uppercase letters, numbers, hyphen allowed)
    CONSTRAINT chk_lennukituup_kood_format CHECK (lennukituup_kood ~ '^[A-Z0-9-]+$'),
    CONSTRAINT chk_lennukituup_lennukituup_kood_not_empty CHECK (lennukituup_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennukituup_lt_nimetus_not_empty CHECK (lt_nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennukituup_maksimaalne_lennukaugus_range CHECK (maksimaalne_lennukaugus BETWEEN 100 AND 25000),
    CONSTRAINT chk_lennukituup_max_reisijate_arv_range CHECK (maksimaalne_reisijate_arv BETWEEN 0 AND 850),
    CONSTRAINT chk_lennukituup_pardapersonali_arv_range CHECK (pardapersonali_arv BETWEEN 0 AND 20),
    CONSTRAINT chk_lennukituup_pilootide_arv_range CHECK (pilootide_arv BETWEEN 2 AND 5)
);
COMMENT ON TABLE lennukituup IS 'Represents an aircraft type (e.g., A320, B737).';

CREATE TABLE lennujaam (
    lennujaam_kood VARCHAR(3) NOT NULL, -- IATA code
    lj_nimetus VARCHAR(100) NOT NULL,
    koordinaadid_laius DECIMAL(8, 6) NOT NULL,
    koordinaadid_pikkus DECIMAL(9, 6) NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    reg_aeg TIMESTAMP(0) NOT NULL DEFAULT timezone('utc', now()),
    viimase_muutm_aeg TIMESTAMP(0) NOT NULL DEFAULT timezone('utc', now()),
    CONSTRAINT pk_lennujaam PRIMARY KEY (lennujaam_kood),
    CONSTRAINT fk_lennujaam_seisund FOREIGN KEY (seisund_kood) REFERENCES lennujaama_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT chk_lennujaam_koordinaadid_laius_range CHECK (koordinaadid_laius BETWEEN -90 AND 90),
	CONSTRAINT chk_lennujaam_koordinaadid_pikkus_range CHECK (koordinaadid_pikkus BETWEEN -180 AND 180),
    CONSTRAINT chk_lennujaam_kood_format CHECK (lennujaam_kood ~ '^[A-Z]{3}$'),
    CONSTRAINT chk_lennujaam_lj_nimetus_not_empty CHECK (lj_nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennujaam_reg_aeg_range CHECK (reg_aeg >= '2000-01-01' AND reg_aeg < (timezone('utc', now()) +'1 second'::interval)),
    CONSTRAINT chk_lennujaam_viimase_muutm_aeg_after_reg CHECK (viimase_muutm_aeg >= reg_aeg),
    CONSTRAINT chk_lennujaam_viimase_muutm_aeg_current CHECK (viimase_muutm_aeg < (timezone('utc', now()) +'1 second'::interval))
);
COMMENT ON TABLE lennujaam IS 'Represents an airport.';

CREATE TABLE lennuk (
    registreerimisnumber VARCHAR(10) NOT NULL,
    lennukituup_kood VARCHAR(20) NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    reg_aeg TIMESTAMP(0) NOT NULL DEFAULT timezone('utc', now()),
    viimase_muutm_aeg TIMESTAMP(0) NOT NULL DEFAULT timezone('utc', now()),
    CONSTRAINT pk_lennuk PRIMARY KEY (registreerimisnumber),
    CONSTRAINT fk_lennuk_lennukituup FOREIGN KEY (lennukituup_kood) REFERENCES lennukituup(lennukituup_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lennuk_seisund FOREIGN KEY (seisund_kood) REFERENCES lennuki_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_lennuk_registreerimisnumber_not_empty CHECK (registreerimisnumber !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennuk_reg_aeg_range CHECK (reg_aeg >= '2000-01-01' AND reg_aeg < (timezone('utc', now()) +'1 second'::interval)),
    CONSTRAINT chk_lennuk_viimase_muutm_aeg_after_reg CHECK (viimase_muutm_aeg >= reg_aeg),
    CONSTRAINT chk_lennuk_viimase_muutm_aeg_current CHECK (viimase_muutm_aeg < (timezone('utc', now()) +'1 second'::interval))
);
COMMENT ON TABLE lennuk IS 'Represents a specific aircraft instance.';

CREATE TABLE lend (
    lend_kood VARCHAR(10) NOT NULL,
    lahtelennujaam_kood VARCHAR(3) NOT NULL,
    sihtlennujaam_kood VARCHAR(3) NOT NULL,
    lennukituup_kood VARCHAR(20), -- Kept nullable from previous step
    lennuk_reg_nr VARCHAR(10), -- Kept nullable from previous step
    eeldatav_lahkumis_aeg TIMESTAMP(0) NOT NULL,
    eeldatav_saabumis_aeg TIMESTAMP(0) NOT NULL,
    tegelik_lahkumis_aeg TIMESTAMP(0) NOT NULL DEFAULT timezone('utc', now()),
    tegelik_saabumis_aeg TIMESTAMP(0) NOT NULL DEFAULT timezone('utc', now()),
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'PLANNED',
    kaugus_linnulennult DECIMAL(10, 2) NOT NULL,
    tuhistamise_pohjus VARCHAR(100),
    reg_aeg TIMESTAMP(0) NOT NULL DEFAULT timezone('utc', now()), -- Changed in previous step
    viimase_muutm_aeg TIMESTAMP(0) NOT NULL DEFAULT timezone('utc', now()), -- Changed in previous step
    CONSTRAINT pk_lend PRIMARY KEY (lend_kood),
    CONSTRAINT fk_lend_lahtelennujaam FOREIGN KEY (lahtelennujaam_kood) REFERENCES lennujaam(lennujaam_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lend_sihtlennujaam FOREIGN KEY (sihtlennujaam_kood) REFERENCES lennujaam(lennujaam_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lend_lennukituup FOREIGN KEY (lennukituup_kood) REFERENCES lennukituup(lennukituup_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lend_lennuk FOREIGN KEY (lennuk_reg_nr) REFERENCES lennuk(registreerimisnumber) ON UPDATE CASCADE ON DELETE RESTRICT, -- Changed in previous step
    CONSTRAINT fk_lend_seisund FOREIGN KEY (seisund_kood) REFERENCES lennu_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    -- Added Format Check (Example: 2 uppercase letters + 1-8 digits)
    CONSTRAINT chk_lend_kood_format CHECK (lend_kood ~ '^[A-Z]{2}[0-9]{1,8}$'),
    CONSTRAINT chk_lend_lennujaam_differ CHECK (sihtlennujaam_kood <> lahtelennujaam_kood),
    CONSTRAINT chk_lend_tuhistamise_pohjus_not_empty CHECK (tuhistamise_pohjus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lend_lennuk_or CHECK ( (lennukituup_kood IS NOT NULL) OR (lennuk_reg_nr IS NOT NULL) ),
    CONSTRAINT chk_lend_tuhistamise_pohjus CHECK ( (seisund_kood <> 'CANCELED') OR tuhistamise_pohjus IS NOT NULL ),
    CONSTRAINT chk_lend_reg_aeg_range CHECK (reg_aeg >= '2000-01-01' AND reg_aeg < (timezone('utc', now()) +'1 second'::interval)), -- Changed in previous step
    CONSTRAINT chk_lend_kaugus_linnulennult_range CHECK (kaugus_linnulennult > 0 AND kaugus_linnulennult <= 21000),
    CONSTRAINT chk_lend_tegelik_saabumis_aeg_range CHECK (tegelik_saabumis_aeg <= (tegelik_lahkumis_aeg + '24 hours'::interval)), -- Changed in previous step
    CONSTRAINT chk_lend_eeldatav_lahkumis_aeg_after CHECK (eeldatav_lahkumis_aeg > reg_aeg),
    CONSTRAINT chk_lend_tegelik_saabumis_aeg_after CHECK (tegelik_saabumis_aeg >= tegelik_lahkumis_aeg),
    CONSTRAINT chk_lend_eeldatav_lahkumis_aeg_max_future CHECK (eeldatav_lahkumis_aeg < (reg_aeg + '5 years'::interval)),
    CONSTRAINT chk_lend_eeldatav_saabumis_aeg_after CHECK (eeldatav_saabumis_aeg > eeldatav_lahkumis_aeg),
    CONSTRAINT chk_lend_eeldatav_saabumis_aeg_max_duration CHECK ((eeldatav_saabumis_aeg - eeldatav_lahkumis_aeg) <= '24 hours'::interval),
    CONSTRAINT chk_lend_tegelik_lahkumis_aeg_after_reg CHECK (tegelik_lahkumis_aeg >= reg_aeg),
    CONSTRAINT chk_lend_tegelik_lahkumis_aeg_current CHECK (tegelik_lahkumis_aeg < (timezone('utc', now()) +'1 second'::interval)),
    CONSTRAINT chk_lend_viimase_muutm_aeg_after_reg CHECK (viimase_muutm_aeg >= reg_aeg),
    CONSTRAINT chk_lend_viimase_muutm_aeg_current CHECK (viimase_muutm_aeg < (timezone('utc', now()) +'1 second'::interval))
);
COMMENT ON TABLE lend IS 'Represents a flight schedule.';

CREATE TABLE isik (
    isik_id SERIAL,
    isikunumber VARCHAR(20),
    eesnimi VARCHAR(50),
    perenimi VARCHAR(50),
    synni_kp DATE,
    elukoht VARCHAR(100),
    e_meil VARCHAR(254) NOT NULL,
    reg_aeg TIMESTAMP(0) NOT NULL DEFAULT timezone('utc', now()),
    viimase_muutm_aeg TIMESTAMP(0) NOT NULL DEFAULT timezone('utc', now()),
    CONSTRAINT pk_isik PRIMARY KEY (isik_id),
    CONSTRAINT uq_isik_e_meil UNIQUE (e_meil),
    CONSTRAINT chk_isik_isikunumber_not_empty CHECK (isikunumber !~ '^[[:space:]]*$'),
    CONSTRAINT chk_isik_eesnimi_not_empty CHECK (eesnimi !~ '^[[:space:]]*$'),
    CONSTRAINT chk_isik_perenimi_not_empty CHECK (perenimi !~ '^[[:space:]]*$'),
    CONSTRAINT chk_isik_elukoht_not_empty CHECK (elukoht !~ '^[[:space:]]*$'),
    CONSTRAINT chk_isik_email_format CHECK (e_meil LIKE '_%@_%.__%'),
    CONSTRAINT chk_isik_synni_kp_min_date CHECK (synni_kp >= '1900-01-01'),
    CONSTRAINT chk_isik_synni_kp_before_reg CHECK (synni_kp < reg_aeg),
    CONSTRAINT chk_isik_reg_aeg_range CHECK (reg_aeg >= '2000-01-01' AND reg_aeg < (timezone('utc', now()) +'1 second'::interval)),
    CONSTRAINT chk_isik_viimase_muutm_aeg_after CHECK (viimase_muutm_aeg >= reg_aeg),
    CONSTRAINT chk_isik_viimase_muutm_aeg_current CHECK (viimase_muutm_aeg < (timezone('utc', now()) +'1 second'::interval)),
    CONSTRAINT chk_isik_eesnimi_or_perenimi_not_null CHECK (eesnimi IS NOT NULL OR perenimi IS NOT NULL)
);
COMMENT ON TABLE isik IS 'Represents a person (can be employee or client).';

CREATE TABLE kuupaevade_vahemiku_maandumiskeeld (
    keeld_alguse_aeg TIMESTAMP(0) NOT NULL,
    keeld_lopu_aeg TIMESTAMP(0) NOT NULL,
    lennujaam_kood VARCHAR(3) NOT NULL,
    CONSTRAINT pk_kuupaevade_vahemiku_maandumiskeeld PRIMARY KEY (keeld_alguse_aeg, keeld_lopu_aeg, lennujaam_kood),
    CONSTRAINT fk_kuupaevade_vahemiku_maandumiskeeld_lennujaam FOREIGN KEY (lennujaam_kood) REFERENCES lennujaam(lennujaam_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_kuupaevade_vahemiku_maandumiskeeld_keeld_alguse_aeg_range CHECK (keeld_alguse_aeg >= '2000-01-01' AND keeld_alguse_aeg < (timezone('utc', now()) + INTERVAL '5 years')),
	CONSTRAINT chk_kuupaevade_vahemiku_maandumiskeeld_keeld_lopu_aeg_after_alguse_aeg CHECK (keeld_lopu_aeg > keeld_alguse_aeg),
    CONSTRAINT chk_kuupaevade_vahemiku_maandumiskeeld_max_duration CHECK (keeld_lopu_aeg < (keeld_alguse_aeg + INTERVAL '5 years'))
);
COMMENT ON TABLE kuupaevade_vahemiku_maandumiskeeld IS 'Represents a period during which landings are prohibited at a specific airport.';


CREATE TABLE lennujaama_vastuvoetavad_lennukituubid (
    lennujaam_kood VARCHAR(3) NOT NULL,
    lennukituup_kood VARCHAR(20) NOT NULL,
    CONSTRAINT pk_lennujaama_vastuvoetavad_lennukituubid PRIMARY KEY (lennujaam_kood, lennukituup_kood),
    CONSTRAINT fk_lennujaama_vastuvoetavad_lennukituubid_lennujaam FOREIGN KEY (lennujaam_kood) REFERENCES lennujaam(lennujaam_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lennujaama_vastuvoetavad_lennukituubid_lennukituup FOREIGN KEY (lennukituup_kood) REFERENCES lennukituup(lennukituup_kood) ON UPDATE CASCADE ON DELETE RESTRICT
);
COMMENT ON TABLE lennujaama_vastuvoetavad_lennukituubid IS 'Links airports to the aircraft types they can accept.';


CREATE TABLE kasutaja_konto (
    isik_id INT NOT NULL,
    on_aktiivne BOOLEAN NOT NULL DEFAULT TRUE,
    parool VARCHAR(255) NOT NULL,
    CONSTRAINT pk_kasutaja_konto PRIMARY KEY (isik_id),
    CONSTRAINT unique_kasutaja_konto_isik_id UNIQUE(isik_id),
    CONSTRAINT chk_kasutaja_konto_parool_not_empty CHECK (parool !~ '^[[:space:]]*$'),
    CONSTRAINT fk_kasutaja_konto_isik FOREIGN KEY (isik_id) REFERENCES isik(isik_id) ON UPDATE RESTRICT ON DELETE CASCADE
);
COMMENT ON TABLE kasutaja_konto IS 'Represents a user account in the system.';

CREATE TABLE tootaja (
    isik_id INT NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'WORKING',
    CONSTRAINT pk_tootaja PRIMARY KEY (isik_id),
    CONSTRAINT fk_tootaja_isik FOREIGN KEY (isik_id) REFERENCES isik(isik_id) ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_tootaja_seisund FOREIGN KEY (seisund_kood) REFERENCES tootaja_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT
);
COMMENT ON TABLE tootaja IS 'Represents an employee, linked to an isik.';

CREATE TABLE klient (
    isik_id INT NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT pk_klient PRIMARY KEY (isik_id),
    CONSTRAINT fk_klient_isik FOREIGN KEY (isik_id) REFERENCES isik(isik_id) ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_klient_seisund FOREIGN KEY (seisund_kood) REFERENCES kliendi_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT
);
COMMENT ON TABLE klient IS 'Represents a client/customer, linked to an isik.';

CREATE TABLE litsents (
    litsents_id SERIAL,
    tootaja_isik_id INT NOT NULL,
    lennukituup_kood VARCHAR(20) NOT NULL,
    r_kood VARCHAR(20) NOT NULL,
    kehtivuse_algus TIMESTAMP(0) NOT NULL,
    kehtivuse_lopp TIMESTAMP(0) NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'VALID',
    CONSTRAINT pk_litsents PRIMARY KEY (litsents_id),
    CONSTRAINT fk_litsents_tootaja FOREIGN KEY (tootaja_isik_id) REFERENCES tootaja(isik_id) ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_litsents_lennukituup FOREIGN KEY (lennukituup_kood) REFERENCES lennukituup(lennukituup_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_litsents_roll FOREIGN KEY (r_kood) REFERENCES tootaja_roll(r_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_litsents_seisund FOREIGN KEY (seisund_kood) REFERENCES litsentsi_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_litsents_tootaja_tuup_roll UNIQUE (tootaja_isik_id, lennukituup_kood, r_kood),
    CONSTRAINT chk_litsents_kehtivuse_algus_range CHECK (kehtivuse_algus >= '2000-01-01' AND kehtivuse_algus < (timezone('utc', now()) + '5 years'::interval)),
	CONSTRAINT chk_litsents_kehtivuse_lopp_after_kehtivuse_algus CHECK(kehtivuse_lopp > kehtivuse_algus),
    CONSTRAINT chk_litsents_kehtivuse_lopp_max_duration CHECK (kehtivuse_lopp < (kehtivuse_algus + '15 years'::interval))
);
COMMENT ON TABLE litsents IS 'Represents licenses held by employees for specific aircraft types and roles.';

CREATE TABLE tootaja_lennus (
    tootaja_lennus_id SERIAL,
    lend_kood VARCHAR(10) NOT NULL,
    tootaja_isik_id INT NOT NULL,
    r_kood VARCHAR(20) NOT NULL,
    CONSTRAINT pk_tootaja_lennus PRIMARY KEY (tootaja_lennus_id),
    CONSTRAINT fk_tootaja_lennus_lend FOREIGN KEY (lend_kood) REFERENCES lend(lend_kood) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_tootaja_lennus_tootaja FOREIGN KEY (tootaja_isik_id) REFERENCES tootaja(isik_id) ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_tootaja_lennus_roll FOREIGN KEY (r_kood) REFERENCES tootaja_roll(r_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_tootaja_lennus_lend_tootaja UNIQUE (lend_kood, tootaja_isik_id)
);
COMMENT ON TABLE tootaja_lennus IS 'Associates employees with specific flights and their roles.';

CREATE TABLE hooldus (
    hooldus_id SERIAL,
    lennuk_reg_nr VARCHAR(10) NOT NULL,
    alguse_aeg TIMESTAMP(0) NOT NULL,
    lopu_aeg TIMESTAMP(0) NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'PLANNED',
    kirjeldus VARCHAR(1000) NOT NULL,
    lennujaam_kood VARCHAR(3) NOT NULL,
    CONSTRAINT pk_hooldus PRIMARY KEY (hooldus_id),
    CONSTRAINT fk_hooldus_lennuk FOREIGN KEY (lennuk_reg_nr) REFERENCES lennuk(registreerimisnumber) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_hooldus_seisund FOREIGN KEY (seisund_kood) REFERENCES hoolduse_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_hooldus_lennujaam FOREIGN KEY (lennujaam_kood) REFERENCES lennujaam(lennujaam_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_hooldus_lennuk_alguse_aeg UNIQUE (lennuk_reg_nr, alguse_aeg),
    CONSTRAINT chk_hooldus_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_hooldus_alguse_aeg_range CHECK (alguse_aeg >= '2000-01-01' AND alguse_aeg < (timezone('utc', now()) +'5 years'::interval)),
    CONSTRAINT chk_hooldus_lopu_aeg_after_alguse_aeg CHECK (lopu_aeg > alguse_aeg),
    CONSTRAINT chk_hooldus_lopu_aeg_max_duration CHECK (lopu_aeg < (alguse_aeg + '6 months'::interval))
);
COMMENT ON TABLE hooldus IS 'Records maintenance activities for aircraft.';

CREATE TABLE broneering (
    broneering_id SERIAL,
    lend_kood VARCHAR(10) NOT NULL,
    klient_isik_id INT NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    broneerimise_aeg TIMESTAMP(0) NOT NULL DEFAULT timezone('utc', now()),
    viimase_muutm_aeg TIMESTAMP(0) NOT NULL DEFAULT timezone('utc', now()),
    maksumus DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_broneering PRIMARY KEY (broneering_id),
    CONSTRAINT fk_broneering_lend FOREIGN KEY (lend_kood) REFERENCES lend(lend_kood) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_broneering_klient FOREIGN KEY (klient_isik_id) REFERENCES klient(isik_id) ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_broneering_seisund FOREIGN KEY (seisund_kood) REFERENCES broneeringu_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_broneering_lend_klient UNIQUE (lend_kood, klient_isik_id),
    CONSTRAINT chk_broneering_broneerimise_aeg_range CHECK (broneerimise_aeg >= '2000-01-01' AND broneerimise_aeg < (timezone('utc', now()) +'1 second'::interval)),
    CONSTRAINT chk_broneering_maksumus_non_negative CHECK (maksumus >= 0),
    CONSTRAINT chk_broneering_viimase_muutm_aeg_after_broneering CHECK (viimase_muutm_aeg >= broneerimise_aeg),
    CONSTRAINT chk_broneering_viimase_muutm_aeg_current CHECK (viimase_muutm_aeg < (timezone('utc', now()) + '1 second'::interval))
);
COMMENT ON TABLE broneering IS 'Represents a client booking on a specific flight.';

-- =========================================
-- Indexes
-- =========================================
CREATE INDEX idx_lend_lahkumis_aeg ON lend(eeldatav_lahkumis_aeg);
CREATE INDEX idx_lend_saabumis_aeg ON lend(eeldatav_saabumis_aeg);
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
CREATE INDEX idx_lennujaam_nimi ON lennujaam(lj_nimetus);
CREATE INDEX idx_lennukituup_nimi ON lennukituup(lt_nimetus);
CREATE INDEX idx_kuupaevade_vahemiku_maandumiskeeld_lennujaam_aeg ON kuupaevade_vahemiku_maandumiskeeld(lennujaam_kood, keeld_alguse_aeg, keeld_lopu_aeg);

-- ========================================================================== --
--                                HELPER FUNCTIONS & TRIGGERS                 --
-- ========================================================================== --

-- Trigger function for viimase_muutm_aeg
CREATE OR REPLACE FUNCTION lennufirma.fn_update_viimase_muutm_aeg()
RETURNS TRIGGER AS $$
BEGIN
  NEW.viimase_muutm_aeg = timezone('utc', now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION lennufirma.fn_update_viimase_muutm_aeg IS 'Trigger function to automatically set/update the viimase_muutm_aeg column to the current time (precision 0) on row inserts and updates.';

-- Apply the trigger for INSERT OR UPDATE
CREATE TRIGGER trg_lend_set_update_viimase_muutm_aeg BEFORE INSERT OR UPDATE ON lennufirma.lend FOR EACH ROW EXECUTE FUNCTION lennufirma.fn_update_viimase_muutm_aeg();
CREATE TRIGGER trg_lennujaam_set_update_viimase_muutm_aeg BEFORE INSERT OR UPDATE ON lennufirma.lennujaam FOR EACH ROW EXECUTE FUNCTION lennufirma.fn_update_viimase_muutm_aeg();
CREATE TRIGGER trg_lennuk_set_update_viimase_muutm_aeg BEFORE INSERT OR UPDATE ON lennufirma.lennuk FOR EACH ROW EXECUTE FUNCTION lennufirma.fn_update_viimase_muutm_aeg();
CREATE TRIGGER trg_isik_set_update_viimase_muutm_aeg BEFORE INSERT OR UPDATE ON lennufirma.isik FOR EACH ROW EXECUTE FUNCTION lennufirma.fn_update_viimase_muutm_aeg();
CREATE TRIGGER trg_broneering_set_update_viimase_muutm_aeg BEFORE INSERT OR UPDATE ON lennufirma.broneering FOR EACH ROW EXECUTE FUNCTION lennufirma.fn_update_viimase_muutm_aeg();

-- Trigger function for flight capacity check
CREATE OR REPLACE FUNCTION check_flight_capacity() RETURNS TRIGGER AS $$
DECLARE
    v_max_passengers INT;
    v_current_bookings INT;
BEGIN
    -- Get max passengers based on the aircraft type assigned to the flight
    SELECT lt.maksimaalne_reisijate_arv INTO v_max_passengers
    FROM lend l
    JOIN lennukituup lt ON COALESCE(l.lennukituup_kood, (SELECT lk.lennukituup_kood FROM lennuk lk WHERE lk.registreerimisnumber = l.lennuk_reg_nr)) = lt.lennukituup_kood
    WHERE l.lend_kood = NEW.lend_kood FOR UPDATE;

    -- If no aircraft type found (should not happen due to constraints, but handle defensively)
    IF v_max_passengers IS NULL THEN
        RAISE WARNING 'Could not determine maximum passenger count for flight %', NEW.lend_kood;
        RETURN NEW; -- Allow booking but log a warning
    END IF;

    -- Count current active bookings for the flight
    SELECT COUNT(*) INTO v_current_bookings
    FROM broneering b
    WHERE b.lend_kood = NEW.lend_kood AND b.seisund_kood = 'ACTIVE';

    -- Check if adding this booking exceeds capacity
    -- If it's an UPDATE, only check if the status is changing to ACTIVE or it's a new INSERT
    IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND NEW.seisund_kood = 'ACTIVE' AND OLD.seisund_kood <> 'ACTIVE') THEN
        IF v_current_bookings >= v_max_passengers THEN
             RAISE EXCEPTION 'Flight capacity exceeded for flight % (Max: %, Current Active: %)',
                NEW.lend_kood, v_max_passengers, v_current_bookings;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_flight_capacity
BEFORE INSERT OR UPDATE ON broneering
FOR EACH ROW EXECUTE FUNCTION check_flight_capacity();

-- Trigger function for aircraft type max distance check
CREATE OR REPLACE FUNCTION lennufirma.check_lennukituup_max_distance()
RETURNS TRIGGER AS $$
DECLARE
    v_max_range DECIMAL(10, 2);
BEGIN
    -- Only check if distance is provided
    IF NEW.kaugus_linnulennult IS NOT NULL THEN
        -- Determine max range based on either assigned aircraft or type
        IF NEW.lennuk_reg_nr IS NOT NULL THEN
            SELECT lt.maksimaalne_lennukaugus INTO v_max_range
            FROM lennufirma.lennuk l
            JOIN lennufirma.lennukituup lt ON l.lennukituup_kood = lt.lennukituup_kood
            WHERE l.registreerimisnumber = NEW.lennuk_reg_nr FOR UPDATE;
        ELSIF NEW.lennukituup_kood IS NOT NULL THEN
            SELECT lt.maksimaalne_lennukaugus INTO v_max_range
            FROM lennufirma.lennukituup lt
            WHERE lt.lennukituup_kood = NEW.lennukituup_kood FOR UPDATE;
        ELSE
             -- Should not happen due to table constraint chk_lend_lennuk_or
             RETURN NEW;
        END IF;

        -- If max range is defined for the type, check the flight distance
        IF v_max_range IS NOT NULL AND NEW.kaugus_linnulennult > v_max_range THEN
            RAISE EXCEPTION 'Flight distance (%) exceeds the maximum range (%) for the assigned aircraft/type (Aircraft: %, Type: %)',
                NEW.kaugus_linnulennult, v_max_range, NEW.lennuk_reg_nr, NEW.lennukituup_kood;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_lennukituup_max_distance
BEFORE INSERT OR UPDATE ON lennufirma.lend
FOR EACH ROW EXECUTE FUNCTION lennufirma.check_lennukituup_max_distance();

-- Trigger function for aircraft type match check
CREATE OR REPLACE FUNCTION lennufirma.check_lennuk_type_match()
RETURNS TRIGGER AS $$
BEGIN
    -- If both aircraft and aircraft type are specified
    IF NEW.lennuk_reg_nr IS NOT NULL AND NEW.lennukituup_kood IS NOT NULL THEN
        -- Check if the aircraft's type matches the specified type
        IF NEW.lennukituup_kood <> (
            SELECT lennukituup_kood
            FROM lennufirma.lennuk
            WHERE registreerimisnumber = NEW.lennuk_reg_nr FOR UPDATE
        ) THEN
            RAISE EXCEPTION 'Aircraft type mismatch: The specified aircraft % is not of type %',
                NEW.lennuk_reg_nr, NEW.lennukituup_kood;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_lend_check_lennuk_type_match
BEFORE INSERT OR UPDATE ON lennufirma.lend
FOR EACH ROW EXECUTE FUNCTION lennufirma.check_lennuk_type_match();

-- Helper function to check landing ban
CREATE OR REPLACE FUNCTION lennufirma.fn_check_landing_ban(
    p_airport_code VARCHAR(3),
    p_arrival_time TIMESTAMP(0)
) RETURNS VOID LANGUAGE plpgsql AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM lennufirma.kuupaevade_vahemiku_maandumiskeeld
        WHERE lennujaam_kood = p_airport_code
          AND p_arrival_time >= keeld_alguse_aeg
          AND p_arrival_time < keeld_lopu_aeg FOR UPDATE
    ) THEN
        RAISE EXCEPTION 'Landing ban active at airport % during the planned arrival time %.', p_airport_code, p_arrival_time;
    END IF;
END;
$$;
COMMENT ON FUNCTION lennufirma.fn_check_landing_ban IS 'Checks if a landing ban is active for a given airport at a specific time.';

-- Helper function to check airport status
CREATE OR REPLACE FUNCTION lennufirma.fn_check_airport_seisund(
    p_airport_code VARCHAR(3)
) RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
    v_status VARCHAR(20);
BEGIN
    SELECT seisund_kood INTO v_status FROM lennufirma.lennujaam WHERE lennujaam_kood = p_airport_code FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Airport % not found.', p_airport_code; END IF;
    IF v_status <> 'OPEN' THEN
        RAISE EXCEPTION 'Airport % is not operational (Status: %).', p_airport_code, v_status;
    END IF;
END;
$$;
COMMENT ON FUNCTION lennufirma.fn_check_airport_seisund IS 'Checks if an airport status is OPEN.';

-- Helper function to check aircraft status
CREATE OR REPLACE FUNCTION lennufirma.fn_check_aircraft_seisund(
    p_aircraft_reg_nr VARCHAR(10)
) RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
    v_status VARCHAR(20);
BEGIN
    SELECT seisund_kood INTO v_status FROM lennufirma.lennuk WHERE registreerimisnumber = p_aircraft_reg_nr FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Aircraft % not found.', p_aircraft_reg_nr; END IF;
    IF v_status <> 'ACTIVE' THEN
        RAISE EXCEPTION 'Aircraft % is not operational (Status: %).', p_aircraft_reg_nr, v_status;
    END IF;
END;
$$;
COMMENT ON FUNCTION lennufirma.fn_check_aircraft_seisund IS 'Checks if an aircraft status is ACTIVE.';


-- ========================================================================== --
--                 FLIGHT OPERATION FUNCTIONS (OPx)                         --
-- ========================================================================== --

-- Function to calculate distance
CREATE OR REPLACE FUNCTION lennufirma.fn_calculate_distance(
    p_lahtelennujaam_kood VARCHAR(3),
    p_sihtlennujaam_kood VARCHAR(3)
)
RETURNS DECIMAL(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    lat1 DECIMAL(9, 6); lon1 DECIMAL(9, 6); lat2 DECIMAL(9, 6); lon2 DECIMAL(9, 6);
    R INT := 6371; dLat FLOAT; dLon FLOAT; a FLOAT; c FLOAT; d DECIMAL(10, 2);
BEGIN
    SELECT koordinaadid_laius, koordinaadid_pikkus INTO lat1, lon1 FROM lennufirma.lennujaam WHERE lennujaam_kood = p_lahtelennujaam_kood FOR UPDATE;
    SELECT koordinaadid_laius, koordinaadid_pikkus INTO lat2, lon2 FROM lennufirma.lennujaam WHERE lennujaam_kood = p_sihtlennujaam_kood FOR UPDATE;
    IF lat1 IS NULL OR lon1 IS NULL OR lat2 IS NULL OR lon2 IS NULL THEN RAISE EXCEPTION 'Coordinates not found for one or both airports (%, %).', p_lahtelennujaam_kood, p_sihtlennujaam_kood; END IF;
    dLat = radians(lat2 - lat1); dLon = radians(lon2 - lon1); lat1 = radians(lat1); lat2 = radians(lat2);
    a = sin(dLat / 2) * sin(dLat / 2) + sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    c = 2 * atan2(sqrt(a), sqrt(1 - a)); d = R * c;
    RETURN ROUND(d, 2);
END;
$$;
COMMENT ON FUNCTION lennufirma.fn_calculate_distance IS 'Calculates the great-circle distance between two airports using the Haversine formula.';

-- OP1: Registreeri lend
CREATE OR REPLACE FUNCTION lennufirma.fn_op1_registreeri_lend(
  p_lennu_kood VARCHAR(10), p_lahtelennujaam_kood VARCHAR(3), p_sihtlennujaam_kood VARCHAR(3),
  p_eeldatav_lahkumis_aeg TIMESTAMP(0), p_eeldatav_saabumis_aeg TIMESTAMP(0),
  p_lennukituup_kood VARCHAR(20) DEFAULT NULL, p_lennuk_reg_nr VARCHAR(10) DEFAULT NULL
) RETURNS VARCHAR(10) LANGUAGE plpgsql AS $$
DECLARE
  v_created_kood VARCHAR(10); v_dep_airport_exists BOOLEAN; v_arr_airport_exists BOOLEAN;
  v_type_exists BOOLEAN; v_plane_exists BOOLEAN; v_calculated_distance DECIMAL(10, 2);
  v_actual_aircraft_type VARCHAR(20); v_aircraft_type_supported_departure BOOLEAN; v_aircraft_type_supported_arrival BOOLEAN;
  v_is_in_maintenance BOOLEAN; -- Variable for maintenance check
BEGIN
  -- Basic Input Validation (as before)...
  IF p_sihtlennujaam_kood = p_lahtelennujaam_kood THEN RAISE EXCEPTION 'OP1 Error: Departure and destination airport cannot be the same (%).', p_lahtelennujaam_kood; END IF;
  IF p_eeldatav_saabumis_aeg <= p_eeldatav_lahkumis_aeg THEN RAISE EXCEPTION 'OP1 Error: Expected arrival time (%) must be later than departure time (%).', p_eeldatav_saabumis_aeg, p_eeldatav_lahkumis_aeg; END IF;
  IF p_lennukituup_kood IS NULL AND p_lennuk_reg_nr IS NULL THEN RAISE EXCEPTION 'OP1 Error: Must specify either aircraft type or specific aircraft.'; END IF;

  -- Existence Checks (as before)...
  SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaam lj WHERE lj.lennujaam_kood = p_lahtelennujaam_kood) INTO v_dep_airport_exists FOR UPDATE; IF NOT v_dep_airport_exists THEN RAISE EXCEPTION 'OP1 Error: Departure airport % not found.', p_lahtelennujaam_kood; END IF;
  SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaam lj WHERE lj.lennujaam_kood = p_sihtlennujaam_kood) INTO v_arr_airport_exists FOR UPDATE; IF NOT v_arr_airport_exists THEN RAISE EXCEPTION 'OP1 Error: Destination airport % not found.', p_sihtlennujaam_kood; END IF;
  IF p_lennukituup_kood IS NOT NULL THEN SELECT EXISTS (SELECT 1 FROM lennufirma.lennukituup lt WHERE lt.lennukituup_kood = p_lennukituup_kood) INTO v_type_exists FOR UPDATE; IF NOT v_type_exists THEN RAISE EXCEPTION 'OP1 Error: Aircraft type % not found.', p_lennukituup_kood; END IF; END IF;
  IF p_lennuk_reg_nr IS NOT NULL THEN SELECT EXISTS (SELECT 1 FROM lennufirma.lennuk lk WHERE lk.registreerimisnumber = upper(p_lennuk_reg_nr)) INTO v_plane_exists FOR UPDATE; IF NOT v_plane_exists THEN RAISE EXCEPTION 'OP1 Error: Aircraft % not found.', upper(p_lennuk_reg_nr); END IF; END IF;

  -- Operational Status Checks (as before)...
  PERFORM fn_check_airport_seisund(p_lahtelennujaam_kood);
  PERFORM fn_check_airport_seisund(p_sihtlennujaam_kood);
  PERFORM fn_check_landing_ban(p_sihtlennujaam_kood, p_eeldatav_saabumis_aeg);
  IF p_lennuk_reg_nr IS NOT NULL THEN
      PERFORM fn_check_aircraft_seisund(upper(p_lennuk_reg_nr)); -- Checks if ACTIVE
  END IF;

  -- Airport Type Compatibility Checks (as before)...
  IF p_lennukituup_kood IS NOT NULL THEN
    SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaama_vastuvoetavad_lennukituubid llvt WHERE llvt.lennujaam_kood = p_lahtelennujaam_kood AND llvt.lennukituup_kood = p_lennukituup_kood) INTO v_aircraft_type_supported_departure FOR UPDATE; IF NOT v_aircraft_type_supported_departure THEN RAISE EXCEPTION 'OP1 Error: Aircraft type % not supported at departure airport %.', p_lennukituup_kood, p_lahtelennujaam_kood; END IF;
    SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaama_vastuvoetavad_lennukituubid llvt WHERE llvt.lennujaam_kood = p_sihtlennujaam_kood AND llvt.lennukituup_kood = p_lennukituup_kood) INTO v_aircraft_type_supported_arrival FOR UPDATE; IF NOT v_aircraft_type_supported_arrival THEN RAISE EXCEPTION 'OP1 Error: Aircraft type % not supported at destination airport %.', p_lennukituup_kood, p_sihtlennujaam_kood; END IF;
  END IF;

  -- Aircraft Assignment Type Check (as before)...
  IF p_lennuk_reg_nr IS NOT NULL AND p_lennukituup_kood IS NOT NULL THEN
     SELECT lk.lennukituup_kood INTO v_actual_aircraft_type FROM lennufirma.lennuk lk WHERE lk.registreerimisnumber = upper(p_lennuk_reg_nr) FOR UPDATE;
     IF v_actual_aircraft_type <> p_lennukituup_kood THEN RAISE EXCEPTION 'OP1 Error: Assigned aircraft % type (%) does not match flight required type (%).', upper(p_lennuk_reg_nr), v_actual_aircraft_type, p_lennukituup_kood; END IF;
  END IF;

  -- *** ADDED: Maintenance Conflict Check ***
  IF p_lennuk_reg_nr IS NOT NULL THEN
      SELECT EXISTS (
          SELECT 1 FROM lennufirma.hooldus h
          WHERE h.lennuk_reg_nr = upper(p_lennuk_reg_nr)
          AND h.seisund_kood <> 'CANCELED' -- Ignore canceled maintenance
          -- Check for overlap using standard operators
          AND h.alguse_aeg < p_eeldatav_saabumis_aeg
          AND h.lopu_aeg > p_eeldatav_lahkumis_aeg FOR UPDATE
      ) INTO v_is_in_maintenance;

      IF v_is_in_maintenance THEN
          RAISE EXCEPTION 'OP1 Error: Aircraft % is scheduled for maintenance during the flight time (% to %).', upper(p_lennuk_reg_nr), p_eeldatav_lahkumis_aeg, p_eeldatav_saabumis_aeg;
      END IF;
  END IF;
  -- *** END: Maintenance Conflict Check ***

  -- Calculate Distance (as before)...
  SELECT lennufirma.fn_calculate_distance(p_lahtelennujaam_kood, p_sihtlennujaam_kood) INTO v_calculated_distance;

  -- Insert Flight (as before)...
  INSERT INTO lennufirma.lend (lend_kood, lahtelennujaam_kood, sihtlennujaam_kood, lennukituup_kood, lennuk_reg_nr, eeldatav_lahkumis_aeg, eeldatav_saabumis_aeg, seisund_kood, kaugus_linnulennult)
  VALUES (upper(p_lennu_kood), p_lahtelennujaam_kood, p_sihtlennujaam_kood, p_lennukituup_kood, upper(p_lennuk_reg_nr), p_eeldatav_lahkumis_aeg, p_eeldatav_saabumis_aeg, 'PLANNED', v_calculated_distance)
  RETURNING lend_kood INTO v_created_kood;

  RETURN v_created_kood;
END;
$$;
COMMENT ON FUNCTION lennufirma.fn_op1_registreeri_lend IS 'OP1: Registers a new flight with status PLANNED, calculates distance, validates inputs, checks airport/aircraft status and landing bans.';

-- OP3: Tuhista lend
CREATE OR REPLACE FUNCTION lennufirma.fn_op3_tuhista_lend(p_lennu_kood VARCHAR(10), p_pohjus VARCHAR(100))
RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE 
    v_current_seisund VARCHAR(20);
    v_updated_rows INT;
BEGIN
    SELECT l.seisund_kood INTO v_current_seisund FROM lend l WHERE l.lend_kood = upper(p_lennu_kood) FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'OP3 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;
    IF v_current_seisund NOT IN ('PLANNED', 'CONFIRMED', 'DELAYED', 'BOARDING', 'GATE DEPARTED') THEN RAISE EXCEPTION 'OP3 Error: Flight % cannot be canceled in status %.', upper(p_lennu_kood), v_current_seisund; END IF;
    IF p_pohjus IS NULL OR p_pohjus ~ '^[[:space:]]*$' THEN RAISE EXCEPTION 'OP3 Error: Cancellation reason is required and cannot be empty.'; END IF;
    
    UPDATE lend SET seisund_kood = 'CANCELED', tuhistamise_pohjus = p_pohjus 
    WHERE lend_kood = upper(p_lennu_kood);
    
    GET DIAGNOSTICS v_updated_rows = ROW_COUNT;
    RETURN v_updated_rows > 0;
END; $$;
COMMENT ON FUNCTION fn_op3_tuhista_lend IS 'OP3: Changes flight status to CANCELED, records the mandatory reason, and returns TRUE if successful.';

-- OP4: Maara hilinenuks
CREATE OR REPLACE FUNCTION lennufirma.fn_op4_maara_hilinenuks(p_lennu_kood VARCHAR(10), p_uus_lahkumis_aeg TIMESTAMP(0), p_uus_saabumis_aeg TIMESTAMP(0))
RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE 
    v_lend_seisund VARCHAR(20); 
    v_original_lahkumis_aeg TIMESTAMP(0); 
    v_siht_kood VARCHAR(3);
    v_updated_rows INT;
BEGIN
    SELECT l.seisund_kood, l.eeldatav_lahkumis_aeg, l.sihtlennujaam_kood
    INTO v_lend_seisund, v_original_lahkumis_aeg, v_siht_kood
    FROM lend l WHERE l.lend_kood = upper(p_lennu_kood) FOR UPDATE;

    IF NOT FOUND THEN RAISE EXCEPTION 'OP4 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;
    IF v_lend_seisund NOT IN ('PLANNED', 'CONFIRMED', 'DELAYED') THEN RAISE EXCEPTION 'OP4 Error: Flight % cannot be marked delayed in status %.', upper(p_lennu_kood), v_lend_seisund; END IF;
    IF p_uus_saabumis_aeg <= p_uus_lahkumis_aeg THEN RAISE EXCEPTION 'OP4 Error: New arrival time (%) must be later than new departure time (%).', p_uus_saabumis_aeg, p_uus_lahkumis_aeg; END IF;
    IF p_uus_lahkumis_aeg <= v_original_lahkumis_aeg THEN RAISE EXCEPTION 'OP4 Error: New departure time (%) must be later than the original departure time (%).', p_uus_lahkumis_aeg, v_original_lahkumis_aeg; END IF;

    -- Check ban for new arrival time
    PERFORM fn_check_landing_ban(v_siht_kood, p_uus_saabumis_aeg);

    UPDATE lend SET seisund_kood = 'DELAYED', eeldatav_lahkumis_aeg = p_uus_lahkumis_aeg, eeldatav_saabumis_aeg = p_uus_saabumis_aeg 
    WHERE lend_kood = upper(p_lennu_kood);
    
    GET DIAGNOSTICS v_updated_rows = ROW_COUNT;
    RETURN v_updated_rows > 0;
END; $$;
COMMENT ON FUNCTION fn_op4_maara_hilinenuks IS 'OP4: Changes flight status to DELAYED, updates times, checks landing ban for the new arrival time, and returns TRUE if successful.';

-- OP13: Kustuta lend
CREATE OR REPLACE FUNCTION fn_op13_kustuta_lend(p_lennu_kood VARCHAR(10))
RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE v_lend_seisund VARCHAR(20); v_count INT;
BEGIN
  SELECT l.seisund_kood INTO v_lend_seisund FROM lend l WHERE l.lend_kood = upper(p_lennu_kood) FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'OP13 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;
  IF v_lend_seisund <> 'PLANNED' THEN RAISE EXCEPTION 'OP13 Error: Flight % cannot be deleted as it is not in PLANNED status (current: %).', upper(p_lennu_kood), v_lend_seisund; END IF;
  DELETE FROM lend WHERE lend_kood = upper(p_lennu_kood);
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count > 0;
END; $$;
COMMENT ON FUNCTION fn_op13_kustuta_lend IS 'OP13: Deletes a flight only if it is in PLANNED status.';

-- OP14: Muuda lendu
CREATE OR REPLACE FUNCTION fn_op14_muuda_lendu(
  p_lennu_kood VARCHAR(10), p_uus_lahkumis_aeg TIMESTAMP(0) DEFAULT NULL, p_uus_saabumis_aeg TIMESTAMP(0) DEFAULT NULL,
  p_uus_lennukituup_kood VARCHAR(20) DEFAULT NULL, p_uus_lennuk_reg_nr VARCHAR(10) DEFAULT NULL,
  p_uus_sihtlennujaam_kood VARCHAR(3) DEFAULT NULL, p_uus_lahtelennujaam_kood VARCHAR(3) DEFAULT NULL
) RETURNS lend LANGUAGE plpgsql AS $$
DECLARE
  v_lend lend%ROWTYPE; v_rec lend%ROWTYPE;
  v_final_lahkumis_aeg TIMESTAMP(0); v_final_saabumis_aeg TIMESTAMP(0);
  v_final_lahke_kood VARCHAR(3); v_final_siht_kood VARCHAR(3);
  v_final_tuup_kood VARCHAR(20); v_final_reg_nr VARCHAR(10);
  v_aircraft_type_supported_departure BOOLEAN; v_aircraft_type_supported_arrival BOOLEAN;
BEGIN
  -- Fetch current flight data
  SELECT l.* INTO v_lend FROM lend l WHERE l.lend_kood = upper(p_lennu_kood) FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'OP14 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;

  -- Check current status
  IF v_lend.seisund_kood NOT IN ('PLANNED', 'CONFIRMED', 'DELAYED') THEN RAISE EXCEPTION 'OP14 Error: Flight % data cannot be modified in status %.', upper(p_lennu_kood), v_lend.seisund_kood; END IF;

  -- Basic existence checks for new FK values if provided
  IF p_uus_lahtelennujaam_kood IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennujaam lj WHERE lj.lennujaam_kood = p_uus_lahtelennujaam_kood) FOR UPDATE THEN RAISE EXCEPTION 'OP14 Error: New departure airport % not found.', p_uus_lahtelennujaam_kood; END IF;
  IF p_uus_sihtlennujaam_kood IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennujaam lj WHERE lj.lennujaam_kood = p_uus_sihtlennujaam_kood) FOR UPDATE THEN RAISE EXCEPTION 'OP14 Error: New destination airport % not found.', p_uus_sihtlennujaam_kood; END IF;
  IF p_uus_lennukituup_kood IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennukituup lt WHERE lt.lennukituup_kood = p_uus_lennukituup_kood) FOR UPDATE THEN RAISE EXCEPTION 'OP14 Error: New aircraft type % not found.', p_uus_lennukituup_kood; END IF;
  IF p_uus_lennuk_reg_nr IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennuk lk WHERE lk.registreerimisnumber = p_uus_lennuk_reg_nr) FOR UPDATE THEN RAISE EXCEPTION 'OP14 Error: New aircraft % not found.', p_uus_lennuk_reg_nr; END IF;

  -- Determine final values after potential update
  v_final_lahkumis_aeg := COALESCE(p_uus_lahkumis_aeg, v_lend.eeldatav_lahkumis_aeg);
  v_final_saabumis_aeg := COALESCE(p_uus_saabumis_aeg, v_lend.eeldatav_saabumis_aeg);
  v_final_lahke_kood := COALESCE(p_uus_lahtelennujaam_kood, v_lend.lahtelennujaam_kood);
  v_final_siht_kood := COALESCE(p_uus_sihtlennujaam_kood, v_lend.sihtlennujaam_kood);
  v_final_tuup_kood := COALESCE(p_uus_lennukituup_kood, v_lend.lennukituup_kood);
  v_final_reg_nr := COALESCE(p_uus_lennuk_reg_nr, v_lend.lennuk_reg_nr);

  -- Validate final state logic
  IF v_final_saabumis_aeg <= v_final_lahkumis_aeg THEN RAISE EXCEPTION 'OP14 Error: Final arrival time (%) must be later than final departure time (%).', v_final_saabumis_aeg, v_final_lahkumis_aeg; END IF;
  IF v_final_siht_kood = v_final_lahke_kood THEN RAISE EXCEPTION 'OP14 Error: Final departure and destination airport cannot be the same (%).', v_final_lahke_kood; END IF;
  IF v_final_tuup_kood IS NULL AND v_final_reg_nr IS NULL THEN RAISE EXCEPTION 'OP14 Error: Final state must have either aircraft type or specific aircraft assigned.'; END IF;

  -- Operational Status Checks for the final state
  PERFORM fn_check_airport_seisund(v_final_lahke_kood);
  PERFORM fn_check_airport_seisund(v_final_siht_kood);
  PERFORM fn_check_landing_ban(v_final_siht_kood, v_final_saabumis_aeg);
  IF v_final_reg_nr IS NOT NULL THEN
      PERFORM fn_check_aircraft_seisund(v_final_reg_nr);
  END IF;

  -- Final Airport Type Compatibility Checks
  IF v_final_tuup_kood IS NOT NULL THEN
    SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaama_vastuvoetavad_lennukituubid llvt WHERE llvt.lennujaam_kood = v_final_lahke_kood AND llvt.lennukituup_kood = v_final_tuup_kood FOR UPDATE) INTO v_aircraft_type_supported_departure;
    IF NOT v_aircraft_type_supported_departure THEN RAISE EXCEPTION 'OP14 Error: Final aircraft type % not supported at final departure airport %.', v_final_tuup_kood, v_final_lahke_kood; END IF;
    SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaama_vastuvoetavad_lennukituubid llvt WHERE llvt.lennujaam_kood = v_final_siht_kood AND llvt.lennukituup_kood = v_final_tuup_kood FOR UPDATE) INTO v_aircraft_type_supported_arrival;
    IF NOT v_aircraft_type_supported_arrival THEN RAISE EXCEPTION 'OP14 Error: Final aircraft type % not supported at final destination airport %.', v_final_tuup_kood, v_final_siht_kood; END IF;
  END IF;

  -- Perform the update
  UPDATE lend SET
    lahtelennujaam_kood = v_final_lahke_kood,
    sihtlennujaam_kood = v_final_siht_kood,
    eeldatav_lahkumis_aeg = v_final_lahkumis_aeg,
    eeldatav_saabumis_aeg = v_final_saabumis_aeg,
    lennukituup_kood = v_final_tuup_kood,
    lennuk_reg_nr = v_final_reg_nr,
    -- Recalculate distance if airports changed
    kaugus_linnulennult = CASE
                            WHEN p_uus_lahtelennujaam_kood IS NOT NULL OR p_uus_sihtlennujaam_kood IS NOT NULL
                            THEN fn_calculate_distance(v_final_lahke_kood, v_final_siht_kood)
                            ELSE v_lend.kaugus_linnulennult
                          END
  WHERE lend_kood = upper(p_lennu_kood) RETURNING * INTO v_rec;

  RETURN v_rec;
END; $$;
COMMENT ON FUNCTION fn_op14_muuda_lendu IS 'OP14: Updates selected flight data, validates inputs, checks final airport/aircraft status, landing bans, and recalculates distance if needed.';

-- OP18: Maara lennuk lennule
CREATE OR REPLACE FUNCTION lennufirma.fn_op18_maara_lennuk_lennule(p_lennu_kood VARCHAR(10), p_lennuk_reg_nr VARCHAR(10))
RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE
    v_lend_seisund VARCHAR(20); 
    v_lend_tuup_kood VARCHAR(20); 
    v_lend_lahkumis_aeg TIMESTAMP(0); 
    v_lend_saabumis_aeg TIMESTAMP(0);
    v_lennuk_seisund VARCHAR(20); 
    v_lennuk_tuup_kood VARCHAR(20); 
    v_is_conflicting BOOLEAN;
    v_lend_lahtelennujaam_kood VARCHAR(3); 
    v_lend_sihtlennujaam_kood VARCHAR(3);
    v_aircraft_type_supported_departure BOOLEAN; 
    v_aircraft_type_supported_arrival BOOLEAN;
    v_is_in_maintenance BOOLEAN;
    v_updated_rows INT;
BEGIN
    -- Fetch flight details
    SELECT l.seisund_kood, l.lennukituup_kood, l.eeldatav_lahkumis_aeg, l.eeldatav_saabumis_aeg, l.lahtelennujaam_kood, l.sihtlennujaam_kood
    INTO v_lend_seisund, v_lend_tuup_kood, v_lend_lahkumis_aeg, v_lend_saabumis_aeg, v_lend_lahtelennujaam_kood, v_lend_sihtlennujaam_kood
    FROM lend l WHERE l.lend_kood = upper(p_lennu_kood) FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'OP18 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;

    -- Fetch aircraft details
    SELECT lk.seisund_kood, lk.lennukituup_kood INTO v_lennuk_seisund, v_lennuk_tuup_kood
    FROM lennuk lk WHERE lk.registreerimisnumber = upper(p_lennuk_reg_nr) FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'OP18 Error: Aircraft with reg nr % not found.', upper(p_lennuk_reg_nr); END IF;

    -- Status Checks
    IF v_lend_seisund NOT IN ('PLANNED', 'DELAYED', 'CONFIRMED') THEN RAISE EXCEPTION 'OP18 Error: Aircraft cannot be assigned to flight % in status %.', upper(p_lennu_kood), v_lend_seisund; END IF;
    PERFORM fn_check_aircraft_seisund(upper(p_lennuk_reg_nr)); -- Checks if aircraft is ACTIVE

    -- Type Compatibility Checks
    IF v_lend_tuup_kood IS NOT NULL AND v_lennuk_tuup_kood <> v_lend_tuup_kood THEN RAISE EXCEPTION 'OP18 Error: Aircraft % type (%) does not match flight % required type (%).', upper(p_lennuk_reg_nr), v_lennuk_tuup_kood, upper(p_lennu_kood), v_lend_tuup_kood; END IF;

    -- Airport Compatibility Check
    SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaama_vastuvoetavad_lennukituubid llvt WHERE llvt.lennujaam_kood = v_lend_lahtelennujaam_kood AND llvt.lennukituup_kood = v_lennuk_tuup_kood FOR UPDATE) INTO v_aircraft_type_supported_departure;
    IF NOT v_aircraft_type_supported_departure THEN RAISE EXCEPTION 'OP18 Error: Assigned aircraft % type (%) not supported at departure airport %.', upper(p_lennuk_reg_nr), v_lennuk_tuup_kood, v_lend_lahtelennujaam_kood; END IF;
    SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaama_vastuvoetavad_lennukituubid llvt WHERE llvt.lennujaam_kood = v_lend_sihtlennujaam_kood AND llvt.lennukituup_kood = v_lennuk_tuup_kood FOR UPDATE) INTO v_aircraft_type_supported_arrival;
    IF NOT v_aircraft_type_supported_arrival THEN RAISE EXCEPTION 'OP18 Error: Assigned aircraft % type (%) not supported at destination airport %.', upper(p_lennuk_reg_nr), v_lennuk_tuup_kood, v_lend_sihtlennujaam_kood; END IF;

    -- Time Conflict Check (Other Flights)
    SELECT EXISTS (
        SELECT 1 FROM lend l_conflict
        WHERE l_conflict.lennuk_reg_nr = upper(p_lennuk_reg_nr)
        AND l_conflict.lend_kood <> upper(p_lennu_kood)
        AND l_conflict.seisund_kood NOT IN ('COMPLETED', 'CANCELED', 'LANDED', 'DEBOARDING')
        AND (l_conflict.eeldatav_lahkumis_aeg - INTERVAL '2 hour') < v_lend_saabumis_aeg
        AND (l_conflict.eeldatav_saabumis_aeg + INTERVAL '2 hour') > v_lend_lahkumis_aeg FOR UPDATE
    ) INTO v_is_conflicting;
    IF v_is_conflicting THEN RAISE EXCEPTION 'OP18 Error: Aircraft % is already assigned to another flight with overlapping times.', upper(p_lennuk_reg_nr); END IF;

    -- Maintenance Conflict Check
    SELECT EXISTS (
        SELECT 1 FROM lennufirma.hooldus h
        WHERE h.lennuk_reg_nr = upper(p_lennuk_reg_nr)
        AND h.seisund_kood <> 'CANCELED' -- Ignore canceled maintenance
        -- Check for overlap using standard operators
        AND h.alguse_aeg < v_lend_saabumis_aeg
        AND h.lopu_aeg > v_lend_lahkumis_aeg FOR UPDATE
    ) INTO v_is_in_maintenance;

    IF v_is_in_maintenance THEN
        RAISE EXCEPTION 'OP18 Error: Aircraft % is scheduled for maintenance during the flight time (% to %).', upper(p_lennuk_reg_nr), v_lend_lahkumis_aeg, v_lend_saabumis_aeg;
    END IF;

    -- Assign aircraft and update type if it was null
    UPDATE lend 
    SET lennuk_reg_nr = upper(p_lennuk_reg_nr), 
        lennukituup_kood = COALESCE(lennukituup_kood, v_lennuk_tuup_kood)
    WHERE lend_kood = upper(p_lennu_kood);
    
    GET DIAGNOSTICS v_updated_rows = ROW_COUNT;
    RETURN v_updated_rows > 0;
END; $$;
COMMENT ON FUNCTION fn_op18_maara_lennuk_lennule IS 'OP18: Assigns an active aircraft to a flight, checking status, type compatibility, airport support, and time conflicts. Returns TRUE if successful.';

-- OP16: Lisa tootaja lennule (Clarified status checks)
CREATE OR REPLACE FUNCTION fn_op16_lisa_tootaja_lennule(p_lennu_kood VARCHAR(10), p_tootaja_isik_id INT, p_rolli_kood VARCHAR(20))
RETURNS INT LANGUAGE plpgsql AS $$
DECLARE
  v_lend_seisund VARCHAR(20); v_lend_tuup_kood VARCHAR(20); v_lend_lahkumis_aeg TIMESTAMP(0); v_lend_saabumis_aeg TIMESTAMP(0);
  v_tootaja_seisund VARCHAR(20); -- Fetched employee status
  v_tootaja_lennus_id INT; v_litsents_olemas BOOLEAN := TRUE; v_is_conflicting BOOLEAN;
BEGIN
  -- Fetch flight details
  SELECT l.seisund_kood, l.lennukituup_kood, l.eeldatav_lahkumis_aeg, l.eeldatav_saabumis_aeg
  INTO v_lend_seisund, v_lend_tuup_kood, v_lend_lahkumis_aeg, v_lend_saabumis_aeg
  FROM lend l WHERE l.lend_kood = upper(p_lennu_kood) FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'OP16 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;

  -- Fetch employee status from tootaja table
  SELECT t.seisund_kood INTO v_tootaja_seisund FROM tootaja t WHERE t.isik_id = p_tootaja_isik_id FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'OP16 Error: Employee with ID % not found.', p_tootaja_isik_id; END IF;

  -- Check role existence
  IF NOT EXISTS (SELECT 1 FROM tootaja_roll tr WHERE tr.r_kood = p_rolli_kood FOR UPDATE) THEN RAISE EXCEPTION 'OP16 Error: Employee role with code % not found.', p_rolli_kood; END IF;

  -- Check flight status (must be plannable)
  IF v_lend_seisund NOT IN ('PLANNED', 'DELAYED') THEN RAISE EXCEPTION 'OP16 Error: Employee cannot be added to flight % in status %.', upper(p_lennu_kood), v_lend_seisund; END IF;

  -- *** Check Employee Status (using tootaja_seisund_liik implicitly via tootaja.seisund_kood) ***
  -- Requires the employee status to be 'WORKING'
  IF v_tootaja_seisund <> 'WORKING' THEN
      RAISE EXCEPTION 'OP16 Error: Employee % is not active (Status: %, required: WORKING).', p_tootaja_isik_id, v_tootaja_seisund;
  END IF;

  -- *** Check License for Pilots/Captains (using litsentsi_seisund_liik implicitly via litsents.seisund_kood) ***
  IF p_rolli_kood IN ('CAPTAIN', 'PILOT') THEN
    IF v_lend_tuup_kood IS NULL THEN RAISE EXCEPTION 'OP16 Error: Flight % has no assigned aircraft type, cannot add pilot/captain.', upper(p_lennu_kood); END IF;
    -- Requires a license for the correct type/role, with status 'VALID', and not expired
    SELECT EXISTS (
        SELECT 1 FROM litsents li
        WHERE li.tootaja_isik_id = p_tootaja_isik_id
          AND li.lennukituup_kood = v_lend_tuup_kood
          AND li.r_kood = p_rolli_kood
          AND li.seisund_kood = 'VALID' -- Check against 'VALID' status code
          AND li.kehtivuse_lopp >= v_lend_lahkumis_aeg FOR UPDATE -- Check expiration date
    ) INTO v_litsents_olemas;
    IF NOT v_litsents_olemas THEN
        RAISE EXCEPTION 'OP16 Error: Employee % lacks a license for role % and type % with status VALID, or it expires before departure (%).',
                       p_tootaja_isik_id, p_rolli_kood, v_lend_tuup_kood, v_lend_lahkumis_aeg;
    END IF;
  END IF;

  -- Check Time Conflicts (3-hour buffer)
SELECT EXISTS (
    SELECT 1
    FROM tootaja_lennus tl
    JOIN lend l_conflict ON tl.lend_kood = l_conflict.lend_kood -- Corrected JOIN condition to use kood
    WHERE
        -- Check for the specific employee
        tl.tootaja_isik_id = p_tootaja_isik_id
        -- Exclude the specific flight being assigned/modified
    AND l_conflict.lend_kood <> upper(p_lennu_kood) -- Assuming kood is the primary key for lend
        -- Exclude flights that are definitely finished or cancelled
    AND l_conflict.seisund_kood NOT IN ('COMPLETED', 'CANCELED', 'LANDED', 'DEBOARDING') -- Use your actual status codes
        -- Overlap check using standard operators:
    AND (l_conflict.eeldatav_lahkumis_aeg - INTERVAL '3 hour') < v_lend_saabumis_aeg -- Conflict starts before new one ends
    AND (l_conflict.eeldatav_saabumis_aeg + INTERVAL '3 hour') > v_lend_lahkumis_aeg FOR UPDATE -- Conflict ends after new one starts
)
INTO v_is_conflicting; -- Assign the boolean result to your variable
  IF v_is_conflicting THEN RAISE EXCEPTION 'OP16 Error: Employee % is already assigned to another flight with overlapping times.', p_tootaja_isik_id; END IF;

  -- Insert assignment
  INSERT INTO tootaja_lennus (lend_kood, tootaja_isik_id, r_kood)
  VALUES (upper(p_lennu_kood), p_tootaja_isik_id, p_rolli_kood)
  RETURNING tootaja_lennus_id INTO v_tootaja_lennus_id;

  RETURN v_tootaja_lennus_id;
END; $$;
COMMENT ON FUNCTION fn_op16_lisa_tootaja_lennule IS 'OP16: Adds an active employee (status WORKING) to a flight, checking role, required license (status VALID and not expired), and time conflicts.';

-- OP17: Eemalda tootaja lennult
CREATE OR REPLACE FUNCTION fn_op17_eemalda_tootaja_lennult(p_lennu_kood VARCHAR(10), p_tootaja_isik_id INT)
RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE v_lend_seisund VARCHAR(20); v_deleted_count INT;
BEGIN
  SELECT l.seisund_kood INTO v_lend_seisund FROM lend l WHERE l.lend_kood = upper(p_lennu_kood) FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'OP17 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;
  IF v_lend_seisund NOT IN ('PLANNED', 'DELAYED') THEN RAISE EXCEPTION 'OP17 Error: Employee cannot be removed from flight % in status %.', upper(p_lennu_kood), v_lend_seisund; END IF;
  DELETE FROM tootaja_lennus WHERE lend_kood = upper(p_lennu_kood) AND tootaja_isik_id = p_tootaja_isik_id;
  GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
  IF v_deleted_count = 0 THEN RAISE WARNING 'OP17 Warning: Employee % was not found on flight % or could not be removed.', p_tootaja_isik_id, upper(p_lennu_kood); RETURN FALSE; END IF;
  RETURN TRUE;
END; $$;
COMMENT ON FUNCTION fn_op17_eemalda_tootaja_lennult IS 'OP17: Removes an employee assignment from a flight if the flight status allows (PLANNED or DELAYED).';

-- ========================================================================== --
--                 BASIC CRUD & READ FUNCTIONS                              --
-- ========================================================================== --

-- Isik Create
CREATE OR REPLACE FUNCTION fn_isik_create(p_eesnimi VARCHAR, p_perenimi VARCHAR, p_email VARCHAR, p_isikunumber VARCHAR DEFAULT NULL, p_synni_kp DATE DEFAULT NULL, p_elukoht VARCHAR(100) DEFAULT NULL) RETURNS INT LANGUAGE plpgsql AS $$
DECLARE v_isik_id INT;
BEGIN
  INSERT INTO isik (eesnimi, perenimi, e_meil, isikunumber, synni_kp, elukoht)
  VALUES (p_eesnimi, p_perenimi, p_email, p_isikunumber, p_synni_kp, p_elukoht) RETURNING isik_id INTO v_isik_id;
  RETURN v_isik_id;
END; $$;
COMMENT ON FUNCTION lennufirma.fn_isik_create IS 'Creates a new person (isik) record and returns the generated isik_id.';

-- Tootaja Create
CREATE OR REPLACE FUNCTION fn_tootaja_create(p_isik_id INT, p_seisund VARCHAR(20)) RETURNS INT LANGUAGE plpgsql AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM isik WHERE isik_id = p_isik_id FOR UPDATE) THEN RAISE EXCEPTION 'Person with ID % not found.', p_isik_id; END IF;
  IF NOT EXISTS (SELECT 1 FROM tootaja_seisund_liik WHERE seisund_kood = p_seisund FOR UPDATE) THEN RAISE EXCEPTION 'Employee status % not found.', p_seisund; END IF;
  INSERT INTO tootaja (isik_id, seisund_kood) VALUES (p_isik_id, p_seisund);
  RETURN p_isik_id;
END; $$;
COMMENT ON FUNCTION lennufirma.fn_tootaja_create IS 'Creates a new employee (tootaja) record, linking to an existing person (isik) by isik_id, and returns the isik_id.';

-- Read functions
CREATE OR REPLACE FUNCTION lennufirma.fn_lennujaam_read_all()
RETURNS TABLE (lennujaam_kood VARCHAR, lj_nimetus VARCHAR, seisund_kood VARCHAR) AS $$
BEGIN RETURN QUERY SELECT lj.lennujaam_kood, lj.lj_nimetus, lj.seisund_kood FROM lennufirma.lennujaam lj WHERE lj.seisund_kood = 'OPEN' ORDER BY lj.lj_nimetus FOR UPDATE; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_lennujaam_read_all IS 'Returns all open airports for dropdown selection.';

CREATE OR REPLACE FUNCTION lennufirma.fn_lennukituup_read_all()
RETURNS TABLE (lennukituup_kood VARCHAR, lt_nimetus VARCHAR) AS $$
BEGIN RETURN QUERY SELECT lt.lennukituup_kood, lt.lt_nimetus FROM lennufirma.lennukituup lt ORDER BY lt.lt_nimetus FOR UPDATE; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_lennukituup_read_all IS 'Returns all aircraft types for dropdown selection.';

CREATE OR REPLACE FUNCTION lennufirma.fn_lennuk_read_all()
RETURNS TABLE (registreerimisnumber VARCHAR, lennukituup_kood VARCHAR, seisund_kood VARCHAR) AS $$
BEGIN RETURN QUERY SELECT lk.registreerimisnumber, lk.lennukituup_kood, lk.seisund_kood FROM lennufirma.lennuk lk WHERE lk.seisund_kood = 'ACTIVE' ORDER BY lk.registreerimisnumber FOR UPDATE; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_lennuk_read_all IS 'Returns all active aircraft for dropdown selection.';

CREATE OR REPLACE FUNCTION lennufirma.fn_tootaja_read_active()
RETURNS TABLE (isik_id INT, eesnimi VARCHAR, perenimi VARCHAR) AS $$
BEGIN RETURN QUERY SELECT i.isik_id, i.eesnimi, i.perenimi FROM lennufirma.isik i JOIN lennufirma.tootaja t ON i.isik_id = t.isik_id WHERE t.seisund_kood = 'WORKING' ORDER BY i.eesnimi, i.perenimi FOR UPDATE; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_tootaja_read_active IS 'Returns all active employees for dropdown selection.';

CREATE OR REPLACE FUNCTION lennufirma.fn_tootaja_roll_read_all()
RETURNS TABLE (r_kood VARCHAR, tr_nimetus VARCHAR) AS $$
BEGIN RETURN QUERY SELECT tr.r_kood, tr.tr_nimetus FROM lennufirma.tootaja_roll tr ORDER BY tr.tr_nimetus FOR UPDATE; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_tootaja_roll_read_all IS 'Returns all employee roles for dropdown selection.';

CREATE OR REPLACE FUNCTION lennufirma.fn_lend_read_all()
RETURNS TABLE (lend_kood VARCHAR, lahtelennujaam_kood VARCHAR, sihtlennujaam_kood VARCHAR, lennukituup_kood VARCHAR, lennuk_reg_nr VARCHAR, eeldatav_lahkumis_aeg TIMESTAMP(0), eeldatav_saabumis_aeg TIMESTAMP(0), tegelik_lahkumis_aeg TIMESTAMP(0), tegelik_saabumis_aeg TIMESTAMP(0), seisund_kood VARCHAR, kaugus_linnulennult DECIMAL, tuhistamise_pohjus VARCHAR(100)) AS $$
BEGIN RETURN QUERY SELECT l.lend_kood, l.lahtelennujaam_kood, l.sihtlennujaam_kood, l.lennukituup_kood, l.lennuk_reg_nr, l.eeldatav_lahkumis_aeg, l.eeldatav_saabumis_aeg, l.tegelik_lahkumis_aeg, l.tegelik_saabumis_aeg, l.seisund_kood, l.kaugus_linnulennult, l.tuhistamise_pohjus FROM lennufirma.lend l ORDER BY l.eeldatav_lahkumis_aeg DESC FOR UPDATE; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_lend_read_all IS 'Returns all flights for listing.';

CREATE OR REPLACE FUNCTION lennufirma.fn_lend_read_by_kood(p_kood VARCHAR)
RETURNS TABLE (lend_kood VARCHAR, lahtelennujaam_kood VARCHAR, sihtlennujaam_kood VARCHAR, lennukituup_kood VARCHAR, lennuk_reg_nr VARCHAR, eeldatav_lahkumis_aeg TIMESTAMP(0), eeldatav_saabumis_aeg TIMESTAMP(0), tegelik_lahkumis_aeg TIMESTAMP(0), tegelik_saabumis_aeg TIMESTAMP(0), seisund_kood VARCHAR, kaugus_linnulennult DECIMAL, tuhistamise_pohjus VARCHAR(100)) AS $$
BEGIN RETURN QUERY SELECT l.lend_kood, l.lahtelennujaam_kood, l.sihtlennujaam_kood, l.lennukituup_kood, l.lennuk_reg_nr, l.eeldatav_lahkumis_aeg, l.eeldatav_saabumis_aeg, l.tegelik_lahkumis_aeg, l.tegelik_saabumis_aeg, l.seisund_kood, l.kaugus_linnulennult, l.tuhistamise_pohjus FROM lennufirma.lend l WHERE l.lend_kood = upper(p_kood) FOR UPDATE; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_lend_read_by_kood IS 'Returns details of a specific flight by its code.';

CREATE OR REPLACE FUNCTION lennufirma.fn_lend_read_tootajad(p_lennu_kood VARCHAR)
RETURNS TABLE (tootaja_lennus_id INT, tootaja_isik_id INT, eesnimi VARCHAR, perenimi VARCHAR, r_kood VARCHAR, roll_nimetus VARCHAR) AS $$
BEGIN RETURN QUERY SELECT tl.tootaja_lennus_id, tl.tootaja_isik_id, i.eesnimi, i.perenimi, tl.r_kood, tr.nimetus AS roll_nimetus FROM lennufirma.tootaja_lennus tl JOIN lennufirma.tootaja t ON tl.tootaja_isik_id = t.isik_id JOIN lennufirma.isik i ON t.isik_id = i.isik_id JOIN lennufirma.tootaja_roll tr ON tl.r_kood = tr.r_kood WHERE tl.lend_kood = upper(p_lennu_kood) ORDER BY tr.nimetus, i.eesnimi, i.perenimi FOR UPDATE; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_lend_read_tootajad IS 'Returns all employees assigned to a specific flight with their roles.';

-- ========================================================================== --
--                                SAMPLE DATA                                 --
-- ========================================================================== --
-- Classifiers
INSERT INTO lennu_seisund_liik (seisund_kood, nimetus) VALUES
('PLANNED', 'Planned'), ('CONFIRMED', 'Confirmed'), ('DELAYED', 'Delayed'), ('BOARDING', 'Boarding'),
('GATEDEPARTED', 'Gate Departed'), ('INFLIGHT', 'In Flight'), ('LANDED', 'Landed'),
('DEBOARDING', 'Deboarding'), ('COMPLETED', 'Completed'), ('CANCELED', 'Canceled'),
('REDIRECTED', 'Redirected'), ('CRASHED', 'Crashed');

INSERT INTO lennujaama_seisund_liik (seisund_kood, nimetus) VALUES ('OPEN', 'Open'), ('CLOSED', 'Closed');
INSERT INTO lennuki_seisund_liik (seisund_kood, nimetus) VALUES ('ACTIVE', 'Active'), ('MAINTENANCE', 'Maintenance'), ('DECOMMISSIONED', 'Decommissioned');
INSERT INTO hoolduse_seisund_liik (seisund_kood, nimetus) VALUES ('PLANNED', 'Planned'), ('COMPLETED', 'Completed'), ('CANCELED', 'Canceled');
INSERT INTO tootaja_seisund_liik (seisund_kood, nimetus) VALUES ('WORKING', 'Working'), ('SUSPENDED', 'Suspended'), ('TERMINATED', 'Terminated');
INSERT INTO kliendi_seisund_liik (seisund_kood, nimetus) VALUES ('ACTIVE', 'Active'), ('BLACKLISTED', 'Blacklisted');
INSERT INTO litsentsi_seisund_liik (seisund_kood, nimetus) VALUES ('VALID', 'Valid'), ('EXPIRED', 'Expired'), ('SUSPENDED', 'Suspended');
INSERT INTO broneeringu_seisund_liik (seisund_kood, nimetus) VALUES ('ACTIVE', 'Active'), ('CANCELED', 'Canceled');

INSERT INTO tootaja_roll (r_kood, tr_nimetus, kirjeldus) VALUES
('MANAGER', 'Flight Manager', 'Responsible for flight planning and management'),
('CAPTAIN', 'Captain', 'Responsible pilot of the aircraft'),
('PILOT', 'Pilot', 'Second pilot / first officer'),
('CABIN_CREW', 'Cabin Crew', 'Cabin personnel');

-- Core Entities
INSERT INTO lennujaam (lennujaam_kood, lj_nimetus, koordinaadid_laius, koordinaadid_pikkus, seisund_kood) VALUES
('TLL', 'Tallinn Airport', 59.413333, 24.8325, 'OPEN'),
('HEL', 'Helsinki Vantaa Airport', 60.317222, 24.963333, 'OPEN'),
('ARN', 'Stockholm Arlanda Airport', 59.651944, 17.918611, 'OPEN');

INSERT INTO lennukituup (lennukituup_kood, lt_nimetus, maksimaalne_lennukaugus, maksimaalne_reisijate_arv, pardapersonali_arv, pilootide_arv) VALUES
('A320', 'Airbus A320', 6000, 180, 4, 2),
('B737', 'Boeing 737-800', 5500, 189, 4, 2);

INSERT INTO lennuk (registreerimisnumber, lennukituup_kood, seisund_kood) VALUES
('ES-ABC', 'A320', 'ACTIVE'),
('ES-DEF', 'B737', 'ACTIVE'),
('ES-GHI', 'A320', 'MAINTENANCE');

-- Sample Employees and related data
DO $$
DECLARE
  v_haldur_id INT;
  v_kapten_id INT;
  v_parda_id INT;
BEGIN
  v_haldur_id := fn_isik_create('Mart', 'Mets', 'manager@lennufirma.ee');
  PERFORM fn_tootaja_create(v_haldur_id, 'WORKING');
  INSERT INTO kasutaja_konto (isik_id, on_aktiivne, parool) VALUES (v_haldur_id, TRUE, 'password123');

  v_kapten_id := fn_isik_create('Kalle', 'Puu', 'captain@lennufirma.ee');
  PERFORM fn_tootaja_create(v_kapten_id, 'WORKING');

  v_parda_id := fn_isik_create('Pille', 'Meri', 'pille@lennufirma.ee');
  PERFORM fn_tootaja_create(v_parda_id, 'WORKING');

  INSERT INTO litsents (tootaja_isik_id, lennukituup_kood, r_kood, kehtivuse_algus, kehtivuse_lopp, seisund_kood)
  VALUES (v_kapten_id, 'A320', 'CAPTAIN', '2023-01-01', '2025-12-31', 'VALID'); -- Valid license
  INSERT INTO litsents (tootaja_isik_id, lennukituup_kood, r_kood, kehtivuse_algus, kehtivuse_lopp, seisund_kood)
  VALUES (v_haldur_id, 'B737', 'PILOT', '2022-01-01', '2023-12-31', 'EXPIRED'); -- Expired license
END $$;

-- Sample Clients
DO $$
DECLARE
    v_klient1_id INT;
    v_klient2_id INT;
BEGIN
    v_klient1_id := fn_isik_create('Mari', 'Maasikas', 'mari.maasikas@example.com', p_isikunumber => '49001011234', p_synni_kp => '1990-01-01');
    v_klient2_id := fn_isik_create('Jaan', 'Tamm', 'jaan.tamm@example.com', p_isikunumber => '38502022345', p_synni_kp => '1985-02-02');
    INSERT INTO klient (isik_id, seisund_kood) VALUES (v_klient1_id, 'ACTIVE');
    INSERT INTO klient (isik_id, seisund_kood) VALUES (v_klient2_id, 'ACTIVE');
END $$;

-- Airport Accepted Types
INSERT INTO lennujaama_vastuvoetavad_lennukituubid (lennujaam_kood, lennukituup_kood) VALUES
('TLL', 'A320'), ('TLL', 'B737'),
('HEL', 'A320'), ('HEL', 'B737'),
('ARN', 'A320'), ('ARN', 'B737');

-- Sample Landing Ban
INSERT INTO kuupaevade_vahemiku_maandumiskeeld (lennujaam_kood, keeld_alguse_aeg, keeld_lopu_aeg) VALUES
('HEL', '2025-05-29 18:30:00+00', '2025-05-29 19:30:00+00');

-- Sample Flights using OP1
-- Test LF101 registration (should fail due to landing ban)
DO $$ BEGIN
    BEGIN -- Nested BEGIN for exception handling
        PERFORM fn_op1_registreeri_lend('LF101', 'TLL', 'HEL', '2025-05-29 18:02:00+00', '2025-05-29 19:02:00+00', p_lennukituup_kood => 'A320', p_lennuk_reg_nr => 'ES-ABC');
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Caught expected exception for LF101 registration due to landing ban: %', SQLERRM;
        -- No ROLLBACK needed here, DO block handles transaction implicitly if error occurs
    END;
END $$;

-- Register LF101 with a time outside the ban (should succeed)
SELECT * FROM fn_op1_registreeri_lend('LF101', 'TLL', 'HEL', '2025-05-29 19:35:00+00', '2025-05-29 20:35:00+00', p_lennukituup_kood => 'A320', p_lennuk_reg_nr => 'ES-ABC');

-- Register LF202 (Should succeed)
SELECT * FROM fn_op1_registreeri_lend('LF202', 'TLL', 'ARN', '2025-05-30 18:02:00+00', '2025-05-30 19:32:00+00', p_lennukituup_kood => 'B737', p_lennuk_reg_nr => 'ES-DEF');

-- Test LF303 registration with maintenance aircraft (should fail)
DO $$ BEGIN
    BEGIN -- Nested BEGIN for exception handling
        PERFORM fn_op1_registreeri_lend('LF303', 'TLL', 'ARN', '2025-06-01 10:00:00+00', '2025-06-01 11:30:00+00', p_lennuk_reg_nr => 'ES-GHI');
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Caught expected exception for LF303 registration due to aircraft maintenance: %', SQLERRM;
    END;
END $$;

INSERT INTO hooldus (lennuk_reg_nr, alguse_aeg, lopu_aeg, seisund_kood, kirjeldus, lennujaam_kood) VALUES ('ES-GHI', '2025-06-01 08:00:00+00', '2025-06-01 09:30:00+00', 'PLANNED', 'Routine maintenance check', 'TLL');
-- Add employees to flight LF101
DO $$
DECLARE
  v_kapten_id INT;
  v_parda_id INT;
BEGIN
  SELECT isik_id INTO v_kapten_id FROM isik WHERE e_meil = 'captain@lennufirma.ee';
  SELECT isik_id INTO v_parda_id FROM isik WHERE e_meil = 'pille@lennufirma.ee';

  -- Add captain (should succeed, has valid A320 license)
  PERFORM fn_op16_lisa_tootaja_lennule('LF101', v_kapten_id, 'CAPTAIN');
  RAISE NOTICE 'Added Captain Kalle Puu to LF101.';

  -- Add cabin crew (should succeed)
  PERFORM fn_op16_lisa_tootaja_lennule('LF101', v_parda_id, 'CABIN_CREW');
  RAISE NOTICE 'Added Cabin Crew Pille Meri to LF101.';
END $$;

-- Test adding employee with expired license (should fail)
DO $$
DECLARE v_haldur_id INT;
BEGIN
    SELECT isik_id INTO v_haldur_id FROM isik WHERE e_meil = 'manager@lennufirma.ee';
    BEGIN -- Nested BEGIN for exception handling
        -- Attempt to add Mart Mets as pilot to LF202 (B737), his license is expired
        PERFORM fn_op16_lisa_tootaja_lennule('LF202', v_haldur_id, 'PILOT');
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Caught expected exception trying to add employee with expired license: %', SQLERRM;
    END;
END $$;

-- Sample Bookings (for flight LF101)
DO $$
DECLARE
    v_klient1_id INT;
    v_klient2_id INT;
BEGIN
    SELECT isik_id INTO v_klient1_id FROM isik WHERE e_meil = 'mari.maasikas@example.com';
    SELECT isik_id INTO v_klient2_id FROM isik WHERE e_meil = 'jaan.tamm@example.com';
    IF v_klient1_id IS NOT NULL THEN INSERT INTO broneering (lend_kood, klient_isik_id, seisund_kood, broneerimise_aeg, maksumus) VALUES ('LF101', v_klient1_id, 'ACTIVE', timezone('utc', now()) - INTERVAL '2 days', 100.75); ELSE RAISE WARNING 'Client 1 (Mari Maasikas) not found, booking skipped.'; END IF;
    IF v_klient2_id IS NOT NULL THEN INSERT INTO broneering (lend_kood, klient_isik_id, seisund_kood, broneerimise_aeg, maksumus) VALUES ('LF101', v_klient2_id, 'ACTIVE', timezone('utc', now()) - INTERVAL '1 day', 150.50); ELSE RAISE WARNING 'Client 2 (Jaan Tamm) not found, booking skipped.'; END IF;
END $$;

UPDATE lennu_seisund_liik SET kirjeldus = 'Lennu seisundi kirjeldus: ' || nimetus WHERE kirjeldus IS NULL;
UPDATE lennujaama_seisund_liik SET kirjeldus = 'Lennujaama seisundi kirjeldus: ' || nimetus WHERE kirjeldus IS NULL;
UPDATE lennuki_seisund_liik SET kirjeldus = 'Lennuki seisundi kirjeldus: ' || nimetus WHERE kirjeldus IS NULL;
UPDATE hoolduse_seisund_liik SET kirjeldus = 'Hoolduse seisundi kirjeldus: ' || nimetus WHERE kirjeldus IS NULL;
UPDATE tootaja_seisund_liik SET kirjeldus = 'Töötaja seisundi kirjeldus: ' || nimetus WHERE kirjeldus IS NULL;
UPDATE kliendi_seisund_liik SET kirjeldus = 'Kliendi seisundi kirjeldus: ' || nimetus WHERE kirjeldus IS NULL;
UPDATE litsentsi_seisund_liik SET kirjeldus = 'Litsentsi seisundi kirjeldus: ' || nimetus WHERE kirjeldus IS NULL;
UPDATE broneeringu_seisund_liik SET kirjeldus = 'Broneeringu seisundi kirjeldus: ' || nimetus WHERE kirjeldus IS NULL;
UPDATE tootaja_roll SET kirjeldus = 'Töötaja rolli kirjeldus: ' || r_kood WHERE kirjeldus IS NULL;
UPDATE isik SET elukoht = 'Kuke tänav 1, Tallinn' WHERE elukoht IS NULL;
UPDATE lend SET tegelik_lahkumis_aeg = timezone('utc', now()), tegelik_saabumis_aeg = (timezone('utc', now()) + '1 hour'::interval) WHERE lend_kood = 'LF101';
UPDATE lend set tuhistamise_pohjus = 'Technical issues' WHERE lend_kood = 'LF202';
-- ========================================================================== --
--                                End of Script                               --
-- ========================================================================== --