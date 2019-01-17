SELECT A.COB_DATE, A.PRODUCT_TYPE_CODE, A.PRODUCT_DESCRIPTION_DECOMP, sum(cast(A.USD_CM_DELTA_DECOMP as numeric(15,5))) as Dollar_Delta FROM cdwuser.U_DECOMP_MSR a Where COB_DATE IN ('2018-02-28','2018-02-27') AND ((CCC_BUSINESS_AREA in ('METALS') AND CCC_DIVISION IN ('COMMODITIES')) /*OLD LOGIC*/ OR (CCC_DIVISION = 'FIXED INCOME DIVISION' AND CCC_BUSINESS_AREA = 'COMMODITIES' and (a.CCC_PRODUCT_LINE IN ('PRECIOUS METALS') OR A.CCC_STRATEGY IN ('BULKS', 'BASE METALS'))) )/* NEW LOGIC*/ AND (CCC_PL_REPORTING_REGION IN ('EUROPE','EMEA')) AND A.PRODUCT_TYPE_CODE = 'FUND' GROUP BY A.COB_DATE, A.PRODUCT_TYPE_CODE, A.PRODUCT_DESCRIPTION_DECOMP