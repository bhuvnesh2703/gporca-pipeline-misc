SELECT     a.COB_DATE,     a.CURRENCY_OF_MEASURE,     CASE          WHEN a.TERM_OF_MEASURE IS NULL OR a.TERM_OF_MEASURE <= (1 * 365.0) THEN '0-1'         WHEN a.TERM_OF_MEASURE > (1 * 365.0) AND a.TERM_OF_MEASURE <= (3 * 365.0) THEN '1-3'         WHEN a.TERM_OF_MEASURE > (3 * 365.0) AND a.TERM_OF_MEASURE <= (5 * 365.0) THEN '3-5'         WHEN a.TERM_OF_MEASURE > (5 * 365.0) AND a.TERM_OF_MEASURE <= (10 * 365.0) THEN '5-10'         WHEN a.TERM_OF_MEASURE > (10 * 365.0) AND a.TERM_OF_MEASURE <= (15 * 365.0) THEN '10-15'     ELSE '15+' END AS TERM_BUCKET,     SUM(a.USD_IR_UNIFIED_PV01) AS USD_IR_UNIFIED_PV01 FROM     cdwuser.U_IR_MSR a WHERE  (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and A.CCC_PL_REPORTING_REGION in ('JAPAN') AND        CCC_BANKING_TRADING IN ('TRADING') AND     (a.PRODUCT_TYPE_CODE IN ('BONDFUT','BONDFUTOPT') OR (a.VAR_EXCL_FL <> 'Y' AND a.MEASURE_VAR_EXCL_FL <> 'Y')) AND     (a.ccc_business_area <> 'INTERNATIONAL WEALTH MGMT') AND     a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' GROUP BY     a.COB_DATE,     a.CURRENCY_OF_MEASURE,     CASE          WHEN a.TERM_OF_MEASURE IS NULL OR a.TERM_OF_MEASURE <= (1 * 365.0) THEN '0-1'         WHEN a.TERM_OF_MEASURE > (1 * 365.0) AND a.TERM_OF_MEASURE <= (3 * 365.0) THEN '1-3'         WHEN a.TERM_OF_MEASURE > (3 * 365.0) AND a.TERM_OF_MEASURE <= (5 * 365.0) THEN '3-5'         WHEN a.TERM_OF_MEASURE > (5 * 365.0) AND a.TERM_OF_MEASURE <= (10 * 365.0) THEN '5-10'         WHEN a.TERM_OF_MEASURE > (10 * 365.0) AND a.TERM_OF_MEASURE <= (15 * 365.0) THEN '10-15'     ELSE '15+' END