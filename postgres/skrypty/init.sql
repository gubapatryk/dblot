CREATE DATABASE jednostka;

-- Użyj baze danych
\c jednostka;

CREATE SCHEMA raporty;


CREATE TABLE raporty.instytucje_szkoleniowe (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nazwa VARCHAR(100) NOT NULL,
    adres VARCHAR(100) NOT NULL
);

CREATE TABLE raporty.instytucje_medyczne (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nazwa VARCHAR(100) NOT NULL,
    adres VARCHAR(100) NOT NULL
);

CREATE TABLE raporty.kategoria_lotow (
    id VARCHAR(3) PRIMARY KEY,
    nazwa VARCHAR(60) NOT NULL
);

CREATE TABLE raporty.modele_maszyn (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nazwa VARCHAR(50) NOT NULL,
    predkosc_max INT NOT NULL
);

CREATE TABLE raporty.maszyny (
    rejestracja VARCHAR(6) PRIMARY KEY,
    id_modelu INT REFERENCES raporty.modele_maszyn(id) NOT NULL
);


CREATE TABLE raporty.zespoly (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nazwa VARCHAR(100)
);

CREATE TABLE raporty.pracownicy (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    zespol INT REFERENCES raporty.zespoly(id),
    imie VARCHAR(60) NOT NULL,
    nazwisko VARCHAR(60) NOT NULL,
    data_zatrudnienia DATE NOT NULL,
    data_zakonczenia DATE
);

CREATE INDEX idx_pracownicy_data_aktualizacji ON raporty.pracownicy (data_zatrudnienia);
CREATE INDEX idx_pracownicy_data_waznosci ON raporty.pracownicy (data_zakonczenia);


CREATE TABLE raporty.kierownicy (
    id_zespolu INT REFERENCES raporty.zespoly(id),
    id_pracownika INT REFERENCES raporty.pracownicy(id),
    rozpoczecie DATE NOT NULL,
    zakonczenie DATE
);





CREATE TABLE raporty.przeglady (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    rejestracja VARCHAR(6) REFERENCES raporty.maszyny(rejestracja) NOT NULL,
    data_aktualizacji DATE NOT NULL,
    data_waznosci DATE NOT NULL
);

CREATE INDEX idx_przeglady_data_aktualizacji ON raporty.przeglady (data_aktualizacji);
CREATE INDEX idx_przeglady_data_waznosci ON raporty.przeglady (data_waznosci);

CREATE TABLE raporty.szkolenia (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    id_instytucji INT REFERENCES raporty.instytucje_szkoleniowe(id) NOT NULL,
    id_pracownika INT REFERENCES raporty.pracownicy(id) NOT NULL,
    nazwa VARCHAR(100) NOT NULL,
    data_aktualizacji DATE NOT NULL,
    data_waznosci DATE NOT NULL
);

CREATE INDEX idx_szkolenia_data_aktualizacji ON raporty.szkolenia (data_aktualizacji);
CREATE INDEX idx_szkolenia_data_waznosci ON raporty.szkolenia (data_waznosci);

CREATE TABLE raporty.badania (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    id_instytucji INT REFERENCES raporty.instytucje_medyczne(id) NOT NULL,
    id_pracownika INT REFERENCES raporty.pracownicy(id) NOT NULL,
    data_aktualizacji DATE NOT NULL,
    data_waznosci DATE NOT NULL
);

CREATE INDEX idx_badania_data_aktualizacji ON raporty.badania (data_aktualizacji);
CREATE INDEX idx_badania_data_waznosci ON raporty.badania (data_waznosci);

CREATE TABLE raporty.lotniska (
    iata VARCHAR(3) PRIMARY KEY,
    szerokosc_geo FLOAT NOT NULL,
    dlugosc_geo FLOAT NOT NULL
);

    
CREATE TABLE raporty.hangary (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    lotnisko VARCHAR(3) REFERENCES raporty.lotniska(iata),
    pojemnosc INT NOT NULL
);


CREATE TABLE raporty.loty (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    pilot1 INT REFERENCES raporty.pracownicy(id) NOT NULL,
    pilot2 INT REFERENCES raporty.pracownicy(id),
    rejestracja VARCHAR(6) REFERENCES raporty.maszyny(rejestracja) NOT NULL,
    kategoria VARCHAR(3) REFERENCES raporty.kategoria_lotow(id) NOT NULL,
    lotnisko_wylotu VARCHAR(3) REFERENCES raporty.lotniska(iata) NOT NULL,
    lotnisko_przylotu VARCHAR(3) REFERENCES raporty.lotniska(iata) NOT NULL,
    godzina_wylotu TIMESTAMP NOT NULL,
    godzina_ladowania TIMESTAMP NOT NULL
);

CREATE INDEX idx_loty_godzina_wylotu ON raporty.loty (godzina_wylotu);
CREATE INDEX idx_loty_godzina_ladowania ON raporty.loty (godzina_ladowania);


