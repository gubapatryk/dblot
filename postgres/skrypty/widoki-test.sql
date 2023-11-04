Dla Andrzeja

jednostka=> select * from raporty.waznosc_badan_lekarskich;
 id_pracownika |    imie    |   nazwisko    | czy_badania_wazne 
---------------+------------+---------------+-------------------
             1 | Jan        | Kowalski      | tak
             2 | Max        | Wojciechowski | nie
             3 | Remigiusz  | Stępień       | nie
             4 | Franciszek | Sikorski      | tak
             5 | Grzegorz   | Jaworski      | tak
             7 | Andrzej    | Nowak         | tak
             8 | Patryk     | Guba          | nie
(7 rows)

jednostka=> select * from raporty.waznosc_szkolen;
 id_pracownika |    imie    |   nazwisko    | czy_badania_wazne 
---------------+------------+---------------+-------------------
             1 | Jan        | Kowalski      | tak
             2 | Max        | Wojciechowski | nie
             3 | Remigiusz  | Stępień       | nie
             4 | Franciszek | Sikorski      | tak
             5 | Grzegorz   | Jaworski      | tak
             7 | Andrzej    | Nowak         | tak
             8 | Patryk     | Guba          | nie
(7 rows)

jednostka=> select * from raporty.waznosc_przegladow;
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

jednostka=> select * from raporty.raport_roczny;
 id_pilota |        pilot        | suma_czasu_lotu_godziny 
-----------+---------------------+-------------------------
         3 | Remigiusz Stępień   |     48.7500000000000000
         4 | Franciszek Sikorski |     45.0000000000000000
         5 | Grzegorz Jaworski   |     20.0000000000000000
         2 | Max Wojciechowski   |     12.0000000000000000
         1 | Jan Kowalski        |     11.2500000000000000
         7 | Andrzej Nowak       |      8.7500000000000000
         8 | Patryk Guba         |                       0
(7 rows)

jednostka=> select * from raporty.raport_miesieczny;
 id_pilota |        pilot        | suma_czasu_lotu_godziny 
-----------+---------------------+-------------------------
         3 | Remigiusz Stępień   |     40.5000000000000000
         4 | Franciszek Sikorski |     36.5000000000000000
         5 | Grzegorz Jaworski   |     12.5000000000000000
         2 | Max Wojciechowski   |      5.0000000000000000
         1 | Jan Kowalski        |      2.5000000000000000
         7 | Andrzej Nowak       |      2.2500000000000000
         8 | Patryk Guba         |                       0
(7 rows)

jednostka=> select * from raporty.raport_roczny_zespol;
 id_pilota |       pilot       | suma_czasu_lotu_godziny 
-----------+-------------------+-------------------------
         5 | Grzegorz Jaworski |     20.0000000000000000
         7 | Andrzej Nowak     |      8.7500000000000000
         8 | Patryk Guba       |                       0
(3 rows)

jednostka=> select * from raporty.raport_miesieczny_zespol;
 id_pilota |       pilot       | suma_czasu_lotu_godziny 
-----------+-------------------+-------------------------
         5 | Grzegorz Jaworski |     12.5000000000000000
         7 | Andrzej Nowak     |      2.2500000000000000
         8 | Patryk Guba       |                       0
(3 rows)

Dla Maxa

jednostka=> select * from raporty.waznosc_badan_lekarskich;

ERROR:  permission denied for view waznosc_badan_lekarskich
jednostka=> select * from raporty.waznosc_szkolen;
ERROR:  permission denied for view waznosc_szkolen

jednostka=> select * from raporty.waznosc_przegladow;
ERROR:  permission denied for view waznosc_przegladow

jednostka=> select * from raporty.raport_roczny;
 id_pilota |        pilot        | suma_czasu_lotu_godziny 
-----------+---------------------+-------------------------
         3 | Remigiusz Stępień   |     48.7500000000000000
         4 | Franciszek Sikorski |     45.0000000000000000
         5 | Grzegorz Jaworski   |     20.0000000000000000
         2 | Max Wojciechowski   |     12.0000000000000000
         1 | Jan Kowalski        |     11.2500000000000000
         7 | Andrzej Nowak       |      8.7500000000000000
         8 | Patryk Guba         |                       0
(7 rows)

jednostka=> select * from raporty.raport_miesieczny;
 id_pilota |        pilot        | suma_czasu_lotu_godziny 
-----------+---------------------+-------------------------
         3 | Remigiusz Stępień   |     40.5000000000000000
         4 | Franciszek Sikorski |     36.5000000000000000
         5 | Grzegorz Jaworski   |     12.5000000000000000
         2 | Max Wojciechowski   |      5.0000000000000000
         1 | Jan Kowalski        |      2.5000000000000000
         7 | Andrzej Nowak       |      2.2500000000000000
         8 | Patryk Guba         |                       0
(7 rows)

jednostka=> select * from raporty.raport_roczny_zespol;
 id_pilota |        pilot        | suma_czasu_lotu_godziny 
-----------+---------------------+-------------------------
         4 | Franciszek Sikorski |     45.0000000000000000
         2 | Max Wojciechowski   |     12.0000000000000000
(2 rows)

jednostka=> select * from raporty.raport_miesieczny_zespol;
 id_pilota |        pilot        | suma_czasu_lotu_godziny 
-----------+---------------------+-------------------------
         4 | Franciszek Sikorski |     36.5000000000000000
         2 | Max Wojciechowski   |      5.0000000000000000
(2 rows)
