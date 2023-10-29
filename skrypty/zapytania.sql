-- UWAGA: nie wszystkie zapytania w tym pliku mogą być aktualne dla obecnego stanu bazy danych bądź poprawne

-- sprawdz ile samolotów jest na każdym z lotnisk i czy to możliwe pod wzgledem pojemności lotnisk
SELECT
    lotniska.iata AS lotnisko,
    SUM(hangary.pojemnosc) AS suma_pojemnosci,
    SUM(CASE WHEN loty.lotnisko_przylotu = lotniska.iata THEN 1 ELSE -1 END) AS ilosc_samolotow_obecnie
FROM
    raporty.lotniska
JOIN
    raporty.hangary ON lotniska.iata = hangary.lotnisko
LEFT JOIN
    raporty.loty ON lotniska.iata = loty.lotnisko_wylotu OR lotniska.iata = loty.lotnisko_przylotu
GROUP BY
    lotniska.iata;

-- czas lotu pilotow w minutach
SELECT
    l.id AS id_lotu,
    p1.imie || ' ' || p1.nazwisko AS pilot1,
    p2.imie || ' ' || p2.nazwisko AS pilot2,
    l.rejestracja AS numer_rejestracyjny,
    l.godzina_wylotu AS czas_wylotu,
    l.godzina_ladowania AS czas_ladowania,
    EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))/60 AS czas_lotu_minuty
FROM
    raporty.loty l
JOIN
    raporty.pracownicy p1 ON l.pilot1 = p1.id
LEFT JOIN
    raporty.pracownicy p2 ON l.pilot2 = p2.id;

-- suma nalotu w minutach

SELECT
    p.id AS id_pilota,
    p.imie || ' ' || p.nazwisko AS pilot,
    SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 60 AS suma_czasu_lotu_minuty
FROM
    raporty.pracownicy p
LEFT JOIN
    raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
GROUP BY
    p.id, p.imie, p.nazwisko;

-- suma nalotu w danym miesiacu

SELECT
    p.id AS id_pilota,
    p.imie || ' ' || p.nazwisko AS pilot,
    SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 60 AS suma_czasu_lotu_minuty
FROM
    raporty.pracownicy p
LEFT JOIN
    raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
WHERE
    EXTRACT(MONTH FROM l.godzina_ladowania) = EXTRACT(MONTH FROM CURRENT_DATE)
GROUP BY
    p.id, p.imie, p.nazwisko
ORDER BY
    suma_czasu_lotu_minuty DESC;

-- czy maszyna ma ważne przeglądy

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

 numer_rejestracyjny | czy_wazne_przeglady 
---------------------+---------------------
 SP-S23              | Tak
 SP-S24              | Nie
 SP-S2R              | Tak
 SP-S72              | Tak
 SP-S76              | Tak
 SP-S7H              | Nie
 SP-SRS              | Tak
(7 rows)


-- podzapytanie - piloci którzy mieli badanie w instytucji o danej nazwie

SELECT id, imie, nazwisko
FROM raporty.pracownicy
WHERE id IN (
    SELECT id_pracownika
    FROM raporty.badania
    WHERE id_instytucji IN (
        SELECT id
        FROM raporty.instytucje_medyczne
        WHERE nazwa = 'Wojskowy Instytut Medycyny Lotniczej'
    )
);

 id |    imie    |   nazwisko    
----+------------+---------------
  7 | Andrzej    | Nowak
  1 | Jan        | Kowalski
  5 | Grzegorz   | Jaworski
  4 | Franciszek | Sikorski
  2 | Max        | Wojciechowski
(5 rows)

-- podzapytanie - loty w których uczestniczył co najmniej jeden kierownik zespołu
SELECT * FROM raporty.loty
WHERE pilot1 IN (SELECT id_pracownika FROM raporty.kierownicy WHERE zakonczenie IS NULL) 
    OR pilot2 IN (SELECT id_pracownika FROM raporty.kierownicy WHERE zakonczenie IS NULL) 
    OR (pilot1 IN (SELECT id_pracownika FROM raporty.kierownicy WHERE zakonczenie IS NULL) AND pilot2 IS NULL);

 id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu |   godzina_wylotu    |  godzina_ladowania  
