WITH basedata AS ( SELECT * FROM ( SELECT le_group, book, product_type, CCC_BUSINESS_AREA, CCC_STRATEGY, CCC_PRODUCT_LINE, modval.SCENARIO_TYPE, STRESS_SCENARIO, SUM(SCENARIO_PNL) AS SCENARIO_PNL, PARALLEL_YC_MOVE_BPS AS PARA, CASE WHEN yc_pca_2_units IS NULL THEN '0' ELSE yc_pca_2_units END AS Steepflat, CASE WHEN modmap.scenario_type = 'Rscen_Direct_IR' THEN 0 ELSE pct_ir_vol_move END AS VOL, CASE WHEN ccc_product_line IN ('IR LIQUID MANAGEMENT', 'IR STRUCTURED MANAGEMENT') THEN 'IR MANAGEMENT' WHEN ccc_strategy = 'AP OPTIONS/EXOTICS' THEN 'AP OPTIONS/EXOTICS' WHEN ccc_strategy = 'CAD LIQUID RATES' THEN 'CAD LIQUID RATES' WHEN ccc_strategy = 'EU AGENCIES' THEN 'EU AGENCIES' WHEN ccc_strategy = 'EU OPTIONS/EXOTICS' THEN 'EU OPTIONS/EXOTICS' WHEN ccc_strategy IN ('GLOBAL LIQUID RATES AP', 'GLOBAL LIQUID RATES EU', 'GLOBAL LIQUID RATES JP', 'GLOBAL LIQUID RATES NA') THEN 'GLOBAL LIQUID RATES' WHEN ccc_strategy IN ('GLOBAL STRUCTURED RATES AP', 'GLOBAL STRUCTURED RATES EU', 'GLOBAL STRUCTURED RATES JP', 'GLOBAL STRUCTURED RATES NA') THEN 'GLOBAL STRUCTURED RATES' WHEN ccc_strategy IN ('DSP STRUCTURED NOTES AP', 'DSP STRUCTURED NOTES EU', 'DSP STRUCTURED NOTES JP', 'DSP STRUCTURED NOTES NA') THEN 'DSP STRUCTURED NOTES' WHEN ccc_strategy IN ('HYBRIDS INT RATES AP', 'HYBRIDS INT RATES EU', 'HYBRIDS INT RATES JP', 'HYBRIDS INT RATES NA') THEN 'HYBRIDS INT RATES' WHEN ccc_strategy IN ('INFLATION PRODUCTS AP', 'INFLATION PRODUCTS EU', 'INFLATION PRODUCTS JP', 'INFLATION PRODUCTS NA', 'TIPS INFLATION 50 PERCENT') THEN 'INFLATION PRODUCTS' WHEN ccc_strategy IN ('IR FX OPTIONS/EXOTICS EU', 'IR FX OPTIONS/EXOTICS JP') THEN 'IR FX OPTIONS/EXOTICS' WHEN ccc_strategy = 'JP OPTIONS/EXOTICS' THEN 'JP OPTIONS/EXOTICS' WHEN ccc_strategy = 'JPY GOVERNMENT BONDS' THEN 'JPY GOVERNMENT BONDS' WHEN ccc_strategy = 'JPY SWAPS' THEN 'JPY SWAPS' WHEN ccc_product_line = 'AGENCIES TRADING' AND ccc_strategy = 'US AGENCIES' THEN 'US AGENCIES' WHEN ccc_strategy = 'US GOVERNMENT BONDS' THEN 'US GOVERNMENT BONDS' WHEN ccc_strategy = 'US OPTIONS/EXOTICS' THEN 'US OPTIONS/EXOTICS' WHEN ccc_strategy = 'AP SWAPS' THEN 'AP SWAPS' ELSE ccc_product_line END AS product_line2, CASE WHEN (CCC_STRATEGY IN ('AP OPTIONS/EXOTICS') OR BOOK IN ('ACTRR'))THEN 'BOOKLIST' WHEN ccc_strategy IN ('AP SWAPS', 'IR FX OPTIONS/EXOTICS EU', 'IR FX OPTIONS/EXOTICS JP', 'INFLATION PRODUCTS AP', 'INFLATION PRODUCTS EU', 'INFLATION PRODUCTS JP', 'INFLATION PRODUCTS NA', 'TIPS INFLATION 50 PERCENT') THEN 'LIQUID' WHEN (ccc_business_area = 'STRUCTURED RATES' or ccc_product_line = 'EU GOVERNMENTS' or book in ('TOMAC','TOBLK')) THEN 'STRUCTURED' WHEN ccc_business_area = 'LIQUID FLOW RATES' THEN 'LIQUID' END AS Methodology, CASE WHEN ATTRIBUTION IN ('IR GAMMA', 'IR YIELD GAMMA') THEN 'GAMMA' ELSE 'Other' END AS ATTRIBUTON2, CASE WHEN position_currency IN ('EUR', 'USD', 'GBP', 'JPY') THEN position_currency ELSE 'Other' END AS position_currency2, CASE WHEN measure_currency IN ('EUR', 'USD', 'GBP', 'JPY') THEN measure_currency ELSE 'Other' END AS measure_currency2 FROM DWUSER.u_modular_scenarios modval INNER JOIN DWUSER.U_STRESS_SCENARIO_ATTRIBS modmap ON modval.stress_scenario = modmap.scenario_nm WHERE cob_date in ('2018-02-21') and cob_date IN ('2018-02-21') AND ccc_business_area IN ('LIQUID FLOW RATES', 'STRUCTURED RATES') AND RUN_PROFILE IN ('STS_MOD_SCN_RUN_NY', 'STS_MOD_SCN_RUN_LN', 'STS_MOD_SCN_RUN_ASIA') AND modmap.scenario_type IN ('Rscen_Direct_IR', 'Rscen_Direct_IRVol', 'Rscen_Cross_IR_IRVol') AND PARALLEL_YC_MOVE_BPS IN ('-100', '-50', '-25', '0', '50', '100', '200', '300') AND ( yc_pca_2_units IS NULL OR yc_pca_2_units IN ('2Y10Y -16', '2Y10Y 16') ) GROUP BY position_currency2, measure_currency2, ATTRIBUTON2, le_group, book, product_type, CCC_BUSINESS_AREA, CCC_STRATEGY, CCC_PRODUCT_LINE, modval.SCENARIO_TYPE, STRESS_SCENARIO, product_line2, PARALLEL_YC_MOVE_BPS, yc_pca_2_units, VOL, Methodology ) t1 ), high_order AS ( SELECT CCC_BUSINESS_AREA, CCC_STRATEGY, book, product_type, product_line2, PARA, Steepflat, VOL, SUM(CASE WHEN SCENARIO_TYPE = 'FULL_REVAL' THEN SCENARIO_PNL ELSE - SCENARIO_PNL END) AS HIGH_ORDER_PNL FROM basedata WHERE ATTRIBUTON2 = 'Other' AND Methodology = 'LIQUID' GROUP BY CCC_BUSINESS_AREA, CCC_STRATEGY, book, product_type, product_line2, PARA, Steepflat, VOL ), weight AS ( SELECT *, CASE WHEN ( product_line2 IN ('US SWAPS', 'US GOVERNMENT BONDS') AND position_currency2 = 'USD' ) THEN '1' WHEN ( product_line2 IN ('US SWAPS', 'US GOVERNMENT BONDS') AND position_currency2 <> 'USD' ) THEN '0' ELSE abs(gamma_pnl) / GREATEST(sum(abs(gamma_pnl)) OVER ( PARTITION BY product_line2, PARA, Steepflat, VOL ), 0.001) end AS gamma_weight FROM ( SELECT product_line2, PARA, Steepflat, VOL, position_currency2, SUM(SCENARIO_PNL) AS GAMMA_PNL FROM basedata WHERE ATTRIBUTON2 = 'GAMMA' AND Methodology = 'LIQUID' AND scenario_type = 'GREEK' GROUP BY product_line2, PARA, Steepflat, VOL, position_currency2 ) t2 ), liquid_ho AS ( SELECT high_order.*, COALESCE(weight.position_currency2, 'UNDEFINED') AS CURRENCY, gamma_weight * HIGH_ORDER_PNL AS HO_PNL FROM high_order LEFT JOIN weight ON weight.product_line2 = high_order.product_line2 AND weight.Steepflat = high_order.Steepflat AND weight.VOL = high_order.VOL AND weight.para = high_order.para ) SELECT 'SR' AS SOURCE, CCC_BUSINESS_AREA, CCC_STRATEGY, book, product_type, product_line2, position_currency2 AS CURRENCY, steepflat, para, vol, SCENARIO_PNL FROM basedata WHERE Methodology = 'STRUCTURED' AND scenario_type = 'FULL_REVAL' UNION ALL SELECT 'LFR_GR' AS SOURCE, CCC_BUSINESS_AREA, CCC_STRATEGY, book, product_type, product_line2, measure_currency2 AS CURRENCY, steepflat, para, vol, SCENARIO_PNL FROM basedata WHERE Methodology = 'LIQUID' AND scenario_type = 'GREEK' AND ATTRIBUTON2 = 'Other' UNION ALL SELECT 'BL' AS SOURCE, CCC_BUSINESS_AREA, CCC_STRATEGY, book, product_type, product_line2, measure_currency2 AS CURRENCY, steepflat, para, vol, SCENARIO_PNL FROM basedata WHERE Methodology = 'BOOKLIST' AND scenario_type = 'GREEK' AND ATTRIBUTON2 = 'Other' UNION ALL SELECT 'LFR_HO' AS SOURCE, CCC_BUSINESS_AREA, CCC_STRATEGY, book, product_type, product_line2, CURRENCY, steepflat, para, vol, HO_PNL FROM liquid_ho