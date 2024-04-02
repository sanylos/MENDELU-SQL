//Vypi�te p��jmen�, jm�na a platy zam�stnanc� v�etn� p�ti procentn� pr�mie.
select jmeno, prijmeni, plat*1.05 from zamestnanci;

//Vypi�te n�zev pracovn� pozice a k n� p�ipojte pr�m�r maxim�ln�ho a minim�ln�ho platu.
select nazev, (max_plat+min_plat)/2 from pracovni_pozice;

// Vypi�te seznam, kter� bude obsahovat z�znamy ve tvaru ���slo odd�len� � n�zev odd�len�.
select id_oddeleni || '-' || nazev from oddeleni;

// Spojte do jednoho sloupce jm�no a p��jmen� zam�stnance a pojmenujte tento sloupec jm�na zam�stnanc�.
select jmeno || ' ' || prijmeni from zamestnanci;

//Vyberte ��sla odd�len�, ve kter�ch je alespo� jeden zam�stnanec.
select distinct id_oddeleni from zamestnanci;

//Vyberte ��sla v�ech vedouc�ch pracovn�k�.
select distinct vedouci from oddeleni;
select distinct nadrizeny from zamestnanci where nadrizeny is not null;

//Vyberte v�echny zam�stnance, kte�� nastoupili mezi 2. 1. 2007 a 9. 7. 2008.
select * from zamestnanci where datum_nastupu between '02-jan-07' and '09-jul-08';

// Vypi�te v�echna p��jmen� zam�stnanc�, jejich� p��jmen� m� jako druh� p�smeno o a posledn� k.
select distinct prijmeni from zamestnanci where prijmeni like '_o%k';

//Vypi�te v�echny zam�stnance, kte�� pracuj� na odd�len�ch ��slo (10,15,23)
select * from zamestnanci where id_oddeleni in (10,15,23);

//Vypi�te jm�na a p��jmen� v�ech zam�stnanc�, kte�� nemaj� nad��zen�ho
select jmeno, prijmeni from zamestnanci where nadrizeny is null;

//Vypi�te n�zvy v�ech zem� za��naj�c� na 'K' a obsahuj�c� p�smeno 'a'.
select nazev from zeme where nazev like 'K%a%';

//Vypi�te adresu pobo�ek, kter� maj� orienta�n� ��slo d�liteln� p�ti beze zbytku.
select mesto, ulice, cislo_orientacni from pobocky where MOD(cislo_orientacni,5) = 0;

//Vypi�te unik�tn� n�zvy odd�len�, kter� obsahuj� 's' nebo 'e'.
select distinct nazev from oddeleni where nazev like '%s%' or nazev like '%e%';

//Vypi�te datum prodeje ve tvaru den v t�dnu den v m�s�ci. m�s�c slovy a posledn� dv� ��slice roku (nap�. �ter� 11. �nor 14), kdy byl proveden n�kup s celkovou mezi 7000 a 7500.
select to_char(cas_prodeje,'day DD. MONTH YY') from prodeje where cena_celkem between 7000 and 7500;

//Vypi�te n�zev producent�, kte�� nemaj� uveden� telefonn� kontakt.
select * from producenti where telefon is null;

//Vypi�te n�zev a telefonn� spojen� producent�, kde kontaktn� osoba se k�estn�m jm�nem jmenuje 'Anna'.
select nazev, telefon from producenti where kontaktni_osoba like 'Anna%';

//Vypi�te datum v�ech prodej� a jejich celkovou cenu a po�et prodan�ch kus�, kde se produkt 'Rohl�k tukov�' od firmy 'Pek�rny Dvor�k' prodal alespo� po �ty�ech kusech. Celkovou cenu zarovnejte doprava a zaokrouhlete na stovky a vypi�te na 10 platn�ch cifer a p�ed jako prvn� znak vypi�te dolar. Datum vypi�te podle p��kladu: �trn�ct� led 09. Sloupce pojmenujte datum a cena.
select to_char(cas_prodeje,'ddspth month YYYY'), '$'||LPAD(round(cena_celkem, -2),10, ' '), pocet_kusu from prodeje 
join polozky_prodeje using (id_prodeje)
join produkty using (id_produkty)
join producenti using (id_producenti)
where produkty.nazev = 'Rohl�k tukov�' and producenti.nazev = 'Pek�rny Dvo��k' and pocet_kusu >= 4;

//Vypi�te n�zvy produkt� a jejich po�izovac� cenu, jejich� po�izovac� cena je cel� ��slo.
select nazev, porizovaci_cena from produkty where round(porizovaci_cena) = porizovaci_cena;

//Odkdy dokdy byly v odd�len� potravin na pobo�ce Brno 2 nab�zeny produkt(y) dra��� ne� 500.
select distinct platnost_od, platnost_do from pobocky
join oddeleni using (id_pobocky)
join nabidky using (id_oddeleni)
where nabidky.cena > 500 and pobocky.nazev = 'Brno 2';

