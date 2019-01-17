SELECT
    A.COB_DATE,
    A.CC_REGION_GROUP,
    A.SECTYPE2,
    SUM (A.USD_PV10_BENCH) AS USD_PV10_BENCH
FROM cdwuser.U_DM_CC A
WHERE
    a.COB_DATE IN ('2018-02-28', '2018-02-27') AND 

    a.CCC_PL_REPORTING_REGION in ('EMEA','EUROPE') AND 
    A.CREDIT_CORPS_CCC_BUSINESS_AREA IN ('CREDIT-CORPORATES') AND
    A.CCC_STRATEGY NOT LIKE '%PAR LOANS TRADING%' AND CCC_STRATEGY NOT in ('PRIMARY LOANS - AP','SECONDARY LOANS - AP') AND CCC_PRODUCT_LINE <> 'PAR LOANS TRADING' AND BOOK NOT IN ('LDN PAR TRADING RG-LNRGO','LDN PAR TRADING SIDDIQUI-LNSSL') AND 

    A.CREDIT_TRADING_FLAG = 'Flow Trading'
GROUP BY
    A.SECTYPE2, A.COB_DATE, 
    A.CC_REGION_GROUP
ORDER BY
    A.CC_REGION_GROUP,
    A.SECTYPE2