SELECT     p.source_scn_name,     p.Product_type,     p.ccc_Business_area,     p.product_hierarchy_level_7,     p.cob_date,     a.expiration_date,     SUM (p.raw_PNL) * 1000 AS Scenario_Shock_Result_Value,     SUM (p.base_USD) * 1000 AS BASE_USD_VALUE FROM     DWUSER.U_Raw_scenario_pnl p     INNER JOIN     (         SELECT             DISTINCT             ticket,             expiration_date,             cob_date,             CCC_BUSIness_area         FROM dwuser.U_FX_MSR         WHERE COB_DATE = '2018-02-28'  AND             CCC_BUSIness_area LIKE 'FXEM MACRO TRADING' AND             bu_risk_system LIKE 'FXOPT%' and expiration_date >= '2018-02-28'     )     AS a     ON         a.ticket = p.ticket AND         a.COB_DATE = p.COB_date AND         a.CCC_BUSIness_area LIKE 'FXEM MACRO TRADING' AND         bu_risk_system LIKE 'FXOPT%' AND         p.product_type IN ('FXOPT', 'FXBSKT') AND         a.CCC_BUSIness_area = p.CCC_BUSIness_area AND p.COB_DATE = '2018-02-28'  AND         p.Source_scn_name = 'FRB2017_SA_FX_All' WHERE p.PROCESS_ID = (62041) GROUP BY   p.source_scn_name,     p.Product_type,     p.ccc_Business_area,     p.product_hierarchy_level_7,     p.cob_date,     a.expiration_date