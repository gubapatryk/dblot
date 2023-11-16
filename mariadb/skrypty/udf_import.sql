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