SELECT     COB_DATE,     CASE         WHEN CR_ULTIMATE_CNTRY_CODE IN ('MAC', 'LKA', 'PAK') THEN 'Other Asia'     ELSE CR_ULTIMATE_CNTRY_CODE END AS COUNTRY_CODE,     CASE         WHEN CCC_BANKING_TRADING = 'TRADING' THEN 'TRADING'     ELSE 'BANKING' END AS BT_FLAG,     SUM (USD_EXPOSURE) AS NET_EXPOSURE FROM     cdwuser.U_EXP_MSR a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and A.CCC_PL_REPORTING_REGION in ('JAPAN','ASIA PACIFIC') AND A.CCC_TAPS_COMPANY in ('0302','0347','0853','4043','4298','4863','6120','6899','6837','6893','4044','5869','0856','6325','0301','0893','0993') AND      (a.CCC_DIVISION='FIXED INCOME DIVISION' AND     a.CCC_BUSINESS_AREA NOT IN ('LENDING', 'FID MANAGEMENT') AND     a.CCC_PRODUCT_LINE <> 'DISTRESSED TRADING') GROUP BY     COB_DATE,     CASE         WHEN CCC_BANKING_TRADING = 'TRADING' THEN 'TRADING'     ELSE 'BANKING' END,     CASE         WHEN CR_ULTIMATE_CNTRY_CODE IN ('MAC', 'LKA', 'PAK') THEN 'Other Asia'     ELSE CR_ULTIMATE_CNTRY_CODE END