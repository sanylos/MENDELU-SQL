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
select nazev from zeme where nazev like 'K%a%'

