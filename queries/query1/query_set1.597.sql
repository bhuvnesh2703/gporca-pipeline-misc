select A.COB_DATE, QUARTERS, A.TIME_BUCKET_CALENDAR, A.CCC_PL_REPORTING_REGION, A.PRODUCT, A.PRODUCT_TYPE_CODE, sum(A.DOLLAR_GREEK) as DOLLAR_GREEK FROM ( Select COB_Date, product_type_code, CCC_Business_Area,CCC_PL_REPORTING_REGION, CCC_PRODUCT_LINE, CCC_TRD_BOOK, EXPIRATION_DATE, time_bucket_calendar, time_bucket_quarter, sum(cast(USD_CM_Delta as numeric(15,5))) as dollar_greek, sum(case when PRODUCT_TYPE_CODE = 'TIMESPREAD' and PROD_POS_NAME_DESCRIPTION = 'WCS POST SPREAD' then 0 else cast(RAW_CM_DELTA as numeric(15,5)) end) as raw_greek, case when EXPIRATION_DATE < ('2019-09-01') then time_bucket_quarter end as quarters, case when CCC_PRODUCT_LINE in ('OLYMPUS FREIGHT') then 'FREIGHT' else 'OTHER' end as PRODUCT FROM cdwuser.U_CM_MSR Where COB_DATE IN ('2018-02-28','2018-02-21') AND ( (CCC_BUSINESS_AREA NOT IN ('CREDIT', 'MS CVA MNE - COMMOD') AND CCC_DIVISION = 'COMMODITIES' and CCC_BUSINESS_AREA in ('OIL LIQUIDS')) /*OLD LOGIC*/ OR (CCC_DIVISION = 'FIXED INCOME DIVISION' AND CCC_BUSINESS_AREA = 'COMMODITIES' and CCC_STRATEGY NOT IN ('MS CVA MNE - COMMOD') and CCC_PRODUCT_LINE IN ('OIL & PRODUCTS')) /*NEW LOGIC*/ ) and product_type_code in ('CLEAN FREIGHT','DIRTY FREIGHT') AND (CCC_PL_REPORTING_REGION IN ('EUROPE','EMEA')) Group by COB_Date, product_type_code, CCC_Business_Area,CCC_PL_REPORTING_REGION, CCC_PRODUCT_LINE, CCC_TRD_BOOK, EXPIRATION_DATE, time_bucket_calendar, time_bucket_quarter)A GROUP BY A.COB_DATE, A.QUARTERS, A.TIME_BUCKET_CALENDAR, A.CCC_PL_REPORTING_REGION, A.PRODUCT, A.PRODUCT_TYPE_CODE