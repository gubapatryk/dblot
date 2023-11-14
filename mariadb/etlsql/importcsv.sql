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