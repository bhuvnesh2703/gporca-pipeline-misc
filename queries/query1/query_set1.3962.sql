SELECT
    A.COB_DATE,
    A.CC_REGION_GROUP,
    Case when GICS_LEVEL_1_NAME in ('FINANCIALS','REAL ESTATE') then 'Y' else 'N' end as IS_FINANCIALS,
    A.RATING2, 
    A.SECTYPE2,
    CASE WHEN CCC_STRATEGY LIKE '%PAR LOANS%' OR CCC_STRATEGY in ('PRIMARY LOANS - AP','SECONDARY LOANS - AP') OR CCC_PRODUCT_LINE = 'PAR LOANS TRADING' OR BOOK IN ('LDN PAR TRADING RG-LNRGO','LDN PAR TRADING SIDDIQUI-LNSSL') THEN 'Par Loans Trading' 
    WHEN CCC_PRODUCT_LINE IN ('HIGH YIELD - EU', 'INV GRADE TRADING - EU', 'EUROPEAN CREDIT FLOW', 'NON IG PRIMARY - HY BOND', 'PRIMARY - BONDS', 'PRIMARY - IG BONDS', 'PRIMARY - NIG BONDS', 'CREDIT CORP MANAGEMENT')
    or CCC_PRODUCT_LINE LIKE '%HIGH YIELD%' or CCC_PRODUCT_LINE LIKE '%GRADE TRADING%' or CCC_PRODUCT_LINE LIKE '%ASIA%' THEN 'CC Ex Par Loans'
    ELSE 'DSP Index Products' END AS CC_CDP_Breakdown,
    SUM (A.USD_PV10_BENCH) AS USD_PV10_BENCH
FROM cdwuser.U_DM_CC A
WHERE
    a.COB_DATE IN (
'2018-01-17', 
'2018-01-24', 
'2018-01-31', 
'2018-02-07', 
'2018-02-14', 
'2018-02-21', 
'2018-02-28')
AND 


    A.CCC_BUSINESS_AREA IN ('CREDIT-CORPORATES', 'DSP - CREDIT', 'CREDIT CORPORATES PRIMARY') 
AND CREDIT_TRADING_FLAG in ('Flow Trading', 'Primary - Bonds')
GROUP BY
    A.COB_DATE,
    A.CC_REGION_GROUP,
    Case when GICS_LEVEL_1_NAME in ('FINANCIALS','REAL ESTATE') then 'Y' else 'N' end,
    A.RATING2, 
    A.SECTYPE2,
    CASE WHEN CCC_STRATEGY LIKE '%PAR LOANS%' OR CCC_STRATEGY in ('PRIMARY LOANS - AP','SECONDARY LOANS - AP') OR CCC_PRODUCT_LINE = 'PAR LOANS TRADING' OR BOOK IN ('LDN PAR TRADING RG-LNRGO','LDN PAR TRADING SIDDIQUI-LNSSL') THEN 'Par Loans Trading' 
    WHEN CCC_PRODUCT_LINE IN ('HIGH YIELD - EU', 'INV GRADE TRADING - EU', 'EUROPEAN CREDIT FLOW', 'NON IG PRIMARY - HY BOND', 'PRIMARY - BONDS', 'PRIMARY - IG BONDS', 'PRIMARY - NIG BONDS', 'CREDIT CORP MANAGEMENT')
    or CCC_PRODUCT_LINE LIKE '%HIGH YIELD%' or CCC_PRODUCT_LINE LIKE '%GRADE TRADING%' or CCC_PRODUCT_LINE LIKE '%ASIA%' THEN 'CC Ex Par Loans'
    ELSE 'DSP Index Products' END