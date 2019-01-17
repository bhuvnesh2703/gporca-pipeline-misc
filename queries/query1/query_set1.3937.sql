SELECT
    A.COB_DATE,
    A.CCC_PL_REPORTING_REGION, A.IS_FINANCIALS, 
    SUM (a.USD_NET_EXPOSURE) AS netexp
FROM cdwuser.U_DM_CC A
WHERE
    a.COB_DATE IN ('2018-02-28', '2018-02-21') AND 

    a.CCC_PL_REPORTING_REGION in ('EMEA','EUROPE') AND 
    A.CCC_BUSINESS_AREA = 'CREDIT-CORPORATES' AND
    A.CREDIT_TRADING_FLAG = 'Junior Subs'
GROUP BY
    A.COB_DATE,
    A.CCC_PL_REPORTING_REGION, A.IS_FINANCIALS