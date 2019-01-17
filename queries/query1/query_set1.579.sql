WITH     CREDIT_RAW AS     (         SELECT              COB_DATE,             POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,             CR_ULTIMATE_CNTRY_CODE,                 MRD_RATING,             CCC_BUSINESS_AREA,             SUM(COALESCE(USD_PV01SPRD,0)) AS CREDIT_SPREAD         FROM             cdwuser.U_EXP_MSR a         WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and A.CCC_TAPS_COMPANY in ('1050') AND              a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND             (a.CCC_BUSINESS_AREA NOT IN ('LENDING','FID MANAGEMENT') AND a.CCC_PRODUCT_LINE <> 'DISTRESSED TRADING') AND     /*a.CCC_BUSINESS_AREA NOT IN ('COMMODITIES') AND*/      a.CCC_BANKING_TRADING = 'TRADING'         GROUP BY             COB_DATE,             POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,             CR_ULTIMATE_CNTRY_CODE,                 MRD_RATING,             CCC_BUSINESS_AREA     ),     CREDIT_SELECT_SUM AS      (         SELECT             bb.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,             bb.CR_ULTIMATE_CNTRY_CODE,             bb.MRD_RATING,             ABS(SUM(bb.CREDIT_SPREAD)) AS CREDIT_SPREAD         FROM             CREDIT_RAW bb         WHERE bb.COB_DATE = '2018-02-28'         GROUP BY             bb.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,             bb.CR_ULTIMATE_CNTRY_CODE,             bb.MRD_RATING     ),     CREDIT_SELECT_RANK AS     (         SELECT             c.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,             c.MRD_RATING,             c.CREDIT_SPREAD,             RANK () OVER (PARTITION BY c.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME ORDER BY c.CREDIT_SPREAD DESC) AS RANK1         FROM             CREDIT_SELECT_SUM c     ),     CREDIT_SELECT_RANKING AS     (     SELECT         d.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,         d.MRD_RATING AS MRD_RATING_NEW     FROM         CREDIT_SELECT_RANK d     WHERE         d.RANK1 =1     ),     CREDIT_SELECT_ADJ AS     (     SELECT         b.COB_DATE,         b.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,         b.CR_ULTIMATE_CNTRY_CODE,             e.MRD_RATING_NEW AS MRD_RATING,         b.CCC_BUSINESS_AREA,         b.CREDIT_SPREAD     FROM         CREDIT_RAW  b     INNER JOIN         CREDIT_SELECT_RANKING e     ON         b.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME=e.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME     ) SELECT     COB_DATE,     POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,     CR_ULTIMATE_CNTRY_CODE,         MRD_RATING,      CCC_BUSINESS_AREA,     SUM(CREDIT_SPREAD) AS CREDIT_SPREAD FROM     CREDIT_SELECT_ADJ GROUP BY     COB_DATE,     POSITION_ULT_ISSUER_PARTY_DARWIN_NAME,     CR_ULTIMATE_CNTRY_CODE,         MRD_RATING,      CCC_BUSINESS_AREA