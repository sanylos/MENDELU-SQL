//Kolik sudů piva bylo celkem vystaveno v restauraci Labská Bašta?
SELECT SUM(pocet_kusu) AS celkovy_pocet_sudů
FROM p3_vystav
JOIN p3_restaurace ON p3_vystav.id_restaurace = p3_restaurace.id_restaurace
WHERE p3_restaurace.nazev = 'Labská Bašta';

//Pro jednotlivé kraje určete pivovar z daného kraje, který vystavil největší objem piva.
WITH TotalVolumePerBrewery AS (
    SELECT 
        K.ID_KRAJE,
        K.NAZEV AS KRAJ,
        PIV.ID_PIVOVARU,
        PIV.NAZEV AS PIVOVAR,
        SUM(V.POCET_KUSU * TOB.OBJEM_V_LITRECH) AS CELKOVY_OBJEM
    FROM 
        VYSTAV V
    JOIN PIVA PI ON V.ID_PIVA = PI.ID_PIVA
    JOIN PIVOVARY PIV ON PI.ID_PIVOVARU = PIV.ID_PIVOVARU
    JOIN ADRESY A ON PIV.ID_ADRESY = A.ID_ADRESY
    JOIN SMEROVACI_CISLA SC ON A.PSC = SC.PSC
    JOIN OBCE O ON SC.ID_OBCE = O.ID_OBCE
    JOIN KRAJE K ON O.ID_KRAJE = K.ID_KRAJE
    JOIN TYPY_OBALU TOB ON V.ID_TYPU_OBALU = TOB.ID_TYPU_OBALU
    GROUP BY 
        K.ID_KRAJE,
        K.NAZEV,
        PIV.ID_PIVOVARU,
        PIV.NAZEV
),
MaxVolumePerRegion AS (
    SELECT 
        ID_KRAJE,
        MAX(CELKOVY_OBJEM) AS MAX_OBJEM
    FROM 
        TotalVolumePerBrewery
    GROUP BY 
        ID_KRAJE
)
SELECT 
    TV.KRAJ,
    TV.PIVOVAR,
    TV.CELKOVY_OBJEM
FROM 
    TotalVolumePerBrewery TV
JOIN 
    MaxVolumePerRegion MR ON TV.ID_KRAJE = MR.ID_KRAJE AND TV.CELKOVY_OBJEM = MR.MAX_OBJEM;

//Pro jednotlivé kraje určete dny s nejvyšším vystaveným objemem.
WITH DailyVolumePerRegion AS (
    SELECT 
        K.ID_KRAJE,
        K.NAZEV AS KRAJ,
        TRUNC(V.CAS_VYSTAVENI) AS DEN,
        SUM(V.POCET_KUSU * TOB.OBJEM_V_LITRECH) AS CELKOVY_OBJEM
    FROM 
        VYSTAV V
    JOIN PIVA PI ON V.ID_PIVA = PI.ID_PIVA
    JOIN PIVOVARY PIV ON PI.ID_PIVOVARU = PIV.ID_PIVOVARU
    JOIN ADRESY A ON PIV.ID_ADRESY = A.ID_ADRESY
    JOIN SMEROVACI_CISLA SC ON A.PSC = SC.PSC
    JOIN OBCE O ON SC.ID_OBCE = O.ID_OBCE
    JOIN KRAJE K ON O.ID_KRAJE = K.ID_KRAJE
    JOIN TYPY_OBALU TOB ON V.ID_TYPU_OBALU = TOB.ID_TYPU_OBALU
    GROUP BY 
        K.ID_KRAJE,
        K.NAZEV,
        TRUNC(V.CAS_VYSTAVENI)
),
MaxVolumePerDayPerRegion AS (
    SELECT 
        ID_KRAJE,
        MAX(CELKOVY_OBJEM) AS MAX_OBJEM
    FROM 
        DailyVolumePerRegion
    GROUP BY 
        ID_KRAJE
)
SELECT 
    DVR.KRAJ,
    DVR.DEN,
    DVR.CELKOVY_OBJEM
FROM 
    DailyVolumePerRegion DVR
JOIN 
    MaxVolumePerDayPerRegion MVDPR ON DVR.ID_KRAJE = MVDPR.ID_KRAJE AND DVR.CELKOVY_OBJEM = MVDPR.MAX_OBJEM;

