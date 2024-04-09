//Vypište jména a pøíjmení zamìstnancù s nejvyšším poètem nadøízených.
with jmeno as (select level as uroven, prijmeni jmeno from zamestnanci
start with nadrizeny is null
connect by prior id_zamestnanci = nadrizeny)
select * from jmeno where uroven = (select max(uroven) from jmeno);

//Vytvoøte stromovou strukturu zamìstnancù
select LPAD(' ',2* level-1) || sys_connect_by_path(prijmeni || ' ' || jmeno, '/') struktura
from zamestnanci
start with nadrizeny is null
connect by prior id_zamestnanci = nadrizeny
order siblings by prijmeni, jmeno;

//Vypište názvy prvních deseti neprodávanìjších produktù na poboèce Brno 1 od 9. 2. do 17. 2. 2014 vèetnì poøadí.
with poradi as(
select id_produkty, sum(pocet_kusu) pocet from pobocky
join prodeje using(id_pobocky)
join polozky_prodeje using(id_prodeje)
where pobocky.nazev = 'Brno 1' and trunc(cas_prodeje) between to_date('09/02/2014','dd/mm/yyyy') and to_date('17/02/2014','dd/mm/yyyy')
group by id_produkty
order by sum(pocet_kusu) desc
fetch first 10 rows only
)
select rownum, nazev, pocet from(
select rownum||'.' poradi, nazev, pocet from poradi
join produkty using(id_produkty));

//Vypište pìt dnù s nejnižším obratem.
select trunc(cas_prodeje), sum(cena_celekem) from prodeje
group by trunc(cas_prodeje)
order by sum(cena_celkem)
fetch first 5 rows only; // => "CENA_CELEKEM": invalid identifier

//Spoèítejte kolik prodejù bylo zaplaceno v hotovosti, kolik kartou a u kolika to není možné z poskytnutých dat zjistit.
with data as(
select id_prodeje, round(sum(cena*pocet_kusu),2) as celkem from prodeje
join pobocky using(id_pobocky)
join polozky_prodeje using(id_prodeje)
join produkty using(id_produkty)
join nabidky using(id_produkty)
join oddeleniprodejny using(id_oddeleni, id_pobocky)
where trunc(cas_prodeje) between platnost_od and platnost_do
group by id_prodeje),
srovnani as(select celkem, cena_celkem from data join prodeje using(id_prodeje))

select * from(
select count(*) kartou from srovnani where mod(cena_celkem,1)=0 and cena_celkem = celkem),
(select count(*) hotove from srovnani where cena_celkem != celkem)
