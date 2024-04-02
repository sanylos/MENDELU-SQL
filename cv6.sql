//Vypište pøíjmení, jména a platy zamìstnancù vèetnì pìti procentní prémie.
select jmeno, prijmeni, plat*1.05 from zamestnanci;

//Vypište název pracovní pozice a k ní pøipojte prùmìr maximálního a minimálního platu.
select nazev, (max_plat+min_plat)/2 from pracovni_pozice;

// Vypište seznam, který bude obsahovat záznamy ve tvaru „èíslo oddìlení – název oddìlení“.
select id_oddeleni || '-' || nazev from oddeleni;

// Spojte do jednoho sloupce jméno a pøíjmení zamìstnance a pojmenujte tento sloupec jména zamìstnancù.
select jmeno || ' ' || prijmeni from zamestnanci;

//Vyberte èísla oddìlení, ve kterých je alespoò jeden zamìstnanec.
select distinct id_oddeleni from zamestnanci;

//Vyberte èísla všech vedoucích pracovníkù.
select distinct vedouci from oddeleni;
select distinct nadrizeny from zamestnanci where nadrizeny is not null;

//Vyberte všechny zamìstnance, kteøí nastoupili mezi 2. 1. 2007 a 9. 7. 2008.
select * from zamestnanci where datum_nastupu between '02-jan-07' and '09-jul-08';

// Vypište všechna pøíjmení zamìstnancù, jejichž pøíjmení má jako druhé písmeno o a poslední k.
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

//Vypište datum prodeje ve tvaru den v týdnu den v mìsíci. mìsíc slovy a poslední dvì èíslice roku (napø. úterý 11. únor 14), kdy byl proveden nákup s celkovou mezi 7000 a 7500.
select to_char(cas_prodeje,'day DD. MONTH YY') from prodeje where cena_celkem between 7000 and 7500;

//Vypište název producentù, kteøí nemají uvedený telefonní kontakt.
select * from producenti where telefon is null;

//Vypište název a telefonní spojení producentù, kde kontaktní osoba se køestním jménem jmenuje 'Anna'.
select nazev, telefon from producenti where kontaktni_osoba like 'Anna%';

//Vypište datum všech prodejù a jejich celkovou cenu a poèet prodaných kusù, kde se produkt 'Rohlík tukový' od firmy 'Pekárny Dvorák' prodal alespoò po ètyøech kusech. Celkovou cenu zarovnejte doprava a zaokrouhlete na stovky a vypište na 10 platných cifer a pøed jako první znak vypište dolar. Datum vypište podle pøíkladu: ètrnáctý led 09. Sloupce pojmenujte datum a cena.
select to_char(cas_prodeje,'ddspth month YYYY'), '$'||LPAD(round(cena_celkem, -2),10, ' '), pocet_kusu from prodeje 
join polozky_prodeje using (id_prodeje)
join produkty using (id_produkty)
join producenti using (id_producenti)
where produkty.nazev = 'Rohlík tukový' and producenti.nazev = 'Pekárny Dvoøák' and pocet_kusu >= 4;

//Vypište názvy produktù a jejich poøizovací cenu, jejichž poøizovací cena je celé èíslo.
select nazev, porizovaci_cena from produkty where round(porizovaci_cena) = porizovaci_cena;

//Odkdy dokdy byly v oddìlení potravin na poboèce Brno 2 nabízeny produkt(y) dražší než 500.
select distinct platnost_od, platnost_do from pobocky
join oddeleni using (id_pobocky)
join nabidky using (id_oddeleni)
where nabidky.cena > 500 and pobocky.nazev = 'Brno 2';

//Vypište maximální, minimální a prùmìrný plat všech zamìstnancù a celkové mzdové náklady (zaokrouhlený na dvì desetinná místa). Sloupce pojmenujte odpovídajícím zpùsobem. Mezi øády tisícù udìlejte èárku.
select MAX(plat) as minimalni, MIN(plat) as maximalni, to_char(AVG(plat), '999999.99') as prumerny, SUM(plat) as celkovy from zamestnanci;

//Vypište v kolika zemích se vyrábí nìjaký produkt.
select count(distinct id_zeme) from produkty;

// Vypište, kolik mìsícù jste na svìtì.
select months_between(sysdate, to_date('12.12.1212','dd.mm.yyyy')) from dual;

