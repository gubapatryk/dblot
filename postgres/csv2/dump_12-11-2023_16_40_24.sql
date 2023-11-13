--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE jednostka;




--
-- Drop roles
--

DROP ROLE andrzej;
DROP ROLE dowodca;
DROP ROLE kierownik;
DROP ROLE maks;
DROP ROLE pilot;
DROP ROLE postgres;
DROP ROLE remigiusz;


--
-- Roles
--

CREATE ROLE andrzej;
ALTER ROLE andrzej WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:z8+88nEqhEGYYJ4LHmupJA==$cLVM+fPS8tOOiOKzTe9SI/wjLM8v/b0bYimNTqFKEc0=:EzqsAlAytO4dnsZTgR1sw4XMUQ/30SHEQnfFQSYlKgc=';
CREATE ROLE dowodca;
ALTER ROLE dowodca WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE kierownik;
ALTER ROLE kierownik WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE maks;
ALTER ROLE maks WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:oyQoEx4djjDjdiSufgTGrg==$GuIXK36fr96P8HyzUdx9nLqPP4tatDBNIcJlV/AYcWo=:RqMKavehRLn0NYQMo//vYbBDogmD+h9bf8xi3dhd+O4=';
CREATE ROLE pilot;
ALTER ROLE pilot WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:lSr94AhotdNHbUNi7Rak+Q==$CslsOcK3R1ZvZ2lEjnKp/htTtCSAJTsvKK+eW6lnL+0=:ppIH54ICHIZOWVsjbiREk4Fig9Rttrdlvi0p84H/Ctg=';
CREATE ROLE remigiusz;
ALTER ROLE remigiusz WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:zPmbm6bBtRy2m4qqserozA==$ysypWaNFUVPdp2L2kwpLRacHpLPWPbXWOv8Bj0EJ7aA=:8tsSGgSdJcI4QyOOHvUOQAqWm1OiHRXK+zLcOz7VvTY=';

--
-- User Configurations
--


--
-- Role memberships
--

GRANT dowodca TO andrzej WITH INHERIT TRUE GRANTED BY postgres;
GRANT kierownik TO remigiusz WITH INHERIT TRUE GRANTED BY postgres;
GRANT pilot TO maks WITH INHERIT TRUE GRANTED BY postgres;