//Pro jednotlivé kraje určete pivovar z daného kraje, který vystavil největší objem piva
WITH TotalVolumePerBrewery AS (
    SELECT 
        KR.ID_KRAJE,
        KR.NAZEV AS KRAJ,
        PIV.ID_PIVOVARU,
        PIV.NAZEV AS PIVOVAR,
        SUM(V.POCET_KUSU * TOB.OBJEM_V_LITRECH) AS CELKOVY_OBJEM
    FROM 
        VYSTAV V
    JOIN PIVA PI ON V.ID_PIVA = PI.ID_PIVA
    JOIN PIVOVARY PIV ON PI.ID_PIVOVARU = PIV.ID_PIVOVARU
    JOIN ADRESY A ON PIV.ID_ADRESY = A.ID_ADRESY
    JOIN SMEROVACI_CISLA SC ON A.PSC = SC.PSC
    JOIN OBCE O ON SC.ID_OBCE = O.ID_OBCE
    JOIN KRAJE KR ON O.ID_KRAJE = KR.ID_KRAJE
    JOIN TYPY_OBALU TOB ON V.ID_TYPU_OBALU = TOB.ID_TYPU_OBALU
    GROUP BY 
        KR.ID_KRAJE,
        KR.NAZEV,
        PIV.ID_PIVOVARU,
        PIV.NAZEV
),
MaxVolumePerRegion AS (
    SELECT 
        ID_KRAJE,
        MAX(CELKOVY_OBJEM) AS MAX_OBJEM
    FROM 
        TotalVolumePerBrewery
    GROUP BY 
        ID_KRAJE
)
SELECT 
    TV.KRAJ,
    TV.PIVOVAR,
    TV.CELKOVY_OBJEM
FROM 
    TotalVolumePerBrewery TV
JOIN 
    MaxVolumePerRegion MR ON TV.ID_KRAJE = MR.ID_KRAJE AND TV.CELKOVY_OBJEM = MR.MAX_OBJEM;

//Pro jednotlivé světadíly určete nejprodávanější produkt (ten, kterého se celkově prodalo nejvíce).
WITH ProduktSvetadily AS (
    SELECT s.NAZEV AS SVETADIL, p.NAZEV AS PRODUKT, SUM(pr.CENA_CELKEM) AS CELKEM_PRODEJ
    FROM SVETADILY s
    JOIN ZEME z ON s.ID_SVETADILY = z.ID_SVETADILY
    JOIN PRODUKTY p ON z.ID_ZEME = p.ID_ZEME
    JOIN PRODEJE pr ON pr.ID_POBOCKY = (
        SELECT po.ID_POBOCKY
        FROM POBOCKY po
        JOIN ODDELENI o ON po.ID_POBOCKY = o.ID_POBOCKY
        WHERE o.ID_ODDELENI = (
            SELECT o2.ID_ODDELENI
            FROM ODDELENI o2
            JOIN PRODUKTY p2 ON o2.ID_ODDELENI = p2.ID_ZEME
            WHERE p2.ID_PRODUKTY = p.ID_PRODUKTY
        )
    )
    GROUP BY s.NAZEV, p.NAZEV
)
SELECT sv.SVETADIL, sv.PRODUKT, sv.CELKEM_PRODEJ
FROM ProduktSvetadily sv
JOIN (
    SELECT SVETADIL, MAX(CELKEM_PRODEJ) AS MAX_PRODEJ
    FROM ProduktSvetadily
    GROUP BY SVETADIL
) max_sv
ON sv.SVETADIL = max_sv.SVETADIL AND sv.CELKEM_PRODEJ = max_sv.MAX_PRODEJ
ORDER BY sv.SVETADIL;

//Vypište jihomoravské pivovary, které vaří alespoň 1 pivo s obsahem alkoholu vyšším než 6%
SELECT 
    PIVOVARY.NAZEV AS PIVOVAR
FROM 
    PIVOVARY
JOIN 
    ADRESY ON PIVOVARY.ID_ADRESY = ADRESY.ID_ADRESY
JOIN 
    SMEROVACI_CISLA ON ADRESY.PSC = SMEROVACI_CISLA.PSC
JOIN 
    OBCE ON SMEROVACI_CISLA.ID_OBCE = OBCE.ID_OBCE
JOIN 
    KRAJE ON OBCE.ID_KRAJE = KRAJE.ID_KRAJE
JOIN 
    PIVA ON PIVOVARY.ID_PIVOVARU = PIVA.ID_PIVOVARU
WHERE 
    KRAJE.NAZEV = 'Jihomoravský kraj'
    AND PIVA.ALKOHOL > 6;

//Pro všechny restaurace určete celkový počet vystavených sudů, ve kterých byl druh piva "tmavý ležák"
SELECT 
    RESTAURACE.NAZEV AS RESTAURACE,
    SUM(VYSTAV.POCET_KUSU) AS CELKOVY_POCET_SUDU
FROM 
    RESTAURACE
