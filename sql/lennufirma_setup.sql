-- ========================================================================== --
--      SIMPLIFIED SCHEMA SETUP (Lennufirma Database) v2.4 - FIXED           --
-- ========================================================================== --
-- This script creates the schema, initializes sample data, and includes
-- essential flight operation functions and triggers.
-- Incorporates fixes based on the analysis report.
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
    kirjeldus TEXT,
    CONSTRAINT pk_lennu_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_lennu_seisund_liik_nimetus UNIQUE (nimetus),
    CONSTRAINT chk_lennu_seisund_liik_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennu_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennu_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$') -- Removed redundant IS NULL check
);
COMMENT ON TABLE lennu_seisund_liik IS 'Classifier for flight statuses (Planned, In Flight, Canceled, etc.).';

CREATE TABLE lennujaama_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus TEXT,
    CONSTRAINT pk_lennujaama_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_lennujaama_seisund_liik_nimetus UNIQUE (nimetus),
    CONSTRAINT chk_lennujaama_seisund_liik_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennujaama_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennujaama_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$') -- Removed redundant IS NULL check
);
COMMENT ON TABLE lennujaama_seisund_liik IS 'Classifier for airport statuses (Open, Closed).';

CREATE TABLE lennuki_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus TEXT,
    CONSTRAINT pk_lennuki_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_lennuki_seisund_liik_nimetus UNIQUE (nimetus),
    CONSTRAINT chk_lennuki_seisund_liik_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennuki_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennuki_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$') -- Removed redundant IS NULL check
);
COMMENT ON TABLE lennuki_seisund_liik IS 'Classifier for aircraft statuses (Active, Maintenance, etc.).';

CREATE TABLE hoolduse_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus TEXT,
    CONSTRAINT pk_hoolduse_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_hoolduse_seisund_liik_nimetus UNIQUE (nimetus),
    CONSTRAINT chk_hoolduse_seisund_liik_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_hoolduse_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_hoolduse_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$') -- Removed redundant IS NULL check
);
COMMENT ON TABLE hoolduse_seisund_liik IS 'Classifier for maintenance statuses (Planned, Completed, etc.).';

CREATE TABLE tootaja_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus TEXT,
    CONSTRAINT pk_tootaja_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_tootaja_seisund_liik_nimetus UNIQUE (nimetus),
    CONSTRAINT chk_tootaja_seisund_liik_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_tootaja_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_tootaja_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$') -- Removed redundant IS NULL check
);
COMMENT ON TABLE tootaja_seisund_liik IS 'Classifier for employee statuses (Working, Terminated, etc.).';

CREATE TABLE kliendi_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus TEXT,
    CONSTRAINT pk_kliendi_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_kliendi_seisund_liik_nimetus UNIQUE (nimetus),
    CONSTRAINT chk_kliendi_seisund_liik_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_kliendi_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_kliendi_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$') -- Removed redundant IS NULL check
);
COMMENT ON TABLE kliendi_seisund_liik IS 'Classifier for client statuses (Active, Blacklisted).';

CREATE TABLE litsentsi_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus TEXT,
    CONSTRAINT pk_litsentsi_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_litsentsi_seisund_liik_nimetus UNIQUE (nimetus),
    CONSTRAINT chk_litsentsi_seisund_liik_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_litsentsi_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_litsentsi_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$') -- Removed redundant IS NULL check
);
COMMENT ON TABLE litsentsi_seisund_liik IS 'Classifier for license statuses (Valid, Expired, etc.).';