-- tabela systemowa do przechowywania relacji między użytkownikiem bazy danych a id pracownika dla widoków
CREATE TABLE raporty.sys_user_prac (
    username VARCHAR(20) NOT NULL,
    id_prac INT NOT NULL
);

INSERT INTO raporty.sys_user_prac (username, id_prac)
VALUES
  ('maks', 2),
  ('remigiusz', 3),
  ('andrzej', 7);

CREATE ROLE dowodca;
GRANT ALL PRIVILEGES ON DATABASE jednostka TO dowodca;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA raporty TO dowodca;
GRANT USAGE on SCHEMA raporty TO dowodca;
GRANT USAGE on SCHEMA public TO dowodca;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE raporty.pracownicy TO dowodca;

CREATE USER andrzej WITH PASSWORD 'andrzej';
GRANT dowodca TO andrzej;


CREATE ROLE kierownik;
GRANT CONNECT ON DATABASE jednostka TO kierownik;
GRANT USAGE on SCHEMA raporty TO kierownik;
GRANT SELECT ON ALL TABLES IN SCHEMA raporty TO kierownik;
GRANT INSERT, UPDATE, DELETE ON TABLE raporty.loty TO kierownik;
GRANT INSERT, UPDATE, DELETE ON TABLE raporty.pracownicy TO kierownik;
GRANT INSERT, UPDATE, DELETE ON TABLE raporty.badania TO kierownik;
GRANT INSERT, UPDATE, DELETE ON TABLE raporty.szkolenia TO kierownik;
GRANT INSERT, UPDATE, DELETE ON TABLE raporty.instytucje_medyczne TO kierownik;
GRANT INSERT, UPDATE, DELETE ON TABLE raporty.instytucje_szkoleniowe TO kierownik;

CREATE USER remigiusz WITH PASSWORD 'remigiusz';
GRANT kierownik TO remigiusz;

CREATE ROLE pilot;
GRANT CONNECT ON DATABASE jednostka TO pilot;
GRANT USAGE on SCHEMA raporty TO pilot;
GRANT SELECT ON ALL TABLES IN SCHEMA raporty TO pilot;
GRANT INSERT, UPDATE, DELETE ON TABLE raporty.loty TO pilot;

CREATE USER maks WITH PASSWORD 'maks';
GRANT pilot TO maks;



COPY raporty.modele_maszyn FROM '/csv/modele_maszyn.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.instytucje_szkoleniowe FROM '/csv/instytucje_szkoleniowe.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.instytucje_medyczne FROM '/csv/instytucje_medyczne.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.kategoria_lotow FROM '/csv/kategoria_lotow.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.maszyny FROM '/csv/maszyny.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.zespoly FROM '/csv/zespoly.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.pracownicy FROM '/csv/pracownicy.csv'  WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.kierownicy FROM '/csv/kierownicy.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.przeglady FROM '/csv/przeglady.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.szkolenia FROM '/csv/szkolenia.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.badania FROM '/csv/badania.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.lotniska FROM '/csv/lotniska.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.hangary FROM '/csv/hangary.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
COPY raporty.loty FROM '/csv/loty.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);


--\COPY raporty.zespoly(nazwa) FROM '/csv/zespoly.csv' WITH (FORMAT CSV, DELIMITER ',', NULL 'null', HEADER);
--\COPY raporty.pracownicy(id,zespol,imie,nazwisko,data_zatrudnienia,data_zakonczenia) FROM '/csv/pracownicy.csv' WITH DELIMITER AS ',' NULL as 'null' CSV HEADER;

--\COPY raporty.modele_maszyn TO '/csv2/modele_maszyn.csv' WITH CSV HEADER;
--\COPY raporty.instytucje_szkoleniowe TO '/csv2/instytucje_szkoleniowe.csv' WITH CSV HEADER;
--\COPY raporty.instytucje_medyczne TO '/csv2/instytucje_medyczne.csv' WITH CSV HEADER;
--\COPY raporty.kategoria_lotow TO '/csv2/kategoria_lotow.csv' WITH CSV HEADER;
--\COPY raporty.maszyny TO '/csv2/maszyny.csv' WITH CSV HEADER;
--\COPY raporty.zespoly TO '/csv2/zespoly.csv' WITH (FORMAT CSV, DELIMITER ',', QUOTE '"', NULL 'null', HEADER);
--\COPY raporty.pracownicy TO '/csv2/pracownicy.csv' WITH CSV HEADER;
--\COPY raporty.kierownicy TO '/csv2/kierownicy.csv' WITH CSV HEADER;
--\COPY raporty.przeglady TO '/csv2/przeglady.csv' WITH CSV HEADER;
--\COPY raporty.szkolenia TO '/csv2/szkolenia.csv' WITH CSV HEADER;
--\COPY raporty.badania TO '/csv2/badania.csv' WITH CSV HEADER;
--\COPY raporty.lotniska TO '/csv2/lotniska.csv' WITH CSV HEADER;
--\COPY raporty.hangary TO '/csv2/hangary.csv' WITH CSV HEADER;
--\COPY raporty.loty TO '/csv2/loty.csv' WITH CSV HEADER;



