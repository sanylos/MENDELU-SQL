//Vytvoøte si libovolnou tabulku, která budete mít alespoò dva sloupce, pøièemž jeden z nich bude primárním klíèem.
CREATE table LIBOVOLNA_TABULKA (
    LIBOVOLNA_TABULKA_ID   NUMBER NOT NULL,
    LIBIVOLNY_TEXT      VARCHAR2(500) NOT NULL
);

//Do vytvoøené tabulky vložte nìkolik záznamù.
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (1,'Nejaky prvni text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (2,'Nejaky druhy text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (3,'Nejaky treti text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (4,'Nejaky ctvrty text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (5,'Nejaky paty text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (6,'Nejaky sesty text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (7,'Nejaky sedmy text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (8,'Nejaky osmy text');
INSERT INTO LIBOVOLNA_TABULKA (LIBOVOLNA_TABULKA_ID, LIBIVOLNY_TEXT) VALUES (9,'Nejaky devaty text');

//Pomocí nepojmenovaného bloku vypište Ahoj.
DECLARE
  pozdrav VARCHAR2(20);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Ahoj');
END;

//Pomocí nepojmenovaného bloku deklarujte promìnnou libovolného typu. Pøiøaïte ji hodnotu odpovídající zvolenému typu. Vypište obsah promìnné.
DECLARE
  prom integer;
BEGIN
    prom:=10;
    DBMS_OUTPUT.PUT_LINE(prom);
END;

//Vytvoøte nový blok a pojmenujte ho vnejsi. Deklarujte v nìm promìnné jmeno_vedouciho a plat. Pøiøaïte
//jim konkrétní hodnoty. Uvnitø bloku vnejsi vytvoøte nový nepojmenovaný blok. Pro nìj deklarujte promìnné jmeno_zamestnance a plat. Pøiøaïte jim konkrétní hodnoty. V rámci vnitøního bloku vypište
//jméno a plat vedoucího i zamìstnance.
DECLARE
  jmeno_vedouciho VARCHAR2(50) := 'Jan Novák';
  plat_vedouciho NUMBER := 5000;
BEGIN
  DECLARE
    jmeno_zamestnance VARCHAR2(50) := 'Petr Dvoøák';
    plat_zamestnance NUMBER := 3000;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Jméno vedoucího: ' || jmeno_vedouciho || ', plat: ' || plat_vedouciho);
    DBMS_OUTPUT.PUT_LINE('Jméno zamìstnance: ' || jmeno_zamestnance || ', plat: ' || plat_zamestnance);
  END;
END;

//Z tøí zadaných stran trojúhelníka zjistìte, zda je možné trojúhelník zkonstruovat. Pokud to možné je, vypište jeho obvod. 
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

//Pøidejte informaci o tom, je-li trojúhelník rovnostranný, pravoúhlý nebo rovnoramenný.
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
            DBMS_OUTPUT.PUT_LINE('je rovnoramenný');
        END IF;
        IF a = b AND a = c AND b = c THEN
            DBMS_OUTPUT.PUT_LINE('je rovnostranný');
        END IF;
        IF a*a + b*b= c*c OR b*b + c*c = a*a OR c*c + a*a = b*b THEN
            DBMS_OUTPUT.PUT_LINE('je pravoúhlý');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('nelze');
    END IF;
END;