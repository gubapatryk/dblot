USE jednostka

GRANT ALL PRIVILEGES ON *.* TO 'dowodca'@'localhost' IDENTIFIED BY 'dowodca';

CREATE TABLE  IF NOT EXISTS instytucje_szkoleniowe (
    id INT NOT NULL AUTO_INCREMENT,
    nazwa VARCHAR(100) NOT NULL,
    adres VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);



CREATE TABLE instytucje_medyczne (
    id INT AUTO_INCREMENT,
    nazwa VARCHAR(100) NOT NULL,
    adres VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE kategoria_lotow (
    id VARCHAR(3),
    nazwa VARCHAR(60) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE modele_maszyn (
    id INT AUTO_INCREMENT,
    nazwa VARCHAR(50) NOT NULL,
    predkosc_max INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE maszyny (
    rejestracja VARCHAR(6),
    id_modelu INT NOT NULL
);


CREATE TABLE zespoly (
    id INT AUTO_INCREMENT,
    nazwa VARCHAR(100),
    PRIMARY KEY (id)
);

CREATE TABLE pracownicy (
    id INT AUTO_INCREMENT,
    zespol INT,
    imie VARCHAR(60) NOT NULL,
    nazwisko VARCHAR(60) NOT NULL,
    data_zatrudnienia DATE NOT NULL,
    data_zakonczenia DATE,
    PRIMARY KEY (id)
);

CREATE TABLE kierownicy (
    id_zespolu INT ,
    id_pracownika INT,
    rozpoczecie DATE NOT NULL,
    zakonczenie DATE
);



CREATE TABLE przeglady (
    id INT AUTO_INCREMENT,
    rejestracja VARCHAR(6) NOT NULL,
    data_aktualizacji DATE NOT NULL,
    data_waznosci DATE NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX idx_przeglady_data_aktualizacji ON przeglady (data_aktualizacji);
CREATE INDEX idx_przeglady_data_waznosci ON przeglady (data_waznosci);

CREATE TABLE szkolenia (
    id INT AUTO_INCREMENT,
    id_instytucji INT NOT NULL,
    id_pracownika INT NOT NULL,
    nazwa VARCHAR(100) NOT NULL,
    data_aktualizacji DATE NOT NULL,
    data_waznosci DATE NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX idx_szkolenia_data_aktualizacji ON szkolenia (data_aktualizacji);
CREATE INDEX idx_szkolenia_data_waznosci ON szkolenia (data_waznosci);

CREATE TABLE badania (
    id INT AUTO_INCREMENT,
    id_instytucji INT NOT NULL,
    id_pracownika INT NOT NULL,
    data_aktualizacji DATE NOT NULL,
    data_waznosci DATE NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX idx_badania_data_aktualizacji ON badania (data_aktualizacji);
CREATE INDEX idx_badania_data_waznosci ON badania (data_waznosci);

CREATE TABLE lotniska (
    iata VARCHAR(3),
    szerokosc_geo FLOAT NOT NULL,
    dlugosc_geo FLOAT NOT NULL,
    PRIMARY KEY (iata)
);

    
CREATE TABLE hangary (
    id INT AUTO_INCREMENT,
    lotnisko VARCHAR(3),
    pojemnosc INT NOT NULL,
    PRIMARY KEY (id)
);


CREATE TABLE loty (
    id INT AUTO_INCREMENT,
    pilot1 INT NOT NULL,
    pilot2 INT,
    rejestracja VARCHAR(6) NOT NULL,
    kategoria VARCHAR(3) NOT NULL,
    lotnisko_wylotu VARCHAR(3)  NOT NULL,
    lotnisko_przylotu VARCHAR(3)  NOT NULL,
    godzina_wylotu TIMESTAMP NOT NULL,
    godzina_ladowania TIMESTAMP NOT NULL,
    PRIMARY KEY (id)
);



/*ETL CSV*/

LOAD DATA INFILE '/etlcsv/modele_maszyn.csv'
INTO TABLE modele_maszyn
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@ignore, nazwa,predkosc_max);

LOAD DATA INFILE '/etlcsv/instytucje_szkoleniowe.csv'
INTO TABLE instytucje_szkoleniowe
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@ignore, nazwa,adres); 

LOAD DATA INFILE '/etlcsv/instytucje_medyczne.csv'
INTO TABLE instytucje_medyczne
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@ignore, nazwa,adres);

LOAD DATA INFILE '/etlcsv/kategoria_lotow.csv'
INTO TABLE kategoria_lotow
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id,nazwa);

LOAD DATA INFILE '/etlcsv/maszyny.csv'
INTO TABLE maszyny
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(rejestracja,id_modelu);

LOAD DATA INFILE '/etlcsv/zespoly.csv'
INTO TABLE zespoly
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@ignore,nazwa);

LOAD DATA INFILE '/etlcsv/pracownicy.csv'
INTO TABLE pracownicy
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@ignore,zespol,imie,nazwisko,data_zatrudnienia,@koniec)
SET data_zakonczenia = NULLIF(@koniec,'');

LOAD DATA INFILE '/etlcsv/kierownicy.csv'
INTO TABLE kierownicy
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_zespolu,id_pracownika,rozpoczecie,@koniec)
SET zakonczenie = NULLIF(@koniec,'');

LOAD DATA INFILE '/etlcsv/przeglady.csv'
INTO TABLE przeglady
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@ignore,rejestracja,data_aktualizacji,data_waznosci);

