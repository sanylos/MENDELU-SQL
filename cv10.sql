//Pomocí nepojmenovaného bloku spoèítejte faktoriál 5.
DECLARE
    p_res NUMBER := 1;
    v_cis INTEGER := 5;
BEGIN
    LOOP
        EXIT WHEN v_cis < 2;
        p_res := p_res * v_cis;
        v_cis := v_cis - 1;
    END LOOP;
    dbms_output.put_line(p_res);
END;

//Pomocí nepojmenovaného bloku zjistìte, prùmìrné pøíjmy mužù a žen. Pokud mají vyšší plat ženy, vypište:
//"Ženy mají vyšší pøíjem." Pokud mají vyšší prùmìrný pøíjem muži, vypište: "Muži berou více." V pøípadì, že se
//prùmìry rovnají, vypište: "Je to remíza." 
DECLARE
prumerny_plat_muzi NUMBER := 0;
prumerny_plat_zeny NUMBER := 0;
BEGIN
SELECT AVG(prijem) INTO prumerny_plat_muzi FROM osoby2 WHERE pohlavi = 'muž';
SELECT AVG(prijem) INTO prumerny_plat_zeny FROM osoby2 WHERE pohlavi = 'žena';
if prumerny_plat_zeny > prumerny_plat_muzi THEN dbms_output.put_line('Ženy mají vyšší pøíjem');
elsif prumerny_plat_muzi > prumerny_plat_zeny THEN dbms_output.put_line('Muži mají vyšší pøíjem');
else dbms_output.put_line('Je to remíza');
END IF;
END;

//Pomocí nepojmenovaného bloku spoèítejte prùmìrnou výšku v jednotlivých krajích zaokrouhlenou na celá
//èísla. Pokud je toto èíslo dìlitelné tøemi beze zbytku, vypište název kraje velkými písmeny. Pokud je zbytek po
//dìlení tøemi jedna, pak název kraje vypište s velkými písmeny na zaèátku každého slova. V ostatních pøípadech
//vypište název kraje malými písmeny. Vždy pøipojte i zaokrouhlený prùmìr.
DECLARE
prumerna_vyska NUMBER := 0;
kraj VARCHAR2(30) := '';
BEGIN
FOR i IN 1..14 LOOP
SELECT FLOOR(AVG(vyska)) INTO prumerna_vyska FROM osoby2
JOIN kraje k USING(kraje_id)
WHERE kraje_id = i;
SELECT nazev INTO kraj FROM kraje WHERE kraje_id = i;
IF MOD(prumerna_vyska,3) = 0 THEN dbms_output.put_line(UPPER(kraj));
ELSIF MOD(prumerna_vyska,3) = 3 THEN dbms_output.put_line(INITCAP(kraj));
ELSE dbms_output.put_line(lower(kraj));
END IF;
END LOOP;
END;
    // N E B O | 2. øešení
DECLARE
CURSOR cur_vysky IS
    SELECT nazev, floor(avg(vyska)) prum
    FROM osoby2 JOIN kraje USING(kraje_id)
    GROUP BY nazev;
r_vysky cur_vysky%ROWTYPE;
BEGIN
    OPEN cur_vysky;
    LOOP
        FETCH cur_vysky INTO r_vysky;
        EXIT WHEN cur_vysky%NOTFOUND;
        CASE r_vysky.prum MOD 3
            WHEN 0 THEN dbms_output.put_line(upper(r_vysky.nazev) || ' ' || r_vysky.prum);
            WHEN 1 THEN dbms_output.put_line(initcap(r_vysky.nazev) || ' ' || r_vysky.prum);
            ELSE dbms_output.put_line(lower(r_vysky.nazev)|| ' ' || r_vysky.prum);
        END CASE;
    END LOOP;
    CLOSE cur_vysky;
END;
    // N E B O | 3. øešení
DECLARE
CURSOR cur_vysky IS
    SELECT nazev, floor(avg(vyska)) prum
    FROM osoby2 JOIN kraje USING(kraje_id)
    GROUP BY nazev;
BEGIN
    FOR r_vysky IN cur_vysky LOOP
        CASE r_vysky.prum MOD 3
            WHEN 0 THEN dbms_output.put_line(upper(r_vysky.nazev) || ' ' || r_vysky.prum);
            WHEN 1 THEN dbms_output.put_line(initcap(r_vysky.nazev) || ' ' || r_vysky.prum);
            ELSE dbms_output.put_line(lower(r_vysky.nazev)|| ' ' || r_vysky.prum);
        END CASE;
    END LOOP;
