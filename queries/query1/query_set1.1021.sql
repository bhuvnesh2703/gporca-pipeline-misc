SELECT     a.COB_DATE,     CASE         WHEN SUBSTR (a.CURRENCY_OF_MEASURE,4,3) <> '' THEN 'Other'         WHEN a.CURRENCY_OF_MEASURE = 'UBD' THEN 'USD'         WHEN a.CURRENCY_OF_MEASURE = 'CNY' AND a.ONSHORE_FL = 'N' THEN 'CNH'         WHEN a.CURRENCY_OF_MEASURE = 'KRW' AND a.ONSHORE_FL = 'Y' THEN 'KRX'     ELSE a.CURRENCY_OF_MEASURE END AS currency_of_msr,     CASE          WHEN A.CCC_TAPS_COMPANY in ('4391', '4341') AND          1=1 THEN 1     ELSE 0 END AS IS_FILTER,     SUM (a.USD_FX) AS USD_FX FROM cdwuser.U_FX_MSR a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and A.CCC_TAPS_COMPANY in ('4391', '4341') AND        CCC_BANKING_TRADING='TRADING' AND /*    (a.PRODUCT_TYPE_CODE IN ('BONDFUT', 'BONDFUTOPT') OR     (a.VAR_EXCL_FL <> 'Y' AND a.MEASURE_VAR_EXCL_FL <> 'Y')) AND*/     a.CCC_DIVISION IN ('FIXED INCOME DIVISION')     /*a.CCC_BUSINESS_AREA NOT IN ('COMMODITIES') AND*/ GROUP BY     COB_DATE,     CASE         WHEN SUBSTR (a.CURRENCY_OF_MEASURE,4,3) <> '' THEN 'Other'         WHEN a.CURRENCY_OF_MEASURE = 'UBD' THEN 'USD'         WHEN a.CURRENCY_OF_MEASURE = 'CNY' AND a.ONSHORE_FL = 'N' THEN 'CNH'         WHEN a.CURRENCY_OF_MEASURE = 'KRW' AND a.ONSHORE_FL = 'Y' THEN 'KRX'     ELSE a.CURRENCY_OF_MEASURE END,     CASE          WHEN A.CCC_TAPS_COMPANY in ('4391', '4341') AND          1=1 THEN 1     ELSE 0 END