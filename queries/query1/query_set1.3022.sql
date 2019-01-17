WITH GDL_Table AS ( SELECT COB_DATE, WM_BANKING_PRODUCT_GROUP, BOOK, CCC_TAPS_COMPANY, CCC_BANKING_TRADING, CCC_DIVISION, division_group, CCC_BUSINESS_AREA, CCC_Product_line, CCC_STRATEGY, (usd_ir_unified_PV01) :: numeric(15,5) AS USD_PV01, (USD_PV01SPRD) :: numeric(15,5) AS USD_PV01SPRD, CASE WHEN currency_code NOT IN ('UBD', 'USD') THEN (USD_Fx) :: numeric(15,5) ELSE 0 END AS USD_FX, (USD_PV10_BENCH) :: numeric(15,5) as USD_PV10_BENCH FROM CDWUSER.U_DM_WM_POSITION a WHERE cob_date IN ( '2018-02-28' ) AND CCC_TAPS_COMPANY IN ('1633') AND VAR_EXCL_FL <> 'Y' ) Select cob_date, SUM( CASE WHEN CCC_DIVISION IN ('RETAIL BANKING GROUP','PRIVATE BANKING GROUP') AND CCC_BUSINESS_AREA = 'NON-JV BANKING' AND WM_BANKING_PRODUCT_GROUP = 'AFS' THEN USD_PV01SPRD ELSE 0 END ) AS pv01sprd_afs, SUM( CASE WHEN CCC_DIVISION IN ('RETAIL BANKING GROUP','PRIVATE BANKING GROUP') AND CCC_BUSINESS_AREA = 'NON-JV BANKING' AND WM_BANKING_PRODUCT_GROUP = 'AFS' AND book = 'AFSC1' THEN USD_PV01SPRD ELSE 0 END ) AS pv01sprd_afs_corp_bnd, SUM( CASE WHEN CCC_DIVISION IN ('RETAIL BANKING GROUP','PRIVATE BANKING GROUP') AND CCC_BUSINESS_AREA = 'NON-JV BANKING' AND WM_BANKING_PRODUCT_GROUP = 'AFS' AND book = 'AFSC1' THEN USD_PV10_BENCH ELSE 0 END ) AS pv01bench_afs_corp_bnd, SUM( CASE WHEN CCC_DIVISION IN ('RETAIL BANKING GROUP','PRIVATE BANKING GROUP') AND CCC_BUSINESS_AREA = 'NON-JV BANKING' AND WM_BANKING_PRODUCT_GROUP = 'AFS' AND book = 'BKCMB' THEN USD_PV01SPRD ELSE 0 END ) AS pv01sprd_afs_cmbs, SUM( CASE WHEN CCC_DIVISION IN ('RETAIL BANKING GROUP','PRIVATE BANKING GROUP') AND CCC_BUSINESS_AREA = 'NON-JV BANKING' AND WM_BANKING_PRODUCT_GROUP = 'AFS' AND book = 'BKCLO' THEN USD_PV01SPRD ELSE 0 END ) AS pv01sprd_afs_clo, SUM( CASE WHEN CCC_DIVISION IN ('RETAIL BANKING GROUP','PRIVATE BANKING GROUP') AND CCC_BUSINESS_AREA = 'NON-JV BANKING' AND WM_BANKING_PRODUCT_GROUP = 'AFS' AND book = 'BKCAR' THEN USD_PV01SPRD ELSE 0 END ) AS pv01sprd_afs_auto_abs, SUM( CASE WHEN CCC_DIVISION = 'FIXED INCOME division_group' AND CCC_BUSINESS_AREA = 'LENDING' AND ccc_product_line <> 'HELD FOR INVESTMENT' AND ccc_strategy <> 'HELD FOR INVESTMENT' THEN USD_PV01SPRD ELSE 0 END ) AS pv01sprd_lending, SUM( CASE WHEN ccc_banking_trading = 'TRADING' THEN USD_PV01SPRD ELSE 0 END ) AS pv01sprd_tr, SUM( CASE WHEN (CCC_STRATEGY IN ('NON IG PRIMARY - LOANS', 'PROJECT FINANCE') OR CCC_PRODUCT_LINE IN ('NON IG PRIMARY - LOANS','PRIMARY - LOANS')) AND (BOOK LIKE '%ELTH FVO%' OR BOOK LIKE '%ELTH HFS%' OR BOOK = 'LJV-PROJECT FINANCE-NA-HFS-IMD-MSBANK-PFMDA') THEN USD_PV01SPRD ELSE 0 END + CASE WHEN (CCC_STRATEGY IN ('HELD FOR SALE', 'HELD FOR SALE IMD', 'RELATIONSHIP TDG UNHEDGBL') OR CCC_PRODUCT_LINE IN ('HELD FOR SALE', 'HELD FOR SALE IMD', 'RELATIONSHIP TDG UNHEDGBL')) AND (UPPER(BOOK) NOT LIKE '%-HEDGEABLE-%') THEN USD_PV01SPRD ELSE 0 END + CASE WHEN (CCC_STRATEGY IN ('HELD FOR SALE', 'HELD FOR SALE IMD', 'HFI HEDGING', 'HFS HEDGING', 'RELATIONSHIP IMD', 'RELATIONSHIP TRADING') OR CCC_PRODUCT_LINE IN ('HELD FOR SALE', 'HELD FOR SALE IMD', 'HFI HEDGING', 'HFS HEDGING', 'RELATIONSHIP IMD', 'RELATIONSHIP TRADING')) AND (UPPER(BOOK) NOT LIKE '%-UNHEDGEABLE-%') THEN USD_PV01SPRD ELSE 0 END + CASE WHEN (CCC_BUSINESS_AREA = 'SECURITIZED PRODUCTS GRP' AND CCC_BUSINESS_AREA <> 'US BANKS-CRA PORTFOLIO' AND DIVISION_GROUP <> 'GWMG' AND CCC_PRODUCT_LINE NOT IN ('WAREHOUSE', 'PRIMARY - LOANS') AND BOOK not like '%HFI%' /* AND VAR_EXCL_FL<> 'Y'*/) THEN USD_PV01SPRD ELSE 0 END + CASE WHEN (CCC_BUSINESS_AREA <> 'SECURITIZED PRODUCTS GRP' AND CCC_BUSINESS_AREA <> 'LENDING' AND CCC_BUSINESS_AREA <> 'US BANKS-CRA PORTFOLIO' AND DIVISION_GROUP <> 'GWMG' AND CCC_PRODUCT_LINE NOT IN ('WAREHOUSE', 'PRIMARY - LOANS') AND BOOK not like '%HFI%' /* AND VAR_EXCL_FL<> 'Y'*/) THEN USD_PV01SPRD ELSE 0 END ) AS tr_nonhfi_lending, SUM(usd_fx) AS usd_fx FROM GDL_Table GROUP BY cob_date