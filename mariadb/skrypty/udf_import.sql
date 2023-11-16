CREATE VIEW waznosc_szkolen AS
SELECT
    p.id AS id_pracownika,
    p.imie,
    p.nazwisko,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM szkolenia s
            WHERE p.id = s.id_pracownika
              AND s.data_waznosci >= CURRENT_DATE
        ) THEN 'tak'
        ELSE 'nie'
    END AS czy_szkolenia_wazne
FROM
    pracownicy p
WHERE
    p.data_zakonczenia IS NULL;


CREATE VIEW waznosc_badan_lekarskich AS
SELECT
    p.id AS id_pracownika,
    p.imie,
    p.nazwisko,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM badania b
            WHERE p.id = b.id_pracownika
              AND b.data_waznosci >= CURRENT_DATE
        ) THEN 'tak'
        ELSE 'nie'
    END AS czy_badania_wazne
FROM
    pracownicy p
WHERE
    p.data_zakonczenia IS NULL;

/*
MariaDB [jednostka]> select * from waznosc_badan_lekarskich;
+---------------+------------+---------------+-------------------+
| id_pracownika | imie       | nazwisko      | czy_badania_wazne |
+---------------+------------+---------------+-------------------+
|             1 | Jan        | Kowalski      | tak               |
|             2 | Max        | Wojciechowski | nie               |
|             3 | Remigiusz  | Stępień       | nie               |
|             4 | Franciszek | Sikorski      | nie               |
|             5 | Grzegorz   | Jaworski      | tak               |
|             7 | Andrzej    | Nowak         | tak               |
|             8 | Patryk     | Guba          | nie               |
+---------------+------------+---------------+-------------------+
7 rows in set (0.002 sec)
*/

CREATE OR REPLACE VIEW raport_miesieczny AS
    SELECT
        p.id AS id_pilota,
        CONCAT(p.imie, ' ', p.nazwisko) AS pilot,
        COALESCE(
            CONCAT(
                ROUND(SUM(TIME_TO_SEC(TIMEDIFF(l.godzina_ladowania, l.godzina_wylotu)) / 3600)), ' godz ',
                ROUND(MOD(SUM(TIME_TO_SEC(TIMEDIFF(l.godzina_ladowania, l.godzina_wylotu))), 3600) / 60), ' min'
            ),
            '0 godz 0 min'
        ) AS suma_czasu_lotu
    FROM
        pracownicy p
    LEFT JOIN
        loty l ON p.id IN (l.pilot1, l.pilot2)
            AND MONTH(l.godzina_ladowania) = MONTH(CURRENT_DATE)
            AND YEAR(l.godzina_ladowania) = YEAR(CURRENT_DATE)
    WHERE
        (l.godzina_ladowania IS NULL OR p.data_zakonczenia IS NULL)
    GROUP BY
        p.id
    ORDER BY
        p.id ASC;


CREATE VIEW raport_roczny AS
    SELECT
        p.id AS id_pilota,
        CONCAT(p.imie, ' ', p.nazwisko) AS pilot,
        COALESCE(
            CONCAT(
                ROUND(SUM(TIME_TO_SEC(TIMEDIFF(l.godzina_ladowania, l.godzina_wylotu)) / 3600)), ' godz ',
                ROUND(MOD(SUM(TIME_TO_SEC(TIMEDIFF(l.godzina_ladowania, l.godzina_wylotu))), 3600) / 60), ' min'
            ),
            '0 godz 0 min'
        ) AS suma_czasu_lotu
    FROM
        pracownicy p
    LEFT JOIN
        loty l ON p.id IN (l.pilot1, l.pilot2)
            AND YEAR(l.godzina_ladowania) = YEAR(CURRENT_DATE)
    WHERE
        (l.godzina_ladowania IS NULL OR p.data_zakonczenia IS NULL)
    GROUP BY
        p.id
    ORDER BY
        p.id ASC;

