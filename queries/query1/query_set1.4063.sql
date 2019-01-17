SELECT
    A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,
    A.COB_DATE,
    ABS (SUM (A.USD_PV01SPRD)) AS ABS_USD_PV01SPRD
FROM cdwuser.U_DM_CC A
WHERE
    A.CREDIT_TRADING_FLAG = 'Flow Trading' AND
    A.CCC_BUSINESS_AREA IN ('CREDIT-CORPORATES') AND
    A.COB_DATE in ('2018-02-28') AND
    A.USD_PV01SPRD IS NOT NULL AND
    A.CCC_PRODUCT_LINE IN ('HIGH YIELD - EU', 'INV GRADE TRADING - EU', 'EUROPEAN CREDIT FLOW')
GROUP BY A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME, A.COB_DATE
ORDER BY ABS_USD_PV01SPRD DESC