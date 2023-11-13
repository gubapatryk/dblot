jednostka=> select raporty.generuj_raport_miesieczny(8,2023);
         generuj_raport_miesieczny         
-------------------------------------------
 (1,"Jan Kowalski","0 godz 0 min")
 (2,"Max Wojciechowski","0 godz 0 min")
 (3,"Remigiusz Stępień","0 godz 0 min")
 (4,"Franciszek Sikorski","2 godz 15 min")
 (5,"Grzegorz Jaworski","2 godz 30 min")
 (7,"Andrzej Nowak","0 godz 0 min")
 (8,"Patryk Guba","0 godz 0 min")
(7 rows)

jednostka=> select raporty.szukaj_pracownikow('Guba');
 szukaj_pracownikow 
--------------------
 (8,"Patryk Guba")
(1 row)

jednostka=> call raporty.dodaj_pracownika(3,'Jan','Nowak','01-11-2023');
CALL
jednostka=> select * from raporty.pracownicy;
 id | zespol |    imie    |   nazwisko    | data_zatrudnienia | data_zakonczenia 
----+--------+------------+---------------+-------------------+------------------
  1 |      1 | Jan        | Kowalski      | 2023-10-01        | 
  2 |      2 | Max        | Wojciechowski | 2016-01-01        | 
  3 |      1 | Remigiusz  | Stępień       | 2017-11-01        | 
  4 |      2 | Franciszek | Sikorski      | 2013-03-01        | 
  5 |      3 | Grzegorz   | Jaworski      | 2010-12-01        | 
  6 |      1 | Janusz     | Kowalski      | 2020-01-01        | 2023-10-02
  7 |      3 | Andrzej    | Nowak         | 2010-12-01        | 
  8 |      3 | Patryk     | Guba          | 2023-10-28        | 
  9 |      3 | Jan        | Nowak         | 2023-01-11        | 
(9 rows)

jednostka=> call raporty.zwolnij_pracownika(9,'09-11-2023');
CALL
jednostka=> select * from raporty.pracownicy;
 id | zespol |    imie    |   nazwisko    | data_zatrudnienia | data_zakonczenia 
----+--------+------------+---------------+-------------------+------------------
  1 |      1 | Jan        | Kowalski      | 2023-10-01        | 
  2 |      2 | Max        | Wojciechowski | 2016-01-01        | 
  3 |      1 | Remigiusz  | Stępień       | 2017-11-01        | 
  4 |      2 | Franciszek | Sikorski      | 2013-03-01        | 
  5 |      3 | Grzegorz   | Jaworski      | 2010-12-01        | 
  6 |      1 | Janusz     | Kowalski      | 2020-01-01        | 2023-10-02
  7 |      3 | Andrzej    | Nowak         | 2010-12-01        | 
  8 |      3 | Patryk     | Guba          | 2023-10-28        | 
  9 |      3 | Jan        | Nowak         | 2023-01-11        | 2023-09-11
(9 rows)

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
          3 |             7 | 2018-01-01  | 2023-11-13
          3 |             8 | 2023-11-13  | 
(5 rows)

jednostka=> select * from raporty.loty limit 5;
 id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu |   godzina_wylotu    |  godzina_ladowania  
----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------
  1 |      1 |      2 | SP-SRS      | IFR       | WAW             | KRK               | 2023-01-15 12:00:00 | 2023-01-15 14:30:00
  2 |      3 |        | SP-S23      | IFR       | GDN             | EPB               | 2023-02-10 09:30:00 | 2023-02-10 11:45:00
  3 |      4 |      5 | SP-S2R      | VFR       | EPB             | EPB               | 2023-03-05 15:45:00 | 2023-03-05 17:15:00
  4 |      6 |      7 | SP-S7H      | SKL       | EPB             | KRK               | 2023-04-01 08:15:00 | 2023-04-01 10:00:00
  5 |      1 |        | SP-S24      | IFR       | WAW             | GDN               | 2023-05-15 19:30:00 | 2023-05-15 21:00:00
(5 rows)

jednostka=> call raporty.usun_lot(3);
CALL
jednostka=> select * from raporty.loty limit 5;
 id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu |   godzina_wylotu    |  godzina_ladowania  