/*
MariaDB [jednostka]> select * from raport_miesieczny;
+-----------+---------------------+-----------------+
| id_pilota | pilot               | suma_czasu_lotu |
+-----------+---------------------+-----------------+
|         1 | Jan Kowalski        | 0 godz 0 min    |
|         2 | Max Wojciechowski   | 0 godz 0 min    |
|         3 | Remigiusz Stępień   | 0 godz 0 min    |
|         4 | Franciszek Sikorski | 0 godz 0 min    |
|         5 | Grzegorz Jaworski   | 99 godz 0 min   |
|         6 | Janusz Kowalski     | 0 godz 0 min    |
|         7 | Andrzej Nowak       | 99 godz 0 min   |
|         8 | Patryk Guba         | 0 godz 0 min    |
+-----------+---------------------+-----------------+
8 rows in set (0.004 sec)

MariaDB [jednostka]> select * from raport_roczny;
+-----------+---------------------+-------------------------+
| id_pilota | pilot               | suma_czasu_lotu_godziny |
+-----------+---------------------+-------------------------+
|         5 | Grzegorz Jaworski   |                119.0000 |
|         7 | Andrzej Nowak       |                107.7500 |
|         3 | Remigiusz Stępień   |                 48.7500 |
|         4 | Franciszek Sikorski |                 45.0000 |
|         2 | Max Wojciechowski   |                 12.0000 |
|         1 | Jan Kowalski        |                 11.2500 |
|         8 | Patryk Guba         |                  0.0000 |
+-----------+---------------------+-------------------------+
7 rows in set (0.002 sec)
*/

DELIMITER //
CREATE TRIGGER sprawdz_czas_lotu
BEFORE INSERT ON loty
FOR EACH ROW
BEGIN
    DECLARE suma_czasu_lotu_pilota1 INT;
    DECLARE suma_czasu_lotu_pilota2 INT;

    -- Obliczanie sumy czasu lotu dla pilota1
    SELECT COALESCE(SUM(TIME_TO_SEC(TIMEDIFF(godzina_ladowania, godzina_wylotu)) / 3600), 0)
    INTO suma_czasu_lotu_pilota1
    FROM loty l
    WHERE l.pilot1 = NEW.pilot1
      AND WEEK(l.godzina_ladowania) = WEEK(CURRENT_DATE) AND  YEAR(l.godzina_ladowania) = YEAR(CURRENT_DATE);

    -- Obliczanie sumy czasu lotu dla pilota2
    SELECT COALESCE(SUM(TIME_TO_SEC(TIMEDIFF(godzina_ladowania, godzina_wylotu)) / 3600), 0)
    INTO suma_czasu_lotu_pilota2
    FROM loty l
    WHERE (l.pilot2 IS NOT NULL AND (l.pilot2 = NEW.pilot1 OR l.pilot2 = NEW.pilot2))
      AND WEEK(l.godzina_ladowania) = WEEK(CURRENT_DATE) AND  YEAR(l.godzina_ladowania) = YEAR(CURRENT_DATE);

    -- Sprawdzanie czy suma czasu lotu przekracza 40 godzin
    IF (suma_czasu_lotu_pilota1 > 40) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Suma nalotu pilota 1 w tym tygodniu przekroczyła 40 godzin';
    ELSEIF (suma_czasu_lotu_pilota1 > 35) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Suma nalotu pilota 1 w tym tygodniu przekroczyła 35 godzin';
    END IF;

    IF (suma_czasu_lotu_pilota2 > 40) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Suma nalotu pilota 2 w tym tygodniu przekroczyła 40 godzin';
    ELSEIF (suma_czasu_lotu_pilota2 > 35) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Suma nalotu pilota 2 w tym tygodniu przekroczyła 35 godzin';
    END IF;
END;
//
DELIMITER ;







/*




*/
CREATE OR REPLACE PROCEDURE sprawdz_przekroczenie_nalotu()
BEGIN
    DECLARE suma_czasu_lotu_pilota1 INT;
    DECLARE suma_czasu_lotu_pilota2 INT;

    -- Obliczanie sumy czasu lotu dla pilota1
    SELECT COALESCE(SUM(TIME_TO_SEC(TIMEDIFF(godzina_ladowania, godzina_wylotu)) / 3600), 0)
    INTO suma_czasu_lotu_pilota1
    FROM loty l
    WHERE l.pilot1 = NEW.pilot1
      AND WEEK(l.godzina_ladowania) = WEEK(CURRENT_DATE) AND  YEAR(l.godzina_ladowania) = YEAR(CURRENT_DATE);

    -- Obliczanie sumy czasu lotu dla pilota2
    SELECT COALESCE(SUM(TIME_TO_SEC(TIMEDIFF(godzina_ladowania, godzina_wylotu)) / 3600), 0)
    INTO suma_czasu_lotu_pilota2
    FROM loty l
    WHERE (l.pilot2 IS NOT NULL AND (l.pilot2 = NEW.pilot1 OR l.pilot2 = NEW.pilot2))
      AND WEEK(l.godzina_ladowania) = WEEK(CURRENT_DATE) AND  YEAR(l.godzina_ladowania) = YEAR(CURRENT_DATE);

    -- Sprawdzanie czy suma czasu lotu przekracza 40 godzin
    IF (suma_czasu_lotu_pilota1 > 40) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Suma nalotu pilota 1 w tym tygodniu przekroczyła 40 godzin';
    ELSIF (suma_czasu_lotu_pilota1 > 35) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Suma nalotu pilota 1 w tym tygodniu przekroczyła 35 godzin';
    END IF;

    IF (suma_czasu_lotu_pilota2 > 40) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Suma nalotu pilota 2 w tym tygodniu przekroczyła 40 godzin';
    ELSIF (suma_czasu_lotu_pilota2 > 35) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Suma nalotu pilota 2 w tym tygodniu przekroczyła 35 godzin';
    END IF;
