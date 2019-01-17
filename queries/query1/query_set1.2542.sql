SELECT * FROM( SELECT CCC_DIVISION, CCC_BUSINESS_AREA, ccc_product_line, sum(case when COB_DATE = '2018-02-28' then coalesce(CM_DELTA,0) else 0 end) as CM_DELTA_COB, sum(case when COB_DATE = '2018-02-28' then coalesce(CM_DELTA,0) else -coalesce(CM_DELTA,0) end) as CM_DELTA_CHANGE, sum(case when COB_DATE = '2018-02-28' then coalesce(USD_CM_KAPPA,0) else 0 end) as USD_CM_KAPPA_COB, sum(case when COB_DATE = '2018-02-28' then coalesce(USD_CM_KAPPA,0) else -coalesce(USD_CM_KAPPA,0) end) as USD_CM_KAPPA_CHANGE FROM ( SELECT cob_date, ccc_division, ccc_business_area, ccc_product_line, SUM(CASE WHEN feed_source_name <> 'ER1' THEN coalesce(USD_CM_DELTA,0) ELSE 0 END) AS CM_DELTA, SUM( CASE WHEN product_type_code not in (UPPER('Interest Rate'),UPPER('euro pwr spread'),UPPER('euro gas spread'),UPPER('timespread'),UPPER('TBD')) then CASE WHEN product_type_code=UPPER('Eur ng') then coalesce(raw_cm_kappa,0) / 10000 WHEN product_type_code NOT IN(UPPER('equity index'),UPPER('Currency'), UPPER('Credit')) THEN coalesce(raw_cm_kappa,0) / 1000 ELSE 0 end ELSE 0 END) AS usd_cm_kappa FROM CDWUSER.u_exp_msr cm WHERE cob_date in ('2018-02-28', '2018-01-31') AND var_excl_fl <> 'Y' AND feed_source_name <> 'CORISK' AND CCC_DIVISION NOT IN ('COMMODITIES') AND PARENT_LEGAL_ENTITY = '0517(G)' AND ccc_banking_trading = 'TRADING' GROUP BY cob_date, ccc_division, ccc_business_area, ccc_product_line UNION SELECT cob_date, ccc_division, ccc_business_area, ccc_product_line, SUM(CASE WHEN FEED_SOURCE_ID = 301 THEN COALESCE(USD_CM_DELTA_DECOMP,0) ELSE 0 END) as CM_DELTA, 0 as usd_cm_kappa FROM CDWUSER.u_decomp_msr WHERE cob_date in ('2018-02-28', '2018-01-31') AND var_excl_fl <> 'Y' AND (COALESCE (PRODUCT_TYPE_CODE_DECOMP, '') = 'COMM' OR COALESCE (CASH_ISSUE_TYPE, '') = 'COMM') AND CCC_DIVISION NOT IN ('COMMODITIES') AND PARENT_LEGAL_ENTITY = '0517(G)' AND ccc_banking_trading = 'TRADING' GROUP BY cob_date, ccc_division, ccc_business_area, ccc_product_line ) A GROUP BY CCC_DIVISION, CCC_BUSINESS_AREA, ccc_product_line ) Z WHERE abs(COALESCE(CM_DELTA_COB, 0)) + abs(COALESCE(CM_DELTA_CHANGE, 0)) + abs(COALESCE(USD_CM_KAPPA_COB, 0)) + abs(COALESCE(USD_CM_KAPPA_CHANGE, 0)) <> 0 order by CCC_DIVISION, CCC_BUSINESS_AREA, ccc_product_line