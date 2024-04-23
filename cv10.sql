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