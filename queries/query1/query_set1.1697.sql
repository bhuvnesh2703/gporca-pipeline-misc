WITH ssg_cr_all AS ( SELECT     CASE          WHEN a.TAPSCUSIP IN ('888893ML5','888893MM3','888893MQ4') THEN 'TM K.K.'         WHEN a.PRODUCT_TYPE_CODE = 'CRDINDEX' THEN a.REFERENCE_INDEX_ENTITY_NAME         WHEN a.POSITION_ISSUER_PARTY_DARWIN_NAME = 'VIETNAM GOVERNMENT' THEN a.POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME         WHEN a.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME <> 'UNDEFINED' THEN a.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME         WHEN a.POSITION_ISSUER_PARTY_DARWIN_NAME <> 'UNDEFINED' THEN a.POSITION_ISSUER_PARTY_DARWIN_NAME     ELSE a.TAPSCUSIP || SUBSTRING(a.PRODUCT_DESCRIPTION,1,15) END AS SSG_DISPLAY_NAME,     CASE          WHEN a.CR_ULTIMATE_CNTRY_CODE <> 'UNDEFINED' THEN a.CR_ULTIMATE_CNTRY_CODE         WHEN a.COUNTRY_CD_OF_RISK <> 'UNDEFINED' THEN a.COUNTRY_CD_OF_RISK         WHEN a.PRODUCT_TYPE_CODE = 'CONVRT' THEN a.ISSUER_COUNTRY_CODE         WHEN a.CR_ULTIMATE_CNTRY_CODE = 'UNDEFINED' THEN a.ISSUER_COUNTRY_CODE     ELSE a.CR_ULTIMATE_CNTRY_CODE END AS ULT_COUNTRY,     CASE          WHEN a.CCC_PRODUCT_LINE = 'DISTRESSED TRADING' THEN 'Distressed'     ELSE 'Others' END AS SSG_POS_GRP,     a.COB_DATE,     CASE         WHEN a.COB_DATE = ('2018-01-31')         THEN 0     ELSE a.USD_EXPOSURE END AS HELP_USD_ASSET_EXPOSURE,     CASE         WHEN a.COB_DATE = ('2018-01-31')         THEN (-1)*a.USD_EXPOSURE     ELSE a.USD_EXPOSURE END AS HELP_CHANGE     FROM     cdwuser.U_CR_MSR a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-01-31') and A.CCC_PL_REPORTING_REGION in ('JAPAN','ASIA PACIFIC') AND A.CCC_TAPS_COMPANY in ('0302','0347','0853','4043','4298','4863','6120', '6899','6837','6893','4044','5869','0856','6325','0301','0893','0993') AND      ((a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND     a.CCC_BUSINESS_AREA = 'CREDIT-CORPORATES' AND     a.CCC_PRODUCT_LINE = 'DISTRESSED TRADING') OR     a.CCC_DIVISION = 'INSTITUTIONAL SECURITIES OTHER')     AND (a.VAR_EXCL_FL <> 'Y') AND     A.USD_EXPOSURE IS NOT NULL AND     NOT(A.USD_EXPOSURE IS NULL AND a.USD_PV10_BENCH IS NULL AND a.USD_CREDIT_PV10PCT IS NULL) ), ssg_all AS ( SELECT     SSG_DISPLAY_NAME,     ULT_COUNTRY,     SSG_POS_GRP,     HELP_USD_ASSET_EXPOSURE AS USD_ASSET_EXPOSURE,     HELP_CHANGE AS CHANGE FROM     ssg_cr_all ) SELECT     SSG_DISPLAY_NAME,     ULT_COUNTRY,     SSG_POS_GRP,     SUM(USD_ASSET_EXPOSURE) AS USD_ASSET_EXPOSURE,     SUM(CHANGE) AS CHANGE FROM     ssg_all GROUP BY     SSG_DISPLAY_NAME,     ULT_COUNTRY,     SSG_POS_GRP ORDER BY     USD_ASSET_EXPOSURE DESC FETCH FIRST 15 ROWS ONLY