SELECT     a.COB_DATE,a.TERM_BUCKET,     a.CURRENCY_OF_MEASURE,     CASE  WHEN (a.BOOK = 'COLLA' and a.VERTICAL_SYSTEM like 'PERSIST%') THEN 'CTDVA' WHEN (a.BOOK = 'COLVA' and a.VERTICAL_SYSTEM like 'PERSIST%') THEN 'LVA' WHEN PRODUCT_SUB_TYPE_CODE IN ('MPE_FVA_RAW', 'MPE_FVA') THEN 'MPE FVA' WHEN PRODUCT_SUB_TYPE_CODE IN ('MNE_FVA', 'MNE_FVA_NET') THEN 'MNE FVA' WHEN (PRODUCT_SUB_TYPE_CODE IN ('MPE_CVA','MPE', 'MPE_PROXY', 'MNE_CP') OR (BOOK IN ('CV2LP', 'CV2LN', 'CVPL1', 'CV2LD', 'CVPL2', 'FVPL2') AND BU_RISK_SYSTEM LIKE 'STS%') OR BOOK = '1679')  THEN 'MPE CVA' WHEN PRODUCT_SUB_TYPE_CODE IN ('MNE_CVA', 'MNE') THEN 'MNE CVA' ELSE 'Hedge' END AS TYPE_FLAG,     SUM (a.USD_FX_KAPPA) AS FX_KAPPA FROM cdwuser.U_FX_MSR a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-01-31') AND LE_GROUP = ('UK') AND      (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)','CPM', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR      a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES','EQ XVA HEDGING')) AND     a.USD_FX_KAPPA IS NOT NULL GROUP BY     a.COB_DATE,a.TERM_BUCKET,     a.CURRENCY_OF_MEASURE,     TYPE_FLAG