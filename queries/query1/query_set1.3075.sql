SELECT a.COB_DATE, a.CCC_TAPS_COMPANY, a.account, a.CCC_STRATEGY, a.WM_BANKING_PRODUCT_GROUP, a.WM_BANKING_PRODUCT_SUB_GROUP, CASE WHEN (ccc_division IN ('PRIVATE BANKING GROUP', 'RETAIL BANKING GROUP', 'PWM US BRANCH') AND ccc_business_area IN ('MSCC MORTGAGE LOAN ORIGINATIONS-GWMG')) AND var_excl_fl <> 'Y' AND (BOOK LIKE ('%LOAN%') OR BOOK LIKE ('%PRODUCTION')) THEN BOOK WHEN CCC_BUSINESS_AREA IN ('US BANKS-CRA PORTFOLIO') AND CCC_TAPS_COMPANY NOT IN ('6635', '1633') THEN BOOK END AS RESI_MTG_BOOK, case when a.WM_BANKING_PRODUCT_SUB_GROUP = 'INTERNAL TRANSFER TRADES' then 'Internal Hedges' else 'n/a' end as Hedges, case when Product_Type_Code in ('BOND') then 'Credit' when Product_Type_Code in ('ABS','CDO_CASH','CLO','CMBS') and PRODUCT_SUB_TYPE_CODE not in ('FHLMC','FNMA','GNMA','STU_LOAN','STU_LOAN_FFELP', 'FHLMC_SENIOR') then 'Credit' else 'Other' end as SECTYPE_GROUP, case when Product_Type_Code in ('BOND') then 'Credit Corp' when Product_Type_Code in ('ABS','CDO_CASH','CLO','CMBS') and PRODUCT_SUB_TYPE_CODE not in ('FHLMC','FNMA','GNMA','STU_LOAN','STU_LOAN_FFELP', 'FHLMC_SENIOR') then 'Credit ABS' when Product_Type_Code in ('GVTBOND') then 'Treasuries' when Product_Type_Code in ('ABS','AGNCMO','CMBS','RMBS') then 'Agencies' else 'Other' end as SECTYPE_GROUP2, Product_Type_Code, PRODUCT_SUB_TYPE_CODE, CASE WHEN PRODUCT_TYPE_CODE = 'DEPOSIT' THEN (CASE WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-A', 'Tier-6','Tier-A-BAU', 'Tier-6-BAU') THEN 'Tier-A' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-B-BAU', 'Tier-5-BAU','Tier-B', 'Tier-5') THEN 'Tier-B' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-C-BAU', 'Tier-4-BAU','Tier-C', 'Tier-4') THEN 'Tier-C' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-D-BAU', 'Tier-3-BAU','Tier-D', 'Tier-3') THEN 'Tier-D' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-8-BAU','Tier-7-BAU', 'Tier-E-BAU','Tier-8','Tier-7', 'Tier-E') THEN 'Tier-E' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-F-BAU', 'Tier-1-BAU','Tier-F', 'Tier-1') THEN 'Tier-F' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-66-BAU','Tier-66') THEN 'Mgd-A' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-65-BAU','Tier-65') THEN 'Mgd-B' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-64','Tier-64-BAU') THEN 'Mgd-C' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-63','Tier-63-BAU') THEN 'Mgd-D' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-67', 'Tier-52', 'Tier-G','Tier-67-BAU', 'Tier-52-BAU', 'Tier-G-BAU') THEN 'Mgd-E' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-61', 'Tier-51', 'Tier-J','Tier-61-BAU', 'Tier-51-BAU', 'Tier-J-BAU') THEN 'Mgd-F' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-H', 'Tier-914','Tier-H-BAU', 'Tier-914-BAU') THEN 'Tier-H' WHEN BANKING_PRODUCT_DESCRIPTION like ('%Tier-6-Exp%') THEN 'Tier-A-Promo' WHEN BANKING_PRODUCT_DESCRIPTION like ('%Tier-5-Exp%') THEN 'Tier-B-Promo' WHEN BANKING_PRODUCT_DESCRIPTION like ('%Tier-4-Exp%') THEN 'Tier-C-Promo' WHEN BANKING_PRODUCT_DESCRIPTION like ('%Tier-3-Exp%') THEN 'Tier-D-Promo' WHEN BANKING_PRODUCT_DESCRIPTION like ('%Tier-7-Exp%') OR BANKING_PRODUCT_DESCRIPTION like ('%Tier-8-Exp%') THEN 'Tier-E-Promo' WHEN BANKING_PRODUCT_DESCRIPTION like ('%Tier-1-Exp%') THEN 'Tier-F-Promo' ELSE 'OTHER' END) ELSE 'n/a' END AS TIER, TERM_BUCKET, case when TERM_BUCKET_AGGR in ('5-7Y','7-10Y') then '5-10Y' else TERM_BUCKET_AGGR end as TERM_BUCKET_AGGR, a.MRD_RATING, CCC_Product_line, SUM(COALESCE(USD_IR_KAPPA, 0) ::numeric(15,5) /10) AS USD_KAPPA, SUM(COALESCE(USD_IR_UNIFIED_PV01, 0)) ::numeric(15,5) AS USD_PV01, SUM(COALESCE(a.USD_PV01SPRD,0))::numeric(15,5) /1000 AS usd_pv01sprd, SUM(COALESCE(a.USD_NOTIONAL,0))::numeric(15,5) /1000 as usd_notional, sum(COALESCE(USD_EXPOSURE, 0)) ::numeric(15,5) / 1000 AS USD_EXPOSURE, sum(COALESCE(USD_PROCEED, 0)) ::numeric(15,5) / 1000 AS MV, SUM (CASE WHEN a.WM_BANKING_PRODUCT_SUB_GROUP = 'Swaption' THEN COALESCE (SLIDE_IR_MIN_100BP_USD,0) ELSE COALESCE (SLIDE_IR_MIN_100BP_USD, USD_PV01 * - 100) END) ::numeric(15,5) AS SLIDE_IR_MIN_100BP_USD, SUM (CASE WHEN a.WM_BANKING_PRODUCT_SUB_GROUP = 'Swaption' THEN COALESCE (SLIDE_IR_MIN_200BP_USD,0) ELSE COALESCE (SLIDE_IR_MIN_200BP_USD, USD_PV01 * - 200) END) ::numeric(15,5) AS SLIDE_IR_MIN_200BP_USD, SUM (CASE WHEN a.WM_BANKING_PRODUCT_SUB_GROUP = 'Swaption' THEN COALESCE (SLIDE_IR_MIN_300BP_USD,0) ELSE COALESCE (SLIDE_IR_MIN_300BP_USD, USD_PV01 * - 300) END) ::numeric(15,5) AS SLIDE_IR_MIN_300BP_USD, SUM (CASE WHEN a.WM_BANKING_PRODUCT_SUB_GROUP = 'Swaption' THEN COALESCE (SLIDE_IR_MIN_50BP_USD,0) ELSE COALESCE (SLIDE_IR_MIN_50BP_USD, USD_PV01 * - 50) END) ::numeric(15,5) AS SLIDE_IR_MIN_50BP_USD, SUM (CASE WHEN a.WM_BANKING_PRODUCT_SUB_GROUP = 'Swaption' THEN COALESCE (SLIDE_IR_PLS_50BP_USD,0) ELSE COALESCE (SLIDE_IR_PLS_50BP_USD, USD_PV01 * 50) END) ::numeric(15,5) AS SLIDE_IR_PLS_50BP_USD, SUM (CASE WHEN a.WM_BANKING_PRODUCT_SUB_GROUP = 'Swaption' THEN COALESCE (SLIDE_IR_PLS_100BP_USD,0) ELSE COALESCE (SLIDE_IR_PLS_100BP_USD, USD_PV01 * 100) END) ::numeric(15,5) AS SLIDE_IR_PLS_100BP_USD, SUM (CASE WHEN a.WM_BANKING_PRODUCT_SUB_GROUP = 'Swaption' THEN COALESCE (SLIDE_IR_PLS_200BP_USD,0) ELSE COALESCE (SLIDE_IR_PLS_200BP_USD, USD_PV01 * 200) END) ::numeric(15,5) AS SLIDE_IR_PLS_200BP_USD, SUM (CASE WHEN a.WM_BANKING_PRODUCT_SUB_GROUP = 'Swaption' THEN COALESCE (SLIDE_IR_PLS_300BP_USD,0) ELSE COALESCE (SLIDE_IR_PLS_300BP_USD, USD_PV01 * 300) END) ::numeric(15,5) AS SLIDE_IR_PLS_300BP_USD FROM cdwuser.U_DM_WM_POSITION A WHERE COB_DATE in ( '2018-02-28', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31', '2017-09-29', '2015-12-31' ) AND A.CCC_TAPS_COMPANY = '6635' AND (A.VAR_EXCL_FL<> 'Y' OR A.BOOK IN ('MSDPB3M','MSDPT3M')) AND (A.ccc_banking_trading = 'BANKING' OR (A.CCC_HIERARCHY_LEVEL2 IN ('WEALTH MANAGEMENT', 'GLOBAL WEALTH MANAGEMENT') or a.CCC_business_area = 'US BANKS-LIQUIDITY') AND A.PRODUCT_TYPE_CODE ='REPO' AND A.CCC_BUSINESS_AREA NOT IN ('NON CORE MARKETS','CORE MARKETS')) GROUP BY a.COB_DATE, A.CCC_TAPS_COMPANY, a.account, a.CCC_STRATEGY, a.WM_BANKING_PRODUCT_GROUP, a.WM_BANKING_PRODUCT_SUB_GROUP, CASE WHEN (ccc_division IN ('PRIVATE BANKING GROUP', 'RETAIL BANKING GROUP', 'PWM US BRANCH') AND ccc_business_area IN ('MSCC MORTGAGE LOAN ORIGINATIONS-GWMG')) AND var_excl_fl <> 'Y' AND (BOOK LIKE ('%LOAN%') OR BOOK LIKE ('%PRODUCTION')) THEN BOOK WHEN CCC_BUSINESS_AREA IN ('US BANKS-CRA PORTFOLIO') AND CCC_TAPS_COMPANY NOT IN ('6635', '1633') THEN BOOK END, case when a.WM_BANKING_PRODUCT_SUB_GROUP = 'INTERNAL TRANSFER TRADES' then 'Internal Hedges' else 'n/a' end, case when Product_Type_Code in ('BOND') then 'Credit' when Product_Type_Code in ('ABS','CDO_CASH','CLO','CMBS') and PRODUCT_SUB_TYPE_CODE not in ('FHLMC','FNMA','GNMA','STU_LOAN','STU_LOAN_FFELP', 'FHLMC_SENIOR') then 'Credit' else 'Other' end, case when Product_Type_Code in ('BOND') then 'Credit Corp' when Product_Type_Code in ('ABS','CDO_CASH','CLO','CMBS') and PRODUCT_SUB_TYPE_CODE not in ('FHLMC','FNMA','GNMA','STU_LOAN','STU_LOAN_FFELP', 'FHLMC_SENIOR') then 'Credit ABS' when Product_Type_Code in ('GVTBOND') then 'Treasuries' when Product_Type_Code in ('ABS','AGNCMO','CMBS','RMBS') then 'Agencies' else 'Other' end, Product_Type_Code, case when TERM_BUCKET_AGGR in ('5-7Y','7-10Y') then '5-10Y' else TERM_BUCKET_AGGR end, a.MRD_RATING, PRODUCT_SUB_TYPE_CODE, CASE WHEN PRODUCT_TYPE_CODE = 'DEPOSIT' THEN (CASE WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-A', 'Tier-6','Tier-A-BAU', 'Tier-6-BAU') THEN 'Tier-A' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-B-BAU', 'Tier-5-BAU','Tier-B', 'Tier-5') THEN 'Tier-B' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-C-BAU', 'Tier-4-BAU','Tier-C', 'Tier-4') THEN 'Tier-C' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-D-BAU', 'Tier-3-BAU','Tier-D', 'Tier-3') THEN 'Tier-D' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-8-BAU','Tier-7-BAU', 'Tier-E-BAU','Tier-8','Tier-7', 'Tier-E') THEN 'Tier-E' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-F-BAU', 'Tier-1-BAU','Tier-F', 'Tier-1') THEN 'Tier-F' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-66-BAU','Tier-66') THEN 'Mgd-A' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-65-BAU','Tier-65') THEN 'Mgd-B' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-64','Tier-64-BAU') THEN 'Mgd-C' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-63','Tier-63-BAU') THEN 'Mgd-D' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-67', 'Tier-52', 'Tier-G','Tier-67-BAU', 'Tier-52-BAU', 'Tier-G-BAU') THEN 'Mgd-E' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-61', 'Tier-51', 'Tier-J','Tier-61-BAU', 'Tier-51-BAU', 'Tier-J-BAU') THEN 'Mgd-F' WHEN BANKING_PRODUCT_DESCRIPTION IN ('Tier-H', 'Tier-914','Tier-H-BAU', 'Tier-914-BAU') THEN 'Tier-H' WHEN BANKING_PRODUCT_DESCRIPTION like ('%Tier-6-Exp%') THEN 'Tier-A-Promo' WHEN BANKING_PRODUCT_DESCRIPTION like ('%Tier-5-Exp%') THEN 'Tier-B-Promo' WHEN BANKING_PRODUCT_DESCRIPTION like ('%Tier-4-Exp%') THEN 'Tier-C-Promo' WHEN BANKING_PRODUCT_DESCRIPTION like ('%Tier-3-Exp%') THEN 'Tier-D-Promo' WHEN BANKING_PRODUCT_DESCRIPTION like ('%Tier-7-Exp%') OR BANKING_PRODUCT_DESCRIPTION like ('%Tier-8-Exp%') THEN 'Tier-E-Promo' WHEN BANKING_PRODUCT_DESCRIPTION like ('%Tier-1-Exp%') THEN 'Tier-F-Promo' ELSE 'OTHER' END) ELSE 'n/a' END, TERM_BUCKET, CCC_Product_line