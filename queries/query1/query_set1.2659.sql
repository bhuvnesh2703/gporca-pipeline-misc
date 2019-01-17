SELECT * FROM ( SELECT CASE WHEN (CCC_BUSINESS_AREA IN ('CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'YES' ELSE 'NO' END AS IS_CVA, CCC_DIVISION, CCC_BUSINESS_AREA,CCC_STRATEGY, CCC_PRODUCT_LINE,CCC_BANKING_TRADING, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(IR_PV01, 0) ELSE 0 END) AS IR_PV01_COB, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(IR_PV01, 0) ELSE -COALESCE(IR_PV01, 0) END) AS IR_PV01_CHANGE, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(IR_VEGA, 0) ELSE 0 END) AS IR_VEGA_COB, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(IR_VEGA, 0) ELSE -COALESCE(IR_VEGA, 0) END) AS IR_VEGA_CHANGE, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(IR_GAMMA, 0) ELSE 0 END) AS IR_GAMMA_COB, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(IR_GAMMA, 0) ELSE -COALESCE(IR_GAMMA, 0) END) AS IR_GAMMA_CHANGE, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_PV01SPRD, 0) ELSE 0 END) AS USD_PV01SPRD_COB, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_PV01SPRD, 0) ELSE -COALESCE(USD_PV01SPRD, 0) END) AS USD_PV01SPRD_CHANGE, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_PV10_COMBINED, 0) ELSE 0 END) AS USD_PV10_COMBINED_COB, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_PV10_COMBINED, 0) ELSE -COALESCE(USD_PV10_COMBINED, 0) END) AS USD_PV10_COMBINED_CHANGE, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_PV10_BENCH, 0) ELSE 0 END) AS USD_PV10_BENCH_COB, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_PV10_BENCH, 0) ELSE -COALESCE(USD_PV10_BENCH, 0) END) AS USD_PV10_BENCH_CHANGE, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_CR_KAPPA, 0) ELSE 0 END) AS USD_CR_KAPPA_COB, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_CR_KAPPA, 0) ELSE -COALESCE(USD_CR_KAPPA, 0) END) AS USD_CR_KAPPA_CHANGE, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_FX, 0) ELSE 0 END) AS USD_FX_COB, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_FX, 0) ELSE -COALESCE(USD_FX, 0) END) AS USD_FX_CHANGE, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_FX_KAPPA, 0) ELSE 0 END) AS USD_FX_KAPPA_COB, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_FX_KAPPA, 0) ELSE -COALESCE(USD_FX_KAPPA, 0) END) AS USD_FX_KAPPA_CHANGE, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_PROCEED, 0) ELSE 0 END) AS USD_PROCEED_COB, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_PROCEED, 0) ELSE -COALESCE(USD_PROCEED, 0) END) AS USD_PROCEED_CHANGE, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_NET_EXPOSURE, 0) ELSE 0 END) AS USD_NET_EXPOSURE_COB, SUM(CASE WHEN IS_COB = 1 THEN COALESCE(USD_NET_EXPOSURE, 0) ELSE -COALESCE(USD_NET_EXPOSURE, 0) END) AS USD_NET_EXPOSURE_CHANGE FROM ( SELECT CASE WHEN COB_DATE = '2018-02-28' THEN 1 ELSE 0 END AS IS_COB, CCC_DIVISION, CCC_BUSINESS_AREA, CCC_STRATEGY, CCC_PRODUCT_LINE, CCC_BANKING_TRADING, SUM(USD_PV01) AS IR_PV01, SUM(USD_KAPPA) AS IR_VEGA, SUM(USD_IR_PARTIAL_GAMMA) AS IR_GAMMA, SUM(USD_PV01SPRD) AS USD_PV01SPRD, SUM(USD_PV10_BENCH) AS USD_PV10_BENCH, SUM(USD_CR_KAPPA) AS USD_CR_KAPPA, SUM(USD_FX) AS USD_FX, SUM(USD_FX_KAPPA) AS USD_FX_KAPPA, SUM(USD_MARKET_VALUE) AS USD_PROCEED, SUM(USD_EXPOSURE) AS USD_NET_EXPOSURE, SUM(USD_PV10_COMBINED) AS USD_PV10_COMBINED FROM ( /*** EXP_MSR ***/ SELECT COB_DATE, CCC_DIVISION, CCC_BUSINESS_AREA,CCC_STRATEGY, CCC_PRODUCT_LINE, CCC_BANKING_TRADING, SUM(COALESCE(USD_IR_UNIFIED_PV01,0)) AS USD_PV01, SUM(CASE WHEN CURRENCY_OF_MEASURE IN ('UBD','USD') THEN 0 ELSE COALESCE(USD_FX,0) END) AS USD_FX, SUM(COALESCE(USD_IR_KAPPA,0))/10 AS USD_KAPPA, SUM(COALESCE(USD_CR_KAPPA,0)) AS USD_CR_KAPPA, SUM(COALESCE(USD_IR_PARTIAL_GAMMA,0)) AS USD_IR_PARTIAL_GAMMA, SUM(COALESCE(USD_PV01SPRD,0)) AS USD_PV01SPRD, SUM(COALESCE(USD_EXPOSURE,0)) AS USD_EXPOSURE, SUM(COALESCE(USD_MARKET_VALUE,0)) AS USD_MARKET_VALUE, SUM(CASE WHEN FEED_SOURCE_NAME <> 'CORISK' THEN COALESCE(USD_FX_KAPPA, 0) + COALESCE(USD_FX_PARTIAL_KAPPA,0) WHEN FEED_SOURCE_NAME = 'CORISK' AND PRODUCT_TYPE_CODE = 'CURRENCY' THEN COALESCE(LCY_FX_KAPPA, 0)/1000 ELSE 0 END) AS USD_FX_KAPPA, 0 AS USD_PV10_BENCH, 0 AS USD_PV10_COMBINED FROM CDWUSER.U_EXP_MSR WHERE COB_DATE IN ('2018-02-28','2018-02-27') AND VAR_EXCL_FL <> 'Y' AND PARENT_LEGAL_ENTITY = '0517(G)' GROUP BY COB_DATE, CCC_DIVISION, CCC_BUSINESS_AREA,CCC_STRATEGY, CCC_PRODUCT_LINE, CCC_BANKING_TRADING UNION ALL /*** PV10 BENCH ***/ SELECT COB_DATE, CCC_DIVISION, CCC_BUSINESS_AREA,CCC_STRATEGY, CCC_PRODUCT_LINE, CCC_BANKING_TRADING, 0 AS USD_PV01, 0 AS USD_FX, 0 AS USD_KAPPA, 0 AS USD_CR_KAPPA, 0 AS USD_IR_PARTIAL_GAMMA, 0 AS USD_PV01SPRD, 0 AS USD_EXPOSURE, 0 AS USD_MARKET_VALUE, 0 AS USD_FX_KAPPA, SUM(USD_PV10_BENCH) AS USD_PV10_BENCH, SUM(CASE WHEN PRODUCT_TYPE_CODE IN ('BONDFUT', 'CASH', 'REPO') OR CCC_STRATEGY = 'MS DVA - STR NOTES' THEN 0 WHEN (PRODUCT_TYPE_CODE = 'DISTRESSED TRADING' AND PRODUCT_TYPE_CODE = 'TRRSWAP') THEN (USD_PV10_BENCH) ELSE (USD_PV10_BENCH + USD_PV10_BENCH_IMPLIED) END) AS USD_PV10_COMBINED FROM ( SELECT COB_DATE, CCC_DIVISION, CCC_BUSINESS_AREA,CCC_STRATEGY, CCC_PRODUCT_LINE, CCC_BANKING_TRADING, PRODUCT_TYPE_CODE, SUM (USD_PV10_BENCH) AS USD_PV10_BENCH, SUM( CASE WHEN ( ( var_excl_fl = 'N' AND vertical_system NOT LIKE 'STS_%' ) OR ( var_excl_fl = 'N' AND product_type_code IN ( 'SWAPIL' ) ) OR ( usd_pv10_bench IS NOT NULL ) ) THEN 0 ELSE ( Coalesce (usd_pv01sprd, 0) * 0.1 * credit_spread ) END) AS USD_PV10_BENCH_IMPLIED FROM ( SELECT COB_DATE, CCC_DIVISION, CCC_BUSINESS_AREA,CCC_STRATEGY, CCC_PRODUCT_LINE, CCC_BANKING_TRADING, PRODUCT_TYPE_CODE, VAR_EXCL_FL, VERTICAL_SYSTEM, USD_PV01SPRD AS USD_PV01SPRD, USD_PV10_BENCH AS USD_PV10_BENCH, CREDIT_SPREAD AS CREDIT_SPREAD FROM CDWUSER.U_CR_MSR a WHERE COB_DATE IN ('2018-02-28','2018-02-27') AND VAR_EXCL_FL <> 'Y' AND FEED_SOURCE_NAME <> 'ER1' AND PARENT_LEGAL_ENTITY = '0517(G)' UNION ALL SELECT B.COB_DATE, B.CCC_DIVISION, B.CCC_BUSINESS_AREA,B.CCC_STRATEGY, B.CCC_PRODUCT_LINE, B.CCC_BANKING_TRADING, B.PRODUCT_TYPE_CODE, B.VAR_EXCL_FL, B.VERTICAL_SYSTEM, 0 AS USD_PV01SPRD, USD_CREDIT_PV10PCT AS USD_PV10_BENCH, 0 AS CREDIT_SPREAD FROM CDWUSER.U_CR_MSR B INNER JOIN CDWUSER.U_IED_POSITION C ON B.COB_DATE = C.COB_DATE AND B.PROCESS_ID = C.PROCESS_ID AND B.POSITION_ID = C.POSITION_ID WHERE B.COB_DATE IN ('2018-02-28','2018-02-27') AND B.FEED_SOURCE_NAME = 'ER1' AND C.PRODUCT_TYPE_CODE IN ('ASCOT', 'CONVRT') AND C.PRODUCT_LEVEL = 'POS' AND B.VAR_EXCL_FL <> 'Y' AND B.PARENT_LEGAL_ENTITY = '0517(G)' ) X GROUP BY COB_DATE, CCC_DIVISION, CCC_BUSINESS_AREA,CCC_STRATEGY, CCC_PRODUCT_LINE, CCC_BANKING_TRADING, PRODUCT_TYPE_CODE ) Y GROUP BY COB_DATE, CCC_DIVISION, CCC_BUSINESS_AREA,CCC_STRATEGY, CCC_PRODUCT_LINE, CCC_BANKING_TRADING ) Z GROUP BY IS_COB, COB_DATE, CCC_DIVISION, CCC_BUSINESS_AREA,CCC_STRATEGY, CCC_PRODUCT_LINE, CCC_BANKING_TRADING ) W GROUP BY CCC_DIVISION, CCC_BUSINESS_AREA, CCC_STRATEGY, CCC_PRODUCT_LINE, CCC_BANKING_TRADING, IS_CVA ) N WHERE IR_PV01_COB + IR_PV01_CHANGE + IR_VEGA_COB + IR_VEGA_CHANGE + IR_GAMMA_COB + IR_GAMMA_CHANGE + USD_PV01SPRD_COB + USD_PV01SPRD_CHANGE + USD_PV10_BENCH_COB + USD_PV10_BENCH_CHANGE + USD_CR_KAPPA_COB + USD_CR_KAPPA_CHANGE + USD_FX_COB + USD_FX_CHANGE + USD_PROCEED_COB + USD_PROCEED_CHANGE + USD_NET_EXPOSURE_COB + USD_NET_EXPOSURE_CHANGE + usd_pv10_combined_COB + usd_pv10_combined_change <> 0 AND IS_CVA = 'YES'