JOIN 
    VYSTAV ON RESTAURACE.ID_RESTAURACE = VYSTAV.ID_RESTAURACE
JOIN 
    PIVA ON VYSTAV.ID_PIVA = PIVA.ID_PIVA
JOIN 
    DRUHY_PIVA ON PIVA.ID_DRUHU_PIVA = DRUHY_PIVA.ID_DRUHU_PIVA
WHERE 
    DRUHY_PIVA.NAZEV = 'tmavý ležák'
GROUP BY 
    RESTAURACE.NAZEV;

//Pro jednotlivé kraje vyberte restaurace s největším počtem vystavených lahví v roce 2019.
WITH RESTAURACE_VYSTAV AS (
    SELECT 
        RESTAURACE.ID_RESTAURACE,
        RESTAURACE.NAZEV AS RESTAURACE_NAZEV,
        KRAJE.NAZEV AS KRAJ_NAZEV,
        SUM(VYSTAV.POCET_KUSU) AS POCET_LAHVI
    FROM 
        RESTAURACE
    JOIN 
        ADRESY ON RESTAURACE.ID_ADRESY = ADRESY.ID_ADRESY
    JOIN 
        SMEROVACI_CISLA ON ADRESY.PSC = SMEROVACI_CISLA.PSC
    JOIN 
        OBCE ON SMEROVACI_CISLA.ID_OBCE = OBCE.ID_OBCE
    JOIN 
        KRAJE ON OBCE.ID_KRAJE = KRAJE.ID_KRAJE
    JOIN 
        VYSTAV ON RESTAURACE.ID_RESTAURACE = VYSTAV.ID_RESTAURACE
    JOIN 
        TYPY_OBALU ON VYSTAV.ID_TYPU_OBALU = TYPY_OBALU.ID_TYPU_OBALU
    WHERE 
        EXTRACT(YEAR FROM VYSTAV.CAS_VYSTAVENI) = 2019
        AND TYPY_OBALU.NAZEV = 'láhev'
    GROUP BY 
        RESTAURACE.ID_RESTAURACE, RESTAURACE.NAZEV, KRAJE.NAZEV
)
SELECT 
    KRAJ_NAZEV,
    RESTAURACE_NAZEV,
    POCET_LAHVI
FROM (
    SELECT 
        KRAJ_NAZEV,
        RESTAURACE_NAZEV,
        POCET_LAHVI,
        ROW_NUMBER() OVER (PARTITION BY KRAJ_NAZEV ORDER BY POCET_LAHVI DESC) AS RN
    FROM 
        RESTAURACE_VYSTAV
)
WHERE 
    RN = 1;

//Pomocí PL/SQL vytvořte proceduru, která pro aktuálně přihlášeného uživatele vypíše informace
o počtu tabulek, pohledů, funkcí, procedur. Vypíše se vždy uživatelské jméno uživatele, který
proceduru spustí, déle se vypíší počty jednotlivých objektů. Vždy se uvede, ke kolika má přístup
a kolik z nich je jeho. Příklad výstupu:
C##STUDENT
tabulky: 6412 / 205
pohledy: 7263 / 129
funkce: 845 / 18
procedury: 1169/ 64
CREATE OR REPLACE PROCEDURE user_object_counts AS
    -- Deklarace proměnných pro uchování počtu objektů
    v_username VARCHAR2(30);
    v_total_tables NUMBER;
    v_user_tables NUMBER;
    v_total_views NUMBER;
    v_user_views NUMBER;
    v_total_functions NUMBER;
    v_user_functions NUMBER;
    v_total_procedures NUMBER;
    v_user_procedures NUMBER;