END;

//Pomocí nepojmenovaného bloku simulujte korelovaný poddotaz, tak že vypíšete osoby (id a pøíjem) s nadprùmìrným pøíjmem v rámci jejich kraje. Nejprve sestavte SQL dotaz a následnì sestavte skript. V rámci skriptu však
//vždy nejprve vypište název kraje a prùmìrný pøíjem zaokrouhlený na 2 desetinná místa. Kraje øaïte abecednì.
//Osoby v krajích pak podle výše pøíjmu od nejmenšího.
DECLARE
CURSOR cur_prijmy IS
    SELECT nazev, round(avg(prijem),2) prum, kraje_id
    FROM osoby2 JOIN kraje USING(kraje_id)
    GROUP BY nazev, kraje_id
    ORDER BY lower(nazev);
CURSOR cur_osoby(p_kraj kraje.kraje_id%TYPE,p_prum NUMBER) IS
    SELECT osoby_id, prijem FROM osoby2
    WHERE kraje_id = p_kraj AND prijem > p_prum
    ORDER BY prijem DESC;
BEGIN
    FOR r_prijmy IN cur_prijmy LOOP
    dbms_output.put_line(r_prijmy.nazev ||' '|| r_prijmy.prum);
    dbms_output.put_line('-----------------------------------');
        FOR r_osoby IN cur_osoby(r_prijmy.kraje_id,r_prijmy.prum) LOOP
            dbms_output.put_line(r_osoby.osoby_id || ' >> ' || r_osoby.prijem);
        END LOOP;
    END LOOP;
END;

//Vytvoøte funkci, která se bude chovat stejnì jako funkce NVL2 bez použití této funkce
CREATE OR REPLACE FUNCTION moje_NVL2(p1 VARCHAR2,p2 VARCHAR2,p3 VARCHAR2) RETURN VARCHAR2 AS
BEGIN
    IF p1 IS NOT NULL THEN
        RETURN p2;
    ELSE
        RETURN p3;
    END IF;
END;
SELECT moje_NVL2('null','abc','xyz') FROM dual;    

//Vytvoøte funkci prvoèíslo, která na základì vstupního parametru urèí, zda se jedná o prvoèíslo. Pokud zadané
//èíslo bude prvoèíslo, funkce vrátí hodnotu 1. Pokud pøedaný parametr nebude prvoèíslo, funkce vrátí hodnotu 0.
//Tato funkce bude vyhodnocovat pouze pøirozená èísla. Pokud uživatel zadá jiné než pøirozené èíslo, funkce vyhodí výjimku -20001 s textem „Není prirozene èíslo.“
CREATE OR REPLACE FUNCTION prvocislo(cislo NUMBER) RETURN NUMBER AS // CHYBA!!!!!
v_delitel INTEGER := 2;
BEGIN
    IF cislo < 1 OR cislo != round(cislo) THEN
        RAISE_APPLICATION_ERROR(-20001,'Není pøirozené èíslo');
    ELSE
        WHILE (SQRT(cislo) >= v_delitel AND cislo MOD v_delitel != 0) LOOP
            v_delitel := v_delitel+1;
        END LOOP;
    END IF;
    IF SQRT(cislo)>=v_delitel THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
    END IF;
END;
select prvocislo(6) FROM dual;

//Vytvoøte proceduru kraje_povolani s parametrem poèet. Výstupem této procedury bude seznam krajù a u nich
//všechna povolání, která se v kraji vyskytují v poètu alespoò poèet. Výpis bude následující:
//Hlavní mìsto Praha
//- ostatní; dùchodce; zamìstnanec;
//Jihomoravský kraj
//- dùchodce; zamìstnanec; OSVÈ;
//...
CREATE OR REPLACE PROCEDURE kraje_povolani(p_pocet INTEGER) IS
    CURSOR cur_kraje IS
        SELECT * from kraje;
    CURSOR cur_povolani(p_kraj kraje.kraje_id%TYPE) IS
        SELECT nazev
        FROM povolani
        JOIN osoby2 USING(povolani_id)
        WHERE kraje_id=p_kraj
        GROUP BY nazev
        HAVING count(*)>=p_pocet;