CREATE TABLE broneeringu_seisund_liik (
    seisund_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus TEXT,
    CONSTRAINT pk_broneeringu_seisund_liik PRIMARY KEY (seisund_kood),
    CONSTRAINT uq_broneeringu_seisund_liik_nimetus UNIQUE (nimetus),
    CONSTRAINT chk_broneeringu_seisund_liik_kood_not_empty CHECK (seisund_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_broneeringu_seisund_liik_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_broneeringu_seisund_liik_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$') -- Removed redundant IS NULL check
);
COMMENT ON TABLE broneeringu_seisund_liik IS 'Classifier for booking statuses (Active, Canceled).';

CREATE TABLE tootaja_roll (
    roll_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    kirjeldus TEXT,
    CONSTRAINT pk_tootaja_roll PRIMARY KEY (roll_kood),
    CONSTRAINT uq_tootaja_roll_nimetus UNIQUE (nimetus),
    CONSTRAINT chk_tootaja_roll_kood_not_empty CHECK (roll_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_tootaja_roll_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_tootaja_roll_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$') -- Removed redundant IS NULL check
);
COMMENT ON TABLE tootaja_roll IS 'Classifier for employee roles (Captain, Cabin Crew, etc.).';

CREATE TABLE lennuki_tootja (
    tootja_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    CONSTRAINT pk_lennuki_tootja PRIMARY KEY (tootja_kood),
    CONSTRAINT uq_lennuki_tootja_nimetus UNIQUE (nimetus),
    CONSTRAINT chk_lennuki_tootja_kood_not_empty CHECK (tootja_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennuki_tootja_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$')
);
COMMENT ON TABLE lennuki_tootja IS 'Classifier for aircraft manufacturers (Airbus, Boeing).';

CREATE TABLE ajavoond (
    ajavoond_kood VARCHAR(50) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    CONSTRAINT pk_ajavoond PRIMARY KEY (ajavoond_kood),
    CONSTRAINT chk_ajavoond_kood_not_empty CHECK (ajavoond_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_ajavoond_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$')
);
COMMENT ON TABLE ajavoond IS 'Classifier for timezones.';

-- =========================================
-- Core Entity Tables
-- =========================================

CREATE TABLE lennujaam (
    lennujaam_kood VARCHAR(3) NOT NULL, -- IATA code
    nimi VARCHAR(100) NOT NULL,
    koordinaadid_laius DECIMAL(9, 6) NOT NULL,
    koordinaadid_pikkus DECIMAL(9, 6) NOT NULL,
    ajavoond_kood VARCHAR(50) NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    reg_aeg TIMESTAMPTZ(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0), -- Fixed precision
    viimase_muutm_aeg TIMESTAMPTZ(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0), -- Fixed precision
    CONSTRAINT pk_lennujaam PRIMARY KEY (lennujaam_kood),
    CONSTRAINT fk_lennujaam_ajavoond FOREIGN KEY (ajavoond_kood) REFERENCES ajavoond(ajavoond_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lennujaam_seisund FOREIGN KEY (seisund_kood) REFERENCES lennujaama_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_lennujaam_kood_format CHECK (lennujaam_kood ~ '^[A-Z]{3}$'),
    CONSTRAINT chk_lennujaam_kood_not_empty CHECK (lennujaam_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennujaam_nimi_not_empty CHECK (nimi !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennujaam_reg_aeg_range CHECK (reg_aeg >= '2000-01-01' AND reg_aeg < (CURRENT_TIMESTAMP(0)+'1 second'::interval)), -- Standardized check
    CONSTRAINT chk_lennujaam_aeg_order CHECK (viimase_muutm_aeg IS NULL OR (viimase_muutm_aeg >= reg_aeg AND viimase_muutm_aeg < (CURRENT_TIMESTAMP(0)+'1 second'::interval))) -- Standardized check
);
COMMENT ON TABLE lennujaam IS 'Represents an airport.';

CREATE TABLE lennukituup (
    lennukituup_kood VARCHAR(20) NOT NULL,
    nimetus VARCHAR(100) NOT NULL,
    lennuki_tootja_kood VARCHAR(20) NOT NULL,
    maksimaalne_lennukaugus DECIMAL(10, 2),
    maksimaalne_reisijate_arv INT,
    pardapersonali_arv INT,
    pilootide_arv INT,
    CONSTRAINT pk_lennukituup PRIMARY KEY (lennukituup_kood),
    CONSTRAINT fk_lennukituup_tootja FOREIGN KEY (lennuki_tootja_kood) REFERENCES lennuki_tootja(tootja_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_lennukituup_kood_not_empty CHECK (lennukituup_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennukituup_nimetus_not_empty CHECK (nimetus !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lennukituup_kaugus CHECK (maksimaalne_lennukaugus > 0),
    CONSTRAINT chk_lennukituup_max_reisijate_arv_positive CHECK (maksimaalne_reisijate_arv > 0), -- Renamed
    CONSTRAINT chk_lennukituup_pardapersonali_arv_positive CHECK (pardapersonali_arv > 0), -- Renamed
    CONSTRAINT chk_lennukituup_pilootide_arv_positive CHECK (pilootide_arv > 0) -- Renamed
);
COMMENT ON TABLE lennukituup IS 'Represents an aircraft type (e.g., A320, B737).';

CREATE TABLE lennuk (
    registreerimisnumber VARCHAR(10) NOT NULL,
    lennukituup_kood VARCHAR(20) NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    reg_aeg TIMESTAMPTZ(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0), -- Fixed precision
    viimase_muutm_aeg TIMESTAMPTZ(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0), -- Fixed precision
    CONSTRAINT pk_lennuk PRIMARY KEY (registreerimisnumber),
    CONSTRAINT fk_lennuk_lennukituup FOREIGN KEY (lennukituup_kood) REFERENCES lennukituup(lennukituup_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lennuk_seisund FOREIGN KEY (seisund_kood) REFERENCES lennuki_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_lennuk_registreerimisnumber_not_empty CHECK (registreerimisnumber !~ '^[[:space:]]*$'), -- Renamed
    CONSTRAINT chk_lennuk_reg_aeg_range CHECK (reg_aeg >= '2000-01-01' AND reg_aeg < (CURRENT_TIMESTAMP(0)+'1 second'::interval)), -- Standardized check
    CONSTRAINT chk_lennuk_aeg_order CHECK (viimase_muutm_aeg IS NULL OR viimase_muutm_aeg >= reg_aeg)
);
COMMENT ON TABLE lennuk IS 'Represents a specific aircraft instance.';

CREATE TABLE isik (
    isik_id SERIAL,
    isikukood VARCHAR(20) NULL,
    eesnimi VARCHAR(50),
    perenimi VARCHAR(50),
    synni_kp DATE NULL,
    elukoht TEXT NULL, -- Changed to TEXT
    e_meil VARCHAR(254) NOT NULL,
    reg_aeg TIMESTAMPTZ(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0), -- Fixed precision
    viimase_muutm_aeg TIMESTAMPTZ(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0), -- Fixed precision
    CONSTRAINT pk_isik PRIMARY KEY (isik_id),
    CONSTRAINT uq_isik_e_meil UNIQUE (e_meil),
    CONSTRAINT uq_isik_isikukood UNIQUE (isikukood),
    CONSTRAINT chk_isik_isikukood_not_empty CHECK (isikukood !~ '^[[:space:]]*$'), -- Removed redundant IS NULL check
    CONSTRAINT chk_isik_eesnimi_not_empty CHECK (eesnimi !~ '^[[:space:]]*$'),
    CONSTRAINT chk_isik_perenimi_not_empty CHECK (perenimi !~ '^[[:space:]]*$'),
    CONSTRAINT chk_isik_elukoht_not_empty CHECK (elukoht !~ '^[[:space:]]*$'), -- Removed redundant IS NULL check
    CONSTRAINT chk_isik_e_meil_not_empty CHECK (e_meil !~ '^[[:space:]]*$'), -- Renamed
    CONSTRAINT chk_isik_email_format CHECK (e_meil LIKE '_%@_%.__%'),
    CONSTRAINT chk_isik_synni_kp_range CHECK (synni_kp >= '1900-01-01' AND synni_kp < CURRENT_DATE), -- Removed redundant IS NULL check
    CONSTRAINT chk_isik_reg_aeg_range CHECK (reg_aeg >= '2000-01-01' AND reg_aeg < '2100-01-01'),
    CONSTRAINT chk_isik_aeg_order CHECK (viimase_muutm_aeg IS NULL OR (viimase_muutm_aeg >= reg_aeg AND viimase_muutm_aeg < (CURRENT_TIMESTAMP(0)+'1 second'::interval))), -- Standardized check
    CONSTRAINT chk_isik_eesnimi_or_perenimi_not_null CHECK (eesnimi IS NOT NULL OR perenimi IS NOT NULL), -- Renamed
    CONSTRAINT chk_isik_reg_aeg_after_synni_kp CHECK (synni_kp IS NULL OR reg_aeg::date > synni_kp) -- Added check
);
COMMENT ON TABLE isik IS 'Represents a person (can be employee or client).';

CREATE TABLE kuupaevade_vahemiku_maandumiskeeld (
    alguse_aeg TIMESTAMPTZ NOT NULL,
    lopu_aeg TIMESTAMPTZ NOT NULL,
    lennujaam_kood VARCHAR(3) NOT NULL,
    CONSTRAINT pk_kuupaevade_vahemiku_maandumiskeeld PRIMARY KEY (alguse_aeg, lopu_aeg, lennujaam_kood),
    CONSTRAINT fk_kuupaevade_vahemiku_maandumiskeeld_lennujaam FOREIGN KEY (lennujaam_kood) REFERENCES lennujaam(lennujaam_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_kvm_alguse_aeg_range CHECK (alguse_aeg >= '2000-01-01' AND alguse_aeg < '2100-01-01'), -- Added check
    CONSTRAINT chk_kvm_lopu_aeg_range CHECK (lopu_aeg >= '2000-01-01' AND lopu_aeg < '2100-01-01'), -- Added check
    CONSTRAINT chk_kvm_aeg_order CHECK (lopu_aeg > alguse_aeg) -- Added check
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
    kasutakonto_id SERIAL NOT NULL,
    on_aktiivne BOOLEAN NOT NULL DEFAULT TRUE,
    parool VARCHAR(255) NOT NULL,
    isik_id INT NOT NULL, -- Changed from SERIAL to INT NOT NULL
    CONSTRAINT pk_kasutaja_konto PRIMARY KEY (kasutakonto_id),
    CONSTRAINT fk_kasutaja_konto_isik FOREIGN KEY (isik_id) REFERENCES isik(isik_id) ON DELETE CASCADE, -- Removed ON UPDATE CASCADE
    CONSTRAINT unique_kasutaja_konto_isik_id UNIQUE(isik_id),
    CONSTRAINT chk_kasutaja_konto_parool_not_empty CHECK (parool !~ '^[[:space:]]*$') -- Added check
);
COMMENT ON TABLE kasutaja_konto IS 'Represents a user account in the system.';

CREATE TABLE tootaja (
    isik_id INT NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'WORKING',
    CONSTRAINT pk_tootaja PRIMARY KEY (isik_id),
    CONSTRAINT fk_tootaja_isik FOREIGN KEY (isik_id) REFERENCES isik(isik_id) ON DELETE CASCADE, -- Removed ON UPDATE CASCADE
    CONSTRAINT fk_tootaja_seisund FOREIGN KEY (seisund_kood) REFERENCES tootaja_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT
);
COMMENT ON TABLE tootaja IS 'Represents an employee, linked to an isik.';

CREATE TABLE klient (
    isik_id INT NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT pk_klient PRIMARY KEY (isik_id),
    CONSTRAINT fk_klient_isik FOREIGN KEY (isik_id) REFERENCES isik(isik_id) ON DELETE CASCADE, -- Removed ON UPDATE CASCADE
    CONSTRAINT fk_klient_seisund FOREIGN KEY (seisund_kood) REFERENCES kliendi_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT
);
COMMENT ON TABLE klient IS 'Represents a client/customer, linked to an isik.';

CREATE TABLE litsents (
    litsents_id SERIAL,
    tootaja_isik_id INT NOT NULL,
    lennukituup_kood VARCHAR(20) NOT NULL,
    roll_kood VARCHAR(20) NOT NULL,
    kehtivuse_algus TIMESTAMPTZ NOT NULL,
    kehtivuse_lopp TIMESTAMPTZ NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'VALID',
    CONSTRAINT pk_litsents PRIMARY KEY (litsents_id),
    CONSTRAINT fk_litsents_tootaja FOREIGN KEY (tootaja_isik_id) REFERENCES tootaja(isik_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_litsents_lennukituup FOREIGN KEY (lennukituup_kood) REFERENCES lennukituup(lennukituup_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_litsents_roll FOREIGN KEY (roll_kood) REFERENCES tootaja_roll(roll_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_litsents_seisund FOREIGN KEY (seisund_kood) REFERENCES litsentsi_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_litsents_tootaja_tuup_roll UNIQUE (tootaja_isik_id, lennukituup_kood, roll_kood),
    CONSTRAINT chk_litsents_aeg_order CHECK (kehtivuse_lopp > kehtivuse_algus),
    CONSTRAINT chk_litsents_algus_range CHECK (kehtivuse_algus >= '2000-01-01' AND kehtivuse_algus < (CURRENT_TIMESTAMP(0)+'5 years'::interval)), -- Standardized check
    CONSTRAINT chk_litsents_lopp_range CHECK (kehtivuse_lopp >= kehtivuse_algus AND kehtivuse_lopp < (kehtivuse_algus + '15 years'::interval))
);
COMMENT ON TABLE litsents IS 'Represents licenses held by employees for specific aircraft types and roles.';

CREATE TABLE lend (
    lend_kood VARCHAR(10) NOT NULL,
    lahtelennujaam_kood VARCHAR(3) NOT NULL,
    sihtlennujaam_kood VARCHAR(3) NOT NULL,
    lennukituup_kood VARCHAR(20) NULL,
    lennuk_reg_nr VARCHAR(10) NULL,
    eeldatav_lahkumis_aeg TIMESTAMPTZ NOT NULL,
    eeldatav_saabumis_aeg TIMESTAMPTZ NOT NULL,
    tegelik_lahkumis_aeg TIMESTAMPTZ,
    tegelik_saabumis_aeg TIMESTAMPTZ,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'PLANNED',
    kaugus_linnulennult DECIMAL(10, 2) NULL,
    tuhistamise_pohjus TEXT NULL, -- Changed to TEXT
    reg_aeg TIMESTAMPTZ(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0), -- Fixed precision
    viimase_muutm_aeg TIMESTAMPTZ(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0), -- Fixed precision
    CONSTRAINT pk_lend PRIMARY KEY (lend_kood),
    CONSTRAINT fk_lend_lahtelennujaam FOREIGN KEY (lahtelennujaam_kood) REFERENCES lennujaam(lennujaam_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lend_sihtlennujaam FOREIGN KEY (sihtlennujaam_kood) REFERENCES lennujaam(lennujaam_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lend_lennukituup FOREIGN KEY (lennukituup_kood) REFERENCES lennukituup(lennukituup_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lend_lennuk FOREIGN KEY (lennuk_reg_nr) REFERENCES lennuk(registreerimisnumber) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_lend_seisund FOREIGN KEY (seisund_kood) REFERENCES lennu_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_lend_kood_not_empty CHECK (lend_kood !~ '^[[:space:]]*$'),
    CONSTRAINT chk_lend_lennujaam_differ CHECK (sihtlennujaam_kood <> lahtelennujaam_kood),
    CONSTRAINT chk_lend_eeldatav_saabumine_after_lahkumine CHECK (eeldatav_saabumis_aeg > eeldatav_lahkumis_aeg), -- Renamed
    CONSTRAINT chk_lend_tegelik_aeg_order CHECK (tegelik_saabumis_aeg IS NULL OR tegelik_lahkumis_aeg IS NULL OR tegelik_saabumis_aeg > tegelik_lahkumis_aeg),
    CONSTRAINT chk_lend_lennuk_or CHECK ( (lennukituup_kood IS NOT NULL) OR (lennuk_reg_nr IS NOT NULL) ),
    CONSTRAINT chk_lend_tuhistamise_pohjus CHECK ( (seisund_kood <> 'CANCELED') OR (tuhistamise_pohjus IS NOT NULL AND tuhistamise_pohjus !~ '^[[:space:]]*$') ),
    CONSTRAINT chk_lend_reg_aeg_range CHECK (reg_aeg >= '2000-01-01' AND reg_aeg < (CURRENT_TIMESTAMP(0)+'1 second'::interval)), -- Standardized check
    CONSTRAINT chk_lend_aeg_order CHECK (viimase_muutm_aeg IS NULL OR viimase_muutm_aeg >= reg_aeg),
    CONSTRAINT chk_lend_eeldatav_lahkumine_range CHECK (eeldatav_lahkumis_aeg > reg_aeg AND eeldatav_lahkumis_aeg < (reg_aeg + '5 years'::interval)), -- Renamed
    CONSTRAINT chk_lend_eeldatav_saabumine_range CHECK (eeldatav_saabumis_aeg > eeldatav_lahkumis_aeg AND (eeldatav_saabumis_aeg - eeldatav_lahkumis_aeg <= '48 hours'::interval)), -- Renamed
    CONSTRAINT chk_lend_kaugus_linnulennult_range CHECK (kaugus_linnulennult > 0 AND kaugus_linnulennult <= 21000), -- Renamed
    CONSTRAINT chk_lend_tegelik_lahkumis_aeg_range CHECK (tegelik_lahkumis_aeg IS NULL OR (tegelik_lahkumis_aeg >= reg_aeg AND tegelik_lahkumis_aeg < (CURRENT_TIMESTAMP(0)+'1 second'::interval))), -- Standardized check
    CONSTRAINT chk_lend_tegelik_saabumis_aeg_range CHECK (tegelik_saabumis_aeg IS NULL OR (tegelik_saabumis_aeg >= tegelik_lahkumis_aeg AND tegelik_saabumis_aeg < (tegelik_lahkumis_aeg + '24 hours'::interval))),
    CONSTRAINT chk_lend_viimase_muutm_aeg_range CHECK (viimase_muutm_aeg IS NULL OR (viimase_muutm_aeg >= reg_aeg AND viimase_muutm_aeg < (CURRENT_TIMESTAMP(0)+'1 second'::interval))) -- Standardized check
);
COMMENT ON TABLE lend IS 'Represents a flight schedule.';

CREATE TABLE tootaja_lennus (
    tootaja_lennus_id SERIAL,
    lend_kood VARCHAR(10) NOT NULL,
    tootaja_isik_id INT NOT NULL,
    roll_kood VARCHAR(20) NOT NULL,
    CONSTRAINT pk_tootaja_lennus PRIMARY KEY (tootaja_lennus_id),
    CONSTRAINT fk_tootaja_lennus_lend FOREIGN KEY (lend_kood) REFERENCES lend(lend_kood) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_tootaja_lennus_tootaja FOREIGN KEY (tootaja_isik_id) REFERENCES tootaja(isik_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_tootaja_lennus_roll FOREIGN KEY (roll_kood) REFERENCES tootaja_roll(roll_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_tootaja_lennus_lend_tootaja UNIQUE (lend_kood, tootaja_isik_id)
);
COMMENT ON TABLE tootaja_lennus IS 'Associates employees with specific flights and their roles.';

CREATE TABLE hooldus (
    hooldus_id SERIAL,
    lennuk_reg_nr VARCHAR(10) NOT NULL,
    alguse_aeg TIMESTAMPTZ NOT NULL,
    lopu_aeg TIMESTAMPTZ NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'PLANNED',
    kirjeldus TEXT NULL, -- Changed to TEXT
    lennujaam_kood VARCHAR(3) NOT NULL,
    CONSTRAINT pk_hooldus PRIMARY KEY (hooldus_id),
    CONSTRAINT fk_hooldus_lennuk FOREIGN KEY (lennuk_reg_nr) REFERENCES lennuk(registreerimisnumber) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_hooldus_seisund FOREIGN KEY (seisund_kood) REFERENCES hoolduse_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_hooldus_lennujaam FOREIGN KEY (lennujaam_kood) REFERENCES lennujaam(lennujaam_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_hooldus_lennuk_alguse_aeg UNIQUE (lennuk_reg_nr, alguse_aeg), -- Renamed
    CONSTRAINT chk_hooldus_aeg_order CHECK (lopu_aeg > alguse_aeg),
    CONSTRAINT chk_hooldus_kirjeldus_not_empty CHECK (kirjeldus !~ '^[[:space:]]*$'), -- Removed redundant IS NULL check
    CONSTRAINT chk_hooldus_algus_range CHECK (alguse_aeg >= '2000-01-01' AND alguse_aeg < (CURRENT_TIMESTAMP(0)+'5 years'::interval)), -- Standardized check
    CONSTRAINT chk_hooldus_lopp_range CHECK (lopu_aeg >= alguse_aeg AND lopu_aeg < (alguse_aeg + '6 months'::interval)) -- Removed redundant IS NULL check
);
COMMENT ON TABLE hooldus IS 'Records maintenance activities for aircraft.';

CREATE TABLE broneering (
    broneering_id SERIAL,
    lend_kood VARCHAR(10) NOT NULL,
    klient_isik_id INT NOT NULL,
    seisund_kood VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    broneerimise_aeg TIMESTAMPTZ(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0), -- Fixed precision
    viimase_muutm_aeg TIMESTAMPTZ(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0), -- Fixed precision
    maksumus DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_broneering PRIMARY KEY (broneering_id),
    CONSTRAINT fk_broneering_lend FOREIGN KEY (lend_kood) REFERENCES lend(lend_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_broneering_klient FOREIGN KEY (klient_isik_id) REFERENCES klient(isik_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_broneering_seisund FOREIGN KEY (seisund_kood) REFERENCES broneeringu_seisund_liik(seisund_kood) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_broneering_lend_klient UNIQUE (lend_kood, klient_isik_id),
    CONSTRAINT chk_broneering_broneerimise_aeg_range CHECK (broneerimise_aeg >= '2000-01-01' AND broneerimise_aeg < (CURRENT_TIMESTAMP(0)+'1 second'::interval)), -- Renamed & Standardized check
    CONSTRAINT chk_broneering_viimase_muutm_aeg_range CHECK (viimase_muutm_aeg IS NULL OR (viimase_muutm_aeg >= broneerimise_aeg AND viimase_muutm_aeg < (CURRENT_TIMESTAMP(0)+'1 second'::interval))), -- Standardized check
    CONSTRAINT chk_broneering_maksumus_non_negative CHECK (maksumus >= 0) -- Added check
);
COMMENT ON TABLE broneering IS 'Represents a client booking on a specific flight.';

-- =========================================
-- Indexes (No changes needed based on fixes)
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
CREATE INDEX idx_lennujaam_nimi ON lennujaam(nimi);
CREATE INDEX idx_lennukituup_nimi ON lennukituup(nimetus);

-- ========================================================================== --
--                                HELPER FUNCTIONS & TRIGGERS                 --
-- ========================================================================== --

-- Updated trigger function for viimase_muutm_aeg
CREATE OR REPLACE FUNCTION lennufirma.fn_update_viimase_muutm_aeg()
RETURNS TRIGGER AS $$
BEGIN
  -- Always update viimase_muutm_aeg on INSERT or UPDATE to current time with precision 0
  NEW.viimase_muutm_aeg = CURRENT_TIMESTAMP(0);
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

-- Trigger function for flight capacity check (No changes needed)
CREATE OR REPLACE FUNCTION check_flight_capacity() RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM broneering
        WHERE lend_kood = NEW.lend_kood AND seisund_kood = 'ACTIVE') >
       (SELECT lt.maksimaalne_reisijate_arv
        FROM lend l
        JOIN lennukituup lt ON l.lennukituup_kood = lt.lennukituup_kood -- Assumes type is set
        WHERE l.lend_kood = NEW.lend_kood)
    THEN
        RAISE EXCEPTION 'Flight capacity exceeded for flight %', NEW.lend_kood;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_flight_capacity
BEFORE INSERT OR UPDATE ON broneering
FOR EACH ROW EXECUTE FUNCTION check_flight_capacity();

-- Trigger function for aircraft type max distance check (No changes needed)
CREATE OR REPLACE FUNCTION lennufirma.check_lennukituup_max_distance()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if lennukituup_kood is provided and kaugus_linnulennult is not null
    IF NEW.lennukituup_kood IS NOT NULL AND NEW.kaugus_linnulennult IS NOT NULL THEN
        -- Verify the flight distance doesn't exceed the aircraft type's maximum range
        IF NEW.kaugus_linnulennult > (
            SELECT maksimaalne_lennukaugus
            FROM lennufirma.lennukituup
            WHERE lennukituup_kood = NEW.lennukituup_kood
        ) THEN
            RAISE EXCEPTION 'Flight distance (%) exceeds the maximum range (%) of aircraft type %',
                NEW.kaugus_linnulennult,
                (SELECT maksimaalne_lennukaugus FROM lennufirma.lennukituup WHERE lennukituup_kood = NEW.lennukituup_kood),
                NEW.lennukituup_kood;
        END IF;
    END IF;

    -- Check if lennuk_reg_nr is provided and kaugus_linnulennult is not null
    IF NEW.lennuk_reg_nr IS NOT NULL AND NEW.kaugus_linnulennult IS NOT NULL THEN
        -- Verify the flight distance doesn't exceed the specific aircraft's type maximum range
        IF NEW.kaugus_linnulennult > (
            SELECT lt.maksimaalne_lennukaugus
            FROM lennufirma.lennuk l
            JOIN lennufirma.lennukituup lt ON l.lennukituup_kood = lt.lennukituup_kood
            WHERE l.registreerimisnumber = NEW.lennuk_reg_nr
        ) THEN
            RAISE EXCEPTION 'Flight distance (%) exceeds the maximum range (%) of aircraft with registration %',
                NEW.kaugus_linnulennult,
                (SELECT lt.maksimaalne_lennukaugus
                 FROM lennufirma.lennuk l
                 JOIN lennufirma.lennukituup lt ON l.lennukituup_kood = lt.lennukituup_kood
                 WHERE l.registreerimisnumber = NEW.lennuk_reg_nr),
                NEW.lennuk_reg_nr;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_lennukituup_max_distance
BEFORE INSERT OR UPDATE ON lennufirma.lend
FOR EACH ROW EXECUTE FUNCTION lennufirma.check_lennukituup_max_distance();

-- Trigger function for aircraft type match check (No changes needed)
CREATE OR REPLACE FUNCTION lennufirma.check_lennuk_type_match()
RETURNS TRIGGER AS $$
BEGIN
    -- If both aircraft and aircraft type are specified
    IF NEW.lennuk_reg_nr IS NOT NULL AND NEW.lennukituup_kood IS NOT NULL THEN
        -- Check if the aircraft's type matches the specified type
        IF NEW.lennukituup_kood <> (
            SELECT lennukituup_kood
            FROM lennufirma.lennuk
            WHERE registreerimisnumber = NEW.lennuk_reg_nr
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


-- ========================================================================== --
--                 FLIGHT OPERATION FUNCTIONS (OPx)                         --
-- ========================================================================== --

-- Function to calculate distance (No changes needed)
CREATE OR REPLACE FUNCTION lennufirma.fn_calculate_distance(
    p_lahtelennujaam_kood VARCHAR(3),
    p_sihtlennujaam_kood VARCHAR(3)
)
RETURNS DECIMAL(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    lat1 DECIMAL(9, 6);
    lon1 DECIMAL(9, 6);
    lat2 DECIMAL(9, 6);
    lon2 DECIMAL(9, 6);
    R INT := 6371; -- Earth's radius in kilometers
    dLat FLOAT;
    dLon FLOAT;
    a FLOAT;
    c FLOAT;
    d DECIMAL(10, 2);
BEGIN
    SELECT koordinaadid_laius, koordinaadid_pikkus INTO lat1, lon1 FROM lennufirma.lennujaam WHERE lennujaam_kood = p_lahtelennujaam_kood;
    SELECT koordinaadid_laius, koordinaadid_pikkus INTO lat2, lon2 FROM lennufirma.lennujaam WHERE lennujaam_kood = p_sihtlennujaam_kood;
    IF lat1 IS NULL OR lon1 IS NULL OR lat2 IS NULL OR lon2 IS NULL THEN RAISE EXCEPTION 'Coordinates not found for one or both airports (%, %).', p_lahtelennujaam_kood, p_sihtlennujaam_kood; END IF;
    dLat = radians(lat2 - lat1); dLon = radians(lon2 - lon1); lat1 = radians(lat1); lat2 = radians(lat2);
    a = sin(dLat / 2) * sin(dLat / 2) + sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    c = 2 * atan2(sqrt(a), sqrt(1 - a)); d = R * c;
    RETURN ROUND(d, 2);
END;
$$;
COMMENT ON FUNCTION lennufirma.fn_calculate_distance IS 'Calculates the great-circle distance between two airports using the Haversine formula.';

-- OP1: Registreeri lend (No changes needed)
CREATE OR REPLACE FUNCTION lennufirma.fn_op1_registreeri_lend(
  p_lennu_kood VARCHAR(10), p_lahtelennujaam_kood VARCHAR(3), p_sihtlennujaam_kood VARCHAR(3),
  p_eeldatav_lahkumis_aeg TIMESTAMPTZ, p_eeldatav_saabumis_aeg TIMESTAMPTZ,
  p_lennukituup_kood VARCHAR(20) DEFAULT NULL, p_lennuk_reg_nr VARCHAR(10) DEFAULT NULL
) RETURNS VARCHAR(10) LANGUAGE plpgsql AS $$
DECLARE
  v_created_kood VARCHAR(10); v_dep_airport_exists BOOLEAN; v_arr_airport_exists BOOLEAN;
  v_type_exists BOOLEAN; v_plane_exists BOOLEAN; v_calculated_distance DECIMAL(10, 2);
  v_actual_aircraft_type VARCHAR(20); v_aircraft_type_supported_departure BOOLEAN; v_aircraft_type_supported_arrival BOOLEAN;
BEGIN
  IF p_sihtlennujaam_kood = p_lahtelennujaam_kood THEN RAISE EXCEPTION 'OP1 Error: Departure and destination airport cannot be the same (%).', p_lahtelennujaam_kood; END IF;
  IF p_eeldatav_saabumis_aeg <= p_eeldatav_lahkumis_aeg THEN RAISE EXCEPTION 'OP1 Error: Expected arrival time (%) must be later than departure time (%).', p_eeldatav_saabumis_aeg, p_eeldatav_lahkumis_aeg; END IF;
  IF p_lennukituup_kood IS NULL AND p_lennuk_reg_nr IS NULL THEN RAISE EXCEPTION 'OP1 Error: Must specify either aircraft type or specific aircraft.'; END IF;
  SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaam lj WHERE lj.lennujaam_kood = p_lahtelennujaam_kood) INTO v_dep_airport_exists; IF NOT v_dep_airport_exists THEN RAISE EXCEPTION 'OP1 Error: Departure airport % not found.', p_lahtelennujaam_kood; END IF;
  SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaam lj WHERE lj.lennujaam_kood = p_sihtlennujaam_kood) INTO v_arr_airport_exists; IF NOT v_arr_airport_exists THEN RAISE EXCEPTION 'OP1 Error: Destination airport % not found.', p_sihtlennujaam_kood; END IF;
  IF p_lennukituup_kood IS NOT NULL THEN SELECT EXISTS (SELECT 1 FROM lennufirma.lennukituup lt WHERE lt.lennukituup_kood = p_lennukituup_kood) INTO v_type_exists; IF NOT v_type_exists THEN RAISE EXCEPTION 'OP1 Error: Aircraft type % not found.', p_lennukituup_kood; END IF; END IF;
  IF p_lennukituup_kood IS NOT NULL THEN
    SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaama_vastuvoetavad_lennukituubid llvt WHERE llvt.lennujaam_kood = p_lahtelennujaam_kood AND llvt.lennukituup_kood = p_lennukituup_kood) INTO v_aircraft_type_supported_departure; IF NOT v_aircraft_type_supported_departure THEN RAISE EXCEPTION 'OP1 Error: Aircraft type % not supported at departure airport %.', p_lennukituup_kood, p_lahtelennujaam_kood; END IF;
    SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaama_vastuvoetavad_lennukituubid llvt WHERE llvt.lennujaam_kood = p_sihtlennujaam_kood AND llvt.lennukituup_kood = p_lennukituup_kood) INTO v_aircraft_type_supported_arrival; IF NOT v_aircraft_type_supported_arrival THEN RAISE EXCEPTION 'OP1 Error: Aircraft type % not supported at destination airport %.', p_lennukituup_kood, p_sihtlennujaam_kood; END IF;
  END IF;
  IF p_lennuk_reg_nr IS NOT NULL THEN
     SELECT EXISTS (SELECT 1 FROM lennufirma.lennuk lk WHERE lk.registreerimisnumber = p_lennuk_reg_nr) INTO v_plane_exists; IF NOT v_plane_exists THEN RAISE EXCEPTION 'OP1 Error: Aircraft % not found.', p_lennuk_reg_nr; END IF;
     IF p_lennukituup_kood IS NOT NULL THEN SELECT lk.lennukituup_kood INTO v_actual_aircraft_type FROM lennufirma.lennuk lk WHERE lk.registreerimisnumber = upper(p_lennuk_reg_nr); IF v_actual_aircraft_type <> p_lennukituup_kood THEN RAISE EXCEPTION 'OP1 Error: Assigned aircraft % type (%) does not match flight required type (%).', upper(p_lennuk_reg_nr), v_actual_aircraft_type, p_lennukituup_kood; END IF; END IF;
  END IF;
  SELECT lennufirma.fn_calculate_distance(p_lahtelennujaam_kood, p_sihtlennujaam_kood) INTO v_calculated_distance;
  INSERT INTO lennufirma.lend (lend_kood, lahtelennujaam_kood, sihtlennujaam_kood, lennukituup_kood, lennuk_reg_nr, eeldatav_lahkumis_aeg, eeldatav_saabumis_aeg, seisund_kood, kaugus_linnulennult)
  VALUES (upper(p_lennu_kood), p_lahtelennujaam_kood, p_sihtlennujaam_kood, p_lennukituup_kood, p_lennuk_reg_nr, p_eeldatav_lahkumis_aeg, p_eeldatav_saabumis_aeg, 'PLANNED', v_calculated_distance)
  RETURNING lend_kood INTO v_created_kood;
  RETURN v_created_kood;
END;
$$;
COMMENT ON FUNCTION lennufirma.fn_op1_registreeri_lend IS 'OP1: Registers a new flight with status PLANNED, calculates and sets the great-circle distance. Validates inputs and foreign keys.';

-- OP3: Tuhista lend (No changes needed)
CREATE OR REPLACE FUNCTION fn_op3_tuhista_lend(p_lennu_kood VARCHAR(10), p_pohjus TEXT) -- Changed type to TEXT
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE v_current_seisund VARCHAR(20);
BEGIN
  SELECT l.seisund_kood INTO v_current_seisund FROM lend l WHERE l.lend_kood = upper(p_lennu_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'OP3 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;
  IF v_current_seisund NOT IN ('PLANNED', 'CONFIRMED', 'DELAYED', 'BOARDING', 'GATE DEPARTED') THEN RAISE EXCEPTION 'OP3 Error: Flight % cannot be canceled in status %.', upper(p_lennu_kood), v_current_seisund; END IF;
  IF p_pohjus IS NULL OR p_pohjus ~ '^[[:space:]]*$' THEN RAISE EXCEPTION 'OP3 Error: Cancellation reason is required and cannot be empty.'; END IF;
  UPDATE lend SET seisund_kood = 'CANCELED', tuhistamise_pohjus = p_pohjus WHERE lend_kood = upper(p_lennu_kood);
END; $$;
COMMENT ON FUNCTION fn_op3_tuhista_lend IS 'OP3: Changes flight status to CANCELED and records the mandatory reason.';

-- OP4: Maara hilinenuks (No changes needed)
CREATE OR REPLACE FUNCTION fn_op4_maara_hilinenuks(p_lennu_kood VARCHAR(10), p_uus_lahkumis_aeg TIMESTAMPTZ, p_uus_saabumis_aeg TIMESTAMPTZ)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE v_lend_seisund VARCHAR(20); v_original_lahkumis_aeg TIMESTAMPTZ;
BEGIN
  SELECT l.seisund_kood, l.eeldatav_lahkumis_aeg INTO v_lend_seisund, v_original_lahkumis_aeg FROM lend l WHERE l.lend_kood = upper(p_lennu_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'OP4 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;
  IF v_lend_seisund NOT IN ('PLANNED', 'CONFIRMED', 'DELAYED') THEN RAISE EXCEPTION 'OP4 Error: Flight % cannot be marked delayed in status %.', upper(p_lennu_kood), v_lend_seisund; END IF;
  IF p_uus_saabumis_aeg <= p_uus_lahkumis_aeg THEN RAISE EXCEPTION 'OP4 Error: New arrival time (%) must be later than new departure time (%).', p_uus_saabumis_aeg, p_uus_lahkumis_aeg; END IF;
  IF p_uus_lahkumis_aeg <= v_original_lahkumis_aeg THEN RAISE EXCEPTION 'OP4 Error: New departure time (%) must be later than the original departure time (%).', p_uus_lahkumis_aeg, v_original_lahkumis_aeg; END IF;
  UPDATE lend SET seisund_kood = 'DELAYED', eeldatav_lahkumis_aeg = p_uus_lahkumis_aeg, eeldatav_saabumis_aeg = p_uus_saabumis_aeg WHERE lend_kood = upper(p_lennu_kood);
END; $$;
COMMENT ON FUNCTION fn_op4_maara_hilinenuks IS 'OP4: Changes flight status to DELAYED and updates estimated departure/arrival times.';

-- OP13: Kustuta lend (No changes needed)
CREATE OR REPLACE FUNCTION fn_op13_kustuta_lend(p_lennu_kood VARCHAR(10))
RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE v_lend_seisund VARCHAR(20); v_has_bookings BOOLEAN; v_has_employees BOOLEAN; v_count INT;
BEGIN
  SELECT l.seisund_kood INTO v_lend_seisund FROM lend l WHERE l.lend_kood = upper(p_lennu_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'OP13 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;
  IF v_lend_seisund <> 'PLANNED' THEN RAISE EXCEPTION 'OP13 Error: Flight % cannot be deleted as it is not in PLANNED status (current: %).', upper(p_lennu_kood), v_lend_seisund; END IF;
  DELETE FROM lend WHERE lend_kood = upper(p_lennu_kood);
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count > 0;
END; $$;
COMMENT ON FUNCTION fn_op13_kustuta_lend IS 'OP13: Deletes a flight only if it is in PLANNED status and has no active bookings or assigned employees.';

-- OP14: Muuda lendu (No changes needed)
CREATE OR REPLACE FUNCTION fn_op14_muuda_lendu(
  p_lennu_kood VARCHAR(10), p_uus_lahkumis_aeg TIMESTAMPTZ DEFAULT NULL, p_uus_saabumis_aeg TIMESTAMPTZ DEFAULT NULL,
  p_uus_lennukituup_kood VARCHAR(20) DEFAULT NULL, p_uus_lennuk_reg_nr VARCHAR(10) DEFAULT NULL,
  p_uus_sihtlennujaam_kood VARCHAR(3) DEFAULT NULL, p_uus_lahtelennujaam_kood VARCHAR(3) DEFAULT NULL
) RETURNS lend LANGUAGE plpgsql AS $$
DECLARE v_lend lend%ROWTYPE; v_rec lend%ROWTYPE;
BEGIN
  SELECT l.* INTO v_lend FROM lend l WHERE l.lend_kood = upper(p_lennu_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'OP14 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;
  IF v_lend.seisund_kood NOT IN ('PLANNED', 'CONFIRMED', 'DELAYED') THEN RAISE EXCEPTION 'OP14 Error: Flight % data cannot be modified in status %.', upper(p_lennu_kood), v_lend.seisund_kood; END IF;
  IF p_uus_lahtelennujaam_kood IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennujaam lj WHERE lj.lennujaam_kood = p_uus_lahtelennujaam_kood) THEN RAISE EXCEPTION 'OP14 Error: New departure airport % not found.', p_uus_lahtelennujaam_kood; END IF;
  IF p_uus_sihtlennujaam_kood IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennujaam lj WHERE lj.lennujaam_kood = p_uus_sihtlennujaam_kood) THEN RAISE EXCEPTION 'OP14 Error: New destination airport % not found.', p_uus_sihtlennujaam_kood; END IF;
  IF p_uus_lennukituup_kood IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennukituup lt WHERE lt.lennukituup_kood = p_uus_lennukituup_kood) THEN RAISE EXCEPTION 'OP14 Error: New aircraft type % not found.', p_uus_lennukituup_kood; END IF;
  IF p_uus_lennuk_reg_nr IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lennuk lk WHERE lk.registreerimisnumber = p_uus_lennuk_reg_nr) THEN RAISE EXCEPTION 'OP14 Error: New aircraft % not found.', p_uus_lennuk_reg_nr; END IF;
  DECLARE
    v_final_lahkumis_aeg TIMESTAMPTZ := COALESCE(p_uus_lahkumis_aeg, v_lend.eeldatav_lahkumis_aeg); v_final_saabumis_aeg TIMESTAMPTZ := COALESCE(p_uus_saabumis_aeg, v_lend.eeldatav_saabumis_aeg);
    v_final_lahke_kood VARCHAR(3) := COALESCE(p_uus_lahtelennujaam_kood, v_lend.lahtelennujaam_kood); v_final_siht_kood VARCHAR(3) := COALESCE(p_uus_sihtlennujaam_kood, v_lend.sihtlennujaam_kood);
    v_final_tuup_kood VARCHAR(20) := COALESCE(p_uus_lennukituup_kood, v_lend.lennukituup_kood); v_final_reg_nr VARCHAR(10) := COALESCE(p_uus_lennuk_reg_nr, v_lend.lennuk_reg_nr);
    v_aircraft_type_supported_departure BOOLEAN; v_aircraft_type_supported_arrival BOOLEAN;
  BEGIN
    IF p_uus_lennukituup_kood IS NOT NULL THEN
      SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaama_vastuvoetavad_lennukituubid llvt WHERE llvt.lennujaam_kood = v_final_lahke_kood AND llvt.lennukituup_kood = v_final_tuup_kood) INTO v_aircraft_type_supported_departure; IF NOT v_aircraft_type_supported_departure THEN RAISE EXCEPTION 'OP14 Error: Aircraft type % not supported at departure airport %.', v_final_tuup_kood, v_final_lahke_kood; END IF;
      SELECT EXISTS (SELECT 1 FROM lennufirma.lennujaama_vastuvoetavad_lennukituubid llvt WHERE llvt.lennujaam_kood = v_final_siht_kood AND llvt.lennukituup_kood = v_final_tuup_kood) INTO v_aircraft_type_supported_arrival; IF NOT v_aircraft_type_supported_arrival THEN RAISE EXCEPTION 'OP14 Error: Aircraft type % not supported at destination airport %.', v_final_tuup_kood, v_final_siht_kood; END IF;
    END IF;
    IF v_final_saabumis_aeg <= v_final_lahkumis_aeg THEN RAISE EXCEPTION 'OP14 Error: Final arrival time (%) must be later than final departure time (%).', v_final_saabumis_aeg, v_final_lahkumis_aeg; END IF;
    IF v_final_siht_kood = v_final_lahke_kood THEN RAISE EXCEPTION 'OP14 Error: Final departure and destination airport cannot be the same (%).', v_final_lahke_kood; END IF;
    IF v_final_tuup_kood IS NULL AND v_final_reg_nr IS NULL THEN RAISE EXCEPTION 'OP14 Error: Final state must have either aircraft type or specific aircraft assigned.'; END IF;
    UPDATE lend SET lahtelennujaam_kood = v_final_lahke_kood, sihtlennujaam_kood = v_final_siht_kood, eeldatav_lahkumis_aeg = v_final_lahkumis_aeg, eeldatav_saabumis_aeg = v_final_saabumis_aeg, lennukituup_kood = v_final_tuup_kood, lennuk_reg_nr = v_final_reg_nr
    WHERE lend_kood = upper(p_lennu_kood) RETURNING * INTO v_rec;
    RETURN v_rec;
  END;
END; $$;
COMMENT ON FUNCTION fn_op14_muuda_lendu IS 'OP14: Updates selected flight data (times, airports, aircraft) with thorough validation.';

-- OP18: Maara lennuk lennule (No changes needed)
CREATE OR REPLACE FUNCTION fn_op18_maara_lennuk_lennule(p_lennu_kood VARCHAR(10), p_lennuk_reg_nr VARCHAR(10))
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
  v_lend_seisund VARCHAR(20); v_lend_tuup_kood VARCHAR(20); v_lend_lahkumis_aeg TIMESTAMPTZ; v_lend_saabumis_aeg TIMESTAMPTZ;
  v_lennuk_seisund VARCHAR(20); v_lennuk_tuup_kood VARCHAR(20); v_is_conflicting BOOLEAN;
BEGIN
  SELECT l.seisund_kood, l.lennukituup_kood, l.eeldatav_lahkumis_aeg, l.eeldatav_saabumis_aeg INTO v_lend_seisund, v_lend_tuup_kood, v_lend_lahkumis_aeg, v_lend_saabumis_aeg FROM lend l WHERE l.lend_kood = upper(p_lennu_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'OP18 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;
  SELECT lk.seisund_kood, lk.lennukituup_kood INTO v_lennuk_seisund, v_lennuk_tuup_kood FROM lennuk lk WHERE lk.registreerimisnumber = upper(p_lennuk_reg_nr);
  IF NOT FOUND THEN RAISE EXCEPTION 'OP18 Error: Aircraft with reg nr % not found.', upper(p_lennuk_reg_nr); END IF;
  IF v_lend_seisund NOT IN ('PLANNED', 'DELAYED') THEN RAISE EXCEPTION 'OP18 Error: Aircraft cannot be assigned to flight % in status %.', upper(p_lennu_kood), v_lend_seisund; END IF;
  IF v_lennuk_seisund <> 'ACTIVE' THEN RAISE EXCEPTION 'OP18 Error: Aircraft % is not active (status: %).', upper(p_lennuk_reg_nr), v_lennuk_seisund; END IF;
  IF v_lend_tuup_kood IS NOT NULL AND v_lennuk_tuup_kood <> v_lend_tuup_kood THEN RAISE EXCEPTION 'OP18 Error: Aircraft % type (%) does not match flight % required type (%).', upper(p_lennuk_reg_nr), v_lennuk_tuup_kood, upper(p_lennu_kood), v_lend_tuup_kood; END IF;
  SELECT EXISTS (SELECT 1 FROM lend l_conflict WHERE l_conflict.lennuk_reg_nr = upper(p_lennuk_reg_nr) AND l_conflict.lend_kood <> upper(p_lennu_kood) AND l_conflict.seisund_kood NOT IN ('COMPLETED', 'CANCELED', 'LANDED', 'DEBOARDING') AND TSTZRANGE(l_conflict.eeldatav_lahkumis_aeg - INTERVAL '2 hour', l_conflict.eeldatav_saabumis_aeg + INTERVAL '2 hour', '[]') && TSTZRANGE(v_lend_lahkumis_aeg, v_lend_saabumis_aeg, '[]')) INTO v_is_conflicting;
  IF v_is_conflicting THEN RAISE EXCEPTION 'OP18 Error: Aircraft % is already assigned to another flight with overlapping times.', upper(p_lennuk_reg_nr); END IF;
  UPDATE lend SET lennuk_reg_nr = upper(p_lennuk_reg_nr), lennukituup_kood = v_lennuk_tuup_kood WHERE lend_kood = upper(p_lennu_kood);
END; $$;
COMMENT ON FUNCTION fn_op18_maara_lennuk_lennule IS 'OP18: Assigns an active aircraft to a flight, checking type compatibility and time conflicts.';

-- OP16: Lisa tootaja lennule (No changes needed)
CREATE OR REPLACE FUNCTION fn_op16_lisa_tootaja_lennule(p_lennu_kood VARCHAR(10), p_tootaja_isik_id INT, p_rolli_kood VARCHAR(20))
RETURNS INT LANGUAGE plpgsql AS $$
DECLARE
  v_lend_seisund VARCHAR(20); v_lend_tuup_kood VARCHAR(20); v_lend_lahkumis_aeg TIMESTAMPTZ; v_lend_saabumis_aeg TIMESTAMPTZ;
  v_tootaja_seisund VARCHAR(20); v_tootaja_lennus_id INT; v_litsents_olemas BOOLEAN := TRUE; v_is_conflicting BOOLEAN;
BEGIN
  SELECT l.seisund_kood, l.lennukituup_kood, l.eeldatav_lahkumis_aeg, l.eeldatav_saabumis_aeg INTO v_lend_seisund, v_lend_tuup_kood, v_lend_lahkumis_aeg, v_lend_saabumis_aeg FROM lend l WHERE l.lend_kood = upper(p_lennu_kood);
  IF NOT FOUND THEN RAISE EXCEPTION 'OP16 Error: Flight with code % not found.', upper(p_lennu_kood); END IF;
  SELECT t.seisund_kood INTO v_tootaja_seisund FROM tootaja t WHERE t.isik_id = p_tootaja_isik_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'OP16 Error: Employee with ID % not found.', p_tootaja_isik_id; END IF;
  IF NOT EXISTS (SELECT 1 FROM tootaja_roll tr WHERE tr.roll_kood = p_rolli_kood) THEN RAISE EXCEPTION 'OP16 Error: Employee role with code % not found.', p_rolli_kood; END IF;
  IF v_lend_seisund NOT IN ('PLANNED', 'DELAYED') THEN RAISE EXCEPTION 'OP16 Error: Employee cannot be added to flight % in status %.', upper(p_lennu_kood), v_lend_seisund; END IF;
  IF v_tootaja_seisund <> 'WORKING' THEN RAISE EXCEPTION 'OP16 Error: Employee % is not active (status: %).', p_tootaja_isik_id, v_tootaja_seisund; END IF;
  IF p_rolli_kood IN ('CAPTAIN', 'PILOT') THEN
    IF v_lend_tuup_kood IS NULL THEN RAISE EXCEPTION 'OP16 Error: Flight % has no assigned aircraft type, cannot add pilot/captain.', upper(p_lennu_kood); END IF;
    SELECT EXISTS (SELECT 1 FROM litsents li WHERE li.tootaja_isik_id = p_tootaja_isik_id AND li.lennukituup_kood = v_lend_tuup_kood AND li.roll_kood = p_rolli_kood AND li.seisund_kood = 'VALID' AND li.kehtivuse_lopp >= v_lend_lahkumis_aeg) INTO v_litsents_olemas;
    IF NOT v_litsents_olemas THEN RAISE EXCEPTION 'OP16 Error: Employee % lacks a valid % license for aircraft type % for flight % at the time of departure.', p_tootaja_isik_id, p_rolli_kood, v_lend_tuup_kood, upper(p_lennu_kood); END IF;
  END IF;
  SELECT EXISTS (SELECT 1 FROM tootaja_lennus tl JOIN lend l_conflict ON tl.lend_kood = l_conflict.lend_kood WHERE tl.tootaja_isik_id = p_tootaja_isik_id AND l_conflict.lend_kood <> upper(p_lennu_kood) AND l_conflict.seisund_kood NOT IN ('COMPLETED', 'CANCELED', 'LANDED', 'DEBOARDING') AND TSTZRANGE(l_conflict.eeldatav_lahkumis_aeg - INTERVAL '3 hour', l_conflict.eeldatav_saabumis_aeg + INTERVAL '3 hour', '[]') && TSTZRANGE(v_lend_lahkumis_aeg, v_lend_saabumis_aeg, '[]')) INTO v_is_conflicting;
  IF v_is_conflicting THEN RAISE EXCEPTION 'OP16 Error: Employee % is already assigned to another flight with overlapping times.', p_tootaja_isik_id; END IF;
  INSERT INTO tootaja_lennus (lend_kood, tootaja_isik_id, roll_kood) VALUES (upper(p_lennu_kood), p_tootaja_isik_id, p_rolli_kood) RETURNING tootaja_lennus_id INTO v_tootaja_lennus_id;
  RETURN v_tootaja_lennus_id;
END; $$;
COMMENT ON FUNCTION fn_op16_lisa_tootaja_lennule IS 'OP16: Adds an active employee to a flight, checking role, required license validity, and time conflicts.';

-- OP17: Eemalda tootaja lennult (No changes needed)
CREATE OR REPLACE FUNCTION fn_op17_eemalda_tootaja_lennult(p_lennu_kood VARCHAR(10), p_tootaja_isik_id INT)
RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE v_lend_seisund VARCHAR(20); v_deleted_count INT;
BEGIN
  SELECT l.seisund_kood INTO v_lend_seisund FROM lend l WHERE l.lend_kood = upper(p_lennu_kood);
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

-- Isik Create (Needed for Sample Data) - Added comment
CREATE OR REPLACE FUNCTION fn_isik_create(p_eesnimi VARCHAR, p_perenimi VARCHAR, p_email VARCHAR, p_isikukood VARCHAR DEFAULT NULL, p_synni_kp DATE DEFAULT NULL, p_elukoht TEXT DEFAULT NULL) RETURNS INT LANGUAGE plpgsql AS $$
DECLARE v_isik_id INT;
BEGIN
  INSERT INTO isik (eesnimi, perenimi, e_meil, isikukood, synni_kp, elukoht)
  VALUES (p_eesnimi, p_perenimi, p_email, p_isikukood, p_synni_kp, p_elukoht) RETURNING isik_id INTO v_isik_id;
  RETURN v_isik_id;
END; $$;
COMMENT ON FUNCTION lennufirma.fn_isik_create(p_eesnimi character varying, p_perenimi character varying, p_email character varying, p_isikukood character varying, p_synni_kp date, p_elukoht text)
    IS 'Creates a new person (isik) record and returns the generated isik_id.';

-- Tootaja Create (Needed for Sample Data) - Added comment
CREATE OR REPLACE FUNCTION fn_tootaja_create(p_isik_id INT, p_seisund VARCHAR(20)) RETURNS INT LANGUAGE plpgsql AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM isik WHERE isik_id = p_isik_id) THEN RAISE EXCEPTION 'Person with ID % not found.', p_isik_id; END IF;
  IF NOT EXISTS (SELECT 1 FROM tootaja_seisund_liik WHERE seisund_kood = p_seisund) THEN RAISE EXCEPTION 'Employee status % not found.', p_seisund; END IF;
  INSERT INTO tootaja (isik_id, seisund_kood) VALUES (p_isik_id, p_seisund);
  RETURN p_isik_id;
END; $$;
COMMENT ON FUNCTION lennufirma.fn_tootaja_create(p_isik_id integer, p_seisund character varying)
    IS 'Creates a new employee (tootaja) record, linking to an existing person (isik) by isik_id, and returns the isik_id.';

-- Read functions (No changes needed)
CREATE OR REPLACE FUNCTION lennufirma.fn_lennujaam_read_all()
RETURNS TABLE (lennujaam_kood VARCHAR, nimi VARCHAR, seisund_kood VARCHAR) AS $$
BEGIN RETURN QUERY SELECT lj.lennujaam_kood, lj.nimi, lj.seisund_kood FROM lennufirma.lennujaam lj WHERE lj.seisund_kood = 'OPEN' ORDER BY lj.nimi; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_lennujaam_read_all IS 'Returns all open airports for dropdown selection.';

CREATE OR REPLACE FUNCTION lennufirma.fn_lennukituup_read_all()
RETURNS TABLE (lennukituup_kood VARCHAR, nimetus VARCHAR) AS $$
BEGIN RETURN QUERY SELECT lt.lennukituup_kood, lt.nimetus FROM lennufirma.lennukituup lt ORDER BY lt.nimetus; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_lennukituup_read_all IS 'Returns all aircraft types for dropdown selection.';

CREATE OR REPLACE FUNCTION lennufirma.fn_lennuk_read_all()
RETURNS TABLE (registreerimisnumber VARCHAR, lennukituup_kood VARCHAR, seisund_kood VARCHAR) AS $$
BEGIN RETURN QUERY SELECT lk.registreerimisnumber, lk.lennukituup_kood, lk.seisund_kood FROM lennufirma.lennuk lk WHERE lk.seisund_kood = 'ACTIVE' ORDER BY lk.registreerimisnumber; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_lennuk_read_all IS 'Returns all active aircraft for dropdown selection.';

CREATE OR REPLACE FUNCTION lennufirma.fn_tootaja_read_active()
RETURNS TABLE (isik_id INT, eesnimi VARCHAR, perenimi VARCHAR) AS $$
BEGIN RETURN QUERY SELECT i.isik_id, i.eesnimi, i.perenimi FROM lennufirma.isik i JOIN lennufirma.tootaja t ON i.isik_id = t.isik_id WHERE t.seisund_kood = 'WORKING' ORDER BY i.eesnimi, i.perenimi; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_tootaja_read_active IS 'Returns all active employees for dropdown selection.';

CREATE OR REPLACE FUNCTION lennufirma.fn_tootaja_roll_read_all()
RETURNS TABLE (roll_kood VARCHAR, nimetus VARCHAR) AS $$
BEGIN RETURN QUERY SELECT tr.roll_kood, tr.nimetus FROM lennufirma.tootaja_roll tr ORDER BY tr.nimetus; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_tootaja_roll_read_all IS 'Returns all employee roles for dropdown selection.';

CREATE OR REPLACE FUNCTION lennufirma.fn_lend_read_all()
RETURNS TABLE (lend_kood VARCHAR, lahtelennujaam_kood VARCHAR, sihtlennujaam_kood VARCHAR, lennukituup_kood VARCHAR, lennuk_reg_nr VARCHAR, eeldatav_lahkumis_aeg TIMESTAMPTZ, eeldatav_saabumis_aeg TIMESTAMPTZ, tegelik_lahkumis_aeg TIMESTAMPTZ, tegelik_saabumis_aeg TIMESTAMPTZ, seisund_kood VARCHAR, kaugus_linnulennult DECIMAL, tuhistamise_pohjus TEXT) AS $$
BEGIN RETURN QUERY SELECT l.lend_kood, l.lahtelennujaam_kood, l.sihtlennujaam_kood, l.lennukituup_kood, l.lennuk_reg_nr, l.eeldatav_lahkumis_aeg, l.eeldatav_saabumis_aeg, l.tegelik_lahkumis_aeg, l.tegelik_saabumis_aeg, l.seisund_kood, l.kaugus_linnulennult, l.tuhistamise_pohjus FROM lennufirma.lend l ORDER BY l.eeldatav_lahkumis_aeg DESC; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_lend_read_all IS 'Returns all flights for listing.';

CREATE OR REPLACE FUNCTION lennufirma.fn_lend_read_by_kood(p_kood VARCHAR)
RETURNS TABLE (lend_kood VARCHAR, lahtelennujaam_kood VARCHAR, sihtlennujaam_kood VARCHAR, lennukituup_kood VARCHAR, lennuk_reg_nr VARCHAR, eeldatav_lahkumis_aeg TIMESTAMPTZ, eeldatav_saabumis_aeg TIMESTAMPTZ, tegelik_lahkumis_aeg TIMESTAMPTZ, tegelik_saabumis_aeg TIMESTAMPTZ, seisund_kood VARCHAR, kaugus_linnulennult DECIMAL, tuhistamise_pohjus TEXT) AS $$
BEGIN RETURN QUERY SELECT l.lend_kood, l.lahtelennujaam_kood, l.sihtlennujaam_kood, l.lennukituup_kood, l.lennuk_reg_nr, l.eeldatav_lahkumis_aeg, l.eeldatav_saabumis_aeg, l.tegelik_lahkumis_aeg, l.tegelik_saabumis_aeg, l.seisund_kood, l.kaugus_linnulennult, l.tuhistamise_pohjus FROM lennufirma.lend l WHERE l.lend_kood = upper(p_kood); END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_lend_read_by_kood IS 'Returns details of a specific flight by its code.';

CREATE OR REPLACE FUNCTION lennufirma.fn_lend_read_tootajad(p_lennu_kood VARCHAR)
RETURNS TABLE (tootaja_lennus_id INT, tootaja_isik_id INT, eesnimi VARCHAR, perenimi VARCHAR, roll_kood VARCHAR, roll_nimetus VARCHAR) AS $$
BEGIN RETURN QUERY SELECT tl.tootaja_lennus_id, tl.tootaja_isik_id, i.eesnimi, i.perenimi, tl.roll_kood, tr.nimetus AS roll_nimetus FROM lennufirma.tootaja_lennus tl JOIN lennufirma.tootaja t ON tl.tootaja_isik_id = t.isik_id JOIN lennufirma.isik i ON t.isik_id = i.isik_id JOIN lennufirma.tootaja_roll tr ON tl.roll_kood = tr.roll_kood WHERE tl.lend_kood = upper(p_lennu_kood) ORDER BY tr.nimetus, i.eesnimi, i.perenimi; END; $$ LANGUAGE plpgsql;
COMMENT ON FUNCTION fn_lend_read_tootajad IS 'Returns all employees assigned to a specific flight with their roles.';

-- ========================================================================== --
--                                SAMPLE DATA                                 --
-- ========================================================================== --
-- Populates the database with initial data for testing and demonstration.
-- Uses direct INSERTs where possible, and functions where necessary.
-- ========================================================================== --

-- Classifiers
INSERT INTO lennu_seisund_liik (seisund_kood, nimetus) VALUES
('PLANNED', 'Planned'), ('CONFIRMED', 'Confirmed'), ('DELAYED', 'Delayed'), ('BOARDING', 'Boarding'),
('GATE DEPARTED', 'Gate Departed'), ('IN FLIGHT', 'In Flight'), ('LANDED', 'Landed'),
('DEBOARDING', 'Deboarding'), ('COMPLETED', 'Completed'), ('CANCELED', 'Canceled'),
('REDIRECTED', 'Redirected'), ('CRASHED', 'Crashed');

INSERT INTO lennujaama_seisund_liik (seisund_kood, nimetus) VALUES ('OPEN', 'Open'), ('CLOSED', 'Closed');
INSERT INTO lennuki_seisund_liik (seisund_kood, nimetus) VALUES ('ACTIVE', 'Active'), ('MAINTENANCE', 'Maintenance'), ('DECOMMISSIONED', 'Decommissioned');
INSERT INTO hoolduse_seisund_liik (seisund_kood, nimetus) VALUES ('PLANNED', 'Planned'), ('COMPLETED', 'Completed'), ('CANCELED', 'Canceled');
INSERT INTO tootaja_seisund_liik (seisund_kood, nimetus) VALUES ('WORKING', 'Working'), ('SUSPENDED', 'Suspended'), ('TERMINATED', 'Terminated');
INSERT INTO kliendi_seisund_liik (seisund_kood, nimetus) VALUES ('ACTIVE', 'Active'), ('BLACKLISTED', 'Blacklisted');
INSERT INTO litsentsi_seisund_liik (seisund_kood, nimetus) VALUES ('VALID', 'Valid'), ('EXPIRED', 'Expired'), ('SUSPENDED', 'Suspended');
INSERT INTO broneeringu_seisund_liik (seisund_kood, nimetus) VALUES ('ACTIVE', 'Active'), ('CANCELED', 'Canceled');

INSERT INTO tootaja_roll (roll_kood, nimetus, kirjeldus) VALUES
('MANAGER', 'Flight Manager', 'Responsible for flight planning and management'),
('CAPTAIN', 'Captain', 'Responsible pilot of the aircraft'),
('PILOT', 'Pilot', 'Second pilot / first officer'),
('CABIN_CREW', 'Cabin Crew', 'Cabin personnel');

INSERT INTO lennuki_tootja (tootja_kood, nimetus) VALUES ('AIRBUS', 'Airbus'), ('BOEING', 'Boeing');

INSERT INTO ajavoond (ajavoond_kood, nimetus) VALUES
('Europe/Tallinn', 'Eastern European Time'),
('Europe/Helsinki', 'Eastern European Time'),
('Europe/Stockholm', 'Central European Time');

-- Core Entities
INSERT INTO lennujaam (lennujaam_kood, nimi, koordinaadid_laius, koordinaadid_pikkus, ajavoond_kood, seisund_kood) VALUES
('TLL', 'Tallinn Airport', 59.413333, 24.8325, 'Europe/Tallinn', 'OPEN'),
('HEL', 'Helsinki Vantaa Airport', 60.317222, 24.963333, 'Europe/Helsinki', 'OPEN'),
('ARN', 'Stockholm Arlanda Airport', 59.651944, 17.918611, 'Europe/Stockholm', 'OPEN');

INSERT INTO lennukituup (lennukituup_kood, nimetus, lennuki_tootja_kood, maksimaalne_lennukaugus, maksimaalne_reisijate_arv, pardapersonali_arv, pilootide_arv) VALUES
('A320', 'Airbus A320', 'AIRBUS', 6000, 180, 4, 2),
('B737', 'Boeing 737-800', 'BOEING', 5500, 189, 4, 2);

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

  v_kapten_id := fn_isik_create('Kalle', 'Puu', 'captain@lennufirma.ee');
  PERFORM fn_tootaja_create(v_kapten_id, 'WORKING');

  v_parda_id := fn_isik_create('Pille', 'Meri', 'pille@lennufirma.ee');
  PERFORM fn_tootaja_create(v_parda_id, 'WORKING');

  INSERT INTO litsents (tootaja_isik_id, lennukituup_kood, roll_kood, kehtivuse_algus, kehtivuse_lopp, seisund_kood)
  VALUES (v_kapten_id, 'A320', 'CAPTAIN', '2023-01-01', '2025-12-31', 'VALID');
END $$;

-- Sample Clients
DO $$
DECLARE
    v_klient1_id INT;
    v_klient2_id INT;
BEGIN
    v_klient1_id := fn_isik_create('Mari', 'Maasikas', 'mari.maasikas@example.com', p_isikukood => '49001011234', p_synni_kp => '1990-01-01');
    v_klient2_id := fn_isik_create('Jaan', 'Tamm', 'jaan.tamm@example.com', p_isikukood => '38502022345', p_synni_kp => '1985-02-02');
    INSERT INTO klient (isik_id, seisund_kood) VALUES (v_klient1_id, 'ACTIVE');
    INSERT INTO klient (isik_id, seisund_kood) VALUES (v_klient2_id, 'ACTIVE');
END $$;

-- Airport Accepted Types
INSERT INTO lennujaama_vastuvoetavad_lennukituubid (lennujaam_kood, lennukituup_kood) VALUES
('TLL', 'A320'), ('TLL', 'B737'), ('HEL', 'A320'), ('ARN', 'B737');

-- Sample Flights using OP1
SELECT * FROM fn_op1_registreeri_lend('LF101', 'TLL', 'HEL', '2025-05-29 18:02:00', '2025-05-29 19:02:00', p_lennukituup_kood => 'A320', p_lennuk_reg_nr => 'ES-ABC');
SELECT * FROM fn_op1_registreeri_lend('LF202', 'TLL', 'ARN', '2025-05-30 18:02:00', '2025-05-30 19:32:00', p_lennukituup_kood => 'B737', p_lennuk_reg_nr => 'ES-DEF');

-- Sample Bookings (for flight LF101)
DO $$
DECLARE
    v_klient1_id INT;
    v_klient2_id INT;
BEGIN
    SELECT isik_id INTO v_klient1_id FROM isik WHERE e_meil = 'mari.maasikas@example.com';
    SELECT isik_id INTO v_klient2_id FROM isik WHERE e_meil = 'jaan.tamm@example.com';
    IF v_klient1_id IS NOT NULL THEN INSERT INTO broneering (lend_kood, klient_isik_id, seisund_kood, broneerimise_aeg, maksumus) VALUES ('LF101', v_klient1_id, 'ACTIVE', CURRENT_TIMESTAMP(0) - INTERVAL '2 days', 100.75); ELSE RAISE WARNING 'Client 1 (Mari Maasikas) not found, booking skipped.'; END IF;
    IF v_klient2_id IS NOT NULL THEN INSERT INTO broneering (lend_kood, klient_isik_id, seisund_kood, broneerimise_aeg, maksumus) VALUES ('LF101', v_klient2_id, 'ACTIVE', CURRENT_TIMESTAMP(0) - INTERVAL '1 day', 150.50); ELSE RAISE WARNING 'Client 2 (Jaan Tamm) not found, booking skipped.'; END IF;
END $$;

-- ========================================================================== --
--                                End of Script                               --
-- ========================================================================== --