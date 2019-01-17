SELECT COB_DATE, SUM (USD_EXPOSURE) AS USD_EXPOSURE, sum(a.USD_PV01SPRD) as sprd_pv01, sum(a.USD_PV10_BENCH) as pv10 FROM cdwuser.U_DM_IR a WHERE cob_date in ('2018-02-28','2018-02-27') AND CCC_division IN ('FIXED INCOME DIVISION') AND CCC_BUSINESS_AREA in ('STRUCTURED RATES') AND CCC_PL_REPORTING_REGION = 'EMEA' AND PRODUCT_TYPE_CODE = 'CRDINDEX' GROUP BY cob_date