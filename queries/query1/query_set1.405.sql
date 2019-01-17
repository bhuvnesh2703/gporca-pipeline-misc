Select CASE WHEN a.CCC_BUSINESS_AREA = 'COMMODITIES' THEN a.CCC_PRODUCT_LINE ELSE a.CCC_BUSINESS_AREA END AS CCC_BUSINESS_AREA, a.CCC_PL_REPORTING_REGION, a.CCC_DIVISION, a.COB_DATE, a.CCC_TAPS_COMPANY, a.PRODUCT_TYPE_CODE, CASE WHEN a.PRODUCT_SUB_TYPE_CODE IN ('N EAST CONSUMPTI', 'N EAST CONSUMPTION') THEN 'N EAST CONSUMPTI' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('N EAST APPALACHI', 'N EAST APPALACHIA') THEN 'N EAST APPALACHI' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('POLYPROPELENE HO', 'POLYPROPELENE HOMOPOLYMER') THEN 'POLYPROPELENE HO' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('POLYPROPYLENE CO', 'POLYPROPYLENE COPOLYMER') THEN 'POLYPROPYLENE CO' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('PURE TEREPHTHALI', 'PURE TEREPHTHALIC ACID') THEN 'PURE TEREPHTHALI' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('GSCI-PRECIOUS ME', 'GSCI-PRECIOUS METALS') THEN 'GSCI-PRECIOUS ME' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('ZERO PRICED EXPO', 'ZERO PRICED EXPOSURE') THEN 'ZERO PRICED EXPO' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('DJUBS-BASE METAL', 'DJUBS-BASE METALS') THEN 'DJUBS-BASE METAL' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('GAS SULFUR CREDI', 'GAS SULFUR CREDIT') THEN 'GAS SULFUR CREDI' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('GASOIL TIMESPREA', 'GASOIL TIMESPREAD') THEN 'GASOIL TIMESPREA' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('USD INTEREST RAT', 'USD INTEREST RATE') THEN 'USD INTEREST RAT' ELSE a.PRODUCT_SUB_TYPE_CODE END AS PRODUCT_SUB_TYPE_CODE, TIME_BUCKET_CALENDAR, SUM(a.DOLLAR_GREEK) as DOLLAR_GREEK, SUM(a.RAW_GREEK) as RAw_GREEK From ( Select prod_pos_name_description,COB_DATE,ccc_business_area,CCC_DIVISION, ccc_product_line, CCC_TAPS_COMPANY,CCC_PL_REPORTING_REGION,product_type_code,time_bucket_calendar, product_sub_type_code, TIME_BUCKET_ANNUAL,EXPIRATION_DATE,time_bucket_quarter, sum(cast(USD_CM_Delta as numeric(15,5))) as dollar_greek, SUM (CASE WHEN PRODUCT_TYPE_CODE = 'TIMESPREAD' AND PROD_POS_NAME_DESCRIPTION = 'WCS POST SPREAD' THEN 0 WHEN (book = 'COMXO' and CCC_PRODUCT_LINE IN ('COMMOD EXOTICS')) then CAST(USD_CM_KAPPA_ABSOLUTE AS NUMERIC (15, 5)) ELSE CAST (RAW_CM_KAPPA AS NUMERIC (15, 5)) END) as raw_greek, case when product_sub_type_code ='ALUMINUM-20MT' then 'Aluminum' when product_type_code in ('BASEMETAL', 'PRECIOUSMETAL') then product_sub_type_code end as Metal FROM cdwuser.U_CM_MSR Where COB_DATE IN ('2018-02-28','2018-02-27') AND CCC_TAPS_COMPANY in ('0302','0342','0517') AND ((CCC_DIVISION IN ('COMMODITIES')) /*OLD LOGIC*/ OR (CCC_DIVISION = 'FIXED INCOME DIVISION' AND CCC_BUSINESS_AREA = 'COMMODITIES')) /*NEW LOGIC*/ and PRODUCT_TYPE_CODE in ('PRECIOUSMETAL','BASEMETAL','IRON ORE') Group By prod_pos_name_description, COB_DATE,ccc_business_area,CCC_TAPS_COMPANY, ccc_product_line, CCC_PL_REPORTING_REGION,CCC_DIVISION, product_type_code,time_bucket_calendar, TIME_BUCKET_ANNUAL, EXPIRATION_DATE,time_bucket_quarter, product_sub_type_code)A GROUP BY CASE WHEN a.CCC_BUSINESS_AREA = 'COMMODITIES' THEN a.CCC_PRODUCT_LINE ELSE a.CCC_BUSINESS_AREA END, a.COB_DATE, a.CCC_PL_REPORTING_REGION, a.CCC_DIVISION, a.CCC_TAPS_COMPANY, a.PRODUCT_TYPE_CODE, a.PRODUCT_SUB_TYPE_CODE, a.TIME_BUCKET_CALENDAR