//Pomoc� nepojmenovan�ho bloku spo��tejte faktori�l 5.
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

//Pomoc� nepojmenovan�ho bloku zjist�te, pr�m�rn� p��jmy mu�� a �en. Pokud maj� vy��� plat �eny, vypi�te:
//"�eny maj� vy��� p��jem." Pokud maj� vy��� pr�m�rn� p��jem mu�i, vypi�te: "Mu�i berou v�ce." V p��pad�, �e se
//pr�m�ry rovnaj�, vypi�te: "Je to rem�za." 
DECLARE
prumerny_plat_muzi NUMBER := 0;
prumerny_plat_zeny NUMBER := 0;
BEGIN
SELECT AVG(prijem) INTO prumerny_plat_muzi FROM osoby2 WHERE pohlavi = 'mu�';
SELECT AVG(prijem) INTO prumerny_plat_zeny FROM osoby2 WHERE pohlavi = '�ena';
if prumerny_plat_zeny > prumerny_plat_muzi THEN dbms_output.put_line('�eny maj� vy��� p��jem');
elsif prumerny_plat_muzi > prumerny_plat_zeny THEN dbms_output.put_line('Mu�i maj� vy��� p��jem');
else dbms_output.put_line('Je to rem�za');
END IF;
END;

//Pomoc� nepojmenovan�ho bloku spo��tejte pr�m�rnou v��ku v jednotliv�ch kraj�ch zaokrouhlenou na cel�
//��sla. Pokud je toto ��slo d�liteln� t�emi beze zbytku, vypi�te n�zev kraje velk�mi p�smeny. Pokud je zbytek po
//d�len� t�emi jedna, pak n�zev kraje vypi�te s velk�mi p�smeny na za��tku ka�d�ho slova. V ostatn�ch p��padech
//vypi�te n�zev kraje mal�mi p�smeny. V�dy p�ipojte i zaokrouhlen� pr�m�r.
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
    // N E B O | 2. �e�en�
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
    // N E B O | 3. �e�en�
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

//Pomoc� nepojmenovan�ho bloku simulujte korelovan� poddotaz, tak �e vyp�ete osoby (id a p��jem) s nadpr�m�rn�m p��jmem v r�mci jejich kraje. Nejprve sestavte SQL dotaz a n�sledn� sestavte skript. V r�mci skriptu v�ak
//v�dy nejprve vypi�te n�zev kraje a pr�m�rn� p��jem zaokrouhlen� na 2 desetinn� m�sta. Kraje �a�te abecedn�.
//Osoby v kraj�ch pak podle v��e p��jmu od nejmen��ho.
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

//Vytvo�te funkci, kter� se bude chovat stejn� jako funkce NVL2 bez pou�it� t�to funkce
CREATE OR REPLACE FUNCTION moje_NVL2(p1 VARCHAR2,p2 VARCHAR2,p3 VARCHAR2) RETURN VARCHAR2 AS
BEGIN
    IF p1 IS NOT NULL THEN
        RETURN p2;
    ELSE
        RETURN p3;
    END IF;
END;
SELECT moje_NVL2('null','abc','xyz') FROM dual;    

//Vytvo�te funkci prvo��slo, kter� na z�klad� vstupn�ho parametru ur��, zda se jedn� o prvo��slo. Pokud zadan�
//��slo bude prvo��slo, funkce vr�t� hodnotu 1. Pokud p�edan� parametr nebude prvo��slo, funkce vr�t� hodnotu 0.
//Tato funkce bude vyhodnocovat pouze p�irozen� ��sla. Pokud u�ivatel zad� jin� ne� p�irozen� ��slo, funkce vyhod� v�jimku -20001 s textem �Nen� prirozene ��slo.�
CREATE OR REPLACE FUNCTION prvocislo(cislo NUMBER) RETURN NUMBER AS // CHYBA!!!!!
v_delitel INTEGER := 2;
BEGIN
    IF cislo < 1 OR cislo != round(cislo) THEN
        RAISE_APPLICATION_ERROR(-20001,'Nen� p�irozen� ��slo');
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

//Vytvo�te proceduru kraje_povolani s parametrem po�et. V�stupem t�to procedury bude seznam kraj� a u nich
//v�echna povol�n�, kter� se v kraji vyskytuj� v po�tu alespo� po�et. V�pis bude n�sleduj�c�:
//Hlavn� m�sto Praha
//- ostatn�; d�chodce; zam�stnanec;
//Jihomoravsk� kraj
//- d�chodce; zam�stnanec; OSV�;
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

//Vytvo�te funkci, kter� na z�klad� parametru kraj, ��slo ot�zky a odpov�� vr�t� id a p��jem osoby. O�et�ete
//p��pad, �e takov�ch osob bude v�ce, nebo �e takov� osoba nebude ani jedna.
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

//Vytvo�te proceduru pro smazan� ��dku z tabulky osoby. Procedura bude m�t jeden parametr (p��jem). Pokud
//��dn� ��dek neobsahuje v sloupci prijem danou hodnotu, vyvol�te v�jimku, kterou zpracujete. V p��pad� �sp�n�ho smaz�n� se vyp�e, kolik z�znam� bylo smaz�no.
CREATE OR REPLACE PROCEDURE smazat_osobu (p_prijem INTEGER) IS
    v_pocet_smazanych NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_pocet_smazanych
    FROM osoby2
    WHERE prijem = p_prijem;
    IF v_pocet_smazanych = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nebyl nalezen ��dn� z�znam s danou hodnotou v sloupci prijem.');
    ELSE
        DELETE FROM osoby2 WHERE prijem = p_prijem;
        DBMS_OUTPUT.PUT_LINE('Bylo smaz�no ' || v_pocet_smazanych || ' z�znam�.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Chyba: ' || SQLERRM);
END;
EXECUTE smazat_osobu(50000);

//Vytvo�te proceduru pro �pravu n�zvu kraje na z�klad� p�ed�van�ho id a nov�ho n�zvu. Je-li zad�no neexistuj�c� id, vyvolejte error s ��slem -20917 a chybovou hl�kou "Pokus o �pravu neexistuj�c�ho kraje."
//a v ��sti v�jimek tuto chybu odchytn�te a o�et�ete.
CREATE OR REPLACE PROCEDURE uprav_kraj (p_id kraje.kraje_id%TYPE, p_nazev VARCHAR2) IS
BEGIN
    UPDATE kraje SET nazev = p_nazev WHERE kraje_id = p_id;
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20917, 'Pokus o �pravu neeistuj�c�ho kraje.');
    END IF;
END;

//Vytvo�te spou��, kter� aby se p��jem mohl zm�nit maxim�lm� o 20%.
CREATE OR REPLACE TRIGGER zmena_prijmu
BEFORE UPDATE OF prijem ON osoby2
FOR EACH ROW
DECLARE
    v_max_zmena NUMBER;
BEGIN
    v_max_zmena := :OLD.prijem * 0.2;

    IF (:NEW.prijem - :OLD.prijem) > v_max_zmena THEN
        RAISE_APPLICATION_ERROR(-20001, 'P��jem nelze zm�nit o v�ce ne� 20%.');
    END IF;
END;

//Upravte p�edchoz� spou�� tak, aby nevyhazovala v�jimku, ale aby nastavila prijem na maxim�ln� zm�nu
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

