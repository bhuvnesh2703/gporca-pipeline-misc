SELECT UNDERLIER_PRODUCT_DESCRIPTION, SUM (COALESCE (SLIDE_PAL_STK_JTD_USD,0)) AS JTD FROM cdwuser.U_EQ_EXT_MSR a WHERE a.cob_date in ('2018-02-28') and ISSUER_COUNTRY_CODE = 'ISR' AND DIVISION IN ('IED', 'FID') AND SLIDE_TYPE_FL = 'D' AND CCC_BUSINESS_AREA NOT IN ('EQUITY FINANCING PRODUCTS', 'PRIME BROKERAGE') AND EXECUTIVE_MODEL LIKE '%MARGIN-LOAN%' GROUP BY UNDERLIER_PRODUCT_DESCRIPTION