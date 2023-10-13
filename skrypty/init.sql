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
    id INT PRIMARY KEY,
    zespol INT REFERENCES raporty.zespoly(id),
    imie VARCHAR(60) NOT NULL,
    nazwisko VARCHAR(60) NOT NULL,
    data_zatrudnienia DATE NOT NULL,
    data_zakonczenia DATE
);

CREATE TABLE raporty.kierownicy (
    id_zespolu INT REFERENCES raporty.zespoly(id),
    id_pracownika INT REFERENCES raporty.pracownicy(id),
    data_rozpoczecia DATE NOT NULL,
    data_zakonczenia DATE
);


CREATE TABLE raporty.przeglady (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    rejestracja VARCHAR(6) REFERENCES raporty.maszyny(rejestracja) NOT NULL,
    data_aktualizacji DATE NOT NULL,
    data_waznosci DATE NOT NULL
);

CREATE TABLE raporty.szkolenia (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    id_instytucji INT REFERENCES raporty.instytucje_szkoleniowe(id) NOT NULL,
    id_pracownika INT REFERENCES raporty.pracownicy(id) NOT NULL,
    nazwa VARCHAR(100) NOT NULL,
    data_aktualizacji DATE NOT NULL,
    data_waznosci DATE NOT NULL
);

CREATE TABLE raporty.badania (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    id_instytucji INT REFERENCES raporty.instytucje_medyczne(id) NOT NULL,
    id_pracownika INT REFERENCES raporty.pracownicy(id) NOT NULL,
    data_aktualizacji DATE NOT NULL,
    data_waznosci DATE NOT NULL
);


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


CREATE ROLE dowodca;
GRANT ALL PRIVILEGES ON DATABASE jednostka TO dowodca;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA raporty TO dowodca;
GRANT USAGE on SCHEMA raporty TO dowodca;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE raporty.pracownicy TO dowodca;

CREATE USER andrzej WITH PASSWORD 'andrzej';
GRANT dowodca TO andrzej;

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