----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------
  1 |      1 |      2 | SP-SRS      | IFR       | WAW             | KRK               | 2023-01-15 12:00:00 | 2023-01-15 14:30:00
  2 |      3 |        | SP-S23      | IFR       | GDN             | EPB               | 2023-02-10 09:30:00 | 2023-02-10 11:45:00
  4 |      6 |      7 | SP-S7H      | SKL       | EPB             | KRK               | 2023-04-01 08:15:00 | 2023-04-01 10:00:00
  5 |      1 |        | SP-S24      | IFR       | WAW             | GDN               | 2023-05-15 19:30:00 | 2023-05-15 21:00:00
  6 |      2 |      3 | SP-SRS      | IFR       | GDN             | EPB               | 2023-06-01 12:30:00 | 2023-06-01 14:45:00
(5 rows)


jednostka=> CALL raporty.dodaj_lot_szkoleniowy(
    p_pilot1 := 7,
    p_pilot2 := 8,
    p_rejestracja := 'SP-SRS',
    p_kategoria := 'IFR',
    p_lotnisko_wylotu := 'WAW',
    p_lotnisko_przylotu := 'KRK',
    p_godzina_wylotu := '2023-11-06T12:00:00',
    p_godzina_ladowania := '2023-11-06T14:00:00'
);
ERROR:  Żaden z pilotów nie jest kierownikiem
CONTEXT:  PL/pgSQL function raporty.dodaj_lot_szkoleniowy(integer,integer,character varying,character varying,character varying,character varying,timestamp without time zone,timestamp without time zone) line 14 at RAISE

jednostka=> CALL raporty.dodaj_lot_szkoleniowy(
    p_pilot1 := 7,
    p_pilot2 := 8,
    p_rejestracja := 'SP-SRS',
    p_kategoria := 'IFR',
    p_lotnisko_wylotu := 'WAW',
    p_lotnisko_przylotu := 'KRK',
    p_godzina_wylotu := '2023-11-06T12:00:00',
    p_godzina_ladowania := '2023-11-06T14:00:00'
);
CALL
jednostka=> select * from raporty.szkolenia order by id desc limit 5;
 id | id_instytucji | id_pracownika |              nazwa              | data_aktualizacji | data_waznosci 
----+---------------+---------------+---------------------------------+-------------------+---------------
 11 |             1 |             8 | Lot szkoleniowy                 | 2023-11-06        | 2024-11-06
 10 |             1 |             7 | Szkolenie Lotnicze Transportowe | 2023-10-01        | 2024-10-01
  9 |             3 |             6 | Szkolenie Lotnicze Zawody       | 2023-09-01        | 2024-09-01
  8 |             2 |             5 | Szkolenie Lotnicze Nocne        | 2022-08-01        | 2024-08-01
  7 |             4 |             4 | Szkolenie Lotnicze Komunikacja  | 2022-07-01        | 2023-07-01
(5 rows)

jednostka=> select * from raporty.loty order by id desc limit 5;
 id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu |   godzina_wylotu    |  godzina_ladowania  
----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------
 28 |      7 |      8 | SP-SRS      | IFR       | WAW             | KRK               | 2023-11-06 12:00:00 | 2023-11-06 14:00:00
 27 |      4 |        | SP-S24      | IFR       | EPB             | EPB               | 2023-10-26 09:30:00 | 2023-10-26 15:45:00
 26 |      3 |      5 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-26 07:15:00 | 2023-10-26 17:30:00
 25 |      3 |      4 | SP-SRS      | SKL       | GDN             | EPB               | 2023-10-25 07:15:00 | 2023-10-25 16:30:00
 24 |      3 |      4 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-24 07:15:00 | 2023-10-24 16:30:00
(5 rows)

jednostka=> CALL raporty.dodaj_lot_szkoleniowy(
    p_pilot1 := 5,
    p_pilot2 := 8,
    p_rejestracja := 'SP-SRS',
    p_kategoria := 'IFR',
    p_lotnisko_wylotu := 'WAW',
    p_lotnisko_przylotu := 'KRK',
    p_godzina_wylotu := '2023-11-07T12:00:00',
    p_godzina_ladowania := '2023-11-07T14:00:00'
);
ERROR:  Pierwszy pilot nie jest kierownikiem

jednostka=> CALL raporty.dodaj_lot_szkoleniowy(
    p_pilot1 := 3,
    p_pilot2 := 8,
    p_rejestracja := 'SP-SRS',
    p_kategoria := 'IFR',
    p_lotnisko_wylotu := 'WAW',
    p_lotnisko_przylotu := 'KRK',
    p_godzina_wylotu := '2023-11-06T12:00:00',
    p_godzina_ladowania := '2023-11-06T14:00:00'
);
ERROR:  Co najmniej jeden z pilotów nie ma aktualnych badań lekarskich



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