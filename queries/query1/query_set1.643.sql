SELECT     a.COB_DATE,     CASE         WHEN (a.CCC_DIVISION IN ('FIXED INCOME DIVISION') AND a.CCC_BUSINESS_AREA IN ('COMMODITIES')) THEN a.PROD_POS_NAME_DESCRIPTION     ELSE a.CURRENCY_OF_MEASURE END AS CURRENCY_OF_MEASURE,     CASE         WHEN a.CCC_BANKING_TRADING='TRADING' THEN 'TRADING'     ELSE 'BANKING' END AS BT_FLAG,     SUM (CAST(a.USD_IR_UNIFIED_PV01 AS DOUBLE PRECISION)) AS usd_ir_unified_pv01 FROM cdwuser.U_IR_MSR_INTRPLT a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and A.CCC_TAPS_COMPANY in ('1050') AND      (a.CCC_DIVISION IN ('FIXED INCOME DIVISION') OR     a.CCC_DIVISION IN ('BANK RESOURCE MANAGEMENT') OR     (a.CCC_DIVISION IN ('INSTITUTIONAL EQUITY DIVISION') AND a.CCC_BUSINESS_AREA NOT IN ('INTERNATIONAL WEALTH MGMT')) OR     a.CCC_DIVISION IN ('INSTITUTIONAL SECURITIES OTHER')) AND     a.USD_IR_UNIFIED_PV01 IS NOT NULL GROUP BY     a.COB_DATE,     CASE         WHEN (a.CCC_DIVISION IN ('FIXED INCOME DIVISION') AND a.CCC_BUSINESS_AREA IN ('COMMODITIES')) THEN a.PROD_POS_NAME_DESCRIPTION     ELSE a.CURRENCY_OF_MEASURE END,     CASE         WHEN a.CCC_BANKING_TRADING='TRADING' THEN 'TRADING'     ELSE 'BANKING' END HAVING SUM (a.USD_IR_UNIFIED_PV01) <> 0