//Vypište pøíjmení, jména a platy zamìstnancù vèetnì pìti procentní prémie.
select jmeno, prijmeni, plat*1.05 from zamestnanci;

//Vypište název pracovní pozice a k ní pøipojte prùmìr maximálního a minimálního platu.
select nazev, (max_plat+min_plat)/2 from pracovni_pozice;

// Vypište seznam, kterı bude obsahovat záznamy ve tvaru „èíslo oddìlení – název oddìlení“.
select id_oddeleni || '-' || nazev from oddeleni;

// Spojte do jednoho sloupce jméno a pøíjmení zamìstnance a pojmenujte tento sloupec jména zamìstnancù.
select jmeno || ' ' || prijmeni from zamestnanci;

//Vyberte èísla oddìlení, ve kterıch je alespoò jeden zamìstnanec.
select distinct id_oddeleni from zamestnanci;

//Vyberte èísla všech vedoucích pracovníkù.
select distinct vedouci from oddeleni;
select distinct nadrizeny from zamestnanci where nadrizeny is not null;

//Vyberte všechny zamìstnance, kteøí nastoupili mezi 2. 1. 2007 a 9. 7. 2008.
select * from zamestnanci where datum_nastupu between '02-jan-07' and '09-jul-08';

// Vypište všechna pøíjmení zamìstnancù, jejich pøíjmení má jako druhé písmeno o a poslední k.
select distinct prijmeni from zamestnanci where prijmeni like '_o%k';

//Vypište všechny zamìstnance, kteøí pracují na oddìleních èíslo (10,15,23)
select * from zamestnanci where id_oddeleni in (10,15,23);

//Vypište jména a pøíjmení všech zamìstnancù, kteøí nemají nadøízeného
select jmeno, prijmeni from zamestnanci where nadrizeny is null;

//Vypište názvy všech zemí zaèínající na 'K' a obsahující písmeno 'a'.
select nazev from zeme where nazev like 'K%a%';

//Vypište adresu poboèek, které mají orientaèní èíslo dìlitelné pìti beze zbytku.
select mesto, ulice, cislo_orientacni from pobocky where MOD(cislo_orientacni,5) = 0;

//Vypište unikátní názvy oddìlení, které obsahují 's' nebo 'e'.
select distinct nazev from oddeleni where nazev like '%s%' or nazev like '%e%';

//Vypište datum prodeje ve tvaru den v tıdnu den v mìsíci. mìsíc slovy a poslední dvì èíslice roku (napø. úterı 11. únor 14), kdy byl proveden nákup s celkovou mezi 7000 a 7500.
select to_char(cas_prodeje,'day DD. MONTH YY') from prodeje where cena_celkem between 7000 and 7500;

//Vypište název producentù, kteøí nemají uvedenı telefonní kontakt.
select * from producenti where telefon is null;

//Vypište název a telefonní spojení producentù, kde kontaktní osoba se køestním jménem jmenuje 'Anna'.
select nazev, telefon from producenti where kontaktni_osoba like 'Anna%';

//Vypište datum všech prodejù a jejich celkovou cenu a poèet prodanıch kusù, kde se produkt 'Rohlík tukovı' od firmy 'Pekárny Dvorák' prodal alespoò po ètyøech kusech. Celkovou cenu zarovnejte doprava a zaokrouhlete na stovky a vypište na 10 platnıch cifer a pøed jako první znak vypište dolar. Datum vypište podle pøíkladu: ètrnáctı led 09. Sloupce pojmenujte datum a cena.
select to_char(cas_prodeje,'ddspth month YYYY'), '$'||LPAD(round(cena_celkem, -2),10, ' '), pocet_kusu from prodeje 
join polozky_prodeje using (id_prodeje)
join produkty using (id_produkty)
join producenti using (id_producenti)
where produkty.nazev = 'Rohlík tukovı' and producenti.nazev = 'Pekárny Dvoøák' and pocet_kusu >= 4;

//Vypište názvy produktù a jejich poøizovací cenu, jejich poøizovací cena je celé èíslo.
select nazev, porizovaci_cena from produkty where round(porizovaci_cena) = porizovaci_cena;

//Odkdy dokdy byly v oddìlení potravin na poboèce Brno 2 nabízeny produkt(y) draší ne 500.
select distinct platnost_od, platnost_do from pobocky
join oddeleni using (id_pobocky)
join nabidky using (id_oddeleni)
where nabidky.cena > 500 and pobocky.nazev = 'Brno 2';

//Vypište maximální, minimální a prùmìrnı plat všech zamìstnancù a celkové mzdové náklady (zaokrouhlenı na dvì desetinná místa). Sloupce pojmenujte odpovídajícím zpùsobem. Mezi øády tisícù udìlejte èárku.
select MAX(plat) as minimalni, MIN(plat) as maximalni, to_char(AVG(plat), '999999.99') as prumerny, SUM(plat) as celkovy from zamestnanci;

//Vypište v kolika zemích se vyrábí nìjakı produkt.
select count(distinct id_zeme) from produkty;

// Vypište, kolik mìsícù jste na svìtì.
select months_between(sysdate, to_date('12.12.1212','dd.mm.yyyy')) from dual;

//Vypište jakım dnem (myšleno, pondìlí, úterı, ...) konèí aktuální mìsíc.
select to_char(last_day(sysdate), 'day') from dual;

//Vypište datum první nedìle roku 2015.
SELECT NEXT_DAY(TO_DATE('01-01-2015', 'DD-MM-YYYY'), 'SUNDAY') FROM DUAL;

//Ze jména a pøíjmení vytvoøte login ve tvaru první písmeno køestního jména a prvních pìt znakù pøíjmení vše malımi písmeny. Loginy vytvoøte tak, aby se v nich nevyskytovala diakritika.
select lower(substr(jmeno, 1,1) || translate(substr(prijmeni,1,5),'ÁáÉéÍíÓóÚúÜü??ÈèÏïÌìÒòØøŠš','AaEeIiOoUuUuNnCcDdEeNnRrSsTtZz')) from zamestnanci;

//Zjistìte, zda takto vytvoøené loginy jsou pro danı soubor zamìstnancù unikátní. Vısledkem bude vıpis ano, nebo ne.
select case when count(login)=count(distinct login) THEN 'yes' ELSE 'no' END from (select lower(substr(jmeno, 1,1) || translate(substr(prijmeni,1,5),'ÁáÉéÍíÓóÚúÜü??ÈèÏïÌìÒòØøŠš','AaEeIiOoUuUuNnCcDdEeNnRrSsTtZz'))login from zamestnanci);

//Urèete, které loginy jsou unikátní a které nejsou unikátní.
select login, decode (count(*),1,'ano','ne')
from (select lower(substr(jmeno, 1,1) || translate(substr(prijmeni,1,5),'ÁáÉéÍíÓóÚúÜü??ÈèÏïÌìÒòØøŠš','AaEeIiOoUuUuNnCcDdEeNnRrSsTtZz'))login from zamestnanci)
group by login;