----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------
  1 |      1 |      2 | SP-SRS      | IFR       | WAW             | KRK               | 2023-01-15 12:00:00 | 2023-01-15 14:30:00
  2 |      3 |        | SP-S23      | IFR       | GDN             | EPB               | 2023-02-10 09:30:00 | 2023-02-10 11:45:00
  4 |      6 |      7 | SP-S7H      | SKL       | EPB             | KRK               | 2023-04-01 08:15:00 | 2023-04-01 10:00:00
  6 |      2 |      3 | SP-SRS      | IFR       | GDN             | EPB               | 2023-06-01 12:30:00 | 2023-06-01 14:45:00
  9 |      7 |      1 | SP-S7H      | IFR       | WAW             | KRK               | 2023-09-01 18:00:00 | 2023-09-01 20:30:00
 10 |      2 |        | SP-S24      | VFR       | WAW             | GDN               | 2023-10-01 21:30:00 | 2023-10-02 00:00:00
 11 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-01 07:15:00 | 2023-10-01 09:30:00
 13 |      6 |      7 | SP-S2R      | IFR       | EPB             | KRK               | 2023-10-15 09:30:00 | 2023-10-15 11:45:00
 14 |      1 |      2 | SP-S7H      | VFR       | WAW             | KRK               | 2023-10-10 15:00:00 | 2023-10-10 17:30:00
 15 |      3 |        | SP-S24      | SKL       | GDN             | EPB               | 2023-03-05 13:45:00 | 2023-03-05 15:15:00
 17 |      6 |      7 | SP-S23      | VFR       | EPB             | KRK               | 2023-05-15 16:30:00 | 2023-05-15 18:45:00
 19 |      2 |      3 | SP-S7H      | IFR       | GDN             | EPB               | 2023-07-10 18:30:00 | 2023-07-10 20:45:00
 23 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-23 07:15:00 | 2023-10-23 16:45:00
 24 |      3 |      4 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-24 07:15:00 | 2023-10-24 16:30:00
 25 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-25 07:15:00 | 2023-10-25 16:30:00
 26 |      3 |      5 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-26 07:15:00 | 2023-10-26 17:30:00
(16 rows)
--nalot w miesiącu w godzinach
SELECT
    p.id AS id_pilota,
    p.imie || ' ' || p.nazwisko AS pilot,
    SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600 AS suma_czasu_lotu_minuty
FROM
    raporty.pracownicy p
LEFT JOIN
    raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
WHERE
    EXTRACT(MONTH FROM l.godzina_ladowania) = EXTRACT(MONTH FROM CURRENT_DATE) AND  EXTRACT(YEAR FROM l.godzina_ladowania) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY
    p.id, p.imie, p.nazwisko
ORDER BY
    suma_czasu_lotu_minuty DESC;

 id_pilota |        pilot        | suma_czasu_lotu_minuty 
-----------+---------------------+------------------------
         3 | Remigiusz Stępień   |    40.5000000000000000
         4 | Franciszek Sikorski |    36.5000000000000000
         5 | Grzegorz Jaworski   |    12.5000000000000000
         2 | Max Wojciechowski   |     5.0000000000000000
         1 | Jan Kowalski        |     2.5000000000000000
         6 | Janusz Kowalski     |     2.2500000000000000
         7 | Andrzej Nowak       |     2.2500000000000000
(7 rows)

-- ile wylatano w tym tygodniu
SELECT
    p.id AS id_pilota,
    p.imie || ' ' || p.nazwisko AS pilot,
    SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600 AS suma_czasu_lotu_minuty
FROM
    raporty.pracownicy p
LEFT JOIN
    raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
WHERE
    EXTRACT('week' FROM l.godzina_ladowania) = EXTRACT('week' FROM CURRENT_DATE) AND  EXTRACT(YEAR FROM l.godzina_ladowania) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY
    p.id, p.imie, p.nazwisko
ORDER BY
    suma_czasu_lotu_minuty DESC;

-- kto ma wazne badania lekarskie

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
    raporty.pracownicy p;


-- raporty przegladow maszyn
SELECT
    m.rejestracja AS numer_rejestracyjny,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM raporty.przeglady p
            WHERE m.rejestracja = p.rejestracja
              AND p.data_waznosci >= CURRENT_DATE
        ) THEN 'tak'
        ELSE 'nie'
    END AS czy_przeglad_wazny
FROM
    raporty.maszyny m;

-- insert duzej liczby danych generowanych w serii
INSERT INTO raporty.pracownicy (id, zespol, imie, nazwisko, data_zatrudnienia, data_zakonczenia)
SELECT
    id,
    1 AS zespol,
    'Jan' AS imie,
    'Kowal' AS nazwisko,
    '2023-01-15' AS data_zatrudnienia,
    NULL AS data_zakonczenia
FROM
    generate_series(7, 100) AS id;

-- i ze zmienna datą

INSERT INTO raporty.pracownicy (id, zespol, imie, nazwisko, data_zatrudnienia, data_zakonczenia)
SELECT
    id,
    1 AS zespol,
    'Jan' AS imie,
    'Kowal' AS nazwisko,
    timestamp '2014-01-10 20:00:00' +                                                                                                                            
       random() * (timestamp '2023-10-20 20:00:00' -
                   timestamp '2014-01-10 10:00:00') AS data_zatrudnienia,
    NULL AS data_zakonczenia
FROM
    generate_series(7, 3000) AS id;

-- z indeksami
INSERT INTO raporty.pracownicy (id, zespol, imie, nazwisko, data_zatrudnienia, data_zakonczenia)
SELECT
    id,
    1 AS zespol,
    'Jan' AS imie,
    'Kowal' AS nazwisko,
    timestamp '2014-01-10 20:00:00' +                                                                                                                            
       random() * (timestamp '2023-10-20 20:00:00' -
                   timestamp '2014-01-10 10:00:00') AS data_zatrudnienia,
    NULL AS data_zakonczenia
