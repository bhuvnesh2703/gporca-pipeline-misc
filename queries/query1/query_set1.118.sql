SELECT
    A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,
    A.COB_DATE,
    ABS (SUM (A.USD_PV10_BENCH)) AS ABS_USD_PV10_BENCH
FROM cdwuser.U_DM_CC A
WHERE
    A.CREDIT_TRADING_FLAG = 'Flow Trading' AND
    A.CCC_BUSINESS_AREA IN ('CREDIT-CORPORATES') AND
    A.COB_DATE in ('2018-02-28', '2018-01-31') AND
    A.USD_PV10_BENCH IS NOT NULL AND
    A.CCC_PRODUCT_LINE = 'HIGH YIELD - NA'
GROUP BY A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME, A.COB_DATE