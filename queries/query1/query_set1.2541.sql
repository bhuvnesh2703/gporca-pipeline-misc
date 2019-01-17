with SOURCE as ( SELECT buss_level5, time_bucket_annual, time_bucket_quarter, ccc_business_area, ccc_product_line, sum(case when is_cob = 1 then delta else 0 end) as delta_cob, sum(case when is_cob = 1 then delta else -delta end) as delta_change, sum(case when is_cob = 1 then kappa else 0 end) as kappa_cob, sum(case when is_cob = 1 then kappa else -kappa end) as kappa_change, sum(case when is_cob = 1 then gamma else 0 end) as gamma_cob, sum(case when is_cob = 1 then gamma else -gamma end) as gamma_change, 0 as rho_cob, 0 as rho_change FROM ( SELECT case when cob_date = '2018-02-28' then 1 else 0 end as is_cob, a.product_type_code as buss_level5, a.time_bucket_annual, a.time_bucket_quarter, a.ccc_business_area, a.ccc_product_line, 0 as delta, 0 as kappa, sum(coalesce(usd_cm_gamma, 0)) as gamma FROM CDWUSER.U_CM_MSR a WHERE cob_date IN ('2018-02-28', '2018-01-31') AND PARENT_LEGAL_ENTITY = '0517(G)' AND VAR_EXCL_FL <> 'Y' AND UPPER(product_type_code) NOT IN ('ERROR', 'TBD') AND CCC_DIVISION NOT IN ('COMMODITIES') AND feed_source_name = 'CORISK' AND ccc_banking_trading = 'TRADING' GROUP BY case when cob_date = '2018-02-28' then 1 else 0 end, a.product_type_code, a.time_bucket_annual, a.time_bucket_quarter, a.ccc_business_area, a.ccc_product_line UNION ALL SELECT case when cob_date = '2018-02-28' then 1 else 0 end as is_cob, a.product_type_code as buss_level5, a.time_bucket_annual, a.time_bucket_quarter, a.ccc_business_area, a.ccc_product_line, 0 as delta, SUM( CASE WHEN feed_source_name <> 'CORISK' then usd_cm_kappa ELSE CASE WHEN product_type_code=UPPER('Eur ng') then coalesce(raw_cm_kappa/10,0) /1000 WHEN a.product_type_code NOT IN(UPPER('equity index'),UPPER('Currency'), UPPER('Credit')) THEN coalesce(raw_cm_kappa,0) /1000 ELSE 0 end END) as kappa, 0 as gamma FROM CDWUSER.U_CM_MSR a WHERE cob_date IN ('2018-02-28', '2018-01-31') AND var_excl_fl <> 'Y' AND product_type_code not in (UPPER('Interest Rate'),UPPER('euro pwr spread'),UPPER('euro gas spread'),UPPER('timespread'),UPPER('TBD')) AND CCC_DIVISION NOT IN ('COMMODITIES') AND PARENT_LEGAL_ENTITY = '0517(G)' AND feed_source_name = 'CORISK' AND ccc_banking_trading = 'TRADING' GROUP BY case when cob_date = '2018-02-28' then 1 else 0 end, a.product_type_code, a.time_bucket_annual, a.time_bucket_quarter, a.ccc_business_area, a.ccc_product_line UNION ALL SELECT case when cob_date = '2018-02-28' then 1 else 0 end as is_cob, a.product_type_code as buss_level5, a.time_bucket_annual, a.time_bucket_quarter, a.ccc_business_area, a.ccc_product_line, SUM(CASE WHEN PRODUCT_TYPE_CODE not in ('EQUITY INDEX','CREDIT') THEN coalesce(USD_CM_DELTA,0) ELSE 0 END) as delta, 0 as kappa, 0 as gamma FROM CDWUSER.U_CM_MSR a WHERE cob_date IN ('2018-02-28', '2018-01-31') AND var_excl_fl <> 'Y' AND FEED_SOURCE_NAME = 'CORISK' AND CCC_DIVISION NOT IN ('COMMODITIES') AND PRODUCT_TYPE_CODE not in ('CASH','MISC','ERROR','TBD','INTEREST RATE','CURRENCY') AND PARENT_LEGAL_ENTITY = '0517(G)' AND feed_source_name = 'CORISK' AND ccc_banking_trading = 'TRADING' GROUP BY case when cob_date = '2018-02-28' then 1 else 0 end, a.product_type_code, a.time_bucket_annual, a.time_bucket_quarter, a.ccc_business_area, a.ccc_product_line ) Y GROUP BY buss_level5, time_bucket_annual, time_bucket_quarter, ccc_business_area, ccc_product_line ) SELECT SOURCE.*, rank_table.rank FROM( SELECT ccc_business_area, ccc_product_line, buss_level5, RANK() OVER (PARTITION BY ccc_product_line ORDER BY ABS(delta_cob) DESC, rownum) AS Rank FROM ( SELECT Z.*, ROW_NUMBER() OVER () AS ROWNUM FROM ( SELECT ccc_business_area, buss_level5, ccc_product_line, SUM(delta_cob) AS delta_cob FROM SOURCE GROUP BY ccc_business_area, ccc_product_line, buss_level5 ) Z ) X ) rank_table , SOURCE WHERE rank_table.ccc_business_area = SOURCE.ccc_business_area AND rank_table.buss_level5 = SOURCE.buss_level5 AND abs(coalesce(SOURCE.delta_cob, 0)) + abs(coalesce(SOURCE.delta_change, 0)) + abs(coalesce(SOURCE.kappa_cob, 0)) + abs(coalesce(SOURCE.kappa_change, 0)) + abs(coalesce(SOURCE.gamma_cob, 0)) + abs(coalesce(SOURCE.gamma_change, 0)) <> 0