CREATE VIEW raporty.waznosc_badan_lekarskich AS
SELECT
    p.id AS id_pracownika,
    p.imie,
    p.nazwisko,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM raporty.badania b
            WHERE p.id = b.id_pracownika
              AND b.data_waznosci >= CURRENT_DATE
        ) THEN 'tak'
        ELSE 'nie'
    END AS czy_badania_wazne
FROM
    raporty.pracownicy p
WHERE
    p.data_zakonczenia IS NULL;

GRANT SELECT ON raporty.waznosc_badan_lekarskich TO dowodca;


CREATE VIEW raporty.waznosc_szkolen AS
SELECT
    p.id AS id_pracownika,
    p.imie,
    p.nazwisko,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM raporty.badania b
            WHERE p.id = b.id_pracownika
              AND b.data_waznosci >= CURRENT_DATE
        ) THEN 'tak'
        ELSE 'nie'
    END AS czy_badania_wazne
FROM
    raporty.pracownicy p
WHERE
    p.data_zakonczenia IS NULL;

GRANT SELECT ON raporty.waznosc_szkolen TO dowodca;

CREATE VIEW raporty.waznosc_przegladow AS
SELECT
    m.rejestracja AS numer_rejestracyjny,
    CASE
        WHEN MAX(p.data_waznosci) >= CURRENT_DATE THEN 'Tak'
        ELSE 'Nie'
    END AS czy_wazne_przeglady
FROM
    raporty.maszyny m
LEFT JOIN
    raporty.przeglady p ON m.rejestracja = p.rejestracja
GROUP BY
    m.rejestracja
ORDER BY
    m.rejestracja;

GRANT SELECT ON raporty.waznosc_przegladow TO dowodca;

CREATE VIEW raporty.raport_miesieczny AS
SELECT
    p.id AS id_pilota,
    p.imie || ' ' || p.nazwisko AS pilot,
    COALESCE(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600,0) AS suma_czasu_lotu_godziny
FROM
    raporty.pracownicy p
LEFT JOIN
    raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
WHERE
    ((EXTRACT(MONTH FROM l.godzina_ladowania) = EXTRACT(MONTH FROM CURRENT_DATE) 
    AND  EXTRACT(YEAR FROM l.godzina_ladowania) = EXTRACT(YEAR FROM CURRENT_DATE)) OR l.godzina_ladowania IS NULL) 
    AND p.data_zakonczenia IS NULL
GROUP BY
    p.id, p.imie, p.nazwisko
ORDER BY
    suma_czasu_lotu_godziny DESC;

GRANT SELECT ON raporty.raport_miesieczny TO dowodca;
GRANT SELECT ON raporty.raport_miesieczny TO kierownik;
GRANT SELECT ON raporty.raport_miesieczny TO pilot;

CREATE VIEW raporty.raport_roczny AS
SELECT
    p.id AS id_pilota,
    p.imie || ' ' || p.nazwisko AS pilot,
    COALESCE(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600,0) AS suma_czasu_lotu_godziny
FROM
    raporty.pracownicy p
LEFT JOIN
    raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
WHERE
    (EXTRACT(YEAR FROM l.godzina_ladowania) = EXTRACT(YEAR FROM CURRENT_DATE) OR l.godzina_ladowania IS NULL) 
    AND p.data_zakonczenia IS NULL
GROUP BY
    p.id, p.imie, p.nazwisko
ORDER BY
    suma_czasu_lotu_godziny DESC;

GRANT SELECT ON raporty.raport_roczny TO dowodca;
GRANT SELECT ON raporty.raport_roczny TO kierownik;
GRANT SELECT ON raporty.raport_roczny TO pilot;


CREATE VIEW raporty.raport_miesieczny_zespol AS
SELECT
    p.id AS id_pilota,
    p.imie || ' ' || p.nazwisko AS pilot,
    COALESCE(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600,0) AS suma_czasu_lotu_godziny
FROM
    raporty.pracownicy p
LEFT JOIN
    raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
WHERE
    ((EXTRACT(MONTH FROM l.godzina_ladowania) = EXTRACT(MONTH FROM CURRENT_DATE) 
    AND  EXTRACT(YEAR FROM l.godzina_ladowania) = EXTRACT(YEAR FROM CURRENT_DATE)) OR l.godzina_ladowania IS NULL) 
    AND p.data_zakonczenia IS NULL
    AND p.zespol IN (SELECT zespol from raporty.pracownicy p
JOIN
    raporty.sys_user_prac s ON p.id = s.id_prac where s.username=current_user)
GROUP BY
    p.id, p.imie, p.nazwisko
ORDER BY
    suma_czasu_lotu_godziny DESC;

GRANT SELECT ON raporty.raport_miesieczny_zespol TO dowodca;
GRANT SELECT ON raporty.raport_miesieczny_zespol TO kierownik;
GRANT SELECT ON raporty.raport_miesieczny_zespol TO pilot;