BEGIN
    FOR r_kraje IN cur_kraje LOOP
        DBMS_OUTPUT.put_line(r_kraje.nazev);
        DBMS_OUTPUT.put(' - ');
        FOR r_povolani IN cur_povolani(r_kraje.kraje_id) LOOP
            DBMS_OUTPUT.put(r_povolani.nazev||'; ');
        END LOOP;
        DBMS_OUTPUT.put_line(NULL);
    END LOOP; 
END;
EXECUTE kraje_povolani(4);

//Vytvoøte funkci, která na základì parametru kraj, èíslo otázky a odpovìï vrátí id a pøíjem osoby. Ošetøete
//pøípad, že takových osob bude více, nebo že taková osoba nebude ani jedna.
CREATE OR REPLACE FUNCTION kdo(p_kraj kraje.kraje_id%TYPE, p_otazka otazky.otazky_id%TYPE, p_odpoved moznosti.moznosti_id%TYPE) RETURN VARCHAR2 IS
    v_id osoby2.osoby_id%TYPE;
    v_prijem osoby2.prijem%TYPE;
BEGIN
    SELECT osoby_id, prijem INTO v_id, v_prijem
    FROM osoby2 JOIN odpovedi USING (osoby_id)
    WHERE kraje_id = p_kraj AND otazky_id = p_otazka AND moznosti_id = p_odpoved;
    RETURN v_id||' - '||v_prijem;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN RETURN 'Moc';
    WHEN NO_DATA_FOUND THEN RETURN 'Nikdo';
END;

SELECT kdo(1,1,1) FROM dual;
SELECT kdo(16,12,1) FROM dual;

//Vytvoøte proceduru pro smazaní øádku z tabulky osoby. Procedura bude mít jeden parametr (pøíjem). Pokud
//žádný øádek neobsahuje v sloupci prijem danou hodnotu, vyvoláte výjimku, kterou zpracujete. V pøípadì úspìšného smazání se vypíše, kolik záznamù bylo smazáno.
CREATE OR REPLACE PROCEDURE smazat_osobu (p_prijem INTEGER) IS
    v_pocet_smazanych NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_pocet_smazanych
    FROM osoby2
    WHERE prijem = p_prijem;
    IF v_pocet_smazanych = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nebyl nalezen žádný záznam s danou hodnotou v sloupci prijem.');
    ELSE
        DELETE FROM osoby2 WHERE prijem = p_prijem;
        DBMS_OUTPUT.PUT_LINE('Bylo smazáno ' || v_pocet_smazanych || ' záznamù.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Chyba: ' || SQLERRM);
END;
EXECUTE smazat_osobu(50000);

//Vytvoøte proceduru pro úpravu názvu kraje na základì pøedávaného id a nového názvu. Je-li zadáno neexistující id, vyvolejte error s èíslem -20917 a chybovou hláškou "Pokus o úpravu neexistujícího kraje."
//a v èásti výjimek tuto chybu odchytnìte a ošetøete.
CREATE OR REPLACE PROCEDURE uprav_kraj (p_id kraje.kraje_id%TYPE, p_nazev VARCHAR2) IS
BEGIN
    UPDATE kraje SET nazev = p_nazev WHERE kraje_id = p_id;
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20917, 'Pokus o úpravu neeistujícího kraje.');
    END IF;
END;

//Vytvoøte spouš, která aby se pøíjem mohl zmìnit maximálmì o 20%.
CREATE OR REPLACE TRIGGER zmena_prijmu
BEFORE UPDATE OF prijem ON osoby2
FOR EACH ROW
DECLARE
    v_max_zmena NUMBER;
BEGIN
    v_max_zmena := :OLD.prijem * 0.2;

    IF (:NEW.prijem - :OLD.prijem) > v_max_zmena THEN
        RAISE_APPLICATION_ERROR(-20001, 'Pøíjem nelze zmìnit o více než 20%.');
    END IF;
END;

//Upravte pøedchozí spouš tak, aby nevyhazovala výjimku, ale aby nastavila prijem na maximální zmìnu
//o 20%.
CREATE OR REPLACE TRIGGER zmena_prijmu
BEFORE UPDATE OF prijem ON osoby2
FOR EACH ROW
BEGIN
    IF (:NEW.prijem > :OLD.prijem * 0.2) THEN
        :NEW.prijem := :OLD.prijem * 1.2;
    ELSIF (:NEW.prijem < :OLD.prijem * 0.8) THEN
        :NEW.prijem := :OLD.prijem * 0.8;
    END IF;
END;

