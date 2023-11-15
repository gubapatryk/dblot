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
    /*
    foreign key(id_instytucji) 
        references instytucje_szkoleniowe(id)
    foreign key(id_pracownika) 
        references pracownicy(id)
    */
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
    /*
    foreign key(id_instytucji) 
        references instytucje_medyczne(id)
    foreign key(id_pracownika) 
        references pracownicy(id)
    */
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
    foreign key(rejestracja) 
        references maszyny(rejestracja)
    foreign key(kategoria) 
        references kategoria_lotow(id)
    foreign key(lotnisko_wylotu) 
        references lotniska(iata)
    foreign key(lotnisko_przylotu) 
        references lotniska(iata)
);


/*

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
*/