CREATE VIEW raporty.raport_roczny_zespol AS
SELECT
    p.id AS id_pilota,
    p.imie || ' ' || p.nazwisko AS pilot,
    COALESCE(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600,0) AS suma_czasu_lotu_godziny
FROM
    raporty.pracownicy p
LEFT JOIN
    raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
WHERE
    (EXTRACT(YEAR FROM l.godzina_ladowania) = EXTRACT(YEAR FROM CURRENT_DATE) OR l.godzina_ladowania IS NULL) 
    AND p.data_zakonczenia IS NULL
    AND p.zespol IN (SELECT zespol from raporty.pracownicy p
JOIN
    raporty.sys_user_prac s ON p.id = s.id_prac where s.username=current_user)
GROUP BY
    p.id, p.imie, p.nazwisko
ORDER BY
    suma_czasu_lotu_godziny DESC;

GRANT SELECT ON raporty.raport_roczny_zespol TO dowodca;
GRANT SELECT ON raporty.raport_roczny_zespol TO kierownik;
GRANT SELECT ON raporty.raport_roczny_zespol TO pilot;



-- funkcje, kury, procedury 

SELECT setval(pg_get_serial_sequence('raporty.pracownicy', 'id'), coalesce(MAX(id), 1))
from raporty.pracownicy;

SELECT setval(pg_get_serial_sequence('raporty.szkolenia', 'id'), coalesce(MAX(id), 1))
from raporty.szkolenia;

SELECT setval(pg_get_serial_sequence('raporty.loty', 'id'), coalesce(MAX(id), 1))
from raporty.loty;

CREATE OR REPLACE PROCEDURE raporty.dodaj_pracownika(
    p_zespol INT,
    p_imie VARCHAR(60),
    p_nazwisko VARCHAR(60),
    p_data_zatrudnienia DATE
)
AS
$$
BEGIN
    INSERT INTO raporty.pracownicy (zespol, imie, nazwisko, data_zatrudnienia, data_zakonczenia)
    VALUES (p_zespol, p_imie, p_nazwisko, p_data_zatrudnienia, NULL);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE raporty.zwolnij_pracownika(
    p_id_pracownika INT,
    p_data_zakonczenia DATE
)
AS
$$
BEGIN
    UPDATE raporty.pracownicy
    SET data_zakonczenia = p_data_zakonczenia
    WHERE id = p_id_pracownika;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION raporty.szukaj_zespolow(p_nazwa_zespolu TEXT)
RETURNS TABLE (
    id int,
    nazwa VARCHAR(100)
)
AS
$$
BEGIN
    RETURN QUERY
    SELECT z.id, z.nazwa
    FROM raporty.zespoly z 
    WHERE z.nazwa ILIKE '%' || p_nazwa_zespolu || '%';
END;
$$
LANGUAGE plpgsql;


-- SELECT * FROM raporty.szukaj_zespoly('andrz');

CREATE OR REPLACE FUNCTION raporty.szukaj_pracownikow(p_nazwa_pracownika TEXT)
RETURNS TABLE (
    id INT,
    imie_nazwisko TEXT
)
AS
$$
BEGIN
    RETURN QUERY
    SELECT p.id, p.imie || ' ' || p.nazwisko AS imie_nazwisko
    FROM raporty.pracownicy p
    WHERE p.imie || ' ' || p.nazwisko ILIKE '%' || p_nazwa_pracownika || '%';
END;
$$
LANGUAGE plpgsql;

-- SELECT * FROM raporty.szukaj_pracownikow('kowal');

-- GRANT USAGE, CREATE ON SCHEMA raporty TO dowodca;

GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA raporty TO dowodca;


-- zlozona procedura

CREATE OR REPLACE PROCEDURE raporty.dodaj_lot_szkoleniowy(
    p_pilot1 INT,
    p_pilot2 INT,
    p_rejestracja VARCHAR(6),
    p_kategoria VARCHAR(3),
    p_lotnisko_wylotu VARCHAR(3),
    p_lotnisko_przylotu VARCHAR(3),
    p_godzina_wylotu TIMESTAMP,
    p_godzina_ladowania TIMESTAMP
)
AS
$$
DECLARE
    v_kierownik INT;
