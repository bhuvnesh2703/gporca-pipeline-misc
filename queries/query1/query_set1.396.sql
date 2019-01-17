Select A.BUSSbyTYPE, A.CCC_PL_REPORTING_REGION, A.product_type_code, A.product_sub_type_code, A.COB_DATE, A.ASSET_TYPE, A.SECTYPE, A.TIME_BUCKET_ANNUAL, A.QUARTERS, A.TANK, SUM(A.USD_FX_DELTA) as USD_FX_DELTA, SUM(A.USD_RHO_GREEK) as USD_RHO_GREEK FROM ( select job_cmdty_code, prod_pos_name_description, CCC_PRODUCT_LINE, product_sub_type_code, product_type_code, CMDTY_CD,EXPIRATION_DATE,time_bucket_quarter,CCC_TRD_BOOK, product_sub_type_name,COB_DATE,CCC_BUSINESS_AREA,TIME_BUCKET_CALENDAR, TIME_BUCKET_ANNUAL,CCC_STRATEGY,CCC_PL_REPORTING_REGION, BU_RISK_RUN_CUSTOM1, sum(cast(coalesce(USD_FX_DELTA,0) as numeric(15,5))) as USD_FX_DELTA, sum(cast(coalesce(USD_IR_RHO,0) as numeric(15,5)) + cast(coalesce(USD_CM_LEASE_RATE,0) as numeric(15,5)))/10 as USD_RHO_GREEK, case when product_sub_type_name in ('STORAGE RELET', 'STORAGE CONTRACT') and COB_DATE >=EXPIRATION_DATE and BU_RISK_RUN_CUSTOM1 = 'STORAGE' then 'TANK' when product_sub_type_name in ('FLEXDEAL', 'P_TANK-T', 'PHYSICAL INVENTORY') and BU_RISK_RUN_CUSTOM1 <> 'STORAGE' then 'TANK' else 'NOTANK' end as TANK, case when EXPIRATION_DATE < ('2019-09-01') then time_bucket_quarter end as quarters, case when CMDTY_CD = 'SPREADS' then 'SPREADS' when BU_RISK_RUN_CUSTOM1 = 'STORAGE' then 'STORAGE' when CCC_BUSINESS_AREA in ('TMG','OLYMPUS','OIL LIQUIDS') then 'OIL LIQUIDS' when CCC_PRODUCT_LINE in ('OIL & PRODUCTS') then 'OIL LIQUIDS' when CCC_STRATEGY in ('TMG', 'OLYMPUS') then 'OIL LIQUIDS' else 'OTHER' end as BUSSbyTYPE, case when product_type_code = 'CRUDE' then prod_pos_name_description when product_type_code in ('DIST', 'JET') then CMDTY_CD when product_type_code = 'ETHANOL' then 'Ethanol' when product_type_code = 'GAS' then 'Gasoline' when (product_type_code= 'NGL' AND job_cmdty_code = 'PROPANESCP') then 'Propane' when (product_type_code= 'NGL' AND job_cmdty_code = 'BUTANE A KMI') then 'Butane' when (product_type_code= 'NGL' AND CMDTY_CD is not null) then CMDTY_CD end as sectype, case when product_type_code in ('DIST', 'JET') then 'Distillate' when product_type_code in ('FUEL','GAS','CRUDE','NAPHTHA', 'ETHANOL', 'NGL') then product_type_code when product_type_code in ('CLEAN FREIGHT','DIRTY FREIGHT') then 'Freight' end as asset_type FROM cdwuser.U_EXP_MSR Where COB_DATE IN ('2018-02-28','2018-02-27') AND ((CCC_BUSINESS_AREA NOT IN ('OIL LIQUIDS') AND CCC_DIVISION = 'COMMODITIES') OR (CCC_DIVISION = 'FIXED INCOME DIVISION' AND CCC_BUSINESS_AREA = 'COMMODITIES' and CCC_PRODUCT_LINE IN ('OIL & PRODUCTS'))) AND PRODUCT_TYPE_CODE NOT IN ('INFLATION', 'TBD', 'MISC','CVA', 'FVA', 'ERROR') AND (CCC_PL_REPORTING_REGION IN ('EUROPE','EMEA')) group by job_cmdty_code, prod_pos_name_description,CCC_PRODUCT_LINE,product_sub_type_code, product_type_code,product_sub_type_name,COB_DATE, CCC_PL_REPORTING_REGION, CCC_BUSINESS_AREA,TIME_BUCKET_CALENDAR,TIME_BUCKET_ANNUAL, CMDTY_CD, EXPIRATION_DATE, time_bucket_quarter,CCC_TRD_BOOK, BU_RISK_RUN_CUSTOM1, CCC_STRATEGY)A group by A.COB_DATE, A.ASSET_TYPE, A.SECTYPE, A.CCC_PL_REPORTING_REGION, A.product_type_code, A.product_sub_type_code, A.TIME_BUCKET_ANNUAL, A.QUARTERS, A.TANK, A.BUSSbyTYPE