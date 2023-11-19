# bazaloty

# Ksiazka kucharska:

### Czyszczenie dockera
```
docker rm -f $(docker ps -a -q)
docker volume rm $(docker volume ls -q)
```
lub
```
docker rm -f $(docker ps -a -q) && docker volume rm $(docker volume ls -q)
docker compose --build
```
### cli psql
```
docker exec -it <id z docker ps> bash
psql -d jednostka -U andrzej

docker exec -it $(sudo docker ps -aqf "name=loty_psql") bash
```
lub
```
docker exec -it $(sudo docker ps -aqf "name=loty_psql") psql -d jednostka -U andrzej
```

### CSV import

Przyklad importu pliku
```
\COPY raporty.pracownicy(id,zespol,imie,nazwisko,data_zatrudnienia,data_zakonczenia) FROM '/csv/pracownicy.csv' DELIMITER ',' CSV HEADER;
\COPY raporty.modele_maszyn TO '/csv/modele_maszyn.csv' WITH CSV HEADER;
```

### Do mariadb

```
docker exec -it $(sudo docker ps -aqf "name=loty_mariadb") mariadb --user dowodca -pdowodca jednostka
```
### ETL
Zapisywanie danych do plików CSV z bazy danych w postgres 
```
docker exec -it $(sudo docker ps -aqf "name=loty_psql") psql -d jednostka -U andrzej -a -f /skrypty/backuptocsv.sql


docker exec -it $(sudo docker ps -aqf "name=loty_mariadb") bash
mariadb -u dowodca -pdowodca jednostka -e "source /etlsql/importcsv.sql"

```

### Automatyzacja
```
docker exec $(sudo docker ps -aqf "name=loty_psql") psql -d jednostka -U andrzej -c "SELECT * FROM RAPORTY.RAPORT_MIESIECZNY" -o /tmp/raport.txt
```
Nastepnie uruchamiamy crontab -e i wprowadzamy następujący grafik:
```
 0 0 1 * * docker exec $(sudo docker ps -aqf "name=loty_psql") psql -d jednostka -U andrzej -c "SELECT * FROM RAPORTY.RAPORT_MIESIECZNY" -o /tmp/raport-$(date +%F).txt
```

Test zmian w raportach - dodajemy jakieś loty:
INSERT INTO raporty.loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania) VALUES (5,6, 'SP-SRS', 'IFR', 'WAW', 'KRK', '2023-11-04 02:00:00', '2023-11-04 15:00:00');


 id_pilota |        pilot        | suma_czasu_lotu 
-----------+---------------------+-----------------
         1 | Jan Kowalski        | 0 godz 0 min
         2 | Max Wojciechowski   | 0 godz 0 min
         3 | Remigiusz Stępień   | 0 godz 0 min
         4 | Franciszek Sikorski | 0 godz 0 min
         5 | Grzegorz Jaworski   | 0 godz 0 min
         7 | Andrzej Nowak       | 0 godz 0 min
         8 | Patryk Guba         | 0 godz 0 min
(7 rows)

 id_pilota |        pilot        | suma_czasu_lotu 
-----------+---------------------+-----------------
         1 | Jan Kowalski        | 0 godz 0 min
         2 | Max Wojciechowski   | 37 godz 0 min
         3 | Remigiusz Stępień   | 37 godz 0 min
         4 | Franciszek Sikorski | 0 godz 0 min
         5 | Grzegorz Jaworski   | 13 godz 0 min
         7 | Andrzej Nowak       | 0 godz 0 min
         8 | Patryk Guba         | 0 godz 0 min
(7 rows)

root@f05b7a892a0f:/tmp# ls
raport2023-11-16.txt