BEGIN
    -- Sprawdź, czy spośród pilotów znajduje się pilot będący kierownikiem
    -- Zalozenie systemowe - szkoleniowca podajemy jako pierwszego, a szkolonego jako drugiego pilota 
    SELECT id_pracownika INTO v_kierownik
    FROM raporty.kierownicy
    WHERE id_pracownika = p_pilot1
      AND rozpoczecie <= CURRENT_TIMESTAMP
      AND zakonczenie IS NULL;

    IF v_kierownik IS NULL THEN
        RAISE EXCEPTION 'Pierwszy pilot nie jest kierownikiem';
    END IF;

    -- Sprawdź, czy posiadają aktualne badania lekarskie
    IF NOT EXISTS (
        SELECT 1
        FROM raporty.badania
        WHERE id_pracownika IN (p_pilot1, p_pilot2)
          AND data_waznosci >= CURRENT_DATE
    ) THEN
        RAISE EXCEPTION 'Co najmniej jeden z pilotów nie ma aktualnych badań lekarskich';
    END IF;

    -- Sprawdź, czy w tym momencie nie uczestniczyli już w innym locie
    IF EXISTS (
        SELECT 1
        FROM raporty.loty
        WHERE (p_pilot1 IN (pilot1, pilot2) OR p_pilot2 IN (pilot1, pilot2))
          AND (p_godzina_wylotu, p_godzina_ladowania) OVERLAPS (godzina_wylotu, godzina_ladowania)
    ) THEN
        RAISE EXCEPTION 'Piloci o podanych numerach ID uczestniczą już w innym locie w tym czasie';
    END IF;

    -- Sprawdz, czy pojazd o podanej rejestracji nie byl juz w innym locie
    IF EXISTS (
        SELECT 1
        FROM raporty.loty
        WHERE rejestracja = p_rejestracja
          AND (p_godzina_wylotu, p_godzina_ladowania) OVERLAPS (godzina_wylotu, godzina_ladowania)
    ) THEN
        RAISE EXCEPTION 'Pojazd o podanej rejestracji uczestniczył już w innym locie w tym czasie';
    END IF;

    -- Dodaj rekord do tabeli raporty.szkolenia
    -- id_instytucji=1, bo szkolenie wewnetrzne (regula biznesowa)
    INSERT INTO raporty.szkolenia (id_instytucji, id_pracownika, nazwa, data_aktualizacji, data_waznosci)
    VALUES (1, p_pilot2, 'Lot szkoleniowy', p_godzina_wylotu, p_godzina_ladowania + INTERVAL '1 year');

    -- Dodaj rekord do tabeli raporty.loty
    INSERT INTO raporty.loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania)
    VALUES (p_pilot1, p_pilot2, p_rejestracja, p_kategoria, p_lotnisko_wylotu, p_lotnisko_przylotu, p_godzina_wylotu, p_godzina_ladowania);
END;
$$
LANGUAGE plpgsql;


/*
CALL raporty.dodaj_lot_szkoleniowy(
    p_pilot1 := 7,
    p_pilot2 := 8,
    p_rejestracja := 'SP-SRS',
    p_kategoria := 'IFR',
    p_lotnisko_wylotu := 'WAW',
    p_lotnisko_przylotu := 'KRK',
    p_godzina_wylotu := '2023-11-06T12:00:00',
    p_godzina_ladowania := '2023-11-06T14:00:00'
);
*/


-- generuj raport, ale dla podanego w parametrach miesiaca (nie obecnego miesiaca)

CREATE OR REPLACE FUNCTION raporty.generuj_raport_miesieczny_zespol(miesiac INTEGER, rok INTEGER)
RETURNS TABLE (
    id_pilota INTEGER,
    pilot TEXT,
    suma_czasu_lotu TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id AS id_pilota,
        p.imie || ' ' || p.nazwisko AS pilot,
        COALESCE(
            ROUND(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600) || ' godz ' || 
            ROUND(MOD(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))), 3600) / 60) || ' min'
        , '0 godz 0 min'
        ) AS suma_czasu_lotu
    FROM
        raporty.pracownicy p
    LEFT JOIN
        raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
            AND EXTRACT(MONTH FROM l.godzina_ladowania) = miesiac
            AND EXTRACT(YEAR FROM l.godzina_ladowania) = rok
    WHERE
        (l.godzina_ladowania IS NULL OR p.data_zakonczenia IS NULL)
        AND p.zespol IN (SELECT zespol FROM raporty.pracownicy p
                        JOIN raporty.sys_user_prac s ON p.id = s.id_prac
                        WHERE s.username = current_user)
    GROUP BY
        p.id
    ORDER BY
        pilot DESC;

    RETURN;
END;
$$ LANGUAGE plpgsql;


-- raport roczny dla zespolu z parametrem rok

CREATE OR REPLACE FUNCTION raporty.generuj_raport_roczny_zespol(rok INTEGER)
RETURNS TABLE (
    id_pilota INTEGER,
    pilot TEXT,
    suma_czasu_lotu TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id AS id_pilota,
        p.imie || ' ' || p.nazwisko AS pilot,
        COALESCE(
            ROUND(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600) || ' godz ' || 
            ROUND(MOD(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))), 3600) / 60) || ' min'
        , '0 godz 0 min'
        ) AS suma_czasu_lotu
    FROM
        raporty.pracownicy p
    LEFT JOIN
        raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
            AND EXTRACT(YEAR FROM l.godzina_ladowania) = rok
    WHERE
        (l.godzina_ladowania IS NULL OR p.data_zakonczenia IS NULL)
        AND p.zespol IN (SELECT zespol FROM raporty.pracownicy p
                        JOIN raporty.sys_user_prac s ON p.id = s.id_prac
                        WHERE s.username = current_user)
    GROUP BY
        p.id
    ORDER BY
        pilot DESC;

    RETURN;
