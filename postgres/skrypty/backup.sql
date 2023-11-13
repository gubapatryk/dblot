/*
Zapisywanie backupu bazy danych

pg_dumpall -c -U postgres > /backupy/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

jednostka=> INSERT INTO raporty.loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania)
VALUES
    (5,7, 'SP-SRS', 'IFR', 'WAW', 'KRK', '2023-11-10 12:00:00', '2023-11-10 18:00:00');
INSERT 0 1
jednostka=> select * from raporty.loty sort order by id desc;
 id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu |   godzina_wylotu    |  godzina_ladowania  
----+--------+--------+-------------+-----------+-----------------+-------------------+---------------------+---------------------
 30 |      5 |      7 | SP-SRS      | IFR       | WAW             | KRK               | 2023-11-10 12:00:00 | 2023-11-10 18:00:00
 28 |      5 |      7 | SP-SRS      | IFR       | WAW             | KRK               | 2023-11-09 12:00:00 | 2023-11-09 18:00:00
 27 |      4 |        | SP-S24      | IFR       | EPB             | EPB               | 2023-10-26 09:30:00 | 2023-10-26 15:45:00
 26 |      3 |      5 | SP-SRS      | SKL       | EPB             | GDN               | 2023-10-26 07:15:00 | 2023-10-26 17:30:00

*/

docker rm -f $(docker ps -a -q) && docker volume rm $(docker volume ls -q)

docker exec -it $(sudo docker ps -aqf "name=loty_psql") bash

psql -d jednostka -U postgres < /backupy/dump_12-11-2023_16_40_24.sql

patryk@ro:~/aprojekty/dblot/postgres $ docker exec -it $(sudo docker ps -aqf "name=loty_psql") psql -d jednostka -U andrzej
psql (16.0 (Debian 16.0-1.pgdg120+1))
Type "help" for help.

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

jednostka=> 
\q
patryk@ro:~/aprojekty/dblot/postgres $ docker exec -it $(sudo docker ps -aqf "name=loty_psql") psql -d jednostka -U maks
psql (16.0 (Debian 16.0-1.pgdg120+1))
Type "help" for help.

jednostka=> select * from raporty.waznosc_przegladow;
ERROR:  permission denied for view waznosc_przegladow
jednostka=> 

jednostka=> select * from raporty.loty sort order by id desc;
 id | pilot1 | pilot2 | rejestracja | kategoria | lotnisko_wylotu | lotnisko_przylotu | godzina_wylotu | godzina_ladowania 
----+--------+--------+-------------+-----------+-----------------+-------------------+----------------+-------------------
(0 rows)