SELECT COB_DATE, data_flag, ccc_pl_reporting_region, UK_Group, sum(PV50) as PV50, CASE WHEN DATA_FLAG = 'Scale' THEN (PV10*5) ELSE PV50 END AS UNIFIED_pv50 from ( SELECT a.COB_DATE, a.ccc_pl_reporting_region, case when LE_GROUP = 'UK' then 'UK Group' ELSE 'Non Uk Group' END AS UK_Group, CASE WHEN (a.VERTICAL_SYSTEM LIKE 'PERSIST%' AND a.PRODUCT_SUB_TYPE_CODE IN ('MPE', 'MNE', 'MNE_CP')) THEN 'Slides' WHEN (a.VERTICAL_SYSTEM LIKE 'C1%' OR a.PRODUCT_TYPE_CODE = 'BANKDEBT') THEN 'Slides' ELSE 'Scale' END AS DATA_FLAG, SUM(a.SLIDE_PV_PLS_50PCT_USD) AS PV50, SUM(a.SLIDE_PV_PLS_10PCT_USD) as PV10 FROM CDWUSER.U_CR_MSR a WHERE COB_DATE in ('2018-02-28','2018-02-21') AND (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD','CPM') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES')) AND NOT a.CCC_STRATEGY = 'INSURANCE PRODUCTS' AND NOT (COALESCE(LOWER (a.CURVE_TYPE), '') = 'cpcrmne' or COALESCE(LOWER (a.CURVE_TYPE), '') = 'ms_seccpm') GROUP BY a.COB_DATE, a.ccc_pl_reporting_region, case when LE_GROUP = 'UK' then 'UK Group' ELSE 'Non Uk Group' END, CASE WHEN (a.VERTICAL_SYSTEM LIKE 'PERSIST%' AND a.PRODUCT_SUB_TYPE_CODE IN ('MPE', 'MNE', 'MNE_CP')) THEN 'Slides' WHEN (a.VERTICAL_SYSTEM LIKE 'C1%' OR a.PRODUCT_TYPE_CODE = 'BANKDEBT') THEN 'Slides' ELSE 'Scale' END )sub_qry GROUP BY COB_DATE, data_flag, ccc_pl_reporting_region, UK_Group, CASE WHEN DATA_FLAG = 'Scale' THEN (PV10*5) ELSE PV50 END FOR READ ONLY