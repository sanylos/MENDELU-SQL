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
select nazev from zeme where nazev like 'K%a%'

