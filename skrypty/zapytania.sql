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