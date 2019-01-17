SELECT
    A.COB_DATE,
    A.CREDIT_CORPS_CCC_BUSINESS_AREA,
CASE WHEN A.CREDIT_CORPS_CCC_PRODUCT_LINE in ('INVESTMENT GRADE TRADING','HIGH YIELD','EUROPEAN CREDIT FLOW1') and CCC_PL_REPORTING_REGION = 'EMEA' Then 'EUROPEAN CREDIT FLOW' ELSE CREDIT_CORPS_CCC_PRODUCT_LINE END AS CREDIT_CORPS_CCC_PRODUCT_LINE,
    A.PRODUCT_TYPE_CODE_GROUPED,
    SUM (A.USD_PV10_BENCH) AS USD_PV10_BENCH
FROM cdwuser.U_DM_CC A
WHERE
    A.COB_DATE IN ('2018-02-28') AND 
    A.CREDIT_TYPE_T1T2_FLAG = 'CREDIT-CORP_T1T2' AND A.CCC_PRODUCT_LINE NOT IN ('DISTRESSED TRADING') AND
    A.CCC_STRATEGY NOT LIKE '%PAR LOANS TRADING%' AND CCC_STRATEGY NOT in ('PRIMARY LOANS - AP','SECONDARY LOANS - AP') AND A.CCC_PRODUCT_LINE <> 'PAR LOANS TRADING' AND BOOK NOT IN ('LDN PAR TRADING RG-LNRGO','LDN PAR TRADING SIDDIQUI-LNSSL')
GROUP BY
    A.COB_DATE,
    A.CREDIT_CORPS_CCC_BUSINESS_AREA,
CASE WHEN A.CREDIT_CORPS_CCC_PRODUCT_LINE in ('INVESTMENT GRADE TRADING','HIGH YIELD','EUROPEAN CREDIT FLOW1') and CCC_PL_REPORTING_REGION = 'EMEA' Then 'EUROPEAN CREDIT FLOW' ELSE CREDIT_CORPS_CCC_PRODUCT_LINE END,
    A.PRODUCT_TYPE_CODE_GROUPED