SELECT
    COALESCE (M.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME, N.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME) AS POSITION_ULT_ISSUER_PARTY_DARWIN_NAME, 
    M.CURRENT_USD_PV10_BENCH,
    N.PREVIOUS_USD_PV10_BENCH,
    ABS (M.CURRENT_USD_PV10_BENCH) AS ABS_CURRENT_USD_PV10_BENCH
FROM
    (
        SELECT
            A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,
            COALESCE (SUM (A.USD_PV10_BENCH),
                      0) AS CURRENT_USD_PV10_BENCH
        FROM CDWUSER.U_DM_CC A
        WHERE
            A.COB_DATE IN ('2018-02-28') AND 
    a.CCC_PL_REPORTING_REGION in ('EMEA','EUROPE') AND 
            A.CCC_PRODUCT_LINE IN ('INV GRADE TRADING - EU', 'HIGH YIELD - EU', 'EUROPEAN CREDIT FLOW') AND
            NOT (A.FID1_SENIORITY IN ('SUBT1', 'SUBUT2', 'AT1') and PRODUCT_TYPE_CODE in ('BOND','PREF'))
 AND (CCC_PL_REPORTING_REGION IN ('EMEA','EUROPE'))
        GROUP BY A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME
    )
    M
   FULL OUTER JOIN
    (
        SELECT
            A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,
            COALESCE (SUM (A.USD_PV10_BENCH),
                      0) AS PREVIOUS_USD_PV10_BENCH
        FROM CDWUSER.U_DM_CC A
        WHERE
            A.COB_DATE IN ('2018-02-27') AND 
    a.CCC_PL_REPORTING_REGION in ('EMEA','EUROPE') AND 
            A.CCC_PRODUCT_LINE IN ('INV GRADE TRADING - EU', 'HIGH YIELD - EU', 'EUROPEAN CREDIT FLOW') AND
            NOT (A.FID1_SENIORITY IN ('SUBT1', 'SUBUT2', 'AT1') and PRODUCT_TYPE_CODE in ('BOND','PREF'))
 AND (CCC_PL_REPORTING_REGION IN ('EMEA','EUROPE'))
        GROUP BY A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME
    )
    N
    ON M.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME = N.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME
ORDER BY ABS (M.CURRENT_USD_PV10_BENCH - N.PREVIOUS_USD_PV10_BENCH) DESC