BEGIN
    -- Získání uživatelského jména aktuálně přihlášeného uživatele
    SELECT USER INTO v_username FROM DUAL;

    -- Počítání všech tabulek, ke kterým má uživatel přístup
    SELECT COUNT(*) INTO v_total_tables FROM ALL_TABLES;
    -- Počítání tabulek, které uživatel vlastní
    SELECT COUNT(*) INTO v_user_tables FROM ALL_TABLES WHERE OWNER = v_username;

    -- Počítání všech pohledů, ke kterým má uživatel přístup
    SELECT COUNT(*) INTO v_total_views FROM ALL_VIEWS;
    -- Počítání pohledů, které uživatel vlastní
    SELECT COUNT(*) INTO v_user_views FROM ALL_VIEWS WHERE OWNER = v_username;

    -- Počítání všech funkcí, ke kterým má uživatel přístup
    SELECT COUNT(*) INTO v_total_functions FROM ALL_OBJECTS WHERE OBJECT_TYPE = 'FUNCTION';
    -- Počítání funkcí, které uživatel vlastní
    SELECT COUNT(*) INTO v_user_functions FROM ALL_OBJECTS WHERE OBJECT_TYPE = 'FUNCTION' AND OWNER = v_username;

    -- Počítání všech procedur, ke kterým má uživatel přístup
    SELECT COUNT(*) INTO v_total_procedures FROM ALL_OBJECTS WHERE OBJECT_TYPE = 'PROCEDURE';
    -- Počítání procedur, které uživatel vlastní
    SELECT COUNT(*) INTO v_user_procedures FROM ALL_OBJECTS WHERE OBJECT_TYPE = 'PROCEDURE' AND OWNER = v_username;

    -- Výpis výsledků
    DBMS_OUTPUT.PUT_LINE(v_username);
    DBMS_OUTPUT.PUT_LINE('tabulky: ' || v_total_tables || ' / ' || v_user_tables);
    DBMS_OUTPUT.PUT_LINE('pohledy: ' || v_total_views || ' / ' || v_user_views);
    DBMS_OUTPUT.PUT_LINE('funkce: ' || v_total_functions || ' / ' || v_user_functions);
    DBMS_OUTPUT.PUT_LINE('procedury: ' || v_total_procedures || ' / ' || v_user_procedures);
END;

//Pro každého zaměstnance vypište jeho jméno a příjmení, počet nadřízených, příjmení přímého nadřízeného a příjmení nejvyššího nadřízeného, pokud je bez nadřízeného, poslední dva sloupce budou obsahovat hodnotu null
WITH 
DirectManager AS (
    SELECT 
        Z1.ID_ZAMESTNANCI AS Employee_ID,
        Z1.JMENO AS Employee_FirstName,
        Z1.PRIJMENI AS Employee_LastName,
        Z2.PRIJMENI AS Direct_Manager_LastName,
        Z1.NADRIZENY AS Direct_Manager_ID
    FROM 
        ZAMESTNANCI Z1
    LEFT JOIN 
        ZAMESTNANCI Z2 ON Z1.NADRIZENY = Z2.ID_ZAMESTNANCI
),
HighestManager AS (
    SELECT 
        Z1.ID_ZAMESTNANCI AS Employee_ID,
        Z3.PRIJMENI AS Highest_Manager_LastName
    FROM 
        ZAMESTNANCI Z1
    LEFT JOIN 
        ZAMESTNANCI Z2 ON Z1.NADRIZENY = Z2.ID_ZAMESTNANCI
    LEFT JOIN 
        ZAMESTNANCI Z3 ON Z2.NADRIZENY = Z3.ID_ZAMESTNANCI
    WHERE 
        Z3.NADRIZENY IS NULL OR Z3.ID_ZAMESTNANCI IS NULL
)
SELECT 
    D.Employee_FirstName AS JMENO,
    D.Employee_LastName AS PRIJMENI,
    (CASE WHEN D.Direct_Manager_ID IS NULL THEN 0 ELSE 1 END) AS Number_of_Managers,
    D.Direct_Manager_LastName,
    H.Highest_Manager_LastName
FROM 
    DirectManager D
LEFT JOIN 
    HighestManager H ON D.Employee_ID = H.Employee_ID
ORDER BY 
    D.Employee_LastName, D.Employee_FirstName;

//Pro jednotlivé země určete nejrpodávanější produkt
WITH SalesByCountry AS (
    SELECT 
        ZEME.ID_ZEME,
        ZEME.NAZEV AS Country_Name,
        PRODUKTY.ID_PRODUKTY,
        PRODUKTY.NAZEV AS Product_Name,
        SUM(PRODEJE.CENA_CELKEM) AS Total_Sales
    FROM 
        PRODEJE
    JOIN 
        POBOCKY ON PRODEJE.ID_POBOCKY = POBOCKY.ID_POBOCKY
    JOIN 
        PRODUKTY ON PRODEJE.ID_PRODEJE = PRODUKTY.ID_PRODUKTY
    JOIN 
        ZEME ON PRODUKTY.ID_ZEME = ZEME.ID_ZEME
    GROUP BY 
        ZEME.ID_ZEME, ZEME.NAZEV, PRODUKTY.ID_PRODUKTY, PRODUKTY.NAZEV
),
RankedSales AS (
    SELECT 
        SalesByCountry.*,
        ROW_NUMBER() OVER (PARTITION BY SalesByCountry.ID_ZEME ORDER BY SalesByCountry.Total_Sales DESC) AS Sales_Rank
    FROM 
        SalesByCountry
)
SELECT 
    Country_Name,
    Product_Name,
    Total_Sales
FROM 
    RankedSales
WHERE 
    Sales_Rank = 1
ORDER BY 
    Country_Name;
