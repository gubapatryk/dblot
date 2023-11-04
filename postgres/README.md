# bazaloty

# Ksiazka kucharska:

### Czyszczenie dockera
```
docker rm -f $(docker ps -a -q)
docker volume rm $(docker volume ls -q)
```
### cli psql
```
docker exec -it <id z docker ps> bash
psql -d jednostka -U andrzej

docker exec -it $(sudo docker ps -aqf "name=loty_psql") bash
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