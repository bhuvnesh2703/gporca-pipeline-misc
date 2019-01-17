SELECT A.COB_DATE, A.PROD_POS_NAME_DESCRIPTION, A.GE_DETAIL0, CASE WHEN A.PRODUCT_SUB_TYPE_CODE IN ('N EAST CONSUMPTI', 'N EAST CONSUMPTION') THEN 'N EAST CONSUMPTION' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('N EAST APPALACHI', 'N EAST APPALACHIA') THEN 'N EAST APPALACHIA' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('POLYPROPELENE HO', 'POLYPROPELENE HOMOPOLYMER') THEN 'POLYPROPELENE HO' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('POLYPROPYLENE CO', 'POLYPROPYLENE COPOLYMER') THEN 'POLYPROPYLENE CO' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('PURE TEREPHTHALI', 'PURE TEREPHTHALIC ACID') THEN 'PURE TEREPHTHALI' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('GSCI-PRECIOUS ME', 'GSCI-PRECIOUS METALS') THEN 'GSCI-PRECIOUS ME' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('ZERO PRICED EXPO', 'ZERO PRICED EXPOSURE') THEN 'ZERO PRICED EXPO' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('DJUBS-BASE METAL', 'DJUBS-BASE METALS') THEN 'DJUBS-BASE METAL' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('GAS SULFUR CREDI', 'GAS SULFUR CREDIT') THEN 'GAS SULFUR CREDI' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('GASOIL TIMESPREA', 'GASOIL TIMESPREAD') THEN 'GASOIL TIMESPREA' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('USD INTEREST RAT', 'USD INTEREST RATE') THEN 'USD INTEREST RAT' ELSE A.PRODUCT_SUB_TYPE_CODE END AS PRODUCT_SUB_TYPE_CODE, A.QUARTERS, A.TIME_BUCKET_CALENDAR, SUM(A.DOLLAR_DELTA) AS DOLLAR_DELTA, SUM(A.RAW_DELTA) AS RAW_DELTA, SUM(A.DOLLAR_VEGA) AS DOLLAR_VEGA, SUM(A.RAW_VEGA) AS RAW_VEGA FROM( SELECT PROD_POS_NAME_DESCRIPTION, COB_DATE, CCC_BUSINESS_AREA, PRODUCT_TYPE_CODE, TIME_BUCKET_CALENDAR, PRODUCT_SUB_TYPE_CODE, TIME_BUCKET_ANNUAL, EXPIRATION_DATE, TIME_BUCKET_QUARTER, case when EXPIRATION_DATE < ('2019-09-01') then time_bucket_quarter end as quarters, CASE WHEN PRODUCT_TYPE_CODE IN ('EAST OFF','EAST PEAK','MIDWEST OFF', 'MIDWEST PEAK','TEXAS OFF','TEXAS PEAK','WEST OFF','WEST PEAK', 'GRNPWR OFF','GRNPWR PEAK','EAST INTERCONNECT OF','EAST INTERCONNECT PE','TEXAS INTERCONNECT O', 'TEXAS INTERCONNECT P', 'ERCOT', 'WEST INTERCONNECT OF', 'WEST INTERCONNECT PE') THEN 'ELECTRICITY' WHEN PRODUCT_TYPE_CODE IN ('NATGAS') THEN PRODUCT_TYPE_CODE END AS GE_DETAIL0 ,SUM(CAST(USD_CM_DELTA AS NUMERIC(15, 5))) AS DOLLAR_DELTA ,SUM(CAST(RAW_CM_DELTA AS NUMERIC(15, 5))) AS RAW_DELTA ,SUM(CAST(USD_CM_KAPPA AS NUMERIC(15, 5))) AS DOLLAR_VEGA ,SUM(CAST(RAW_CM_KAPPA AS NUMERIC(15, 5))) AS RAW_VEGA FROM cdwuser.U_CM_MSR Where COB_DATE IN ('2018-02-28','2018-01-31') AND PRODUCT_TYPE_CODE IN ('NATGAS','EAST OFF', 'EAST PEAK', 'MIDWEST OFF', 'MIDWEST PEAK', 'TEXAS OFF', 'TEXAS PEAK', 'WEST OFF', 'WEST PEAK','GRNPWR OFF','GRNPWR PEAK', 'EAST INTERCONNECT OF','EAST INTERCONNECT PE','TEXAS INTERCONNECT O', 'TEXAS INTERCONNECT P', 'ERCOT', 'WEST INTERCONNECT OF', 'WEST INTERCONNECT PE') AND ((CCC_BUSINESS_AREA IN ('NA ELECTRICITYNATURAL GAS') AND CCC_DIVISION IN ('COMMODITIES')) /*OLD LOGIC*/ OR (CCC_DIVISION = 'FIXED INCOME DIVISION' AND CCC_BUSINESS_AREA = 'COMMODITIES' AND CCC_PRODUCT_LINE IN ('NA POWER & GAS'))) /*NEW LOGIC*/ AND (CCC_PL_REPORTING_REGION IN ('EUROPE','EMEA')) and NOT(INCLUDE_IN_REG_CAAP_FL = 'N' and PRODUCT_SUB_TYPE_CODE in ('N EAST CONSUMPTI', 'N EAST CONSUMPTION', 'N EAST APPALACHI', 'N EAST APPALACHIA') and BOOK = '18003') GROUP BY PROD_POS_NAME_DESCRIPTION, COB_DATE, CCC_BUSINESS_AREA, PRODUCT_TYPE_CODE, TIME_BUCKET_CALENDAR, PRODUCT_SUB_TYPE_CODE, TIME_BUCKET_ANNUAL, EXPIRATION_DATE, TIME_BUCKET_QUARTER, CASE WHEN EXPIRATION_DATE < ('2019-03-04') THEN TIME_BUCKET_QUARTER END, CASE WHEN PRODUCT_TYPE_CODE IN ('EAST OFF','EAST PEAK','MIDWEST OFF', 'MIDWEST PEAK','TEXAS OFF','TEXAS PEAK','WEST OFF','WEST PEAK', 'GRNPWR OFF','GRNPWR PEAK','EAST INTERCONNECT OF','EAST INTERCONNECT PE','TEXAS INTERCONNECT O', 'TEXAS INTERCONNECT P', 'ERCOT', 'WEST INTERCONNECT OF', 'WEST INTERCONNECT PE') THEN 'ELECTRICITY' WHEN PRODUCT_TYPE_CODE IN ('NATGAS') THEN PRODUCT_TYPE_CODE END ) A GROUP BY A.COB_DATE, A.PROD_POS_NAME_DESCRIPTION, A.GE_DETAIL0, CASE WHEN A.PRODUCT_SUB_TYPE_CODE IN ('N EAST CONSUMPTI', 'N EAST CONSUMPTION') THEN 'N EAST CONSUMPTION' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('N EAST APPALACHI', 'N EAST APPALACHIA') THEN 'N EAST APPALACHIA' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('POLYPROPELENE HO', 'POLYPROPELENE HOMOPOLYMER') THEN 'POLYPROPELENE HO' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('POLYPROPYLENE CO', 'POLYPROPYLENE COPOLYMER') THEN 'POLYPROPYLENE CO' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('PURE TEREPHTHALI', 'PURE TEREPHTHALIC ACID') THEN 'PURE TEREPHTHALI' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('GSCI-PRECIOUS ME', 'GSCI-PRECIOUS METALS') THEN 'GSCI-PRECIOUS ME' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('ZERO PRICED EXPO', 'ZERO PRICED EXPOSURE') THEN 'ZERO PRICED EXPO' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('DJUBS-BASE METAL', 'DJUBS-BASE METALS') THEN 'DJUBS-BASE METAL' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('GAS SULFUR CREDI', 'GAS SULFUR CREDIT') THEN 'GAS SULFUR CREDI' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('GASOIL TIMESPREA', 'GASOIL TIMESPREAD') THEN 'GASOIL TIMESPREA' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('USD INTEREST RAT', 'USD INTEREST RATE') THEN 'USD INTEREST RAT' ELSE A.PRODUCT_SUB_TYPE_CODE END, A.QUARTERS, A.TIME_BUCKET_CALENDAR