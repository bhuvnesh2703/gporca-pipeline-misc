SELECT
    A.COB_DATE,
    A.IS_SOV, 
    SUM (A.USD_NET_EXPOSURE) AS USD_NET_EXPOSURE
FROM cdwuser.U_DM_CC A
WHERE
    a.COB_DATE IN ('2018-02-28', '2018-02-27') AND 
    A.IS_UK_GROUP = 'Y' AND 

    A.CCC_STRATEGY = 'EM CREDIT' AND
    A.COUNTRY_CD_OF_RISK IN ('ARG', 'VEN', 'UKR')
GROUP BY
    A.COB_DATE,
    A.IS_SOV