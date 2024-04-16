//Vytvo�te si libovolnou tabulku, kter� budete m�t alespo� dva sloupce, p�i�em� jeden z nich bude prim�rn�m kl��em.
CREATE table LIBOVOLNA_TABULKA (
    LIBOVOLNA_TABULKA_ID   NUMBER NOT NULL,
    LIBIVOLNY_TEXT      VARCHAR2(500) NOT NULL
);

//Do vytvo�en� tabulky vlo�te n�kolik z�znam�.
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (1,'Nejaky prvni text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (2,'Nejaky druhy text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (3,'Nejaky treti text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (4,'Nejaky ctvrty text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (5,'Nejaky paty text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (6,'Nejaky sesty text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (7,'Nejaky sedmy text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (8,'Nejaky osmy text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (9,'Nejaky devaty text');

//Pomoc� nepojmenovan�ho bloku vypi�te Ahoj.
DECLARE
  pozdrav VARCHAR2(20);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Ahoj');
END;

//Pomoc� nepojmenovan�ho bloku deklarujte prom�nnou libovoln�ho typu. P�i�a�te ji hodnotu odpov�daj�c� zvolen�mu typu. Vypi�te obsah prom�nn�.
DECLARE
  prom integer;
BEGIN
    prom:=10;
    DBMS_OUTPUT.PUT_LINE(prom);
END;

//Vytvo�te nov� blok a pojmenujte ho vnejsi. Deklarujte v n�m prom�nn� jmeno_vedouciho a plat. P�i�a�te
//jim konkr�tn� hodnoty. Uvnit� bloku vnejsi vytvo�te nov� nepojmenovan� blok. Pro n�j deklarujte prom�nn� jmeno_zamestnance a plat. P�i�a�te jim konkr�tn� hodnoty. V r�mci vnit�n�ho bloku vypi�te
//jm�no a plat vedouc�ho i zam�stnance.
DECLARE
  jmeno_vedouciho VARCHAR2(50) := 'Jan Nov�k';
  plat_vedouciho NUMBER := 5000;
BEGIN
  DECLARE
    jmeno_zamestnance VARCHAR2(50) := 'Petr Dvo��k';
    plat_zamestnance NUMBER := 3000;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Jm�no vedouc�ho: ' || jmeno_vedouciho || ', plat: ' || plat_vedouciho);
    DBMS_OUTPUT.PUT_LINE('Jm�no zam�stnance: ' || jmeno_zamestnance || ', plat: ' || plat_zamestnance);
  END;
END;

//Z t�� zadan�ch stran troj�heln�ka zjist�te, zda je mo�n� troj�heln�k zkonstruovat. Pokud to mo�n� je, vypi�te jeho obvod. 
DECLARE
    a integer;
    b integer;
    c integer;
BEGIN
    a:=10;
    b:=100;
    c:=10;
    IF a+b<c AND b+c<a AND a+c<b THEN
        DBMS_OUTPUT.PUT_LINE('lze');
    ELSE
        DBMS_OUTPUT.PUT_LINE('nelze');
    END IF;
END;

//P�idejte informaci o tom, je-li troj�heln�k rovnostrann�, pravo�hl� nebo rovnoramenn�.
DECLARE
    a integer;
    b integer;
    c integer;
BEGIN
    a:=3;
    b:=4;
    c:=5;
    IF a+b>c AND b+c>a AND a+c>b THEN
        DBMS_OUTPUT.PUT_LINE('lze');
        IF a = b OR b = c OR a = c THEN
            DBMS_OUTPUT.PUT_LINE('je rovnoramenn�');
        END IF;
        IF a = b AND a = c AND b = c THEN
            DBMS_OUTPUT.PUT_LINE('je rovnostrann�');
        END IF;
        IF a*a + b*b= c*c OR b*b + c*c = a*a OR c*c + a*a = b*b THEN
            DBMS_OUTPUT.PUT_LINE('je pravo�hl�');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('nelze');
    END IF;
END;