LOAD DATA INFILE '/etlcsv/szkolenia.csv'
INTO TABLE szkolenia
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@ignore, id_instytucji,id_pracownika,nazwa,data_aktualizacji,data_waznosci);

LOAD DATA INFILE '/etlcsv/badania.csv'
INTO TABLE badania
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@ignore, id_instytucji,id_pracownika,data_aktualizacji,data_waznosci);

LOAD DATA INFILE '/etlcsv/lotniska.csv'
INTO TABLE lotniska
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(iata,szerokosc_geo,dlugosc_geo);

LOAD DATA INFILE '/etlcsv/hangary.csv'
INTO TABLE hangary
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@ignore,lotnisko,pojemnosc);

LOAD DATA INFILE '/etlcsv/loty.csv'
INTO TABLE loty
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@ignore,pilot1,@pil2,rejestracja,kategoria,lotnisko_wylotu,lotnisko_przylotu,godzina_wylotu,godzina_ladowania)
SET pilot2 = NULLIF(@pil2,'');

/* widoki */

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

/* wyzwalacze */

/*
DELIMITER //
CREATE TRIGGER sprawdz_czas_lotu
AFTER INSERT ON loty
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
        SIGNAL SQLSTATE '02000'
        SET MESSAGE_TEXT = 'Suma nalotu pilota 1 w tym tygodniu przekroczyła 40 godzin';
    ELSEIF (suma_czasu_lotu_pilota1 > 35) THEN
        SIGNAL SQLSTATE '02000'
        SET MESSAGE_TEXT = 'Suma nalotu pilota 1 w tym tygodniu przekroczyła 35 godzin';
    END IF;

    IF (suma_czasu_lotu_pilota2 > 40) THEN
        SIGNAL SQLSTATE '02000'
        SET MESSAGE_TEXT = 'Suma nalotu pilota 2 w tym tygodniu przekroczyła 40 godzin';
    ELSEIF (suma_czasu_lotu_pilota2 > 35) THEN
        SIGNAL SQLSTATE '02000'
        SET MESSAGE_TEXT = 'Suma nalotu pilota 2 w tym tygodniu przekroczyła 35 godzin';
    END IF;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = suma_czasu_lotu_pilota1;
END;
//
DELIMITER ;


*/

DELIMITER //

CREATE OR REPLACE TRIGGER sprawdz_przekroczenie_nalotu_trigger
AFTER INSERT ON loty
FOR EACH ROW
BEGIN
    DECLARE suma_czasu_lotu_pilota1 INT;
    DECLARE suma_czasu_lotu_pilota2 INT;

    -- Obliczanie sumy czasu lotu dla pilota1
    SELECT COALESCE(SUM(TIME_TO_SEC(TIMEDIFF(godzina_ladowania, godzina_wylotu)) / 3600), 0)
    INTO suma_czasu_lotu_pilota1
    FROM loty l
    WHERE l.pilot1 = NEW.pilot1
      AND WEEK(l.godzina_ladowania) = WEEK(NEW.godzina_ladowania) AND  YEAR(l.godzina_ladowania) = YEAR(NEW.godzina_ladowania);

    -- Obliczanie sumy czasu lotu dla pilota2
    SELECT COALESCE(SUM(TIME_TO_SEC(TIMEDIFF(godzina_ladowania, godzina_wylotu)) / 3600), 0)
    INTO suma_czasu_lotu_pilota2
    FROM loty l
    WHERE (l.pilot2 IS NOT NULL AND (l.pilot2 = NEW.pilot1 OR l.pilot2 = NEW.pilot2))
      AND WEEK(l.godzina_ladowania) = WEEK(NEW.godzina_ladowania) AND  YEAR(l.godzina_ladowania) = YEAR(NEW.godzina_ladowania);

    -- Sprawdzanie czy suma czasu lotu przekracza 40 godzin
    IF (suma_czasu_lotu_pilota1 > 40 OR suma_czasu_lotu_pilota2 > 40) THEN
        SIGNAL SQLSTATE '02000'
        SET MESSAGE_TEXT = 'Suma nalotu co najmniej jednego z pilotow w tym tygodniu przekroczyła 40 godzin';
    ELSEIF (suma_czasu_lotu_pilota1 > 35 OR suma_czasu_lotu_pilota2 > 35) THEN
        SIGNAL SQLSTATE '02000'
        SET MESSAGE_TEXT = 'Suma nalotu co najmniej jednego z pilotow w tym tygodniu przekroczyła 35 godzin';
    END IF;
END //

DELIMITER ;



/*
MariaDB [jednostka]> INSERT INTO loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania)
    -> VALUES
    ->     (5,7, 'SP-SRS', 'IFR', 'WAW', 'KRK', '2023-11-04 02:00:00', '2023-11-05 15:00:00');
ERROR 1643 (02000): Suma nalotu co najmniej jednego z pilotow w tym tygodniu przekroczyła 35 godzin

MariaDB [jednostka]> INSERT INTO loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania)
    -> VALUES
    ->     (5,7, 'SP-SRS', 'IFR', 'WAW', 'KRK', '2023-11-04 02:00:00', '2023-11-05 15:00:00');
ERROR 1643 (02000): Suma nalotu co najmniej jednego z pilotow w tym tygodniu przekroczyła 40 godzin

*/