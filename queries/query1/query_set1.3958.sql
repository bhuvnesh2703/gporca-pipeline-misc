SELECT
    A.COB_DATE,
    A.SECTYPE2, 
    SUM (A.USD_PV10_BENCH) AS USD_PV10_BENCH
FROM cdwuser.U_DM_CC A
WHERE
    a.COB_DATE IN ('2018-02-28', '2018-02-27') AND 


    (A.CCC_STRATEGY LIKE '%PAR LOANS TRADING%' OR CCC_STRATEGY in ('PRIMARY LOANS - AP','SECONDARY LOANS - AP') OR CCC_PRODUCT_LINE = 'PAR LOANS TRADING' OR BOOK IN ('LDN PAR TRADING RG-LNRGO','LDN PAR TRADING SIDDIQUI-LNSSL')) AND
    A.CREDIT_TRADING_FLAG = 'Flow Trading'
GROUP BY
    A.SECTYPE2, 
    A.COB_DATE