SELECT     a.COB_DATE,     CASE         WHEN a.EXPIRATION_DATE <= (a.COB_DATE+INTERVAL '1 MONTH') THEN '1m'         WHEN a.EXPIRATION_DATE <= (a.COB_DATE+INTERVAL '3 MONTHS') THEN '3m'         WHEN a.EXPIRATION_DATE <= (a.COB_DATE+INTERVAL '6 MONTHS') THEN '6m'         WHEN a.EXPIRATION_DATE <= (a.COB_DATE+INTERVAL '9 MONTHS') THEN '9m'         WHEN a.EXPIRATION_DATE <= (a.COB_DATE+INTERVAL '1 YEAR') THEN '1y'         WHEN a.EXPIRATION_DATE <= (a.COB_DATE+INTERVAL '2 YEARS') THEN '2y'         WHEN a.EXPIRATION_DATE > (a.COB_DATE+INTERVAL '2 YEARS') THEN '2y'         ELSE 'x'     END AS fx_fwd_bucket,     CASE         WHEN SUBSTR (a.CURRENCY_OF_MEASURE,4,3) <> '' THEN 'Other'         WHEN a.CURRENCY_OF_MEASURE = 'CNY' AND a.ONSHORE_FL = 'N' THEN 'CNH'         ELSE a.CURRENCY_OF_MEASURE     END AS currency_of_msr,     SUM(CAST(a.USD_FX AS DOUBLE PRECISION)) AS USD_FX FROM cdwuser.U_FX_MSR_INTRPLT a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-21') and A.CCC_PL_REPORTING_REGION in ('ASIA PACIFIC') AND  /*    (a.PRODUCT_TYPE_CODE IN ('BONDFUT', 'BONDFUTOPT') OR (a.VAR_EXCL_FL <> 'Y' AND a.MEASURE_VAR_EXCL_FL <> 'Y')) AND*/     a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND     /*a.CCC_BUSINESS_AREA NOT IN ('COMMODITIES') AND*/       CCC_BANKING_TRADING='TRADING' AND     a.usd_FX <> 0 AND     a.usd_FX IS NOT NULL AND     a.vertical_system LIKE 'FXDDI%' AND     a.CURRENCY_OF_MEASURE IN('CNY','CNH') GROUP BY     a.COB_DATE,     CASE         WHEN a.EXPIRATION_DATE <= (a.COB_DATE+INTERVAL '1 MONTH') THEN '1m'         WHEN a.EXPIRATION_DATE <= (a.COB_DATE+INTERVAL '3 MONTHS') THEN '3m'         WHEN a.EXPIRATION_DATE <= (a.COB_DATE+INTERVAL '6 MONTHS') THEN '6m'         WHEN a.EXPIRATION_DATE <= (a.COB_DATE+INTERVAL '9 MONTHS') THEN '9m'         WHEN a.EXPIRATION_DATE <= (a.COB_DATE+INTERVAL '1 YEAR') THEN '1y'         WHEN a.EXPIRATION_DATE <= (a.COB_DATE+INTERVAL '2 YEARS') THEN '2y'         WHEN a.EXPIRATION_DATE > (a.COB_DATE+INTERVAL '2 YEARS') THEN '2y'         ELSE 'x'     END,     CASE         WHEN SUBSTR (a.CURRENCY_OF_MEASURE,4,3) <> '' THEN 'Other'         WHEN a.CURRENCY_OF_MEASURE = 'CNY' AND a.ONSHORE_FL = 'N' THEN 'CNH'         ELSE a.CURRENCY_OF_MEASURE     END