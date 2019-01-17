SELECT
    A.COB_DATE,
    Case when GICS_LEVEL_1_NAME in ('FINANCIALS','REAL ESTATE') then 'FINANCIALS'
    when GICS_LEVEL_1_NAME in ('ENERGY', 'MATERIALS', 'UTILITIES') Then 'ENERGY' 
    when GICS_LEVEL_1_NAME in ('TELECOMMUNICATION SERVICES', 'INFORMATION TECHNOLOGY') Then 'IT' 
    Else GICS_LEVEL_1_NAME END as Industry,
    ABS (SUM (A.USD_PV01SPRD)) AS ABS_USD_PV01SPRD
FROM cdwuser.U_DM_CC A
WHERE
    A.CREDIT_TRADING_FLAG = 'Flow Trading' AND
    A.CCC_BUSINESS_AREA IN ('CREDIT-CORPORATES') AND
    A.COB_DATE in ('2018-02-28', '2018-01-31') AND
    A.USD_PV01SPRD IS NOT NULL AND
    A.CCC_PRODUCT_LINE IN ('HIGH YIELD - EU', 'INV GRADE TRADING - EU', 'EUROPEAN CREDIT FLOW') AND
    A.GICS_LEVEL_1_NAME NOT IN ('N\A', 'UNDEFINED', 'NOT CLASSIFIED')
GROUP BY
    A.COB_DATE,
    Case when GICS_LEVEL_1_NAME in ('FINANCIALS','REAL ESTATE') then 'FINANCIALS'
    when GICS_LEVEL_1_NAME in ('ENERGY', 'MATERIALS', 'UTILITIES') Then 'ENERGY' 
    when GICS_LEVEL_1_NAME in ('TELECOMMUNICATION SERVICES', 'INFORMATION TECHNOLOGY') Then 'IT' 
    Else GICS_LEVEL_1_NAME END