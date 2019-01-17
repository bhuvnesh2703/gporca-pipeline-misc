Select a.COB_Date, CASE WHEN a.PRODUCT_SUB_TYPE_CODE IN ('N EAST CONSUMPTI', 'N EAST CONSUMPTION') THEN 'N EAST CONSUMPTI' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('N EAST APPALACHI', 'N EAST APPALACHIA') THEN 'N EAST APPALACHI' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('POLYPROPELENE HO', 'POLYPROPELENE HOMOPOLYMER') THEN 'POLYPROPELENE HO' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('POLYPROPYLENE CO', 'POLYPROPYLENE COPOLYMER') THEN 'POLYPROPYLENE CO' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('PURE TEREPHTHALI', 'PURE TEREPHTHALIC ACID') THEN 'PURE TEREPHTHALI' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('GSCI-PRECIOUS ME', 'GSCI-PRECIOUS METALS') THEN 'GSCI-PRECIOUS ME' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('ZERO PRICED EXPO', 'ZERO PRICED EXPOSURE') THEN 'ZERO PRICED EXPO' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('DJUBS-BASE METAL', 'DJUBS-BASE METALS') THEN 'DJUBS-BASE METAL' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('GAS SULFUR CREDI', 'GAS SULFUR CREDIT') THEN 'GAS SULFUR CREDI' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('GASOIL TIMESPREA', 'GASOIL TIMESPREAD') THEN 'GASOIL TIMESPREA' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('USD INTEREST RAT', 'USD INTEREST RATE') THEN 'USD INTEREST RAT' ELSE a.PRODUCT_SUB_TYPE_CODE END AS PRODUCT_SUB_TYPE_CODE, a.CCC_PL_REPORTING_REGION, a.TIME_BUCKET_CALENDAR, SUM(a.RAW_GREEK) as RAW_GREEK From ( select prod_pos_name_description, CCC_PL_REPORTING_REGION, product_sub_type_code, product_type_code, CCC_TRD_BOOK, product_sub_type_name,COB_DATE,CCC_BUSINESS_AREA,TIME_BUCKET_CALENDAR, sum(cast(RAW_CM_LEASE_RATE/1000 as numeric(15,5))) as RAW_GREEK, Sum(cast(USD_CM_LEASE_RATE as numeric(15,5))) as DOLLAR_GREEK FROM cdwuser.U_CM_MSR Where COB_DATE IN ('2018-02-28','2018-01-31') AND ((CCC_BUSINESS_AREA IN ('METALS') and ccc_division = 'COMMODITIES' AND product_type_code in ('PRECIOUSMETAL','BASEMETAL')) /*OLD LOGIC*/ OR (CCC_DIVISION = 'FIXED INCOME DIVISION' AND CCC_BUSINESS_AREA IN ('COMMODITIES') and (CCC_PRODUCT_LINE IN ('PRECIOUS METALS') OR CCC_STRATEGY IN ('BULKS', 'BASE METALS')) and product_type_code in ('PRECIOUSMETAL','BASEMETAL'))) /*NEW LOGIC*/ AND (CCC_PL_REPORTING_REGION IN ('EUROPE','EMEA')) group by prod_pos_name_description,product_sub_type_code, CCC_PL_REPORTING_REGION,product_type_code, product_sub_type_name,COB_DATE, CCC_BUSINESS_AREA,TIME_BUCKET_CALENDAR,CCC_TRD_BOOK)A GROUP BY a.COB_DATE, a.PRODUCT_SUB_TYPE_CODE, a.CCC_PL_REPORTING_REGION, a.TIME_BUCKET_CALENDAR