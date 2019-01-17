SELECT COB_DATE, POSITION_ID, PROCESS_ID, CCC_PL_REPORTING_REGION, SUM(COALESCE(NOTIONAL,0)) AS NOTIONAL, CASE WHEN (SUM(COALESCE(NOTIONAL,0)) >0) THEN 'LONG' WHEN (SUM(COALESCE(NOTIONAL,0)) <0) THEN 'SHORT' ELSE CAST (NULL AS VARCHAR(7)) END As LONG_SHORT, EXPIRY_BUCKET, STRIKE_BUCKET from (SELECT v.COB_DATE, V.POSITION_ID, V.PROCESS_ID, V.CCC_PL_REPORTING_REGION, CASE WHEN ((V.USD_DELTA IS NOT NULL) OR (V.USD_DELTA IS NULL AND v.BASKET_FL IN ('Y'))) THEN COALESCE(v.TRADE_SIZE*V.LOT_SIZE*V.MEASURE_CONVERSION_FACTOR*V.STRIKE,0) ELSE 1000*v.USD_DELTA END AS NOTIONAL, CASE WHEN v.OPTION_MONEYNESS IS NULL THEN CAST (NULL AS VARCHAR(7)) WHEN (v.OPTION_MONEYNESS <= 0.7 AND v.PRODUCT_TYPE_CODE = 'OPTION') THEN '< 70%' WHEN v.OPTION_MONEYNESS > 0.7 AND v.OPTION_MONEYNESS <= 0.75 THEN '70-75%' WHEN v.OPTION_MONEYNESS > 0.75 AND v.OPTION_MONEYNESS <= 0.8 THEN '75-80%' WHEN v.OPTION_MONEYNESS > 0.8 AND v.OPTION_MONEYNESS <= 0.85 THEN '80-85%' WHEN v.OPTION_MONEYNESS > 0.85 AND v.OPTION_MONEYNESS <= 0.9 THEN '85-90%' WHEN v.OPTION_MONEYNESS > 0.9 AND v.OPTION_MONEYNESS <= 0.95 THEN '90-95%' WHEN v.OPTION_MONEYNESS > 0.95 AND v.OPTION_MONEYNESS <= 0.96 THEN '95-96%' WHEN v.OPTION_MONEYNESS > 0.96 AND v.OPTION_MONEYNESS <= 0.97 THEN '96-97%' WHEN v.OPTION_MONEYNESS > 0.97 AND v.OPTION_MONEYNESS <= 0.98 THEN '97-98%' WHEN v.OPTION_MONEYNESS > 0.98 AND v.OPTION_MONEYNESS <= 0.99 THEN '98-99%' WHEN v.OPTION_MONEYNESS > 0.99 AND v.OPTION_MONEYNESS <= 1.0 THEN '99-100%' WHEN v.OPTION_MONEYNESS > 1.0 AND v.OPTION_MONEYNESS <= 1.01 THEN '100-101%' WHEN v.OPTION_MONEYNESS > 1.01 AND v.OPTION_MONEYNESS <= 1.02 THEN '101-102%' WHEN v.OPTION_MONEYNESS > 1.02 AND v.OPTION_MONEYNESS <= 1.03 THEN '102-103%' WHEN v.OPTION_MONEYNESS > 1.03 AND v.OPTION_MONEYNESS <= 1.04 THEN '103-104%' WHEN v.OPTION_MONEYNESS > 1.04 AND v.OPTION_MONEYNESS <= 1.05 THEN '104-105%' WHEN v.OPTION_MONEYNESS > 1.05 AND v.OPTION_MONEYNESS <= 1.1 THEN '105-110%' WHEN v.OPTION_MONEYNESS > 1.1 AND v.OPTION_MONEYNESS <= 1.15 THEN '110-115%' WHEN v.OPTION_MONEYNESS > 1.15 AND v.OPTION_MONEYNESS <= 1.2 THEN '115-120%' WHEN v.OPTION_MONEYNESS > 1.2 AND v.OPTION_MONEYNESS <= 1.25 THEN '120-125%' WHEN v.OPTION_MONEYNESS > 1.25 AND v.OPTION_MONEYNESS <= 1.3 THEN '125-130%' WHEN v.OPTION_MONEYNESS > 1.3 THEN '>130%' ELSE CAST (NULL AS VARCHAR(7)) END As STRIKE_BUCKET, CASE WHEN ( (v.EXPIRATION_DATE) - (v.cob_date) <= 7 ) THEN '<1W' WHEN ( (v.EXPIRATION_DATE) - (v.cob_date) > 7 AND (v.EXPIRATION_DATE) - (v.cob_date) <= 14 ) THEN '1-2W' WHEN ( (v.EXPIRATION_DATE) - (v.cob_date) > 14 AND (v.EXPIRATION_DATE) - (v.cob_date) <= 30 ) THEN '2W-1M' WHEN ( (v.EXPIRATION_DATE) - (v.cob_date) > 30 AND (v.EXPIRATION_DATE) - (v.cob_date) <= 91 ) THEN '1-3M' WHEN ( (v.EXPIRATION_DATE) - (v.cob_date) > 91 AND (v.EXPIRATION_DATE) - (v.cob_date) <= 183 ) THEN '3-6M' WHEN ( (v.EXPIRATION_DATE) - (v.cob_date) > 183 AND (v.EXPIRATION_DATE) - (v.cob_date) <= 365 ) THEN '6-12M' WHEN ( (v.EXPIRATION_DATE) - (v.cob_date) > 365 AND (v.EXPIRATION_DATE) - (v.cob_date) <= 1096 ) THEN '1-3Y' WHEN ( (v.EXPIRATION_DATE) - (v.cob_date) > 1096 AND (v.EXPIRATION_DATE) - (v.cob_date) <= 1826 ) THEN '3-5Y' WHEN ( (v.EXPIRATION_DATE) - (v.cob_date) > 1826 AND (v.EXPIRATION_DATE) - (v.cob_date) <= 3652 ) THEN '5-10Y' WHEN ( (v.EXPIRATION_DATE) - (v.cob_date) > 3652 ) THEN '>10Y' Else 'N/A' END As EXPIRY_BUCKET FROM CDWUSER.U_EQ_MSR V WHERE v.CCC_DIVISION IN ('INSTITUTIONAL EQUITY DIVISION') AND v.CCC_BANKING_TRADING IN ('TRADING' ) AND V.CCC_BUSINESS_AREA IN ('DERIVATIVES') AND V.PRODUCT_TYPE_CODE IN ('OPTION') AND v.EXECUTIVE_MODEL IN ('AMERICAN-OPTION','EUROPEAN-OPTION') AND V.CCC_STRATEGY IN ('EXOTICS') AND v.SILO_SRC = 'IED' AND V.COB_DATE IN ('2018-02-28') AND V.CCC_PL_REPORTING_REGION IN ('AMERICAS') AND V.CASH_ISSUE_TYPE IN ('INDEX','ETF','BASKET') GROUP BY 1,2,3,4,5,6,7 )sub_qry GROUP BY COB_DATE, POSITION_ID, PROCESS_ID, CCC_PL_REPORTING_REGION, EXPIRY_BUCKET, STRIKE_BUCKET ORDER BY POSITION_ID