//Vypište jakým dnem (myšleno, pondìlí, úterý, ...) konèí aktuální mìsíc.
select to_char(last_day(sysdate), 'day') from dual;

//Vypište datum první nedìle roku 2015.
SELECT NEXT_DAY(TO_DATE('01-01-2015', 'DD-MM-YYYY'), 'SUNDAY') FROM DUAL;

//Ze jména a pøíjmení vytvoøte login ve tvaru první písmeno køestního jména a prvních pìt znakù pøíjmení vše malými písmeny. Loginy vytvoøte tak, aby se v nich nevyskytovala diakritika.
select lower(substr(jmeno, 1,1) || translate(substr(prijmeni,1,5),'ÁáÉéÍíÓóÚúÜü??ÈèÏïÌìÒòØøŠšŽž','AaEeIiOoUuUuNnCcDdEeNnRrSsTtZz')) from zamestnanci;

//Zjistìte, zda takto vytvoøené loginy jsou pro daný soubor zamìstnancù unikátní. Výsledkem bude výpis ano, nebo ne.
select case when count(login)=count(distinct login) THEN 'yes' ELSE 'no' END from (select lower(substr(jmeno, 1,1) || translate(substr(prijmeni,1,5),'ÁáÉéÍíÓóÚúÜü??ÈèÏïÌìÒòØøŠšŽž','AaEeIiOoUuUuNnCcDdEeNnRrSsTtZz'))login from zamestnanci);

//Urèete, které loginy jsou unikátní a které nejsou unikátní.
select login, decode (count(*),1,'ano','ne')
from (select lower(substr(jmeno, 1,1) || translate(substr(prijmeni,1,5),'ÁáÉéÍíÓóÚúÜü??ÈèÏïÌìÒòØøŠšŽž','AaEeIiOoUuUuNnCcDdEeNnRrSsTtZz'))login from zamestnanci)
group by login;

//Vypište název producenta a jeho telefonní èíslo, pokud nemá uveden telefon, vypište email. Pokud nemá ani e-mail, vypište kontaktní osobu. Pokud nemá zaznamenánu ani tu, vypište: „Nemá uveden žádný kontakt.“ Tento sloupec pojmenujte kontakt.
select nazev, coalesce(telefon,email,kontaktni_osoba,'Nemá uveden žádný kontakt') from producenti;

//Vypište jméno, pøíjmení, poèet dnù v zamìstnání a název jejich pracovní pozice u zamìstnancù, kteøí k 1. 1. 2008 byli již minimálnì pùl roku zamìstnáni a seøaïte je podle doby pracovního pomìru od nejdéle pracujícího.
select jmeno, prijmeni, trunc(sysdate - datum_nastupu), datum_nastupu from zamestnanci where datum_nastupu - to_date('01-JAN-08', 'dd-MON-yy') > 365/2 order by datum_nastupu;

//Vypište jméno a pøíjmení zamìstnancù a pøíjmení jejich vedoucích, jejichž plat je nad prùmìrný. Pokud nemají vedoucího vypište „bez nadøízeného“. Zamìstnance seøaïte podle pøíjmení a jména.
select z.jmeno, z.prijmeni, z.plat, v.prijmeni as vedouci from zamestnanci z 
left join zamestnanci v on (z.nadrizeny = v.id_zamestnanci)
where z.plat > (select avg(plat) from zamestnanci);

// Vypište úè(et/ty) od prodej(e/ù), kter(ý/é) byl(y) provedeny 9. února 2014 na poboèce v Bøeclavi a jejich celková cena byla mezi 5000 a 7500.
select id_prodeje, nvl(produkty.nazev,'CELKEM') as polozka, nabidky.cena as cena, pocet_kusu, cena*pocet_kusu as celkem from prodeje
join pobocky using(id_pobocky)
join polozky_prodeje using(id_prodeje)
join produkty using(id_produkty)
join nabidky using(id_produkty)
join oddeleniprodejny using(id_oddeleni, id_pobocky)
where pobocky.nazev = 'Bøeclav' and cas_prodeje like ('09-FEB-14%') and cena_celkem between 5000 and 7500
and trunc(cas_prodeje) between platnost_od and platnost_do
group by grouping sets ((id_prodeje),(id_prodeje, produkty.nazev, nabidky.cena, pocet_kusu))
order by id_prodeje;