--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0 (Debian 16.0-1.pgdg120+1)
-- Dumped by pg_dump version 16.0 (Debian 16.0-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO postgres;

\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: postgres
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "jednostka" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0 (Debian 16.0-1.pgdg120+1)
-- Dumped by pg_dump version 16.0 (Debian 16.0-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: jednostka; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE jednostka WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE jednostka OWNER TO postgres;

\connect jednostka

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: raporty; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA raporty;


ALTER SCHEMA raporty OWNER TO postgres;

--
-- Name: sprawdz_nakladanie_sie_lotow(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sprawdz_nakladanie_sie_lotow() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM raporty.loty l
        WHERE (NEW.pilot1 = l.pilot1 OR NEW.pilot1 = l.pilot2 OR NEW.pilot2 = l.pilot1 OR NEW.pilot2 = l.pilot2)
          AND (
            (NEW.godzina_wylotu >= l.godzina_wylotu AND NEW.godzina_wylotu < l.godzina_ladowania)
            OR (NEW.godzina_ladowania > l.godzina_wylotu AND NEW.godzina_ladowania <= l.godzina_ladowania)
            OR (NEW.godzina_wylotu <= l.godzina_wylotu AND NEW.godzina_ladowania >= l.godzina_ladowania)
        )
    ) THEN
        RAISE EXCEPTION 'Pilot lub maszyna już zajęta w tym czasie';
        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.sprawdz_nakladanie_sie_lotow() OWNER TO postgres;

--
-- Name: sprawdz_przekroczenie_nalotu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sprawdz_przekroczenie_nalotu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    suma_czasu_lotu_pilota1 INT;
    suma_czasu_lotu_pilota2 INT;
BEGIN
    -- Obliczanie sumy czasu lotu dla pilota1
    SELECT COALESCE(SUM(EXTRACT(EPOCH FROM (godzina_ladowania - godzina_wylotu))) / 3600, 0)
    INTO suma_czasu_lotu_pilota1
    FROM raporty.loty l
    WHERE l.pilot1 = NEW.pilot1
      AND EXTRACT('week' FROM l.godzina_ladowania) = EXTRACT('week' FROM CURRENT_DATE) AND  EXTRACT(YEAR FROM l.godzina_ladowania) = EXTRACT(YEAR FROM CURRENT_DATE);

    -- Obliczanie sumy czasu lotu dla pilota2
    SELECT COALESCE(SUM(EXTRACT(EPOCH FROM (godzina_ladowania - godzina_wylotu))) / 3600, 0)
    INTO suma_czasu_lotu_pilota2
    FROM raporty.loty l
    WHERE (l.pilot2 IS NOT NULL AND (l.pilot2 = NEW.pilot1 OR l.pilot2 = NEW.pilot2))
      AND EXTRACT('week' FROM l.godzina_ladowania) = EXTRACT('week' FROM CURRENT_DATE) AND  EXTRACT(YEAR FROM l.godzina_ladowania) = EXTRACT(YEAR FROM CURRENT_DATE);

    -- Sprawdzanie czy suma czasu lotu przekracza 40 godzin
    IF suma_czasu_lotu_pilota1 > 40 THEN
        RAISE NOTICE 'Suma nalotu pilota 1 w tym tygodniu przekroczyła 40 godzin';
    ELSIF suma_czasu_lotu_pilota1 > 35 THEN
        RAISE NOTICE 'Suma nalotu pilota 1 w tym tygodniu przekroczyła 35 godzin';    
    END IF;

    IF suma_czasu_lotu_pilota2 > 40 THEN
        RAISE NOTICE 'Suma nalotu pilota 2 w tym tygodniu przekroczyła 40 godzin';
    ELSIF suma_czasu_lotu_pilota2 > 35 THEN
        RAISE NOTICE 'Suma nalotu pilota 2 w tym tygodniu przekroczyła 35 godzin';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.sprawdz_przekroczenie_nalotu() OWNER TO postgres;

--
-- Name: dodaj_lot_szkoleniowy(integer, integer, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone); Type: PROCEDURE; Schema: raporty; Owner: postgres
--

CREATE PROCEDURE raporty.dodaj_lot_szkoleniowy(IN p_pilot1 integer, IN p_pilot2 integer, IN p_rejestracja character varying, IN p_kategoria character varying, IN p_lotnisko_wylotu character varying, IN p_lotnisko_przylotu character varying, IN p_godzina_wylotu timestamp without time zone, IN p_godzina_ladowania timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_kierownik INT;
BEGIN
    -- Sprawdź, czy spośród pilotów znajduje się pilot będący kierownikiem
    -- Zalozenie systemowe - szkoleniowca podajemy jako pierwszego, a szkolonego jako drugiego pilota 
    SELECT id_pracownika INTO v_kierownik
    FROM raporty.kierownicy
    WHERE id_pracownika = p_pilot1
      AND rozpoczecie <= CURRENT_TIMESTAMP
      AND zakonczenie IS NULL;

    IF v_kierownik IS NULL THEN
        RAISE EXCEPTION 'Żaden z pilotów nie jest kierownikiem';
    END IF;

    -- Sprawdź, czy posiadają aktualne badania lekarskie
    IF NOT EXISTS (
        SELECT 1
        FROM raporty.badania
        WHERE id_pracownika IN (p_pilot1, p_pilot2)
          AND data_waznosci >= CURRENT_DATE
    ) THEN
        RAISE EXCEPTION 'Co najmniej jeden z pilotów nie ma aktualnych badań lekarskich';
    END IF;

    -- Sprawdź, czy w tym momencie nie uczestniczyli już w innym locie
    IF EXISTS (
        SELECT 1
        FROM raporty.loty
        WHERE (p_pilot1 IN (pilot1, pilot2) OR p_pilot2 IN (pilot1, pilot2))
          AND (p_godzina_wylotu, p_godzina_ladowania) OVERLAPS (godzina_wylotu, godzina_ladowania)
    ) THEN
        RAISE EXCEPTION 'Piloci o podanych numerach ID uczestniczą już w innym locie w tym czasie';
    END IF;

    -- Sprawdz, czy pojazd o podanej rejestracji nie byl juz w innym locie
    IF EXISTS (
        SELECT 1
        FROM raporty.loty
        WHERE rejestracja = p_rejestracja
          AND (p_godzina_wylotu, p_godzina_ladowania) OVERLAPS (godzina_wylotu, godzina_ladowania)
    ) THEN
        RAISE EXCEPTION 'Pojazd o podanej rejestracji uczestniczył już w innym locie w tym czasie';
    END IF;

    -- Dodaj rekord do tabeli raporty.szkolenia
    -- id_instytucji=1, bo szkolenie wewnetrzne (regula biznesowa)
    INSERT INTO raporty.szkolenia (id_instytucji, id_pracownika, nazwa, data_aktualizacji, data_waznosci)
    VALUES (1, p_pilot2, 'Lot szkoleniowy', p_godzina_wylotu, p_godzina_ladowania + INTERVAL '1 year');

    -- Dodaj rekord do tabeli raporty.loty
    INSERT INTO raporty.loty (pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania)
    VALUES (p_pilot1, p_pilot2, p_rejestracja, p_kategoria, p_lotnisko_wylotu, p_lotnisko_przylotu, p_godzina_wylotu, p_godzina_ladowania);
END;
$$;


ALTER PROCEDURE raporty.dodaj_lot_szkoleniowy(IN p_pilot1 integer, IN p_pilot2 integer, IN p_rejestracja character varying, IN p_kategoria character varying, IN p_lotnisko_wylotu character varying, IN p_lotnisko_przylotu character varying, IN p_godzina_wylotu timestamp without time zone, IN p_godzina_ladowania timestamp without time zone) OWNER TO postgres;

--
-- Name: dodaj_pracownika(integer, character varying, character varying, date, date); Type: PROCEDURE; Schema: raporty; Owner: postgres
--

CREATE PROCEDURE raporty.dodaj_pracownika(IN p_zespol integer, IN p_imie character varying, IN p_nazwisko character varying, IN p_data_zatrudnienia date, IN p_data_zakonczenia date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO raporty.pracownicy (zespol, imie, nazwisko, data_zatrudnienia, data_zakonczenia)
    VALUES (p_zespol, p_imie, p_nazwisko, p_data_zatrudnienia, p_data_zakonczenia);
END;
$$;


ALTER PROCEDURE raporty.dodaj_pracownika(IN p_zespol integer, IN p_imie character varying, IN p_nazwisko character varying, IN p_data_zatrudnienia date, IN p_data_zakonczenia date) OWNER TO postgres;

--
-- Name: generuj_raport_miesieczny(integer, integer); Type: FUNCTION; Schema: raporty; Owner: postgres
--

CREATE FUNCTION raporty.generuj_raport_miesieczny(miesiac integer, rok integer) RETURNS TABLE(id_pilota integer, pilot text, suma_czasu_lotu text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id AS id_pilota,
        p.imie || ' ' || p.nazwisko AS pilot,
        COALESCE(
            ROUND(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600) || ' godz ' || 
            ROUND(MOD(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))), 3600) / 60) || ' min'
        , '0 godz 0 min'
        ) AS suma_czasu_lotu
    FROM
        raporty.pracownicy p
    LEFT JOIN
        raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
            AND EXTRACT(MONTH FROM l.godzina_ladowania) = miesiac
            AND EXTRACT(YEAR FROM l.godzina_ladowania) = rok
    WHERE
        (l.godzina_ladowania IS NULL OR p.data_zakonczenia IS NULL)
    GROUP BY
        p.id
    ORDER BY
        pilot DESC;

    RETURN;
END;
$$;


ALTER FUNCTION raporty.generuj_raport_miesieczny(miesiac integer, rok integer) OWNER TO postgres;

--
-- Name: generuj_raport_miesieczny_zespol(integer, integer); Type: FUNCTION; Schema: raporty; Owner: postgres
--

CREATE FUNCTION raporty.generuj_raport_miesieczny_zespol(miesiac integer, rok integer) RETURNS TABLE(id_pilota integer, pilot text, suma_czasu_lotu text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id AS id_pilota,
        p.imie || ' ' || p.nazwisko AS pilot,
        COALESCE(
            ROUND(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600) || ' godz ' || 
            ROUND(MOD(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))), 3600) / 60) || ' min'
        , '0 godz 0 min'
        ) AS suma_czasu_lotu
    FROM
        raporty.pracownicy p
    LEFT JOIN
        raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
            AND EXTRACT(MONTH FROM l.godzina_ladowania) = miesiac
            AND EXTRACT(YEAR FROM l.godzina_ladowania) = rok
    WHERE
        (l.godzina_ladowania IS NULL OR p.data_zakonczenia IS NULL)
        AND p.zespol IN (SELECT zespol FROM raporty.pracownicy p
                        JOIN raporty.sys_user_prac s ON p.id = s.id_prac
                        WHERE s.username = current_user)
    GROUP BY
        p.id
    ORDER BY
        pilot DESC;

    RETURN;
END;
$$;


ALTER FUNCTION raporty.generuj_raport_miesieczny_zespol(miesiac integer, rok integer) OWNER TO postgres;

--
-- Name: generuj_raport_roczny(integer); Type: FUNCTION; Schema: raporty; Owner: postgres
--

CREATE FUNCTION raporty.generuj_raport_roczny(rok integer) RETURNS TABLE(id_pilota integer, pilot text, suma_czasu_lotu text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id AS id_pilota,
        p.imie || ' ' || p.nazwisko AS pilot,
        COALESCE(
            ROUND(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600) || ' godz ' || 
            ROUND(MOD(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))), 3600) / 60) || ' min'
        , '0 godz 0 min'
        ) AS suma_czasu_lotu
    FROM
        raporty.pracownicy p
    LEFT JOIN
        raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
    WHERE
        (EXTRACT(YEAR FROM l.godzina_ladowania) = rok
        OR l.godzina_ladowania IS NULL) 
        AND p.data_zakonczenia IS NULL
    GROUP BY
        p.id, p.imie, p.nazwisko
    ORDER BY
        pilot DESC;

    RETURN;
END;
$$;


ALTER FUNCTION raporty.generuj_raport_roczny(rok integer) OWNER TO postgres;

--
-- Name: generuj_raport_roczny_zespol(integer); Type: FUNCTION; Schema: raporty; Owner: postgres
--

CREATE FUNCTION raporty.generuj_raport_roczny_zespol(rok integer) RETURNS TABLE(id_pilota integer, pilot text, suma_czasu_lotu text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id AS id_pilota,
        p.imie || ' ' || p.nazwisko AS pilot,
        COALESCE(
            ROUND(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))) / 3600) || ' godz ' || 
            ROUND(MOD(SUM(EXTRACT(EPOCH FROM (l.godzina_ladowania - l.godzina_wylotu))), 3600) / 60) || ' min'
        , '0 godz 0 min'
        ) AS suma_czasu_lotu
    FROM
        raporty.pracownicy p
    LEFT JOIN
        raporty.loty l ON p.id IN (l.pilot1, l.pilot2)
            AND EXTRACT(YEAR FROM l.godzina_ladowania) = rok
    WHERE
        (l.godzina_ladowania IS NULL OR p.data_zakonczenia IS NULL)
        AND p.zespol IN (SELECT zespol FROM raporty.pracownicy p
                        JOIN raporty.sys_user_prac s ON p.id = s.id_prac
                        WHERE s.username = current_user)
    GROUP BY
        p.id
    ORDER BY
        pilot DESC;

    RETURN;
