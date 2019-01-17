SELECT case when ccc_division in ('INSTITUTIONAL EQUITY DIVISION', 'FIXED INCOME DIVISION') then ccc_division else 'Other' end as ccc_division, ccc_business_area as ccc_business_are, ccc_product_line as ccc_product_line, SUM (case when COB_DATE = '2018-02-28' then coalesce(usd_eq_delta, 0) else 0 end ) AS usd_eq_delta_cob, SUM (case when COB_DATE = '2018-02-28' then coalesce(usd_eq_delta, 0) else -coalesce(usd_eq_delta, 0) end ) AS usd_eq_delta_change, SUM (case when COB_DATE = '2018-02-28' then coalesce(usd_eq_kappa, 0) else 0 end ) AS usd_eq_kappa_cob, SUM (case when COB_DATE = '2018-02-28' then coalesce(usd_eq_kappa, 0) else -coalesce(usd_eq_kappa, 0) end ) AS usd_eq_kappa_change FROM ( SELECT cob_date, ccc_division, ccc_business_area, ccc_product_line, sum(case when feed_source_name <> 'CORISK' then usd_eq_kappa else 0 end) as usd_eq_kappa, sum(case when feed_source_name not in ('CORISK', 'ER1') then usd_delta else 0 end) as usd_eq_delta FROM CDWUSER.u_exp_msr WHERE COB_DATE IN ('2018-02-28', '2018-02-27') AND PARENT_LEGAL_ENTITY = '0517(G)' AND var_excl_fl <> 'Y' GROUP BY cob_date, ccc_division, ccc_business_area, ccc_product_line UNION SELECT cob_date, ccc_division, ccc_business_area, ccc_product_line, SUM(coalesce(raw_cm_kappa, 0)) / 1000 as usd_eq_kappa, SUM(coalesce(USD_CM_DELTA, 0)) as usd_eq_delta FROM CDWUSER.u_exp_msr WHERE COB_DATE IN ('2018-02-28', '2018-02-27') AND PARENT_LEGAL_ENTITY = '0517(G)' AND var_excl_fl <> 'Y' AND FEED_SOURCE_NAME = 'CORISK' AND PRODUCT_TYPE_CODE = 'EQUITY INDEX' GROUP BY cob_date, ccc_division, ccc_business_area, ccc_product_line UNION SELECT cob_date, ccc_division, ccc_business_area, ccc_product_line, 0 as usd_eq_kappa, SUM(coalesce(USD_EQ_DELTA_DECOMP, 0)) as usd_eq_delta FROM CDWUSER.u_decomp_msr WHERE COB_DATE IN ('2018-02-28', '2018-02-27') AND PARENT_LEGAL_ENTITY = '0517(G)' AND var_excl_fl <> 'Y' AND FEED_SOURCE_ID = 301 AND COALESCE (PRODUCT_TYPE_CODE_DECOMP, '') <> 'COMM' AND COALESCE (CASH_ISSUE_TYPE, '') <> 'COMM' GROUP BY cob_date, ccc_division, ccc_business_area, ccc_product_line ) X GROUP BY case when ccc_division in ('INSTITUTIONAL EQUITY DIVISION', 'FIXED INCOME DIVISION') then ccc_division else 'Other' end, ccc_business_area, ccc_product_line