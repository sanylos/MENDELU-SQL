//Vypište pivovary sídlící ve stejné obci jako libovolná restaurace
SELECT DISTINCT pivovary.nazev
FROM pivovary
JOIN adresy pa USING (id_adresy)
JOIN smerovaci_cisla ppsc USING(psc)
JOIN smerovaci_cisla rpsc USING (id_obce)
JOIN adresy ra ON (ra.psc=rpsc.psc)
JOIN restaurace ON (restaurace.id_adresy
=ra.id_adresy)

//Pro jednotlivé pivovary určete množství vystaveného piva v sudech. Výsledu zaokrouhlete na celé hektolitry. Pivovary řaďte podle názvu.
SELECT pivovary.nazev, nvl(objem,0) objem
FROM pivovary LEFT JOIN
(SELECT
round(sum(pocet_kusu*objem_v_litrech)/100) objem,
id_pivovaru
FROM piva JOIN vystav USING(id_piva)
JOIN typy_obalu USING(id_typu_obalu)
WHERE typy_obalu.nazev='sud'
GROUP BY id_pivovaru) USING (id_pivovaru)
ORDER BY pivovary.nazev

//Vypište názvy všech piv, která byla v roce 2018 v rámci svého pivovaru nejprodávanější (nejvíce prodaných litrů).
WITH
spotreba AS
(SELECT pivovary.nazev pivovar, piva.nazev pivo,
sum(pocet_kusu*objem_v_litrech) litry
FROM pivovary JOIN piva USING(id_pivovaru) JOIN
vystav USING(id_piva) JOIN typy_obalu
USING(id_typu_obalu)
WHERE to_char(cas_vystaveni, 'yyyy')='2018'
GROUP BY pivovary.nazev, piva.nazev)
SELECT pivovar, pivo
FROM spotreba a
WHERE litry= (SELECT max(litry)
FROM spotreba b
WHERE a.pivovar =b.pivovar)

//Vypište pro jednotlivé kraje název nejprodávanějšího piva (nejvíce prodaných litrů v restauracích toho kraje)
WITH
spotreba AS
(SELECT kraje.nazev, id_piva,
sum(pocet_kusu*objem_v_litrech) litry
FROM kraje JOIN obce USING(id_kraje)
JOIN smerovaci_cisla USING(id_obce)
JOIN adresy USING (psc)
JOIN restaurace USING(id_adresy)
JOIN vystav USING(id_restaurace)
JOIN typy_obalu USING(id_typu_obalu)
GROUP BY kraje.nazev, id_piva)
SELECT x.nazev, pivovary.nazev, piva.nazev
FROM pivovary JOIN piva USING (id_pivovaru) JOIN
(SELECT nazev, id_piva
FROM spotreba a
WHERE litry= (SELECT max(litry)
FROM spotreba b
WHERE a.nazev=b.nazev)) x
USING (id_piva)
