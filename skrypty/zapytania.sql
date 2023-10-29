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

-- podzapytanie - loty w których uczestniczył co najmniej jeden kierownik zespołu
SELECT * FROM raporty.loty
WHERE pilot1 IN (SELECT id_pracownika FROM raporty.kierownicy WHERE zakonczenie IS NULL) 
    OR pilot2 IN (SELECT id_pracownika FROM raporty.kierownicy WHERE zakonczenie IS NULL) 
    OR (pilot1 IN (SELECT id_pracownika FROM raporty.kierownicy WHERE zakonczenie IS NULL) AND pilot2 IS NULL);


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