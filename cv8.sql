CREATE table POVOLANI (
    POVOLANI_ID NUMBER NOT NULL,
    NAZEV       VARCHAR2(50) NOT NULL,
    constraint  POVOLANI_PK primary key (POVOLANI_ID)
);

CREATE table KRAJE (
    KRAJE_ID   NUMBER NOT NULL,
    NAZEV      VARCHAR2(50) NOT NULL,
    constraint  KRAJE_PK primary key (KRAJE_ID)
);

CREATE table OTAZKY (
    OTAZKY_ID   NUMBER NOT NULL,
    TEXT      VARCHAR2(500) NOT NULL,
    constraint  OTAZKY_PK primary key (OTAZKY_ID)
);

CREATE table MOZNOSTI (
    MOZNOSTI_ID   NUMBER NOT NULL,
    TEXT      VARCHAR2(500) NOT NULL,
    constraint  MOZNOSTI_PK primary key (MOZNOSTI_ID)
);

CREATE table OSOBY2 (
    OSOBY_ID    NUMBER NOT NULL,
    VEK         NUMBER NOT NULL,
    POHLAVI     VARCHAR2(4 CHAR) NOT NULL,
    VYSKA       NUMBER,
    VAHA        NUMBER,
    PRIJEM      NUMBER,
    POVOLANI_ID NUMBER NOT NULL,
    KRAJE_ID    NUMBER NOT NULL,
    constraint  OSOBY_PK primary key (OSOBY_ID)
);

ALTER TABLE OSOBY2 ADD CONSTRAINT OSOBY_FK1 
FOREIGN KEY (KRAJE_ID)
REFERENCES KRAJE (KRAJE_ID);

ALTER TABLE OSOBY2 ADD CONSTRAINT OSOBY_FK2 
FOREIGN KEY (POVOLANI_ID)
REFERENCES POVOLANI (POVOLANI_ID);

CREATE table OTAZKY_MOZNOSTI (
    OTAZKY_ID   NUMBER NOT NULL,
    MOZNOSTI_ID   NUMBER NOT NULL,
    constraint  OTAZKY_MOZNOSTI_PK primary key (OTAZKY_ID, MOZNOSTI_ID)
);

ALTER TABLE OTAZKY_MOZNOSTI ADD CONSTRAINT OTAZKY_MOZNOSTI_FK1 
FOREIGN KEY (OTAZKY_ID)
REFERENCES OTAZKY (OTAZKY_ID);

ALTER TABLE OTAZKY_MOZNOSTI ADD CONSTRAINT OTAZKY_MOZNOSTI_FK2 
FOREIGN KEY (MOZNOSTI_ID)
REFERENCES MOZNOSTI (MOZNOSTI_ID);

CREATE table ODPOVEDI (
    OTAZKY_ID   NUMBER NOT NULL,
    MOZNOSTI_ID   NUMBER NOT NULL,
    OSOBY_ID    NUMBER NOT NULL,
    constraint  ODPOVEDI_PK primary key (OTAZKY_ID, OSOBY_ID)
);

ALTER TABLE ODPOVEDI ADD CONSTRAINT ODPOVEDI_FK1 
FOREIGN KEY (OTAZKY_ID)
REFERENCES OTAZKY (OTAZKY_ID);

ALTER TABLE ODPOVEDI ADD CONSTRAINT ODPOVEDI_FK2 
FOREIGN KEY (MOZNOSTI_ID)
REFERENCES MOZNOSTI (MOZNOSTI_ID);

ALTER TABLE ODPOVEDI ADD CONSTRAINT ODPOVEDI_FK3 
FOREIGN KEY (OSOBY_ID)
REFERENCES OSOBY2 (OSOBY_ID);

//Vytvo�te pohled (starsi30), kter� umo�n� p��stup jen k osob�m star��m t�iceti let.
create or replace view starsi30 as
select * from osoby2 where vek > 30;

//Vlo�te pomoc� pohledu starsi30 vlo�te t�iadvacetiletou studentku z Prahy i id 1000.
insert into starsi30 (osoby_id, vek, pohlavi, kraje_id, povolani_id) 
values (1000,23,'�ena',(select kraje_id from kraje where nazev = 'Hlavn� m�sto Praha'),(select povolani_id from povolani where nazev='student'));

//Upravte pohled tak, abyste nemohli vkl�dat jin� data, ne� pohled zobrazuje.
create or replace view starsi30 as
select * from osoby2 where vek > 30
with check option;

//Sma�te prost�ednictv�m pohledu p�idan� osoby.
delete from starsi30 where osoby_id = 1000;

