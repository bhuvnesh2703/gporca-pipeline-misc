WITH RAW_DATA AS(     SELECT         a.COB_DATE,         a.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME AS ULT_NAME,         SUM (CASE WHEN (a.PRODUCT_TYPE_CODE = 'CVA' AND a.PRODUCT_SUB_TYPE_CODE LIKE 'MPE%') THEN COALESCE (CAST(a.usd_pv01sprd AS DOUBLE PRECISION),0) ELSE 0 END) AS CVA_MPE,         SUM (CASE WHEN (a.PRODUCT_TYPE_CODE IN ('DEFSWAP', 'CRDINDEX')) THEN COALESCE (CAST(a.usd_pv01sprd AS DOUBLE PRECISION),0) ELSE 0 END) AS CVA_HEDGE     FROM         cdwuser.U_CR_MSR a     WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and CCC_TAPS_COMPANY IN ('4391', '4341')         AND (a.CCC_BUSINESS_AREA IN ('CPM', 'CPM TRADING (MPE)', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR         a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES')) AND         a.ccc_product_line NOT IN ('CREDIT LOAN PORTFOLIO', 'CMD STRUCTURED FINANCE') AND     A.CURVE_TYPE NOT IN ('CPCR_CLEAR') AND         (a.VAR_EXCL_FL <> 'Y') AND         a.CURVE_NAME NOT IN ('ms_seccpm', 'cpcr_mpefund', 'cpcrmne')     GROUP BY         a.COB_DATE,         a.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME ), TABLE_FORM_DATA AS( SELECT     a.COB_DATE,     a.ULT_NAME,     SUM(CASE WHEN a.COB_DATE = '2018-02-28'     THEN a.CVA_MPE ELSE 0 END) AS CVA_MPE,     SUM(CASE WHEN a.COB_DATE = '2018-02-28'     THEN a.CVA_HEDGE ELSE 0 END) AS CVA_HEDGE,     SUM(CASE WHEN a.COB_DATE = '2018-02-28'     THEN (a.CVA_MPE+a.CVA_HEDGE) ELSE 0 END) AS NET,     SUM(CASE WHEN a.COB_DATE = '2018-02-28'     THEN (a.CVA_MPE+a.CVA_HEDGE) ELSE (-1)*(a.CVA_MPE+a.CVA_HEDGE) END) AS CHANGE FROM     RAW_DATA a GROUP BY     a.COB_DATE,     a.ULT_NAME ), ORDER_FORM_DATA AS(     SELECT         ROW_NUMBER () OVER (ORDER BY SUM(a.NET) ASC) AS ROW_POS_MIN,         ROW_NUMBER () OVER (ORDER BY SUM(a.NET) DESC) AS ROW_POS_MAX,         a.ULT_NAME,         SUM(a.CVA_MPE) AS CVA_MPE,         SUM(a.CVA_HEDGE) AS CVA_HEDGE,         SUM(a.NET) AS NET,         SUM(a.CHANGE) AS CHANGE     FROM         TABLE_FORM_DATA a     GROUP BY         a.ULT_NAME ) SELECT     CASE         WHEN a.ROW_POS_MIN >10 THEN 11     ELSE a.ROW_POS_MIN END AS ROW_POS_MIN,     a.ROW_POS_MAX,     a.ULT_NAME,     a.CVA_MPE,     a.CVA_HEDGE,     a.NET,     a.CHANGE FROM     ORDER_FORM_DATA a WHERE     a.ROW_POS_MIN<=10 OR a.ROW_POS_MAX<=5