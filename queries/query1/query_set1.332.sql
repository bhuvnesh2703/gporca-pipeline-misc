SELECT b.COB_DATE , case when (b.ccc_business_area IN ('NA ELECTRICITYNATURAL GAS') or b.ccc_product_line in ('NA POWER & GAS')) THEN 'NA ELECTRICITYNATURAL GAS' WHEN (B.CCC_BUSINESS_AREA IN ('OIL LIQUIDS') OR B.CCC_PRODUCT_LINE IN ('OIL & PRODUCTS')) THEN 'OIL LIQUIDS' WHEN B.CCC_PRODUCT_LINE IN ('COMMOD EXOTICS','IB STRUCTURED') THEN 'EXOTICS' WHEN B.CCC_PRODUCT_LINE IN ('COMMOD INDEX','IB INDEX') THEN 'INDEX' ELSE B.CCC_PRODUCT_LINE END AS CCC_BUSINESS_AREA ,b.CCC_PRODUCT_LINE ,b.SCENARIO_TYPE ,b.IS_INCLUDED ,b.STRESS_SCENARIO ,b.RUN_PROFILE ,b.CCC_STRATEGY ,b.SCENARIO_DIMENSION ,b.CCC_DIVISION ,b.Include_in_reg_cap ,b.attribution ,CASE WHEN ( (has_crossgamma = 'Y') AND b.ATTRIBUTION = 'CM GAMMA') THEN 'excluded' ELSE b.IS_INCLUDED END AS INCLUDE ,SUM(b.SCENARIO_PNL) AS SCENARIO_PNL FROM dwuser.U_MODULAR_SCENARIOS b WHERE b.COB_DATE = '2018-02-07' AND b.Run_profile IN ('CM_MOD_SCN_RUN') and b.process_id not in (2792, 792, 62037) AND b.Stress_Scenario IN ( 'CM_PRICE_DOWN50_VOL_0' ,'CM_PRICE_DOWN40_VOL_0' ,'CM_PRICE_DOWN30_VOL_0' ,'CM_PRICE_DOWN20_VOL_0' ,'CM_PRICE_DOWN10_VOL_0' ,'CM_PRICE_0_VOL_0' ,'CM_PRICE_UP10_VOL_0' ,'CM_PRICE_UP20_VOL_0' ,'CM_PRICE_UP30_VOL_0' ,'CM_PRICE_UP40_VOL_0' ,'CM_PRICE_UP50_VOL_0' ) AND (b.ccc_business_area = 'COMMODITIES' OR b.CCC_DIVISION = 'COMMODITIES') AND ( b.SUBPROD_PRODUCT_TYPE NOT IN ( 'CURRENCY' ,'CREDIT' ,'INTEREST RATE' ,'WEATHER' ) OR b.SUBPROD_PRODUCT_TYPE IS NULL ) /* AND NOT ( B.CCC_PRODUCT_LINE IN ('COMMOD EXOTICS', 'IB STRUCTURED') AND B.SUBPROD_PRODUCT_TYPE = 'ZCS' ) */ GROUP BY b.COB_DATE ,b.CCC_BUSINESS_AREA ,b.CCC_PRODUCT_LINE ,b.SCENARIO_TYPE ,b.IS_INCLUDED ,b.STRESS_SCENARIO ,b.RUN_PROFILE ,b.CCC_STRATEGY ,b.SCENARIO_DIMENSION ,b.CCC_DIVISION ,b.Include_in_reg_cap ,b.attribution ,CASE WHEN ( (has_crossgamma = 'Y') AND b.ATTRIBUTION = 'CM GAMMA' ) THEN 'excluded' ELSE b.IS_INCLUDED END