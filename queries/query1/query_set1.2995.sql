SELECT v.COB_DATE, v.CCC_PL_REPORTING_REGION, v.TERM_BUCKET, v.BOOK, v.account, v.PRODUCT_TYPE_CODE, v.VINTAGE, v.CMBS_RATING, v.REFERENCE_INDEX_ENTITY_NAME, Case WHEN v.ACCOUNT IN ('072006HB8','07200HTM7', '07200HTS4') THEN 'Risk Retention' WHEN v.BOOK IN ('CRE_LENDING_EU_HFI', 'CRE_LENDING_HFI') THEN 'HFI' WHEN v.PRODUCT_TYPE_CODE = 'LOAN' and v.BOOK IN ('CRE_LENDING_EU_HFS', 'CRE_LENDING_HFS') THEN 'HFS LOANS' WHEN v.PRODUCT_TYPE_CODE = 'CMBS' THEN 'FV CMBS HEDGES' WHEN v.PRODUCT_TYPE_CODE = 'SWAP' AND v.account LIKE '072005%' and v.book in ('CRE_LENDING','CRE_LENDING_EU') THEN 'FV RATELOCK' WHEN v.PRODUCT_TYPE_CODE = 'SWAP' AND v.account LIKE '072005%' and v.book in ('CRE_LENDING_HFS','CRE_LENDING_EU_HFS') THEN 'HFS RATELOCK' WHEN v.PRODUCT_TYPE_CODE = 'SWAP' AND v.account LIKE '08300%' and v.book in ('CRE_LENDING','CRE_LENDING_EU') OR v.book = 'JVFXS' THEN 'FV SWAP HEDGES' WHEN v.PRODUCT_TYPE_CODE = 'SWAP' AND v.account LIKE '08300%' and v.book in ('CRE_LENDING_HFS','CRE_LENDING_EU_HFS') THEN 'HFS SWAP HEDGES' WHEN v.PRODUCT_TYPE_CODE = 'BONDFUT' and v.book in ('CRE_LENDING','CRE_LENDING_EU','CRE_LENDING_HFS','CRE_LENDING_EU_HFS') THEN 'BONDFUTURES' WHEN v.book = 'CRE_LENDING_EU' or (v.book = 'CRE_LENDING' and v.PRODUCT_TYPE_CODE = 'LOAN') THEN 'FV LOANS' WHEN v.book = 'JVFXT' then 'CRD HEDGES' ELSE v.account END AS "SPG GROUPING", SUM((v.USD_IR_UNIFIED_PV01) :: numeric(15,5)) AS PV01, SUM((v.USD_PV01SPRD) :: numeric(15,5)) AS SPV01, SUM((v.USD_NOTIONAL) :: numeric(15,5)) * 1000 AS NOTIONAL, SUM((V.USD_EXPOSURE) :: numeric(15,5)) * 1000 AS NET, SUM((V.USD_PV10_BENCH) :: numeric(15,5)) AS PV10 FROM CDWUSER.U_DM_WM v WHERE v.COB_DATE IN ( '2018-02-28', '2018-02-27', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31' ) AND v.CCC_TAPS_COMPANY = '1633' AND v.CCC_DIVISION IN ('FIXED INCOME DIVISION', 'NON CORE') AND v.CCC_BUSINESS_AREA = 'SECURITIZED PRODUCTS GRP' AND v.CCC_PRODUCT_LINE IN ('CRE LENDING', 'CREL BANK HFI', 'CRE LENDING SEC/HFS') GROUP BY v.COB_DATE, v.CCC_PL_REPORTING_REGION, V.BOOK, v.TERM_BUCKET, v.account, v.PRODUCT_TYPE_CODE, v.VINTAGE, v.CMBS_RATING, v.REFERENCE_INDEX_ENTITY_NAME, Case WHEN v.ACCOUNT IN ('072006HB8','07200HTM7', '07200HTS4') THEN 'Risk Retention' WHEN v.BOOK IN ('CRE_LENDING_EU_HFI', 'CRE_LENDING_HFI') THEN 'HFI' WHEN v.PRODUCT_TYPE_CODE = 'LOAN' and v.BOOK IN ('CRE_LENDING_EU_HFS', 'CRE_LENDING_HFS') THEN 'HFS LOANS' WHEN v.PRODUCT_TYPE_CODE = 'CMBS' THEN 'FV CMBS HEDGES' WHEN v.PRODUCT_TYPE_CODE = 'SWAP' AND v.account LIKE '072005%' and v.book in ('CRE_LENDING','CRE_LENDING_EU') THEN 'FV RATELOCK' WHEN v.PRODUCT_TYPE_CODE = 'SWAP' AND v.account LIKE '072005%' and v.book in ('CRE_LENDING_HFS','CRE_LENDING_EU_HFS') THEN 'HFS RATELOCK' WHEN v.PRODUCT_TYPE_CODE = 'SWAP' AND v.account LIKE '08300%' and v.book in ('CRE_LENDING','CRE_LENDING_EU') OR v.book = 'JVFXS' THEN 'FV SWAP HEDGES' WHEN v.PRODUCT_TYPE_CODE = 'SWAP' AND v.account LIKE '08300%' and v.book in ('CRE_LENDING_HFS','CRE_LENDING_EU_HFS') THEN 'HFS SWAP HEDGES' WHEN v.PRODUCT_TYPE_CODE = 'BONDFUT' and v.book in ('CRE_LENDING','CRE_LENDING_EU','CRE_LENDING_HFS','CRE_LENDING_EU_HFS') THEN 'BONDFUTURES' WHEN v.book = 'CRE_LENDING_EU' or (v.book = 'CRE_LENDING' and v.PRODUCT_TYPE_CODE = 'LOAN') THEN 'FV LOANS' WHEN v.book = 'JVFXT' then 'CRD HEDGES' ELSE v.account END