END;
$$ LANGUAGE plpgsql;

-- raport miesieczny dla jednostki

CREATE OR REPLACE FUNCTION raporty.generuj_raport_miesieczny(miesiac INTEGER, rok INTEGER)
RETURNS TABLE (
    id_pilota INTEGER,
    pilot TEXT,
    suma_czasu_lotu TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id AS id_pilota,
        p.imie || ' ' || p.nazwisko AS pilot,
        COALESCE(
            ROUND(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600) || ' godz ' || 
            ROUND(MOD(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))), 3600) / 60) || ' min'
        , '0 godz 0 min'
        ) AS suma_czasu_lotu
    FROM
        raporty.pracownicy p
    LEFT JOIN
        raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
            AND EXTRACT(MONTH FROM l.godzina_ladowania) = miesiac
            AND EXTRACT(YEAR FROM l.godzina_ladowania) = rok
    WHERE
        (l.godzina_ladowania IS NULL OR p.data_zakonczenia IS NULL)
    GROUP BY
        p.id
    ORDER BY
        p.id ASC;

    RETURN;
END;
$$ LANGUAGE plpgsql;

-- raport roczny dla jednostki

CREATE OR REPLACE FUNCTION raporty.generuj_raport_roczny(rok INTEGER)
RETURNS TABLE (
    id_pilota INTEGER,
    pilot TEXT,
    suma_czasu_lotu TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id AS id_pilota,
        p.imie || ' ' || p.nazwisko AS pilot,
        COALESCE(
            ROUND(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600) || ' godz ' || 
            ROUND(MOD(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))), 3600) / 60) || ' min'
        , '0 godz 0 min'
        ) AS suma_czasu_lotu
    FROM
        raporty.pracownicy p
    LEFT JOIN
        raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
    WHERE
        (EXTRACT(YEAR FROM l.godzina_ladowania) = rok
        OR l.godzina_ladowania IS NULL) 
        AND p.data_zakonczenia IS NULL
    GROUP BY
        p.id, p.imie, p.nazwisko
    ORDER BY
        pilot DESC;

    RETURN;
END;
$$ LANGUAGE plpgsql;


/*
*/


-- wyzwalacze



-- Sprawdzanie limitu nalotu w tygodniu wyzwalaczem

CREATE OR REPLACE FUNCTION sprawdz_przekroczenie_nalotu()
RETURNS TRIGGER AS $$
DECLARE
    suma_czasu_lotu_pilota1 INT;
    suma_czasu_lotu_pilota2 INT;
BEGIN
    -- Obliczanie sumy czasu lotu dla pilota1
    SELECT COALESCE(SUM(EXTRACT(EPOCH FROM (godzina_ladowania - godzina_wylotu))) / 3600, 0)
    INTO suma_czasu_lotu_pilota1
    FROM raporty.loty l
    WHERE l.pilot1 = NEW.pilot1
      AND EXTRACT('week' FROM l.godzina_ladowania) = EXTRACT('week' FROM CURRENT_DATE) AND  EXTRACT(YEAR FROM l.godzina_ladowania) = EXTRACT(YEAR FROM CURRENT_DATE);

    -- Obliczanie sumy czasu lotu dla pilota2
    SELECT COALESCE(SUM(EXTRACT(EPOCH FROM (godzina_ladowania - godzina_wylotu))) / 3600, 0)
    INTO suma_czasu_lotu_pilota2
    FROM raporty.loty l
    WHERE (l.pilot2 IS NOT NULL AND (l.pilot2 = NEW.pilot1 OR l.pilot2 = NEW.pilot2))
      AND EXTRACT('week' FROM l.godzina_ladowania) = EXTRACT('week' FROM CURRENT_DATE) AND  EXTRACT(YEAR FROM l.godzina_ladowania) = EXTRACT(YEAR FROM CURRENT_DATE);

    -- Sprawdzanie czy suma czasu lotu przekracza 40 godzin
    IF suma_czasu_lotu_pilota1 > 40 THEN
        RAISE NOTICE 'Suma nalotu pilota 1 w tym tygodniu przekroczyła 40 godzin';
    ELSIF suma_czasu_lotu_pilota1 > 35 THEN
        RAISE NOTICE 'Suma nalotu pilota 1 w tym tygodniu przekroczyła 35 godzin';    
    END IF;

    IF suma_czasu_lotu_pilota2 > 40 THEN
        RAISE NOTICE 'Suma nalotu pilota 2 w tym tygodniu przekroczyła 40 godzin';
    ELSIF suma_czasu_lotu_pilota2 > 35 THEN
        RAISE NOTICE 'Suma nalotu pilota 2 w tym tygodniu przekroczyła 35 godzin';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Utwórz wyzwalacz, który będzie aktywowany po każdym wstawieniu do tabeli raporty.loty
CREATE TRIGGER sprawdz_przekroczenie_nalotu_trigger
AFTER INSERT ON raporty.loty
FOR EACH ROW
EXECUTE FUNCTION sprawdz_przekroczenie_nalotu();