//Vytvo�te pohled, kter� bude zobrazovat kompletn� vypln�n� dotazn�ky ve form�:
//informace o osob�, odpov��1, ... odpov��12.
CREATE OR REPLACE VIEW dotaznik (osoba,vek,pohlavi,vyska,vaha,prijem,otazka1,otazka2,otazka3,otazka4,otazka5,otazka6,otazka7,otazka8,otazka9,otazka10,otazka11,otazka12)
AS
SELECT osoby_id,vek,pohlavi,vyska,vaha,prijem,o1.text,o2.text,o3.text,o4.text,o5.text,o6.text,o7.text,o8.text,o9.text,o10.text,o11.text,o12.text FROM osoby2
LEFT JOIN(SELECT moznosti.text, osoby_id FROM odpovedi
JOIN moznosti USING(moznosti_id)
WHERE otazky_id = 1) o1 USING(osoby_id)
LEFT JOIN(SELECT moznosti.text, osoby_id FROM odpovedi
JOIN moznosti USING(moznosti_id)
WHERE otazky_id = 2) o2 USING(osoby_id)
LEFT JOIN(SELECT moznosti.text, osoby_id FROM odpovedi
JOIN moznosti USING(moznosti_id)
WHERE otazky_id = 3) o3 USING(osoby_id)
LEFT JOIN(SELECT moznosti.text, osoby_id FROM odpovedi
JOIN moznosti USING(moznosti_id)
WHERE otazky_id = 4) o4 USING(osoby_id)
LEFT JOIN(SELECT moznosti.text, osoby_id FROM odpovedi
JOIN moznosti USING(moznosti_id)
WHERE otazky_id = 5) o5 USING(osoby_id)
LEFT JOIN(SELECT moznosti.text, osoby_id FROM odpovedi
JOIN moznosti USING(moznosti_id)
WHERE otazky_id = 6) o6 USING(osoby_id)
LEFT JOIN(SELECT moznosti.text, osoby_id FROM odpovedi
JOIN moznosti USING(moznosti_id)
WHERE otazky_id = 7) o7 USING(osoby_id)
LEFT JOIN(SELECT moznosti.text, osoby_id FROM odpovedi
JOIN moznosti USING(moznosti_id)
WHERE otazky_id = 8) o8 USING(osoby_id)
LEFT JOIN(SELECT moznosti.text, osoby_id FROM odpovedi
JOIN moznosti USING(moznosti_id)
WHERE otazky_id = 9) o9 USING(osoby_id)
LEFT JOIN(SELECT moznosti.text, osoby_id FROM odpovedi
JOIN moznosti USING(moznosti_id)
WHERE otazky_id = 10) o10 USING(osoby_id)
LEFT JOIN(SELECT moznosti.text, osoby_id FROM odpovedi
JOIN moznosti USING(moznosti_id)
WHERE otazky_id = 11) o11 USING(osoby_id)
LEFT JOIN(SELECT moznosti.text, osoby_id FROM odpovedi
JOIN moznosti USING(moznosti_id)
WHERE otazky_id = 12) o12 USING(osoby_id);

select count(otazka1),count(otazka2),count(otazka3),count(otazka4) from dotaznik;

//Vytvo�te kopii tabulky osoby, do tabulky vlo�te v�echny osoby, kter� bydl� v
//Karlovarsk�m kraji. V�em osob�m v t�to tabulce zdvojn�sobte p��jem.
CREATE OR REPLACE VIEW osoby_karlovarsky AS
SELECT * FROM osoby2
WHERE kraje_id = (SELECT kraje_id FROM kraje WHERE nazev = 'Karlovarsk� kraj');

select * from osoby_karlovarsky;

// Z tabulky osoby vlo�te do tabulky kopie osoby v�echny d�chodce, v p��pad�, �e se v
//tabulce osoba ji� vyskytuje, upravte data podle tabulky osoby, v p��pad�, �e se v
//tabulce kopie nevyskytuje tato data vlo�te.
create table kopie_osoby as 
select osoby_id,vek,pohlavi,vyska,vaha,prijem*2 as prijem, povolani_id, kraje_id from osoby2 where kraje_id = 4;

MERGE INTO kopie_osoby USING
    (select * FROM osoby2 WHERE povolani_id=(SELECT povolani_id FROM povolani WHERE nazev='d�chodce')) duchodce
    ON(kopie_osoby.osoby_id=duchodce.osoby_id)
    WHEN MATCHED THEN
        UPDATE SET
        kopie_osoby.prijem = duchodce.prijem
    WHEN NOT MATCHED THEN
        INSERT VALUES (duchodce.osoby_id, duchodce.vek, duchodce.pohlavi, duchodce.vyska, duchodce.vaha, duchodce.prijem, duchodce.povolani_id, duchodce.kraje_id)