END;
$$;


ALTER FUNCTION raporty.generuj_raport_roczny_zespol(rok integer) OWNER TO postgres;

--
-- Name: szukaj_pracownikow(text); Type: FUNCTION; Schema: raporty; Owner: postgres
--

CREATE FUNCTION raporty.szukaj_pracownikow(p_nazwa_pracownika text) RETURNS TABLE(id integer, imie_nazwisko text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.imie || ' ' || p.nazwisko AS imie_nazwisko
    FROM raporty.pracownicy p
    WHERE p.imie || ' ' || p.nazwisko ILIKE '%' || p_nazwa_pracownika || '%';
END;
$$;


ALTER FUNCTION raporty.szukaj_pracownikow(p_nazwa_pracownika text) OWNER TO postgres;

--
-- Name: szukaj_zespolow(text); Type: FUNCTION; Schema: raporty; Owner: postgres
--

CREATE FUNCTION raporty.szukaj_zespolow(p_nazwa_zespolu text) RETURNS TABLE(id integer, nazwa character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT z.id, z.nazwa
    FROM raporty.zespoly z 
    WHERE z.nazwa ILIKE '%' || p_nazwa_zespolu || '%';
END;
$$;


ALTER FUNCTION raporty.szukaj_zespolow(p_nazwa_zespolu text) OWNER TO postgres;

--
-- Name: ustal_nowego_kierownika(integer, integer); Type: PROCEDURE; Schema: raporty; Owner: postgres
--

CREATE PROCEDURE raporty.ustal_nowego_kierownika(IN p_id_pracownika integer, IN p_id_zespolu integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_data_aktualna DATE;
BEGIN
    -- Pobierz aktualną datę
    v_data_aktualna := CURRENT_DATE;

    -- Znajdź dotychczasowego kierownika
    UPDATE raporty.kierownicy
    SET zakonczenie = v_data_aktualna
    WHERE id_zespolu = p_id_zespolu
        AND zakonczenie IS NULL;

    -- Ustaw nowego kierownika
    INSERT INTO raporty.kierownicy (id_zespolu, id_pracownika, rozpoczecie)
    VALUES (p_id_zespolu, p_id_pracownika, v_data_aktualna);
END;
$$;


ALTER PROCEDURE raporty.ustal_nowego_kierownika(IN p_id_pracownika integer, IN p_id_zespolu integer) OWNER TO postgres;

--
-- Name: usun_lot(integer); Type: PROCEDURE; Schema: raporty; Owner: postgres
--

CREATE PROCEDURE raporty.usun_lot(IN p_id_lotu integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Usuń lot o podanym id
    DELETE FROM raporty.loty
    WHERE id = p_id_lotu;
END;
$$;


ALTER PROCEDURE raporty.usun_lot(IN p_id_lotu integer) OWNER TO postgres;

--
-- Name: zwolnij_pracownika(integer, date); Type: PROCEDURE; Schema: raporty; Owner: postgres
--

CREATE PROCEDURE raporty.zwolnij_pracownika(IN p_id_pracownika integer, IN p_data_zakonczenia date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE raporty.pracownicy
    SET data_zakonczenia = p_data_zakonczenia
    WHERE id = p_id_pracownika;
END;
$$;


ALTER PROCEDURE raporty.zwolnij_pracownika(IN p_id_pracownika integer, IN p_data_zakonczenia date) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: badania; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.badania (
    id integer NOT NULL,
    id_instytucji integer NOT NULL,
    id_pracownika integer NOT NULL,
    data_aktualizacji date NOT NULL,
    data_waznosci date NOT NULL
);


ALTER TABLE raporty.badania OWNER TO postgres;

--
-- Name: badania_id_seq; Type: SEQUENCE; Schema: raporty; Owner: postgres
--

ALTER TABLE raporty.badania ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME raporty.badania_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hangary; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.hangary (
    id integer NOT NULL,
    lotnisko character varying(3),
    pojemnosc integer NOT NULL
);


ALTER TABLE raporty.hangary OWNER TO postgres;

--
-- Name: hangary_id_seq; Type: SEQUENCE; Schema: raporty; Owner: postgres
--

ALTER TABLE raporty.hangary ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME raporty.hangary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instytucje_medyczne; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.instytucje_medyczne (
    id integer NOT NULL,
    nazwa character varying(100) NOT NULL,
    adres character varying(100) NOT NULL
);


ALTER TABLE raporty.instytucje_medyczne OWNER TO postgres;

--
-- Name: instytucje_medyczne_id_seq; Type: SEQUENCE; Schema: raporty; Owner: postgres
--

ALTER TABLE raporty.instytucje_medyczne ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME raporty.instytucje_medyczne_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instytucje_szkoleniowe; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.instytucje_szkoleniowe (
    id integer NOT NULL,
    nazwa character varying(100) NOT NULL,
    adres character varying(100) NOT NULL
);


ALTER TABLE raporty.instytucje_szkoleniowe OWNER TO postgres;

--
-- Name: instytucje_szkoleniowe_id_seq; Type: SEQUENCE; Schema: raporty; Owner: postgres
--

ALTER TABLE raporty.instytucje_szkoleniowe ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME raporty.instytucje_szkoleniowe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kategoria_lotow; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.kategoria_lotow (
    id character varying(3) NOT NULL,
    nazwa character varying(60) NOT NULL
);


ALTER TABLE raporty.kategoria_lotow OWNER TO postgres;

--
-- Name: kierownicy; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.kierownicy (
    id_zespolu integer,
    id_pracownika integer,
    rozpoczecie date NOT NULL,
    zakonczenie date
);


ALTER TABLE raporty.kierownicy OWNER TO postgres;

--
-- Name: lotniska; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.lotniska (
    iata character varying(3) NOT NULL,
    szerokosc_geo double precision NOT NULL,
    dlugosc_geo double precision NOT NULL
);


ALTER TABLE raporty.lotniska OWNER TO postgres;

--
-- Name: loty; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.loty (
    id integer NOT NULL,
    pilot1 integer NOT NULL,
    pilot2 integer,
    rejestracja character varying(6) NOT NULL,
    kategoria character varying(3) NOT NULL,
    lotnisko_wylotu character varying(3) NOT NULL,
    lotnisko_przylotu character varying(3) NOT NULL,
    godzina_wylotu timestamp without time zone NOT NULL,
    godzina_ladowania timestamp without time zone NOT NULL
);


ALTER TABLE raporty.loty OWNER TO postgres;

--
-- Name: loty_id_seq; Type: SEQUENCE; Schema: raporty; Owner: postgres
--

ALTER TABLE raporty.loty ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME raporty.loty_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: maszyny; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.maszyny (
    rejestracja character varying(6) NOT NULL,
    id_modelu integer NOT NULL
);


ALTER TABLE raporty.maszyny OWNER TO postgres;

--
-- Name: modele_maszyn; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.modele_maszyn (
    id integer NOT NULL,
    nazwa character varying(50) NOT NULL,
    predkosc_max integer NOT NULL
);


ALTER TABLE raporty.modele_maszyn OWNER TO postgres;

--
-- Name: modele_maszyn_id_seq; Type: SEQUENCE; Schema: raporty; Owner: postgres
--

ALTER TABLE raporty.modele_maszyn ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME raporty.modele_maszyn_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pracownicy; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.pracownicy (
    id integer NOT NULL,
    zespol integer,
    imie character varying(60) NOT NULL,
    nazwisko character varying(60) NOT NULL,
    data_zatrudnienia date NOT NULL,
    data_zakonczenia date
);


ALTER TABLE raporty.pracownicy OWNER TO postgres;

--
-- Name: pracownicy_id_seq; Type: SEQUENCE; Schema: raporty; Owner: postgres
--

ALTER TABLE raporty.pracownicy ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME raporty.pracownicy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: przeglady; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.przeglady (
    id integer NOT NULL,
    rejestracja character varying(6) NOT NULL,
    data_aktualizacji date NOT NULL,
    data_waznosci date NOT NULL
);


ALTER TABLE raporty.przeglady OWNER TO postgres;

--
-- Name: przeglady_id_seq; Type: SEQUENCE; Schema: raporty; Owner: postgres
--

ALTER TABLE raporty.przeglady ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME raporty.przeglady_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: raport_miesieczny; Type: VIEW; Schema: raporty; Owner: postgres
--

CREATE VIEW raporty.raport_miesieczny AS
 SELECT p.id AS id_pilota,
    (((p.imie)::text || ' '::text) || (p.nazwisko)::text) AS pilot,
    COALESCE((sum(EXTRACT(epoch FROM (l.godzina_ladowania - l.godzina_wylotu))) / (3600)::numeric), (0)::numeric) AS suma_czasu_lotu_godziny
   FROM (raporty.pracownicy p
     LEFT JOIN raporty.loty l ON (((p.id = l.pilot1) OR (p.id = l.pilot2))))
  WHERE ((((EXTRACT(month FROM l.godzina_ladowania) = EXTRACT(month FROM CURRENT_DATE)) AND (EXTRACT(year FROM l.godzina_ladowania) = EXTRACT(year FROM CURRENT_DATE))) OR (l.godzina_ladowania IS NULL)) AND (p.data_zakonczenia IS NULL))
  GROUP BY p.id, p.imie, p.nazwisko
  ORDER BY COALESCE((sum(EXTRACT(epoch FROM (l.godzina_ladowania - l.godzina_wylotu))) / (3600)::numeric), (0)::numeric) DESC;


ALTER VIEW raporty.raport_miesieczny OWNER TO postgres;

--
-- Name: sys_user_prac; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.sys_user_prac (
    username character varying(20) NOT NULL,
    id_prac integer NOT NULL
);


ALTER TABLE raporty.sys_user_prac OWNER TO postgres;

--
-- Name: raport_miesieczny_zespol; Type: VIEW; Schema: raporty; Owner: postgres
--

CREATE VIEW raporty.raport_miesieczny_zespol AS
 SELECT p.id AS id_pilota,
    (((p.imie)::text || ' '::text) || (p.nazwisko)::text) AS pilot,
    COALESCE((sum(EXTRACT(epoch FROM (l.godzina_ladowania - l.godzina_wylotu))) / (3600)::numeric), (0)::numeric) AS suma_czasu_lotu_godziny
   FROM (raporty.pracownicy p
     LEFT JOIN raporty.loty l ON (((p.id = l.pilot1) OR (p.id = l.pilot2))))
  WHERE ((((EXTRACT(month FROM l.godzina_ladowania) = EXTRACT(month FROM CURRENT_DATE)) AND (EXTRACT(year FROM l.godzina_ladowania) = EXTRACT(year FROM CURRENT_DATE))) OR (l.godzina_ladowania IS NULL)) AND (p.data_zakonczenia IS NULL) AND (p.zespol IN ( SELECT p_1.zespol
           FROM (raporty.pracownicy p_1
             JOIN raporty.sys_user_prac s ON ((p_1.id = s.id_prac)))
          WHERE ((s.username)::text = CURRENT_USER))))
  GROUP BY p.id, p.imie, p.nazwisko
  ORDER BY COALESCE((sum(EXTRACT(epoch FROM (l.godzina_ladowania - l.godzina_wylotu))) / (3600)::numeric), (0)::numeric) DESC;


ALTER VIEW raporty.raport_miesieczny_zespol OWNER TO postgres;

--
-- Name: raport_roczny; Type: VIEW; Schema: raporty; Owner: postgres
--

CREATE VIEW raporty.raport_roczny AS
 SELECT p.id AS id_pilota,
    (((p.imie)::text || ' '::text) || (p.nazwisko)::text) AS pilot,
    COALESCE((sum(EXTRACT(epoch FROM (l.godzina_ladowania - l.godzina_wylotu))) / (3600)::numeric), (0)::numeric) AS suma_czasu_lotu_godziny
   FROM (raporty.pracownicy p
     LEFT JOIN raporty.loty l ON (((p.id = l.pilot1) OR (p.id = l.pilot2))))
  WHERE (((EXTRACT(year FROM l.godzina_ladowania) = EXTRACT(year FROM CURRENT_DATE)) OR (l.godzina_ladowania IS NULL)) AND (p.data_zakonczenia IS NULL))
  GROUP BY p.id, p.imie, p.nazwisko
  ORDER BY COALESCE((sum(EXTRACT(epoch FROM (l.godzina_ladowania - l.godzina_wylotu))) / (3600)::numeric), (0)::numeric) DESC;


ALTER VIEW raporty.raport_roczny OWNER TO postgres;

--
-- Name: raport_roczny_zespol; Type: VIEW; Schema: raporty; Owner: postgres
--

CREATE VIEW raporty.raport_roczny_zespol AS
 SELECT p.id AS id_pilota,
    (((p.imie)::text || ' '::text) || (p.nazwisko)::text) AS pilot,
    COALESCE((sum(EXTRACT(epoch FROM (l.godzina_ladowania - l.godzina_wylotu))) / (3600)::numeric), (0)::numeric) AS suma_czasu_lotu_godziny
   FROM (raporty.pracownicy p
     LEFT JOIN raporty.loty l ON (((p.id = l.pilot1) OR (p.id = l.pilot2))))
  WHERE (((EXTRACT(year FROM l.godzina_ladowania) = EXTRACT(year FROM CURRENT_DATE)) OR (l.godzina_ladowania IS NULL)) AND (p.data_zakonczenia IS NULL) AND (p.zespol IN ( SELECT p_1.zespol
           FROM (raporty.pracownicy p_1
             JOIN raporty.sys_user_prac s ON ((p_1.id = s.id_prac)))
          WHERE ((s.username)::text = CURRENT_USER))))
  GROUP BY p.id, p.imie, p.nazwisko
  ORDER BY COALESCE((sum(EXTRACT(epoch FROM (l.godzina_ladowania - l.godzina_wylotu))) / (3600)::numeric), (0)::numeric) DESC;


ALTER VIEW raporty.raport_roczny_zespol OWNER TO postgres;

--
-- Name: szkolenia; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.szkolenia (
    id integer NOT NULL,
    id_instytucji integer NOT NULL,
    id_pracownika integer NOT NULL,
    nazwa character varying(100) NOT NULL,
    data_aktualizacji date NOT NULL,
    data_waznosci date NOT NULL
);


ALTER TABLE raporty.szkolenia OWNER TO postgres;

--
-- Name: szkolenia_id_seq; Type: SEQUENCE; Schema: raporty; Owner: postgres
--

ALTER TABLE raporty.szkolenia ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME raporty.szkolenia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: waznosc_badan_lekarskich; Type: VIEW; Schema: raporty; Owner: postgres
--

CREATE VIEW raporty.waznosc_badan_lekarskich AS
 SELECT id AS id_pracownika,
    imie,
    nazwisko,
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM raporty.badania b
              WHERE ((p.id = b.id_pracownika) AND (b.data_waznosci >= CURRENT_DATE)))) THEN 'tak'::text
            ELSE 'nie'::text
        END AS czy_badania_wazne
   FROM raporty.pracownicy p
  WHERE (data_zakonczenia IS NULL);


ALTER VIEW raporty.waznosc_badan_lekarskich OWNER TO postgres;

--
-- Name: waznosc_przegladow; Type: VIEW; Schema: raporty; Owner: postgres
--

CREATE VIEW raporty.waznosc_przegladow AS
 SELECT m.rejestracja AS numer_rejestracyjny,
        CASE
            WHEN (max(p.data_waznosci) >= CURRENT_DATE) THEN 'Tak'::text
            ELSE 'Nie'::text
        END AS czy_wazne_przeglady
   FROM (raporty.maszyny m
     LEFT JOIN raporty.przeglady p ON (((m.rejestracja)::text = (p.rejestracja)::text)))
  GROUP BY m.rejestracja
  ORDER BY m.rejestracja;


ALTER VIEW raporty.waznosc_przegladow OWNER TO postgres;

--
-- Name: waznosc_szkolen; Type: VIEW; Schema: raporty; Owner: postgres
--

CREATE VIEW raporty.waznosc_szkolen AS
 SELECT id AS id_pracownika,
    imie,
    nazwisko,
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM raporty.badania b
              WHERE ((p.id = b.id_pracownika) AND (b.data_waznosci >= CURRENT_DATE)))) THEN 'tak'::text
            ELSE 'nie'::text
        END AS czy_badania_wazne
   FROM raporty.pracownicy p
  WHERE (data_zakonczenia IS NULL);


ALTER VIEW raporty.waznosc_szkolen OWNER TO postgres;

--
-- Name: zespoly; Type: TABLE; Schema: raporty; Owner: postgres
--

CREATE TABLE raporty.zespoly (
    id integer NOT NULL,
    nazwa character varying(100)
);


ALTER TABLE raporty.zespoly OWNER TO postgres;

--
-- Name: zespoly_id_seq; Type: SEQUENCE; Schema: raporty; Owner: postgres
--

ALTER TABLE raporty.zespoly ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME raporty.zespoly_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: badania; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.badania (id, id_instytucji, id_pracownika, data_aktualizacji, data_waznosci) FROM stdin;
1	1	1	2022-01-15	2023-01-15
2	2	2	2022-02-10	2023-02-10
3	3	3	2022-03-05	2023-03-05
4	1	4	2022-04-01	2023-04-01
5	2	5	2022-05-15	2023-05-15
6	3	6	2022-06-01	2023-06-01
7	1	7	2022-07-01	2023-07-01
8	2	1	2022-08-01	2023-08-01
9	3	2	2022-09-01	2023-09-01
10	1	3	2022-10-01	2023-10-01
11	2	4	2022-11-01	2023-11-01
12	3	5	2022-12-01	2023-12-01
13	1	6	2023-01-01	2024-01-01
14	2	7	2023-02-01	2024-02-01
15	3	1	2023-03-01	2024-03-01
\.


--
-- Data for Name: hangary; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.hangary (id, lotnisko, pojemnosc) FROM stdin;
1	WAW	1
2	WAW	3
3	WAW	2
4	KRK	2
5	KRK	1
6	GDN	2
7	EPB	2
\.


--
-- Data for Name: instytucje_medyczne; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.instytucje_medyczne (id, nazwa, adres) FROM stdin;
1	Szpital Wojskowy Centralny	ul. Szpitalna 1, 00-001 Warszawa
2	Wojskowy Instytut Medycyny Lotniczej	ul. Lotnicza 5, 03-123 Warszawa
3	Centrum Medyczne Sił Powietrznych	ul. Pilotów 10, 02-456 Warszawa
4	Państwowy Instytut Medyczny MSWiA w Warszawie	ul. Wołoska 137, 02-507 Warszawa
\.


--
-- Data for Name: instytucje_szkoleniowe; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.instytucje_szkoleniowe (id, nazwa, adres) FROM stdin;
1	Szkolenie Wewnętrzne	 Jednostka Wojskowa Nowowiejska 37 02-010 Warszawa
2	Lotnicze Centrum Szkoleniowe	ul. Żurawia 22 00-515 Warszawa
3	Akademia Pilotów Profesjonalnych	ul. Nowogrodzka 45 00-695 Warszawa
4	Urząd Lotnictwa Cywilnego	Marcina Flisa 2 02-247 Warszawa
5	Akademia Sztuki Wojennej	Aleja Generała Antoniego Chruściela „Montera” 103 00-910 Warszawa
\.


--
-- Data for Name: kategoria_lotow; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.kategoria_lotow (id, nazwa) FROM stdin;
IFR	Instrument Flight Rules
VFR	Visual Flight Rules
SKL	Lot szkoleniowy
TST	Lot testowy
\.


--
-- Data for Name: kierownicy; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.kierownicy (id_zespolu, id_pracownika, rozpoczecie, zakonczenie) FROM stdin;
1	1	2010-01-01	2022-12-31
2	2	2015-01-01	\N
1	3	2023-01-01	\N
3	7	2018-01-01	\N
\.


--
-- Data for Name: lotniska; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.lotniska (iata, szerokosc_geo, dlugosc_geo) FROM stdin;
WAW	52.1657	20.9671
EPB	52.2685	20.9109
KRK	50.0778	19.7845
GDN	54.3776	18.4662
\.


--
-- Data for Name: loty; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.loty (id, pilot1, pilot2, rejestracja, kategoria, lotnisko_wylotu, lotnisko_przylotu, godzina_wylotu, godzina_ladowania) FROM stdin;
1	1	2	SP-SRS	IFR	WAW	KRK	2023-01-15 12:00:00	2023-01-15 14:30:00
2	3	\N	SP-S23	IFR	GDN	EPB	2023-02-10 09:30:00	2023-02-10 11:45:00
3	4	5	SP-S2R	VFR	EPB	EPB	2023-03-05 15:45:00	2023-03-05 17:15:00
4	6	7	SP-S7H	SKL	EPB	KRK	2023-04-01 08:15:00	2023-04-01 10:00:00
5	1	\N	SP-S24	IFR	WAW	GDN	2023-05-15 19:30:00	2023-05-15 21:00:00
6	2	3	SP-SRS	IFR	GDN	EPB	2023-06-01 12:30:00	2023-06-01 14:45:00
7	4	\N	SP-S23	VFR	EPB	EPB	2023-07-10 14:00:00	2023-07-10 16:30:00
8	5	6	SP-S2R	SKL	EPB	KRK	2023-08-15 10:45:00	2023-08-15 12:15:00
9	7	1	SP-S7H	IFR	WAW	KRK	2023-09-01 18:00:00	2023-09-01 20:30:00
10	2	\N	SP-S24	VFR	WAW	GDN	2023-10-01 21:30:00	2023-10-02 00:00:00
11	3	4	SP-SRS	SKL	GDN	EPB	2023-10-01 07:15:00	2023-10-01 09:30:00
12	5	\N	SP-S23	IFR	EPB	EPB	2023-10-05 14:45:00	2023-10-05 17:00:00
13	6	7	SP-S2R	IFR	EPB	KRK	2023-10-15 09:30:00	2023-10-15 11:45:00
14	1	2	SP-S7H	VFR	WAW	KRK	2023-10-10 15:00:00	2023-10-10 17:30:00
15	3	\N	SP-S24	SKL	GDN	EPB	2023-03-05 13:45:00	2023-03-05 15:15:00
16	4	5	SP-SRS	IFR	EPB	EPB	2023-04-01 08:15:00	2023-04-01 10:30:00
17	6	7	SP-S23	VFR	EPB	KRK	2023-05-15 16:30:00	2023-05-15 18:45:00
18	1	\N	SP-S2R	SKL	WAW	GDN	2023-06-01 11:45:00	2023-06-01 14:00:00
19	2	3	SP-S7H	IFR	GDN	EPB	2023-07-10 18:30:00	2023-07-10 20:45:00
20	4	\N	SP-S24	IFR	EPB	EPB	2023-08-15 13:30:00	2023-08-15 15:45:00
21	5	6	SP-SRS	VFR	EPB	KRK	2023-09-01 10:15:00	2023-09-01 12:30:00
22	5	6	SP-SRS	VFR	EPB	KRK	2022-10-01 11:15:00	2022-10-01 14:45:00
23	3	4	SP-SRS	SKL	GDN	EPB	2023-10-23 07:15:00	2023-10-23 16:45:00
24	3	4	SP-SRS	SKL	EPB	GDN	2023-10-24 07:15:00	2023-10-24 16:30:00
25	3	4	SP-SRS	SKL	GDN	EPB	2023-10-25 07:15:00	2023-10-25 16:30:00
26	3	5	SP-SRS	SKL	EPB	GDN	2023-10-26 07:15:00	2023-10-26 17:30:00
27	4	\N	SP-S24	IFR	EPB	EPB	2023-10-26 09:30:00	2023-10-26 15:45:00
28	5	7	SP-SRS	IFR	WAW	KRK	2023-11-09 12:00:00	2023-11-09 18:00:00
30	5	7	SP-SRS	IFR	WAW	KRK	2023-11-10 12:00:00	2023-11-10 18:00:00
\.


--
-- Data for Name: maszyny; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.maszyny (rejestracja, id_modelu) FROM stdin;
SP-SRS	1
SP-S23	2
SP-S2R	3
SP-S7H	1
SP-S24	2
SP-S76	4
SP-S72	4
\.


--
-- Data for Name: modele_maszyn; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.modele_maszyn (id, nazwa, predkosc_max) FROM stdin;
1	Bell 412	230
2	Robinson R44	240
3	PZL Sokół	260
4	Mi-8	250
\.


--
-- Data for Name: pracownicy; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.pracownicy (id, zespol, imie, nazwisko, data_zatrudnienia, data_zakonczenia) FROM stdin;
1	1	Jan	Kowalski	2023-10-01	\N
2	2	Max	Wojciechowski	2016-01-01	\N
3	1	Remigiusz	Stępień	2017-11-01	\N
4	2	Franciszek	Sikorski	2013-03-01	\N
5	3	Grzegorz	Jaworski	2010-12-01	\N
6	1	Janusz	Kowalski	2020-01-01	2023-10-02
7	3	Andrzej	Nowak	2010-12-01	\N
8	3	Patryk	Guba	2023-10-28	\N
\.


--
-- Data for Name: przeglady; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.przeglady (id, rejestracja, data_aktualizacji, data_waznosci) FROM stdin;
1	SP-SRS	2018-01-15	2019-01-15
2	SP-S23	2018-02-10	2019-02-10
3	SP-S2R	2018-03-05	2019-03-05
4	SP-S7H	2019-04-01	2020-04-01
5	SP-S24	2019-05-15	2020-05-15
6	SP-SRS	2020-06-01	2021-06-01
7	SP-S23	2020-07-01	2021-07-01
8	SP-S2R	2021-08-01	2022-08-01
9	SP-S7H	2021-09-01	2022-09-01
10	SP-S24	2022-10-01	2023-10-01
11	SP-SRS	2023-10-01	2024-11-01
12	SP-S23	2023-10-01	2024-12-01
13	SP-S2R	2023-01-01	2024-01-01
14	SP-S72	2023-02-01	2024-02-01
15	SP-S76	2023-06-01	2024-03-01
\.


--
-- Data for Name: sys_user_prac; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.sys_user_prac (username, id_prac) FROM stdin;
maks	2
remigiusz	3
andrzej	7
\.


--
-- Data for Name: szkolenia; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.szkolenia (id, id_instytucji, id_pracownika, nazwa, data_aktualizacji, data_waznosci) FROM stdin;
1	1	5	Szkolenie Lotnicze Podstawowe	2021-01-15	2022-01-15
2	2	6	Szkolenie Instruktorskie Lotnictwo	2021-02-10	2022-02-10
3	3	7	Szkolenie Medyczne Lotnictwo	2021-03-05	2022-03-05
4	1	1	Szkolenie Awaryjne Lądowanie	2021-04-01	2025-04-01
5	2	2	Szkolenie Lotnicze zaawansowane	2021-05-15	2022-05-15
6	3	3	Szkolenie Ratownictwo Lotnicze	2022-06-01	2024-06-01
7	4	4	Szkolenie Lotnicze Komunikacja	2022-07-01	2023-07-01
8	2	5	Szkolenie Lotnicze Nocne	2022-08-01	2024-08-01
9	3	6	Szkolenie Lotnicze Zawody	2023-09-01	2024-09-01
10	1	7	Szkolenie Lotnicze Transportowe	2023-10-01	2024-10-01
\.


--
-- Data for Name: zespoly; Type: TABLE DATA; Schema: raporty; Owner: postgres
--

COPY raporty.zespoly (id, nazwa) FROM stdin;
1	1 Eskadra Transportowa
2	3 Zespol Lotnictwa Specjalnego
3	Druzyna Andrzeja
4	39 Samodzielny Specjalny Pułk Lotnictwa Wywiadowczego
\.


--
-- Name: badania_id_seq; Type: SEQUENCE SET; Schema: raporty; Owner: postgres
--

SELECT pg_catalog.setval('raporty.badania_id_seq', 1, false);


--
-- Name: hangary_id_seq; Type: SEQUENCE SET; Schema: raporty; Owner: postgres
--

SELECT pg_catalog.setval('raporty.hangary_id_seq', 1, false);


--
-- Name: instytucje_medyczne_id_seq; Type: SEQUENCE SET; Schema: raporty; Owner: postgres
--

SELECT pg_catalog.setval('raporty.instytucje_medyczne_id_seq', 1, false);


--
-- Name: instytucje_szkoleniowe_id_seq; Type: SEQUENCE SET; Schema: raporty; Owner: postgres
--

SELECT pg_catalog.setval('raporty.instytucje_szkoleniowe_id_seq', 1, false);


--
-- Name: loty_id_seq; Type: SEQUENCE SET; Schema: raporty; Owner: postgres
--

SELECT pg_catalog.setval('raporty.loty_id_seq', 30, true);


--
-- Name: modele_maszyn_id_seq; Type: SEQUENCE SET; Schema: raporty; Owner: postgres
--

SELECT pg_catalog.setval('raporty.modele_maszyn_id_seq', 1, false);


--
-- Name: pracownicy_id_seq; Type: SEQUENCE SET; Schema: raporty; Owner: postgres
--

SELECT pg_catalog.setval('raporty.pracownicy_id_seq', 8, true);


--
-- Name: przeglady_id_seq; Type: SEQUENCE SET; Schema: raporty; Owner: postgres
--

SELECT pg_catalog.setval('raporty.przeglady_id_seq', 1, false);


--
-- Name: szkolenia_id_seq; Type: SEQUENCE SET; Schema: raporty; Owner: postgres
--

SELECT pg_catalog.setval('raporty.szkolenia_id_seq', 10, true);


--
-- Name: zespoly_id_seq; Type: SEQUENCE SET; Schema: raporty; Owner: postgres
--

SELECT pg_catalog.setval('raporty.zespoly_id_seq', 1, false);


--
-- Name: badania badania_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.badania
    ADD CONSTRAINT badania_pkey PRIMARY KEY (id);


--
-- Name: hangary hangary_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.hangary
    ADD CONSTRAINT hangary_pkey PRIMARY KEY (id);


--
-- Name: instytucje_medyczne instytucje_medyczne_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.instytucje_medyczne
    ADD CONSTRAINT instytucje_medyczne_pkey PRIMARY KEY (id);


--
-- Name: instytucje_szkoleniowe instytucje_szkoleniowe_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.instytucje_szkoleniowe
    ADD CONSTRAINT instytucje_szkoleniowe_pkey PRIMARY KEY (id);


--
-- Name: kategoria_lotow kategoria_lotow_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.kategoria_lotow
    ADD CONSTRAINT kategoria_lotow_pkey PRIMARY KEY (id);


--
-- Name: lotniska lotniska_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.lotniska
    ADD CONSTRAINT lotniska_pkey PRIMARY KEY (iata);


--
-- Name: loty loty_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.loty
    ADD CONSTRAINT loty_pkey PRIMARY KEY (id);


--
-- Name: maszyny maszyny_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.maszyny
    ADD CONSTRAINT maszyny_pkey PRIMARY KEY (rejestracja);


--
-- Name: modele_maszyn modele_maszyn_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.modele_maszyn
    ADD CONSTRAINT modele_maszyn_pkey PRIMARY KEY (id);


--
-- Name: pracownicy pracownicy_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.pracownicy
    ADD CONSTRAINT pracownicy_pkey PRIMARY KEY (id);


--
-- Name: przeglady przeglady_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.przeglady
    ADD CONSTRAINT przeglady_pkey PRIMARY KEY (id);


--
-- Name: szkolenia szkolenia_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.szkolenia
    ADD CONSTRAINT szkolenia_pkey PRIMARY KEY (id);


--
-- Name: zespoly zespoly_pkey; Type: CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.zespoly
    ADD CONSTRAINT zespoly_pkey PRIMARY KEY (id);


--
-- Name: idx_badania_data_aktualizacji; Type: INDEX; Schema: raporty; Owner: postgres
--

CREATE INDEX idx_badania_data_aktualizacji ON raporty.badania USING btree (data_aktualizacji);


--
-- Name: idx_badania_data_waznosci; Type: INDEX; Schema: raporty; Owner: postgres
--

CREATE INDEX idx_badania_data_waznosci ON raporty.badania USING btree (data_waznosci);


--
-- Name: idx_loty_godzina_ladowania; Type: INDEX; Schema: raporty; Owner: postgres
--

CREATE INDEX idx_loty_godzina_ladowania ON raporty.loty USING btree (godzina_ladowania);


--
-- Name: idx_loty_godzina_wylotu; Type: INDEX; Schema: raporty; Owner: postgres
--

CREATE INDEX idx_loty_godzina_wylotu ON raporty.loty USING btree (godzina_wylotu);


--
-- Name: idx_pracownicy_data_aktualizacji; Type: INDEX; Schema: raporty; Owner: postgres
--

CREATE INDEX idx_pracownicy_data_aktualizacji ON raporty.pracownicy USING btree (data_zatrudnienia);


--
-- Name: idx_pracownicy_data_waznosci; Type: INDEX; Schema: raporty; Owner: postgres
--

CREATE INDEX idx_pracownicy_data_waznosci ON raporty.pracownicy USING btree (data_zakonczenia);


--
-- Name: idx_przeglady_data_aktualizacji; Type: INDEX; Schema: raporty; Owner: postgres
--

CREATE INDEX idx_przeglady_data_aktualizacji ON raporty.przeglady USING btree (data_aktualizacji);


--
-- Name: idx_przeglady_data_waznosci; Type: INDEX; Schema: raporty; Owner: postgres
--

CREATE INDEX idx_przeglady_data_waznosci ON raporty.przeglady USING btree (data_waznosci);


--
-- Name: idx_szkolenia_data_aktualizacji; Type: INDEX; Schema: raporty; Owner: postgres
--

CREATE INDEX idx_szkolenia_data_aktualizacji ON raporty.szkolenia USING btree (data_aktualizacji);


--
-- Name: idx_szkolenia_data_waznosci; Type: INDEX; Schema: raporty; Owner: postgres
--

CREATE INDEX idx_szkolenia_data_waznosci ON raporty.szkolenia USING btree (data_waznosci);


--
-- Name: loty sprawdz_nakladanie_sie_lotow_trigger; Type: TRIGGER; Schema: raporty; Owner: postgres
--

CREATE TRIGGER sprawdz_nakladanie_sie_lotow_trigger BEFORE INSERT ON raporty.loty FOR EACH ROW EXECUTE FUNCTION public.sprawdz_nakladanie_sie_lotow();


--
-- Name: loty sprawdz_przekroczenie_nalotu_trigger; Type: TRIGGER; Schema: raporty; Owner: postgres
--

CREATE TRIGGER sprawdz_przekroczenie_nalotu_trigger AFTER INSERT ON raporty.loty FOR EACH ROW EXECUTE FUNCTION public.sprawdz_przekroczenie_nalotu();


--
-- Name: badania badania_id_instytucji_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.badania
    ADD CONSTRAINT badania_id_instytucji_fkey FOREIGN KEY (id_instytucji) REFERENCES raporty.instytucje_medyczne(id);


--
-- Name: badania badania_id_pracownika_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.badania
    ADD CONSTRAINT badania_id_pracownika_fkey FOREIGN KEY (id_pracownika) REFERENCES raporty.pracownicy(id);


--
-- Name: hangary hangary_lotnisko_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.hangary
    ADD CONSTRAINT hangary_lotnisko_fkey FOREIGN KEY (lotnisko) REFERENCES raporty.lotniska(iata);


--
-- Name: kierownicy kierownicy_id_pracownika_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.kierownicy
    ADD CONSTRAINT kierownicy_id_pracownika_fkey FOREIGN KEY (id_pracownika) REFERENCES raporty.pracownicy(id);


--
-- Name: kierownicy kierownicy_id_zespolu_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.kierownicy
    ADD CONSTRAINT kierownicy_id_zespolu_fkey FOREIGN KEY (id_zespolu) REFERENCES raporty.zespoly(id);


--
-- Name: loty loty_kategoria_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.loty
    ADD CONSTRAINT loty_kategoria_fkey FOREIGN KEY (kategoria) REFERENCES raporty.kategoria_lotow(id);


--
-- Name: loty loty_lotnisko_przylotu_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.loty
    ADD CONSTRAINT loty_lotnisko_przylotu_fkey FOREIGN KEY (lotnisko_przylotu) REFERENCES raporty.lotniska(iata);


--
-- Name: loty loty_lotnisko_wylotu_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.loty
    ADD CONSTRAINT loty_lotnisko_wylotu_fkey FOREIGN KEY (lotnisko_wylotu) REFERENCES raporty.lotniska(iata);


--
-- Name: loty loty_pilot1_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.loty
    ADD CONSTRAINT loty_pilot1_fkey FOREIGN KEY (pilot1) REFERENCES raporty.pracownicy(id);


--
-- Name: loty loty_pilot2_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.loty
    ADD CONSTRAINT loty_pilot2_fkey FOREIGN KEY (pilot2) REFERENCES raporty.pracownicy(id);


--
-- Name: loty loty_rejestracja_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.loty
    ADD CONSTRAINT loty_rejestracja_fkey FOREIGN KEY (rejestracja) REFERENCES raporty.maszyny(rejestracja);


--
-- Name: maszyny maszyny_id_modelu_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.maszyny
    ADD CONSTRAINT maszyny_id_modelu_fkey FOREIGN KEY (id_modelu) REFERENCES raporty.modele_maszyn(id);


--
-- Name: pracownicy pracownicy_zespol_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.pracownicy
    ADD CONSTRAINT pracownicy_zespol_fkey FOREIGN KEY (zespol) REFERENCES raporty.zespoly(id);


--
-- Name: przeglady przeglady_rejestracja_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.przeglady
    ADD CONSTRAINT przeglady_rejestracja_fkey FOREIGN KEY (rejestracja) REFERENCES raporty.maszyny(rejestracja);


--
-- Name: szkolenia szkolenia_id_instytucji_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.szkolenia
    ADD CONSTRAINT szkolenia_id_instytucji_fkey FOREIGN KEY (id_instytucji) REFERENCES raporty.instytucje_szkoleniowe(id);


--
-- Name: szkolenia szkolenia_id_pracownika_fkey; Type: FK CONSTRAINT; Schema: raporty; Owner: postgres
--

ALTER TABLE ONLY raporty.szkolenia
    ADD CONSTRAINT szkolenia_id_pracownika_fkey FOREIGN KEY (id_pracownika) REFERENCES raporty.pracownicy(id);


--
-- Name: DATABASE jednostka; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON DATABASE jednostka TO dowodca;
GRANT CONNECT ON DATABASE jednostka TO kierownik;
GRANT CONNECT ON DATABASE jednostka TO pilot;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO dowodca;


--
-- Name: SCHEMA raporty; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA raporty TO dowodca;
GRANT USAGE ON SCHEMA raporty TO kierownik;
GRANT USAGE ON SCHEMA raporty TO pilot;


--
-- Name: PROCEDURE dodaj_pracownika(IN p_zespol integer, IN p_imie character varying, IN p_nazwisko character varying, IN p_data_zatrudnienia date, IN p_data_zakonczenia date); Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON PROCEDURE raporty.dodaj_pracownika(IN p_zespol integer, IN p_imie character varying, IN p_nazwisko character varying, IN p_data_zatrudnienia date, IN p_data_zakonczenia date) TO dowodca;


--
-- Name: PROCEDURE zwolnij_pracownika(IN p_id_pracownika integer, IN p_data_zakonczenia date); Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON PROCEDURE raporty.zwolnij_pracownika(IN p_id_pracownika integer, IN p_data_zakonczenia date) TO dowodca;


--
-- Name: TABLE badania; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.badania TO dowodca;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE raporty.badania TO kierownik;
GRANT SELECT ON TABLE raporty.badania TO pilot;


--
-- Name: TABLE hangary; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.hangary TO dowodca;
GRANT SELECT ON TABLE raporty.hangary TO kierownik;
GRANT SELECT ON TABLE raporty.hangary TO pilot;


--
-- Name: TABLE instytucje_medyczne; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.instytucje_medyczne TO dowodca;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE raporty.instytucje_medyczne TO kierownik;
GRANT SELECT ON TABLE raporty.instytucje_medyczne TO pilot;


--
-- Name: TABLE instytucje_szkoleniowe; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.instytucje_szkoleniowe TO dowodca;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE raporty.instytucje_szkoleniowe TO kierownik;
GRANT SELECT ON TABLE raporty.instytucje_szkoleniowe TO pilot;


--
-- Name: TABLE kategoria_lotow; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.kategoria_lotow TO dowodca;
GRANT SELECT ON TABLE raporty.kategoria_lotow TO kierownik;
GRANT SELECT ON TABLE raporty.kategoria_lotow TO pilot;


--
-- Name: TABLE kierownicy; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.kierownicy TO dowodca;
GRANT SELECT ON TABLE raporty.kierownicy TO kierownik;
GRANT SELECT ON TABLE raporty.kierownicy TO pilot;


--
-- Name: TABLE lotniska; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.lotniska TO dowodca;
GRANT SELECT ON TABLE raporty.lotniska TO kierownik;
GRANT SELECT ON TABLE raporty.lotniska TO pilot;


--
-- Name: TABLE loty; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.loty TO dowodca;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE raporty.loty TO kierownik;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE raporty.loty TO pilot;


--
-- Name: TABLE maszyny; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.maszyny TO dowodca;
GRANT SELECT ON TABLE raporty.maszyny TO kierownik;
GRANT SELECT ON TABLE raporty.maszyny TO pilot;


--
-- Name: TABLE modele_maszyn; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.modele_maszyn TO dowodca;
GRANT SELECT ON TABLE raporty.modele_maszyn TO kierownik;
GRANT SELECT ON TABLE raporty.modele_maszyn TO pilot;


--
-- Name: TABLE pracownicy; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.pracownicy TO dowodca;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE raporty.pracownicy TO kierownik;
GRANT SELECT ON TABLE raporty.pracownicy TO pilot;


--
-- Name: TABLE przeglady; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.przeglady TO dowodca;
GRANT SELECT ON TABLE raporty.przeglady TO kierownik;
GRANT SELECT ON TABLE raporty.przeglady TO pilot;


--
-- Name: TABLE raport_miesieczny; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT SELECT ON TABLE raporty.raport_miesieczny TO dowodca;
GRANT SELECT ON TABLE raporty.raport_miesieczny TO kierownik;
GRANT SELECT ON TABLE raporty.raport_miesieczny TO pilot;


--
-- Name: TABLE sys_user_prac; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.sys_user_prac TO dowodca;
GRANT SELECT ON TABLE raporty.sys_user_prac TO kierownik;
GRANT SELECT ON TABLE raporty.sys_user_prac TO pilot;


--
-- Name: TABLE raport_miesieczny_zespol; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT SELECT ON TABLE raporty.raport_miesieczny_zespol TO dowodca;
GRANT SELECT ON TABLE raporty.raport_miesieczny_zespol TO kierownik;
GRANT SELECT ON TABLE raporty.raport_miesieczny_zespol TO pilot;


--
-- Name: TABLE raport_roczny; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT SELECT ON TABLE raporty.raport_roczny TO dowodca;
GRANT SELECT ON TABLE raporty.raport_roczny TO kierownik;
GRANT SELECT ON TABLE raporty.raport_roczny TO pilot;


--
-- Name: TABLE raport_roczny_zespol; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT SELECT ON TABLE raporty.raport_roczny_zespol TO dowodca;
GRANT SELECT ON TABLE raporty.raport_roczny_zespol TO kierownik;
GRANT SELECT ON TABLE raporty.raport_roczny_zespol TO pilot;


--
-- Name: TABLE szkolenia; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.szkolenia TO dowodca;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE raporty.szkolenia TO kierownik;
GRANT SELECT ON TABLE raporty.szkolenia TO pilot;


--
-- Name: TABLE waznosc_badan_lekarskich; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT SELECT ON TABLE raporty.waznosc_badan_lekarskich TO dowodca;


--
-- Name: TABLE waznosc_przegladow; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT SELECT ON TABLE raporty.waznosc_przegladow TO dowodca;


--
-- Name: TABLE waznosc_szkolen; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT SELECT ON TABLE raporty.waznosc_szkolen TO dowodca;


--
-- Name: TABLE zespoly; Type: ACL; Schema: raporty; Owner: postgres
--

GRANT ALL ON TABLE raporty.zespoly TO dowodca;
GRANT SELECT ON TABLE raporty.zespoly TO kierownik;
GRANT SELECT ON TABLE raporty.zespoly TO pilot;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0 (Debian 16.0-1.pgdg120+1)
-- Dumped by pg_dump version 16.0 (Debian 16.0-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