//Vypi�te maxim�ln�, minim�ln� a pr�m�rn� plat v�ech zam�stnanc� a celkov� mzdov� n�klady (zaokrouhlen� na dv� desetinn� m�sta). Sloupce pojmenujte odpov�daj�c�m zp�sobem. Mezi ��dy tis�c� ud�lejte ��rku.
select MAX(plat) as minimalni, MIN(plat) as maximalni, to_char(AVG(plat), '999999.99') as prumerny, SUM(plat) as celkovy from zamestnanci;

//Vypi�te v kolika zem�ch se vyr�b� n�jak� produkt.
select count(distinct id_zeme) from produkty;

// Vypi�te, kolik m�s�c� jste na sv�t�.
select months_between(sysdate, to_date('12.12.1212','dd.mm.yyyy')) from dual;

//Vypi�te jak�m dnem (my�leno, pond�l�, �ter�, ...) kon�� aktu�ln� m�s�c.
select to_char(last_day(sysdate), 'day') from dual;

//Vypi�te datum prvn� ned�le roku 2015.
SELECT NEXT_DAY(TO_DATE('01-01-2015', 'DD-MM-YYYY'), 'SUNDAY') FROM DUAL;

//Ze jm�na a p��jmen� vytvo�te login ve tvaru prvn� p�smeno k�estn�ho jm�na a prvn�ch p�t znak� p��jmen� v�e mal�mi p�smeny. Loginy vytvo�te tak, aby se v nich nevyskytovala diakritika.
select lower(substr(jmeno, 1,1) || translate(substr(prijmeni,1,5),'������������??����������������','AaEeIiOoUuUuNnCcDdEeNnRrSsTtZz')) from zamestnanci;

//Zjist�te, zda takto vytvo�en� loginy jsou pro dan� soubor zam�stnanc� unik�tn�. V�sledkem bude v�pis ano, nebo ne.
select case when count(login)=count(distinct login) THEN 'yes' ELSE 'no' END from (select lower(substr(jmeno, 1,1) || translate(substr(prijmeni,1,5),'������������??����������������','AaEeIiOoUuUuNnCcDdEeNnRrSsTtZz'))login from zamestnanci);

//Ur�ete, kter� loginy jsou unik�tn� a kter� nejsou unik�tn�.
select login, decode (count(*),1,'ano','ne')
from (select lower(substr(jmeno, 1,1) || translate(substr(prijmeni,1,5),'������������??����������������','AaEeIiOoUuUuNnCcDdEeNnRrSsTtZz'))login from zamestnanci)
group by login;

//Vypi�te n�zev producenta a jeho telefonn� ��slo, pokud nem� uveden telefon, vypi�te email. Pokud nem� ani e-mail, vypi�te kontaktn� osobu. Pokud nem� zaznamen�nu ani tu, vypi�te: �Nem� uveden ��dn� kontakt.� Tento sloupec pojmenujte kontakt.
select nazev, coalesce(telefon,email,kontaktni_osoba,'Nem� uveden ��dn� kontakt') from producenti;

//Vypi�te jm�no, p��jmen�, po�et dn� v zam�stn�n� a n�zev jejich pracovn� pozice u zam�stnanc�, kte�� k 1. 1. 2008 byli ji� minim�ln� p�l roku zam�stn�ni a se�a�te je podle doby pracovn�ho pom�ru od nejd�le pracuj�c�ho.
select jmeno, prijmeni, trunc(sysdate - datum_nastupu), datum_nastupu from zamestnanci where datum_nastupu - to_date('01-JAN-08', 'dd-MON-yy') > 365/2 order by datum_nastupu;

//Vypi�te jm�no a p��jmen� zam�stnanc� a p��jmen� jejich vedouc�ch, jejich� plat je nad pr�m�rn�. Pokud nemaj� vedouc�ho vypi�te �bez nad��zen�ho�. Zam�stnance se�a�te podle p��jmen� a jm�na.
select z.jmeno, z.prijmeni, z.plat, v.prijmeni as vedouci from zamestnanci z 
left join zamestnanci v on (z.nadrizeny = v.id_zamestnanci)
where z.plat > (select avg(plat) from zamestnanci);

// Vypi�te ��(et/ty) od prodej(e/�), kter(�/�) byl(y) provedeny 9. �nora 2014 na pobo�ce v B�eclavi a jejich celkov� cena byla mezi 5000 a 7500.
select id_prodeje, nvl(produkty.nazev,'CELKEM') as polozka, nabidky.cena as cena, pocet_kusu, cena*pocet_kusu as celkem from prodeje
join pobocky using(id_pobocky)
join polozky_prodeje using(id_prodeje)
join produkty using(id_produkty)
join nabidky using(id_produkty)
join oddeleniprodejny using(id_oddeleni, id_pobocky)
where pobocky.nazev = 'B�eclav' and cas_prodeje like ('09-FEB-14%') and cena_celkem between 5000 and 7500
and trunc(cas_prodeje) between platnost_od and platnost_do
group by grouping sets ((id_prodeje),(id_prodeje, produkty.nazev, nabidky.cena, pocet_kusu))
order by id_prodeje;