CREATE OR REPLACE FUNCTION sprawdz_nakladanie_sie_lotow()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM raporty.loty l
        WHERE (NEW.pilot1 = l.pilot1 OR NEW.pilot1 = l.pilot2 OR NEW.pilot2 = l.pilot1 OR NEW.pilot2 = l.pilot2)
          AND (
            (NEW.godzina_wylotu >= l.godzina_wylotu AND NEW.godzina_wylotu < l.godzina_ladowania)
            OR (NEW.godzina_ladowania > l.godzina_wylotu AND NEW.godzina_ladowania <= l.godzina_ladowania)
            OR (NEW.godzina_wylotu <= l.godzina_wylotu AND NEW.godzina_ladowania >= l.godzina_ladowania)
        )
    ) THEN
        RAISE EXCEPTION 'Pilot lub maszyna już zajęta w tym czasie';
        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sprawdz_nakladanie_sie_lotow_trigger
BEFORE INSERT ON raporty.loty
FOR EACH ROW
EXECUTE FUNCTION sprawdz_nakladanie_sie_lotow();


/*
jednostka=> select * from raporty.loty order by id desc limit 5;
 id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu |   godzina_wylotu    |  godzina_ladowania  
----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------
 27 |      4 |        | SP-S24      | IFR       | EPB             | EPB               | 2023-10-26 09:30:00 | 2023-10-26 15:45:00
 26 |      3 |      5 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-26 07:15:00 | 2023-10-26 17:30:00
 25 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-25 07:15:00 | 2023-10-25 16:30:00
 24 |      3 |      4 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-24 07:15:00 | 2023-10-24 16:30:00
 23 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-23 07:15:00 | 2023-10-23 16:45:00
(5 rows)
INSERT INTO raporty.loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania)
VALUES
    (5,7, 'SP-SRS', 'IFR', 'WAW', 'KRK', '2023-11-01 12:00:00', '2023-11-05 15:00:00');

jednostka=> INSERT INTO raporty.loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania)
VALUES
    (5,8, 'SP-SRS', 'IFR', 'WAW', 'KRK', '2023-11-04 12:00:00', '2023-11-04 15:00:00');
INSERT 0 1

jednostka=> select * from raporty.loty order by id desc limit 5;
 id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu |   godzina_wylotu    |  godzina_ladowania  
----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------
 28 |      5 |      8 | SP-SRS      | IFR       | WAW             | KRK               | 2023-11-04 12:00:00 | 2023-11-04 15:00:00
 27 |      4 |        | SP-S24      | IFR       | EPB             | EPB               | 2023-10-26 09:30:00 | 2023-10-26 15:45:00
 26 |      3 |      5 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-26 07:15:00 | 2023-10-26 17:30:00
 25 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-25 07:15:00 | 2023-10-25 16:30:00
 24 |      3 |      4 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-24 07:15:00 | 2023-10-24 16:30:00
(5 rows)

jednostka=> INSERT INTO raporty.loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania)
VALUES
    (5,7, 'SP-SRS', 'IFR', 'WAW', 'KRK', '2023-11-01 12:00:00', '2023-11-05 15:00:00');
ERROR:  Pilot lub maszyna już zajęta w tym czasie
CONTEXT:  PL/pgSQL function sprawdz_nakladanie_sie_lotow() line 13 at RAISE
jednostka=> select * from raporty.loty order by id desc limit 5;
 id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu |   godzina_wylotu    |  godzina_ladowania  
----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------
 28 |      5 |      8 | SP-SRS      | IFR       | WAW             | KRK               | 2023-11-04 12:00:00 | 2023-11-04 15:00:00
 27 |      4 |        | SP-S24      | IFR       | EPB             | EPB               | 2023-10-26 09:30:00 | 2023-10-26 15:45:00
 26 |      3 |      5 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-26 07:15:00 | 2023-10-26 17:30:00
 25 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-25 07:15:00 | 2023-10-25 16:30:00
 24 |      3 |      4 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-24 07:15:00 | 2023-10-24 16:30:00
(5 rows)
*/

