SELECT
    A.COB_DATE, a.PRODUCT_TYPE_CODE,
    CASE WHEN A.PRODUCT_TYPE_CODE IN ('GDPLINKED','GVTBONDIL') THEN 'CASH' ELSE A.PRODUCT_TYPE_CODE_GROUPED END AS PRODUCT_TYPE_CODE_GROUPED,
    CASE WHEN A.GICS_LEVEL_1_NAME='GOVERNMENT' THEN 'Sov' Else 'NonSov' END AS SovFlag,
    SUM (A.USD_NET_EXPOSURE) AS USD_NET_EXPOSURE
FROM cdwuser.U_DM_CC A
WHERE
    A.COB_DATE IN ('2018-02-28') AND 
    A.CCC_STRATEGY = 'EM CREDIT' AND
    A.COUNTRY_CD_OF_RISK IN ('ARG', 'VEN', 'UKR')
GROUP BY
    A.COB_DATE, a.PRODUCT_TYPE_CODE,
    CASE WHEN A.PRODUCT_TYPE_CODE IN ('GDPLINKED','GVTBONDIL') THEN 'CASH' ELSE A.PRODUCT_TYPE_CODE_GROUPED END,
    CASE WHEN A.GICS_LEVEL_1_NAME='GOVERNMENT' THEN 'Sov' Else 'NonSov' END