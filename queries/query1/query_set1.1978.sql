SELECT     a.COB_DATE,     a.ISSUER_COUNTRY_CODE_DECOMP,     a.CCC_DIVISION,     CASE         WHEN CCC_BANKING_TRADING='TRADING' THEN 'TRADING'     ELSE 'BANKING' END AS BT_FLAG,     SUM (a.USD_EQ_DELTA_DECOMP) AS USD_EQ_DELTA FROM CDWUSER.U_DECOMP_MSR a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and A.CCC_PL_REPORTING_REGION in ('JAPAN') AND      ((a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.ccc_business_area <> 'INTERNATIONAL WEALTH MGMT') OR     a.CCC_DIVISION = 'FIXED INCOME DIVISION' OR     a.CCC_DIVISION='BANK RESOURCE MANAGEMENT' OR     a.CCC_DIVISION='INSTITUTIONAL SECURITIES OTHER') AND     a.USD_EQ_DELTA_DECOMP IS NOT NULL GROUP BY     a.COB_DATE,     a.ISSUER_COUNTRY_CODE_DECOMP,     a.CCC_DIVISION,     CASE         WHEN CCC_BANKING_TRADING='TRADING' THEN 'TRADING'     ELSE 'BANKING' END HAVING SUM     (a.USD_EQ_DELTA_DECOMP) <> 0