/*

jednostka=> select * from raporty.loty order by id desc limit 5;
 id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu |   godzina_wylotu    |  godzina_ladowania  
----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------
 27 |      4 |        | SP-S24      | IFR       | EPB             | EPB               | 2023-10-26 09:30:00 | 2023-10-26 15:45:00
 26 |      3 |      5 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-26 07:15:00 | 2023-10-26 17:30:00
 25 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-25 07:15:00 | 2023-10-25 16:30:00
 24 |      3 |      4 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-24 07:15:00 | 2023-10-24 16:30:00
 23 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-23 07:15:00 | 2023-10-23 16:45:00
(5 rows)


jednostka=> select raporty.generuj_raport_miesieczny_zespol(11,2023);
    generuj_raport_miesieczny_zespol    
----------------------------------------
 (8,"Patryk Guba","0 godz 0 min")
 (5,"Grzegorz Jaworski","0 godz 0 min")
 (7,"Andrzej Nowak","0 godz 0 min")

jednostka=> INSERT INTO raporty.loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania)
VALUES
    (5,8, 'SP-SRS', 'IFR', 'WAW', 'KRK', '2023-11-06 02:00:00', '2023-11-07 15:00:00');
NOTICE:  Suma nalotu pilota 1 w tym tygodniu przekroczyła 35 godzin
NOTICE:  Suma nalotu pilota 2 w tym tygodniu przekroczyła 35 godzin
INSERT 0 1


jednostka=> select * from raporty.loty order by id desc limit 5;
 id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu |   godzina_wylotu    |  godzina_ladowania  
----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------
 28 |      5 |      8 | SP-SRS      | IFR       | WAW             | KRK               | 2023-11-06 02:00:00 | 2023-11-07 15:00:00
 27 |      4 |        | SP-S24      | IFR       | EPB             | EPB               | 2023-10-26 09:30:00 | 2023-10-26 15:45:00
 26 |      3 |      5 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-26 07:15:00 | 2023-10-26 17:30:00
 25 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-25 07:15:00 | 2023-10-25 16:30:00
 24 |      3 |      4 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-24 07:15:00 | 2023-10-24 16:30:00
(5 rows)

jednostka=> INSERT INTO raporty.loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania)
VALUES
    (5,8, 'SP-SRS', 'IFR', 'WAW', 'KRK', '2023-11-08 12:00:00', '2023-11-08 18:00:00');
NOTICE:  Suma nalotu pilota 1 w tym tygodniu przekroczyła 40 godzin
NOTICE:  Suma nalotu pilota 2 w tym tygodniu przekroczyła 40 godzin
INSERT 0 1
jednostka=> INSERT INTO raporty.loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania)
VALUES
    (5,7, 'SP-SRS', 'IFR', 'WAW', 'KRK', '2023-11-09 12:00:00', '2023-11-09 18:00:00');
NOTICE:  Suma nalotu pilota 1 w tym tygodniu przekroczyła 40 godzin
INSERT 0 1

jednostka=> select * from raporty.loty order by id desc limit 5;
 id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu |   godzina_wylotu    |  godzina_ladowania  
----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------
 30 |      5 |      7 | SP-SRS      | IFR       | WAW             | KRK               | 2023-11-09 12:00:00 | 2023-11-09 18:00:00
 29 |      5 |      8 | SP-SRS      | IFR       | WAW             | KRK               | 2023-11-08 12:00:00 | 2023-11-08 18:00:00
 28 |      5 |      8 | SP-SRS      | IFR       | WAW             | KRK               | 2023-11-06 02:00:00 | 2023-11-07 15:00:00
 27 |      4 |        | SP-S24      | IFR       | EPB             | EPB               | 2023-10-26 09:30:00 | 2023-10-26 15:45:00
 26 |      3 |      5 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-26 07:15:00 | 2023-10-26 17:30:00
(5 rows)

*/

CREATE OR REPLACE PROCEDURE raporty.ustal_nowego_kierownika(
    p_id_pracownika INT,
    p_id_zespolu INT
)
AS $$
DECLARE
    v_data_aktualna DATE;
BEGIN
    -- Pobierz aktualną datę
    v_data_aktualna := CURRENT_DATE;

    -- Znajdź dotychczasowego kierownika
    UPDATE raporty.kierownicy
    SET zakonczenie = v_data_aktualna
    WHERE id_zespolu = p_id_zespolu
        AND zakonczenie IS NULL;

    -- Ustaw nowego kierownika
    INSERT INTO raporty.kierownicy (id_zespolu, id_pracownika, rozpoczecie)
    VALUES (p_id_zespolu, p_id_pracownika, v_data_aktualna);
END;
$$ LANGUAGE plpgsql;

/*
jednostka=> select * from raporty.kierownicy;
 id_zespolu | id_pracownika | rozpoczecie | zakonczenie 
------------+---------------+-------------+-------------
          1 |             1 | 2010-01-01  | 2022-12-31
          2 |             2 | 2015-01-01  | 
          1 |             3 | 2023-01-01  | 
          3 |             7 | 2018-01-01  | 
(4 rows)
jednostka=> call raporty.ustal_nowego_kierownika(8,3);
CALL
jednostka=> select * from raporty.kierownicy;
 id_zespolu | id_pracownika | rozpoczecie | zakonczenie 
------------+---------------+-------------+-------------
          1 |             1 | 2010-01-01  | 2022-12-31
          2 |             2 | 2015-01-01  | 
          1 |             3 | 2023-01-01  | 
          3 |             7 | 2018-01-01  | 2023-11-08
          3 |             8 | 2023-11-08  | 
(5 rows)
*/


-- Procedura do usuwania źle wpisanych lotów
CREATE OR REPLACE PROCEDURE raporty.usun_lot(
    p_id_lotu INT
)
AS $$
BEGIN
    -- Usuń lot o podanym id
    DELETE FROM raporty.loty
    WHERE id = p_id_lotu;
END;
$$ LANGUAGE plpgsql;