FROM
    generate_series(8, 3000) AS id;


-- testy kluczy wielokolumnowych
jednostka=> SELECT
    z.id AS zespol_id,
    z.nazwa AS nazwa_zespolu,
    p.id AS pracownik_id,
    p.imie,
    p.nazwisko,
    p.data_zatrudnienia,
    p.data_zakonczenia,
    k.rozpoczecie,
    k.zakonczenie AS zakonczenie_kierownika
FROM
    raporty.zespoly z
JOIN
    raporty.pracownicy p ON z.id = p.zespol
LEFT JOIN
    raporty.kierownicy k ON z.id = k.id_zespolu AND p.id = k.id_pracownika;
 zespol_id |         nazwa_zespolu          | pracownik_id |    imie    |   nazwisko    | data_zatrudnienia | data_zakonczenia | rozpoczecie | zakonczenie_kierownika 
-----------+--------------------------------+--------------+------------+---------------+-------------------+------------------+-------------+------------------------
         1 | 1 Eskadra Transportowa         |            1 | Jan        | Kowalski      | 2023-10-01        |                  | 2010-01-01  | 2022-12-31
         2 | 3 Zespol Lotnictwa Specjalnego |            2 | Max        | Wojciechowski | 2016-01-01        |                  | 2015-01-01  | 
         1 | 1 Eskadra Transportowa         |            3 | Remigiusz  | Stępień       | 2017-11-01        |                  | 2023-01-01  | 
         3 | Druzyna Andrzeja               |            7 | Andrzej    | Nowak         | 2010-12-01        |                  | 2018-01-01  | 
         1 | 1 Eskadra Transportowa         |          430 | Jan        | Kowal         | 2019-03-22        |                  |             |
...


jednostka=> INSERT INTO raporty.badania (id_instytucji, id_pracownika, data_aktualizacji, data_waznosci)
VALUES (1, 1, '2023-10-29', '2024-10-29');
ERROR:  permission denied for table badania
jednostka=> select * from raporty.badania;
 id | id_instytucji | id_pracownika | data_aktualizacji | data_waznosci 
----+---------------+---------------+-------------------+---------------
  1 |             1 |             1 | 2022-01-15        | 2023-01-15
  2 |             2 |             2 | 2022-02-10        | 2023-02-10
  3 |             3 |             3 | 2022-03-05        | 2023-03-05
  4 |             1 |             4 | 2022-04-01        | 2023-04-01
  5 |             2 |             5 | 2022-05-15        | 2023-05-15
  6 |             3 |             6 | 2022-06-01        | 2023-06-01
  7 |             1 |             7 | 2022-07-01        | 2023-07-01
  8 |             2 |             1 | 2022-08-01        | 2023-08-01
  9 |             3 |             2 | 2022-09-01        | 2023-09-01
 10 |             1 |             3 | 2022-10-01        | 2023-10-01
 11 |             2 |             4 | 2022-11-01        | 2023-11-01
 12 |             3 |             5 | 2022-12-01        | 2023-12-01
 13 |             1 |             6 | 2023-01-01        | 2024-01-01
 14 |             2 |             7 | 2023-02-01        | 2024-02-01
 15 |             3 |             1 | 2023-03-01        | 2024-03-01
(15 rows)

jednostka=> INSERT INTO raporty.badania (id, id_instytucji, id_pracownika, data_aktualizacji, data_waznosci)
VALUES (16, 1, 1, '2023-10-29', '2024-10-29');
INSERT 0 1

docker exec -it $(sudo docker ps -aqf "name=loty_psql") psql -d jednostka -U jan


SELECT
    p.id AS id_pracownika,
    p.imie,
    p.nazwisko,
    CASE
        WHEN s.data_waznosci > CURRENT_DATE THEN 'tak'
        ELSE 'nie'
    END AS czy_szkolenie_wazne
FROM
    raporty.pracownicy p
LEFT JOIN (
    SELECT
        s.id_pracownika,
        MAX(s.data_waznosci) AS max_data_waznosci
    FROM
        raporty.szkolenia s
    LEFT JOIN raporty.kierownicy k ON s.id_pracownika = k.id_pracownika
    WHERE
        k.id_pracownika IS NULL
    GROUP BY
        s.id_pracownika
) latest_training ON p.id = latest_training.id_pracownika
LEFT JOIN raporty.szkolenia s ON latest_training.id_pracownika = s.id_pracownika AND latest_training.max_data_waznosci = s.data_waznosci
WHERE
    kierownicy.id_pracownika IS NULL OR kierownicy.id_pracownika IS NULL;


-- zamiana "nullowej" sumy na nienullowe zero - https://stackoverflow.com/questions/40098273/sql-sum-change-null-with-0
SELECT
    p.id AS id_pilota,
    p.imie || ' ' || p.nazwisko AS pilot,
    COALESCE(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600,0) AS suma_czasu_lotu_minuty
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
    suma_czasu_lotu_minuty DESC;