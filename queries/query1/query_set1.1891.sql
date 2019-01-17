SELECT 'fr' AS TYPE ,cob_date ,stress_scenario AS scn ,ccc_strategy ,ccc_business_area ,ccc_division ,scenario_type ,scenario_dimension ,condition_name ,attribution ,product_type ,condition_set ,book ,SUM(scenario_pnl) AS pnl ,CASE WHEN book IN ( 'ACBON', 'ACEXC', 'ACSTP', 'AGTRS', 'GRNMC', 'REDMC', 'TOGMP', 'TOMWP','TORPP','ACTRO' ) THEN 'SD' WHEN book IN ( 'ACUSD' ,'ACSWN' ,'ACCMS' ,'ARMBK' ,'ACBOP' ,'DMSTS' ,'ACMTG' ) THEN 'LD' ELSE 'OTHER' END AS desk_type FROM dwuser.u_modular_scenarios_ccar where COB_DATE = '2018-02-28' AND ccc_strategy = 'US OPTIONS/EXOTICS' AND stress_scenario IN ( 'BHC2017_S1_IR_ALL' ,'BHC2017_S1_IR_SPOT' ,'BHC2017_S1_IR_VOL' ,'FRB2017_SA_IR_ALL' ,'FRB2017_SA_IR_SPOT' ,'FRB2017_SA_IR_VOL' ) AND risk_system NOT LIKE '%SILO' AND ( CCAR_BUSINESS_CATEGORY NOT LIKE 'NOT%' OR CCC_BUSINESS_AREA = 'GLOBAL EQUITY ADMIN & DEV' ) AND attribution NOT LIKE '%GAMMA%' AND is_included = 'YES' GROUP BY cob_date ,stress_scenario ,ccc_strategy ,ccc_business_area ,ccc_division ,scenario_type ,scenario_dimension ,condition_name ,attribution ,product_type ,condition_set ,book  union all  SELECT 'fr' AS TYPE ,cob_date ,stress_scenario AS scn ,ccc_strategy ,ccc_business_area ,ccc_division ,scenario_type ,scenario_dimension ,condition_name ,attribution ,product_type ,condition_set ,book ,SUM(scenario_pnl) AS pnl ,CASE WHEN book IN ( 'ACBON', 'ACEXC', 'ACSTP', 'AGTRS', 'GRNMC', 'REDMC', 'TOGMP', 'TOMWP','TORPP','ACTRO' ) THEN 'SD' WHEN book IN ( 'ACUSD' ,'ACSWN' ,'ACCMS' ,'ARMBK' ,'ACBOP' ,'DMSTS' ,'ACMTG' ) THEN 'LD' ELSE 'OTHER' END AS desk_type FROM dwuser.u_modular_scenarios_ccar where COB_DATE = '2018-01-31' AND ccc_strategy = 'US OPTIONS/EXOTICS' AND stress_scenario IN ( 'BHC2017_S1_IR_ALL' ,'BHC2017_S1_IR_SPOT' ,'BHC2017_S1_IR_VOL' ,'FRB2017_SA_IR_ALL' ,'FRB2017_SA_IR_SPOT' ,'FRB2017_SA_IR_VOL' ) AND risk_system NOT LIKE '%SILO' AND ( CCAR_BUSINESS_CATEGORY NOT LIKE 'NOT%' OR CCC_BUSINESS_AREA = 'GLOBAL EQUITY ADMIN & DEV' ) AND attribution NOT LIKE '%GAMMA%' AND is_included = 'YES' GROUP BY cob_date ,stress_scenario ,ccc_strategy ,ccc_business_area ,ccc_division ,scenario_type ,scenario_dimension ,condition_name ,attribution ,product_type ,condition_set ,book