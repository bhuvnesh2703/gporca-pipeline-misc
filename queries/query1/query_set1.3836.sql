SELECT
    A.COB_DATE,
    SUM (A.USD_PV10_BENCH) AS USD_PV10_BENCH
FROM cdwuser.U_DM_CC A
WHERE
    A.CCC_BUSINESS_AREA = 'MUNICIPAL SECURITIES' AND
    a.COB_DATE IN ('2018-02-28', '2018-02-27') 
GROUP BY A.COB_DATE