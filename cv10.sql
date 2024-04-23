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