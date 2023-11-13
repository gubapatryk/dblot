laczenie sie z baza danych
```
docker exec -it $(sudo docker ps -aqf "name=loty_mariadb") mariadb -u dowodca -pdowodca jednostka
```