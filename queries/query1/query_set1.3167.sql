SELECT
    cr.cob_date, 
    cr.ccc_business_area,
    cr.CCC_PRODUCT_LINE, 
    cr.CURRENCY_OF_MEASURE,
    cr.CCC_DIVISION,
    cr.ISSUER_COUNTRY_CODE,
    cr.FID1_INDUSTRY_NAME_LEVEL1,
    cr.PRODUCT_TYPE_CODE,
    cr.LE_GROUP,
    cr.FID1_SENIORITY,
    cr.CCC_PL_REPORTING_REGION,
    cr.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,
/* rating identification */
CASE WHEN cr.MRD_RATING IN ('AAA', 'AA', 'A', 'BBB') THEN 'IG'
ELSE 'HY' END AS Rating, 
/* logic to identify Distressed counties */
CASE WHEN CR.ISSUER_COUNTRY_CODE in ('VEN','ARG','UKR') THEN 'distressed countires' ELSE 'pv10%' end as Shock_type,
/* industry breakdown */ 
CASE WHEN FID1_INDUSTRY_NAME_LEVEL1 in ('CORPORATES: FINANCIALS') then 'Financials'
when FID1_INDUSTRY_NAME_LEVEL1 in ('SOVEREIGN','GOVERNMENT SPONSORED') then 'Sovereign' 
ELSE 'Other' end as Industry, 
/* CVA Flag*/
CASE WHEN (cr.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)','CPM', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD','COMMODS FINANCING') 
OR cr.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES')) 
AND cr.CCC_PRODUCT_LINE NOT IN ('CREDIT LOAN PORTFOLIO', 'CMD STRUCTURED FINANCE') then 'CVA_Traded_Credit'
when cr.CCC_BUSINESS_AREA = 'LENDING' OR cr.CCC_PRODUCT_LINE = 'PRIMARY - LOANS' then 'LENDING' 
ELSE 'Traded_Credit' end as CVA_FL, 
/* Risk metrics */
 SUM (coalesce(cr.USD_PV10_BENCH,cr.USD_CREDIT_PV10PCT)) as BPV10,
 SUM (cr.USD_CREDIT_PV10PCT) as CB_only,  /* CBs are captured in Others Industry */
 SUM (cr.usd_exposure) AS NetExposure,
 SUM (cr.USD_PV01SPRD) AS SPV01
FROM cdwuser.u_cr_msr cr
WHERE
    cob_date IN ('2018-02-28','2018-02-21') 
    AND cr.VERTICAL_SYSTEM NOT LIKE '%SPG%' AND 
    cr.ISSUER_COUNTRY_CODE IN ('RUS')
AND CCC_DIVISION NOT IN ('FID DVA', 'FIC DVA') AND CCC_STRATEGY NOT IN ('MS DVA STR NOTES IED') 

GROUP BY
    cr.cob_date, 
    cr.ccc_business_area,
    cr.CCC_PRODUCT_LINE,  cr.CURRENCY_OF_MEASURE,
    cr.ISSUER_COUNTRY_CODE,
    cr.FID1_INDUSTRY_NAME_LEVEL1,
    cr.PRODUCT_TYPE_CODE,
    cr.LE_GROUP,
    cr.CCC_DIVISION,
    cr.FID1_SENIORITY,
    cr.CCC_PL_REPORTING_REGION,
    cr.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,
CASE WHEN cr.MRD_RATING IN ('AAA', 'AA', 'A', 'BBB') THEN 'IG'   
ELSE 'HY' END,
CASE WHEN (cr.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)','CPM', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD','COMMODS FINANCING') 
OR cr.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES')) 
AND cr.CCC_PRODUCT_LINE NOT IN ('CREDIT LOAN PORTFOLIO', 'CMD STRUCTURED FINANCE') then 'CVA_Traded_Credit'
when cr.CCC_BUSINESS_AREA = 'LENDING' OR cr.CCC_PRODUCT_LINE = 'PRIMARY - LOANS' then 'LENDING' 
ELSE 'Traded_Credit' END