END //

DELIMITER ;

-- Utwórz wyzwalacz, który będzie aktywowany po każdym wstawieniu do tabeli loty
CREATE TRIGGER sprawdz_przekroczenie_nalotu_trigger
AFTER INSERT ON loty
FOR EACH ROW
CALL sprawdz_przekroczenie_nalotu();

INSERT INTO loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania)
VALUES
    (6,8, 'SP-SRS', 'IFR', 'WAW', 'KRK', '2023-11-04 02:00:00', '2023-11-05 15:00:00');


/*

SELECT * FROM modele_maszyn;
SELECT * FROM instytucje_szkoleniowe;
SELECT * FROM instytucje_medyczne;
SELECT * FROM kategoria_lotow;
SELECT * FROM maszyny;
SELECT * FROM zespoly;
SELECT * FROM pracownicy;
SELECT * FROM kierownicy;
SELECT * FROM przeglady;
SELECT * FROM szkolenia;
SELECT * FROM badania;
SELECT * FROM lotniska;
SELECT * FROM hangary;
SELECT * FROM loty;


MariaDB [jednostka]> SELECT * FROM modele_maszyn;
+----+--------------+--------------+
| id | nazwa        | predkosc_max |
+----+--------------+--------------+
|  1 | Bell 412     |          230 |
|  2 | Robinson R44 |          240 |
|  3 | PZL Sokół    |          260 |
|  4 | Mi-8         |          250 |
+----+--------------+--------------+
4 rows in set (0.002 sec)

MariaDB [jednostka]> SELECT * FROM instytucje_szkoleniowe;
+----+-----------------------------------+-------------------------------------------------------------------------+
| id | nazwa                             | adres                                                                   |
+----+-----------------------------------+-------------------------------------------------------------------------+
|  1 | Szkolenie Wewnętrzne              |  Jednostka Wojskowa Nowowiejska 37 02-010 Warszawa                      |
|  2 | Lotnicze Centrum Szkoleniowe      | ul. Żurawia 22 00-515 Warszawa                                          |
|  3 | Akademia Pilotów Profesjonalnych  | ul. Nowogrodzka 45 00-695 Warszawa                                      |
|  4 | Urząd Lotnictwa Cywilnego         | Marcina Flisa 2 02-247 Warszawa                                         |
|  5 | Akademia Sztuki Wojennej          | Aleja Generała Antoniego Chruściela „Montera” 103 00-910 Warszawa       |
+----+-----------------------------------+-------------------------------------------------------------------------+
5 rows in set (0.001 sec)

MariaDB [jednostka]> SELECT * FROM instytucje_medyczne;
+----+------------------------------------------------+-----------------------------------+
| id | nazwa                                          | adres                             |
+----+------------------------------------------------+-----------------------------------+
|  1 | Szpital Wojskowy Centralny                     | ul. Szpitalna 1, 00-001 Warszawa  |
|  2 | Wojskowy Instytut Medycyny Lotniczej           | ul. Lotnicza 5, 03-123 Warszawa   |
|  3 | Centrum Medyczne Sił Powietrznych              | ul. Pilotów 10, 02-456 Warszawa   |
|  4 | Państwowy Instytut Medyczny MSWiA w Warszawie  | ul. Wołoska 137, 02-507 Warszawa  |
+----+------------------------------------------------+-----------------------------------+
4 rows in set (0.001 sec)

MariaDB [jednostka]> SELECT * FROM kategoria_lotow;
+-----+-------------------------+
| id  | nazwa                   |
+-----+-------------------------+
| IFR | Instrument Flight Rules |
| SKL | Lot szkoleniowy         |
| TST | Lot testowy             |
| VFR | Visual Flight Rules     |
+-----+-------------------------+
4 rows in set (0.001 sec)

MariaDB [jednostka]> SELECT * FROM maszyny;
+-------------+-----------+
| rejestracja | id_modelu |
+-------------+-----------+
| SP-SRS      |         1 |
| SP-S23      |         2 |
| SP-S2R      |         3 |
| SP-S7H      |         1 |
| SP-S24      |         2 |
| SP-S76      |         4 |
| SP-S72      |         4 |
+-------------+-----------+
7 rows in set (0.001 sec)

MariaDB [jednostka]> SELECT * FROM zespoly;
+----+--------------------------------------------------------+
| id | nazwa                                                  |
+----+--------------------------------------------------------+
|  1 | 1 Eskadra Transportowa                                 |
|  2 | 3 Zespol Lotnictwa Specjalnego                         |
|  3 | Druzyna Andrzeja                                       |
|  4 | 39 Samodzielny Specjalny Pułk Lotnictwa Wywiadowczego  |
+----+--------------------------------------------------------+
4 rows in set (0.001 sec)

MariaDB [jednostka]> SELECT * FROM pracownicy;
+----+--------+------------+---------------+-------------------+------------------+
| id | zespol | imie       | nazwisko      | data_zatrudnienia | data_zakonczenia |
+----+--------+------------+---------------+-------------------+------------------+
|  1 |      1 | Jan        | Kowalski      | 2023-10-01        | NULL             |
|  2 |      2 | Max        | Wojciechowski | 2016-01-01        | NULL             |
|  3 |      1 | Remigiusz  | Stępień       | 2017-11-01        | NULL             |
|  4 |      2 | Franciszek | Sikorski      | 2013-03-01        | NULL             |
|  5 |      3 | Grzegorz   | Jaworski      | 2010-12-01        | NULL             |
|  6 |      1 | Janusz     | Kowalski      | 2020-01-01        | 2023-10-02       |
|  7 |      3 | Andrzej    | Nowak         | 2010-12-01        | NULL             |
|  8 |      3 | Patryk     | Guba          | 2023-10-28        | NULL             |
+----+--------+------------+---------------+-------------------+------------------+
8 rows in set (0.001 sec)

MariaDB [jednostka]> SELECT * FROM kierownicy;
+------------+---------------+-------------+-------------+
| id_zespolu | id_pracownika | rozpoczecie | zakonczenie |
+------------+---------------+-------------+-------------+
|          1 |             1 | 2010-01-01  | 2022-12-31  |
|          2 |             2 | 2015-01-01  | NULL        |
|          1 |             3 | 2023-01-01  | NULL        |
|          3 |             7 | 2018-01-01  | NULL        |
+------------+---------------+-------------+-------------+
4 rows in set (0.001 sec)

MariaDB [jednostka]> SELECT * FROM przeglady;
+----+-------------+-------------------+---------------+
| id | rejestracja | data_aktualizacji | data_waznosci |
+----+-------------+-------------------+---------------+
|  1 | SP-SRS      | 2018-01-15        | 2019-01-15    |
|  2 | SP-S23      | 2018-02-10        | 2019-02-10    |
|  3 | SP-S2R      | 2018-03-05        | 2019-03-05    |
|  4 | SP-S7H      | 2019-04-01        | 2020-04-01    |
|  5 | SP-S24      | 2019-05-15        | 2020-05-15    |
|  6 | SP-SRS      | 2020-06-01        | 2021-06-01    |
|  7 | SP-S23      | 2020-07-01        | 2021-07-01    |
|  8 | SP-S2R      | 2021-08-01        | 2022-08-01    |
|  9 | SP-S7H      | 2021-09-01        | 2022-09-01    |
| 10 | SP-S24      | 2022-10-01        | 2023-10-01    |
| 11 | SP-SRS      | 2023-10-01        | 2024-11-01    |
| 12 | SP-S23      | 2023-10-01        | 2024-12-01    |
| 13 | SP-S2R      | 2023-01-01        | 2024-01-01    |
| 14 | SP-S72      | 2023-02-01        | 2024-02-01    |
| 15 | SP-S76      | 2023-06-01        | 2024-03-01    |
+----+-------------+-------------------+---------------+
15 rows in set (0.001 sec)

MariaDB [jednostka]> SELECT * FROM szkolenia;
+----+---------------+---------------+------------------------------------+-------------------+---------------+
| id | id_instytucji | id_pracownika | nazwa                              | data_aktualizacji | data_waznosci |
+----+---------------+---------------+------------------------------------+-------------------+---------------+
|  1 |             1 |             5 | Szkolenie Lotnicze Podstawowe      | 2021-01-15        | 2022-01-15    |
|  2 |             2 |             6 | Szkolenie Instruktorskie Lotnictwo | 2021-02-10        | 2022-02-10    |
|  3 |             3 |             7 | Szkolenie Medyczne Lotnictwo       | 2021-03-05        | 2022-03-05    |
|  4 |             1 |             1 | Szkolenie Awaryjne Lądowanie       | 2021-04-01        | 2025-04-01    |
|  5 |             2 |             2 | Szkolenie Lotnicze zaawansowane    | 2021-05-15        | 2022-05-15    |
|  6 |             3 |             3 | Szkolenie Ratownictwo Lotnicze     | 2022-06-01        | 2024-06-01    |
|  7 |             4 |             4 | Szkolenie Lotnicze Komunikacja     | 2022-07-01        | 2023-07-01    |
|  8 |             2 |             5 | Szkolenie Lotnicze Nocne           | 2022-08-01        | 2024-08-01    |
|  9 |             3 |             6 | Szkolenie Lotnicze Zawody          | 2023-09-01        | 2024-09-01    |
| 10 |             1 |             7 | Szkolenie Lotnicze Transportowe    | 2023-10-01        | 2024-10-01    |
+----+---------------+---------------+------------------------------------+-------------------+---------------+
10 rows in set (0.001 sec)

MariaDB [jednostka]> SELECT * FROM badania;
+----+---------------+---------------+-------------------+---------------+
| id | id_instytucji | id_pracownika | data_aktualizacji | data_waznosci |
+----+---------------+---------------+-------------------+---------------+
|  1 |             1 |             1 | 2022-01-15        | 2023-01-15    |
|  2 |             2 |             2 | 2022-02-10        | 2023-02-10    |
|  3 |             3 |             3 | 2022-03-05        | 2023-03-05    |
|  4 |             1 |             4 | 2022-04-01        | 2023-04-01    |
|  5 |             2 |             5 | 2022-05-15        | 2023-05-15    |
|  6 |             3 |             6 | 2022-06-01        | 2023-06-01    |
|  7 |             1 |             7 | 2022-07-01        | 2023-07-01    |
|  8 |             2 |             1 | 2022-08-01        | 2023-08-01    |
|  9 |             3 |             2 | 2022-09-01        | 2023-09-01    |
| 10 |             1 |             3 | 2022-10-01        | 2023-10-01    |
| 11 |             2 |             4 | 2022-11-01        | 2023-11-01    |
| 12 |             3 |             5 | 2022-12-01        | 2023-12-01    |
| 13 |             1 |             6 | 2023-01-01        | 2024-01-01    |
| 14 |             2 |             7 | 2023-02-01        | 2024-02-01    |
| 15 |             3 |             1 | 2023-03-01        | 2024-03-01    |
+----+---------------+---------------+-------------------+---------------+
15 rows in set (0.001 sec)

MariaDB [jednostka]> SELECT * FROM lotniska;
+------+---------------+-------------+
| iata | szerokosc_geo | dlugosc_geo |
+------+---------------+-------------+
| EPB  |       52.2685 |     20.9109 |
| GDN  |       54.3776 |     18.4662 |
| KRK  |       50.0778 |     19.7845 |
| WAW  |       52.1657 |     20.9671 |
+------+---------------+-------------+
4 rows in set (0.001 sec)

MariaDB [jednostka]> SELECT * FROM hangary;
+----+----------+-----------+
| id | lotnisko | pojemnosc |
+----+----------+-----------+
|  1 | WAW      |         1 |
|  2 | WAW      |         3 |
|  3 | WAW      |         2 |
|  4 | KRK      |         2 |
|  5 | KRK      |         1 |
|  6 | GDN      |         2 |
|  7 | EPB      |         2 |
+----+----------+-----------+
7 rows in set (0.001 sec)

MariaDB [jednostka]> SELECT * FROM loty;
+----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------+
| id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu | godzina_wylotu      | godzina_ladowania   |
+----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------+
|  1 |      1 |      2 | SP-SRS      | IFR       | WAW             | KRK               | 2023-01-15 12:00:00 | 2023-01-15 14:30:00 |
|  2 |      3 |   NULL | SP-S23      | IFR       | GDN             | EPB               | 2023-02-10 09:30:00 | 2023-02-10 11:45:00 |
|  3 |      4 |      5 | SP-S2R      | VFR       | EPB             | EPB               | 2023-03-05 15:45:00 | 2023-03-05 17:15:00 |
|  4 |      6 |      7 | SP-S7H      | SKL       | EPB             | KRK               | 2023-04-01 08:15:00 | 2023-04-01 10:00:00 |
|  5 |      1 |   NULL | SP-S24      | IFR       | WAW             | GDN               | 2023-05-15 19:30:00 | 2023-05-15 21:00:00 |
|  6 |      2 |      3 | SP-SRS      | IFR       | GDN             | EPB               | 2023-06-01 12:30:00 | 2023-06-01 14:45:00 |
|  7 |      4 |   NULL | SP-S23      | VFR       | EPB             | EPB               | 2023-07-10 14:00:00 | 2023-07-10 16:30:00 |
|  8 |      5 |      6 | SP-S2R      | SKL       | EPB             | KRK               | 2023-08-15 10:45:00 | 2023-08-15 12:15:00 |
|  9 |      7 |      1 | SP-S7H      | IFR       | WAW             | KRK               | 2023-09-01 18:00:00 | 2023-09-01 20:30:00 |
| 10 |      2 |   NULL | SP-S24      | VFR       | WAW             | GDN               | 2023-10-01 21:30:00 | 2023-10-02 00:00:00 |
| 11 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-01 07:15:00 | 2023-10-01 09:30:00 |
| 12 |      5 |   NULL | SP-S23      | IFR       | EPB             | EPB               | 2023-10-05 14:45:00 | 2023-10-05 17:00:00 |
| 13 |      6 |      7 | SP-S2R      | IFR       | EPB             | KRK               | 2023-10-15 09:30:00 | 2023-10-15 11:45:00 |
| 14 |      1 |      2 | SP-S7H      | VFR       | WAW             | KRK               | 2023-10-10 15:00:00 | 2023-10-10 17:30:00 |
| 15 |      3 |   NULL | SP-S24      | SKL       | GDN             | EPB               | 2023-03-05 13:45:00 | 2023-03-05 15:15:00 |
| 16 |      4 |      5 | SP-SRS      | IFR       | EPB             | EPB               | 2023-04-01 08:15:00 | 2023-04-01 10:30:00 |
| 17 |      6 |      7 | SP-S23      | VFR       | EPB             | KRK               | 2023-05-15 16:30:00 | 2023-05-15 18:45:00 |
| 18 |      1 |   NULL | SP-S2R      | SKL       | WAW             | GDN               | 2023-06-01 11:45:00 | 2023-06-01 14:00:00 |
| 19 |      2 |      3 | SP-S7H      | IFR       | GDN             | EPB               | 2023-07-10 18:30:00 | 2023-07-10 20:45:00 |
| 20 |      4 |   NULL | SP-S24      | IFR       | EPB             | EPB               | 2023-08-15 13:30:00 | 2023-08-15 15:45:00 |
| 21 |      5 |      6 | SP-SRS      | VFR       | EPB             | KRK               | 2023-09-01 10:15:00 | 2023-09-01 12:30:00 |
| 22 |      5 |      6 | SP-SRS      | VFR       | EPB             | KRK               | 2022-10-01 11:15:00 | 2022-10-01 14:45:00 |
| 23 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-23 07:15:00 | 2023-10-23 16:45:00 |
| 24 |      3 |      4 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-24 07:15:00 | 2023-10-24 16:30:00 |
| 25 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-25 07:15:00 | 2023-10-25 16:30:00 |
| 26 |      3 |      5 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-26 07:15:00 | 2023-10-26 17:30:00 |
| 27 |      4 |   NULL | SP-S24      | IFR       | EPB             | EPB               | 2023-10-26 09:30:00 | 2023-10-26 15:45:00 |
+----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------+
27 rows in set (0.001 sec)

*/
