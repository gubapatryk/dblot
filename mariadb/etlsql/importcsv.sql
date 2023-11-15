/*
COPY raporty.modele_maszyn FROM '/etlcsv/modele_maszyn.csv' DELIMITER ',' CSV HEADER;
COPY raporty.instytucje_szkoleniowe FROM '/etlcsv/instytucje_szkoleniowe.csv' DELIMITER ',' CSV HEADER;
COPY raporty.instytucje_medyczne FROM '/etlcsv/instytucje_medyczne.csv' DELIMITER ',' CSV HEADER;
COPY raporty.kategoria_lotow FROM '/etlcsv/kategoria_lotow.csv' DELIMITER ',' CSV HEADER;
COPY raporty.maszyny FROM '/etlcsv/maszyny.csv' DELIMITER ',' CSV HEADER;
COPY raporty.zespoly FROM '/etlcsv/zespoly.csv' DELIMITER ',' CSV HEADER;
COPY raporty.pracownicy FROM '/etlcsv/pracownicy.csv' DELIMITER ',' CSV HEADER;
COPY raporty.kierownicy FROM '/etlcsv/kierownicy.csv' DELIMITER ',' CSV HEADER;
COPY raporty.przeglady FROM '/etlcsv/przeglady.csv' DELIMITER ',' CSV HEADER;
COPY raporty.szkolenia FROM '/etlcsv/szkolenia.csv' DELIMITER ',' CSV HEADER;
COPY raporty.badania FROM '/etlcsv/badania.csv' DELIMITER ',' CSV HEADER;
COPY raporty.lotniska FROM '/etlcsv/lotniska.csv' DELIMITER ',' CSV HEADER;
COPY raporty.hangary FROM '/etlcsv/hangary.csv' DELIMITER ',' CSV HEADER;
COPY raporty.loty FROM '/etlcsv/loty.csv' DELIMITER ',' CSV HEADER;
*/

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