SELECT COB_DATE, CASE WHEN PRODUCT_SUB_TYPE_CODE IN ('N EAST CONSUMPTI', 'N EAST CONSUMPTION') THEN 'N EAST CONSUMPTI' WHEN PRODUCT_SUB_TYPE_CODE IN ('N EAST APPALACHI', 'N EAST APPALACHIA') THEN 'N EAST APPALACHI' WHEN PRODUCT_SUB_TYPE_CODE IN ('POLYPROPELENE HO', 'POLYPROPELENE HOMOPOLYMER') THEN 'POLYPROPELENE HO' WHEN PRODUCT_SUB_TYPE_CODE IN ('POLYPROPYLENE CO', 'POLYPROPYLENE COPOLYMER') THEN 'POLYPROPYLENE CO' WHEN PRODUCT_SUB_TYPE_CODE IN ('PURE TEREPHTHALI', 'PURE TEREPHTHALIC ACID') THEN 'PURE TEREPHTHALI' WHEN PRODUCT_SUB_TYPE_CODE IN ('GSCI-PRECIOUS ME', 'GSCI-PRECIOUS METALS') THEN 'GSCI-PRECIOUS ME' WHEN PRODUCT_SUB_TYPE_CODE IN ('ZERO PRICED EXPO', 'ZERO PRICED EXPOSURE') THEN 'ZERO PRICED EXPO' WHEN PRODUCT_SUB_TYPE_CODE IN ('DJUBS-BASE METAL', 'DJUBS-BASE METALS') THEN 'DJUBS-BASE METAL' WHEN PRODUCT_SUB_TYPE_CODE IN ('GAS SULFUR CREDI', 'GAS SULFUR CREDIT') THEN 'GAS SULFUR CREDI' WHEN PRODUCT_SUB_TYPE_CODE IN ('GASOIL TIMESPREA', 'GASOIL TIMESPREAD') THEN 'GASOIL TIMESPREA' WHEN PRODUCT_SUB_TYPE_CODE IN ('USD INTEREST RAT', 'USD INTEREST RATE') THEN 'USD INTEREST RAT' ELSE PRODUCT_SUB_TYPE_CODE END AS PRODUCT_SUB_TYPE_CODE, CCC_PL_REPORTING_REGION, CASE WHEN CCC_BUSINESS_AREA = 'COMMODITIES' THEN CCC_PRODUCT_LINE ELSE CCC_BUSINESS_AREA END AS CCC_BUSINESS_AREA, PRODUCT_TYPE_CODE, prod_pos_name_description, time_bucket_calendar , sum(cast(USD_CM_DELTA as numeric(15,5))) as Dollar_Delta FROM cdwuser.U_CM_MSR WHERE COB_DATE IN ('2018-02-28','2018-01-31') AND ((CCC_DIVISION='COMMODITIES' AND CCC_BUSINESS_AREA in ('AP EU ELECTRICNATURAL GAS', 'OLYMPUS', 'TMG')) /*OLD LOGIC*/ OR (CCC_DIVISION = 'FIXED INCOME DIVISION' AND CCC_BUSINESS_AREA = 'COMMODITIES' and CCC_STRATEGY IN ('AP EU POWER & GAS', 'OLYMPUS', 'TMG'))) /*NEW LOGIC*/ AND PRODUCT_TYPE_CODE NOT IN ('CURRENCY', 'INTEREST RATE', 'INFLATION', 'TBD', 'MISC','CVA', 'FVA') Group BY COB_DATE,PRODUCT_SUB_TYPE_CODE,CCC_PL_REPORTING_REGION, PRODUCT_TYPE_CODE,prod_pos_name_description,EXPIRATION_DATE,time_bucket_quarter, CASE WHEN CCC_BUSINESS_AREA = 'COMMODITIES' THEN CCC_PRODUCT_LINE ELSE CCC_BUSINESS_AREA END, time_bucket_calendar