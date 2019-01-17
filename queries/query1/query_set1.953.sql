SELECT     a.COB_DATE, a.TERM_BUCKET,     CASE          WHEN FEED_SOURCE_NAME = 'CORISK' THEN substr (PROD_POS_NAME_DESCRIPTION,1,3)         ELSE a.CURVE_CURRENCY     END AS CURRENCY,     CASE          WHEN (a.PRODUCT_SUB_TYPE_CODE = 'CTDVA') THEN 'CTDVA'          WHEN (a.PRODUCT_SUB_TYPE_CODE = 'LVA') THEN 'LVA'          WHEN (a.PRODUCT_SUB_TYPE_CODE = 'OISVA') THEN 'OISVA'          WHEN (PRODUCT_SUB_TYPE_CODE IN ('MPE_FVA_RAW', 'MPE_FVA') OR (BOOK IN ('FVPL2','FVPL3') AND BU_RISK_SYSTEM LIKE 'STS%') ) THEN 'MPE FVA'          WHEN (PRODUCT_SUB_TYPE_CODE IN ('MNE_FVA','MNE_FVA_NET') OR (BOOK IN ('FVNL3') AND BU_RISK_SYSTEM LIKE 'STS%')) THEN 'MNE FVA'          WHEN (PRODUCT_SUB_TYPE_CODE IN ('MPE_CVA', 'MPE', 'MPE_PROXY', 'MNE_CP') OR (BOOK IN ('CV2LP', 'CV2LN', 'CVPL1', 'CV2LD', 'CVPL2') AND BU_RISK_SYSTEM LIKE 'STS%') OR BOOK = '1679') THEN 'MPE CVA'          WHEN PRODUCT_SUB_TYPE_CODE IN ('MNE_CVA', 'MNE') THEN 'MNE CVA'         ELSE 'Hedge'      END AS TYPE_FLAG,     a.curve_name,     SUM (COALESCE (a.GRID_MEASURE_VALUE,0) / 10) AS USD_KAPPA FROM cdwuser.U_GRID_MSR a WHERE     1 = 1 AND (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') AND      GRID_MEASURE_NAME IN ('USD_KAPPA') AND     (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR      a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES','EQ XVA HEDGING')) AND     a.GRID_MEASURE_VALUE IS NOT NULL GROUP BY     a.COB_DATE, a.TERM_BUCKET,     CURRENCY,     TYPE_FLAG,     curve_name