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