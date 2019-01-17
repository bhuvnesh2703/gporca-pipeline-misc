SELECT
    CUR.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,
    CUR.CURRENT_USD_NET_EXPOSURE, CUR.ABS_CURRENT_USD_NET_EXPOSURE,
    PRV.PRV_USD_NET_EXPOSURE
FROM
    (
        SELECT
            A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,
            COALESCE (SUM (A.USD_NET_EXPOSURE),
                      0) AS CURRENT_USD_NET_EXPOSURE,
            ABS (COALESCE (SUM (A.USD_NET_EXPOSURE),
                           0)) AS ABS_CURRENT_USD_NET_EXPOSURE
        FROM CDWUSER.U_DM_CC A
        WHERE
            A.COB_DATE IN ('2018-02-28') AND 
            STATE_CODE = 'PR' AND
            CCC_BUSINESS_AREA = 'MUNICIPAL SECURITIES' AND
            PRODUCT_TYPE_CODE NOT IN ('TOB') AND CCC_BANKING_TRADING = 'TRADING' AND
            POSITION_ULT_ISSUER_PARTY_DARWIN_NAME <> 'UNDEFINED'
 AND (CCC_PL_REPORTING_REGION IN ('EMEA','EUROPE'))
        GROUP BY A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME
    )
    CUR
    FULL OUTER JOIN
    (
        SELECT
            A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,
            COALESCE (SUM (A.USD_NET_EXPOSURE),
                      0) AS PRV_USD_NET_EXPOSURE
        FROM CDWUSER.U_DM_CC A
        WHERE
            A.COB_DATE IN ('2018-02-27') AND 
            STATE_CODE = 'PR' AND
            CCC_BUSINESS_AREA = 'MUNICIPAL SECURITIES' AND
            PRODUCT_TYPE_CODE NOT IN ('TOB') AND CCC_BANKING_TRADING = 'TRADING' AND
            POSITION_ULT_ISSUER_PARTY_DARWIN_NAME <> 'UNDEFINED'
 AND (CCC_PL_REPORTING_REGION IN ('EMEA','EUROPE'))
        GROUP BY A.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME
    )
    PRV
    ON Cur.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME = PRV.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME