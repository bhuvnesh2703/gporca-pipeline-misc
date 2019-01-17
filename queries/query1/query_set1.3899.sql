SELECT
    A.COB_DATE,
    A.RATING2,
    A.CCC_PL_REPORTING_REGION,
    A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,
    A.CREDIT_TRADING_FLAG,
    ABS (SUM (A.USD_PV10_BENCH)) AS ABS_USD_PV10_BENCH,
    ABS (SUM (A.USD_PV01SPRD)) AS ABS_USD_PV01SPRD
FROM cdwuser.U_DM_CC A
WHERE
    A.COB_DATE in ('2018-02-28','2018-02-27') AND
    A.CCC_PRODUCT_LINE = 'DISTRESSED TRADING' AND
    A.CCC_STRATEGY <> 'PAR LOANS TRADING' AND  
    A.CREDIT_TRADING_FLAG in ('Distressed', 'Distressed Hedges')
GROUP BY
    A.COB_DATE,
    A.RATING2,
    A.CCC_PL_REPORTING_REGION,
    A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,
    A.CREDIT_TRADING_FLAG