/*CREDIT CORP SECTOR AND ISSUER*/ SELECT a.cob_date, max(abs(A.USD_PV01SPRD)) AS CREDIT_CORP_SECTOR_USD_PV01SPRD, 0 AS CREDIT_CORP_SECTOR_USD_PV10_BENCH, 0 AS CREDIT_CORP_ISSUER_USD_PV01SPRD, 0 AS CREDIT_CORP_ISSUER_USD_PV10_BENCH, 0 AS CREDIT_CMBS_ISSUER_USD_EXPOSURE, 0 AS CREDIT_CLO_ISSUER_USD_EXPOSURE, 0 AS CREDIT_AUTO_ISSUER_USD_EXPOSURE FROM ( SELECT a.COB_DATE, a.FID1_INDUSTRY_NAME_LEVEL2, SUM(COALESCE((USD_PV01SPRD) :: numeric(15,5),0)) as USD_PV01SPRD from CDWUSER.U_DM_WM A where a.cob_date in ( '2018-02-28', '2018-02-27', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31' ) and a.book in ('AFSC1') and a.ccc_taps_company in ('1633') GROUP BY a.COB_DATE, a.FID1_INDUSTRY_NAME_LEVEL2 ) a group by a.COB_DATE UNION ALL SELECT a.cob_date, 0 AS CREDIT_CORP_SECTOR_USD_PV01SPRD, max(abs(A.USD_PV10_BENCH)) AS CREDIT_CORP_SECTOR_USD_PV10_BENCH, 0 AS CREDIT_CORP_ISSUER_USD_PV01SPRD, 0 AS CREDIT_CORP_ISSUER_USD_PV10_BENCH, 0 AS CREDIT_CMBS_ISSUER_USD_EXPOSURE, 0 AS CREDIT_CLO_ISSUER_USD_EXPOSURE, 0 AS CREDIT_AUTO_ISSUER_USD_EXPOSURE FROM ( SELECT a.COB_DATE, a.FID1_INDUSTRY_NAME_LEVEL2, SUM(COALESCE((USD_PV10_BENCH) :: numeric(15,5),0)) as USD_PV10_BENCH from CDWUSER.U_DM_WM A where a.cob_date in ( '2018-02-28', '2018-02-27', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31' ) and a.book in ('AFSC1') and a.ccc_taps_company in ('1633') GROUP BY a.COB_DATE, a.FID1_INDUSTRY_NAME_LEVEL2 ) a group by a.COB_DATE union all SELECT a.cob_date, 0 AS CREDIT_CORP_SECTOR_USD_PV01SPRD, 0 AS CREDIT_CORP_SECTOR_USD_PV10_BENCH, max(abs(A.USD_PV01SPRD)) AS CREDIT_CORP_ISSUER_USD_PV01SPRD, 0 AS CREDIT_CORP_ISSUER_USD_PV10_BENCH, 0 AS CREDIT_CMBS_ISSUER_USD_EXPOSURE, 0 AS CREDIT_CLO_ISSUER_USD_EXPOSURE, 0 AS CREDIT_AUTO_ISSUER_USD_EXPOSURE FROM ( SELECT a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME, SUM(COALESCE((USD_PV01SPRD) :: numeric(15,5),0)) as USD_PV01SPRD from CDWUSER.U_DM_WM_POSITION A where a.cob_date in ( '2018-02-28', '2018-02-27', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31' ) and a.book in ('AFSC1') and a.ccc_taps_company in ('1633') GROUP BY a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME ) a group by a.COB_DATE UNION ALL SELECT a.cob_date, 0 AS CREDIT_CORP_SECTOR_USD_PV01SPRD, 0 AS CREDIT_CORP_SECTOR_USD_PV10_BENCH, 0 AS CREDIT_CORP_ISSUER_USD_PV01SPRD, max(abs(A.USD_PV10_BENCH)) AS CREDIT_CORP_ISSUER_USD_PV10_BENCH, 0 AS CREDIT_CMBS_ISSUER_USD_EXPOSURE, 0 AS CREDIT_CLO_ISSUER_USD_EXPOSURE, 0 AS CREDIT_AUTO_ISSUER_USD_EXPOSURE FROM ( SELECT a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME, SUM(COALESCE((USD_PV10_BENCH) :: numeric(15,5),0)) as USD_PV10_BENCH from CDWUSER.U_DM_WM_POSITION A where a.cob_date in ( '2018-02-28', '2018-02-27', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31' ) and a.book in ('AFSC1') and a.ccc_taps_company in ('1633') GROUP BY a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME ) a group by a.COB_DATE /*CREDIT CMBS ISSUER*/ UNION ALL SELECT a.cob_date, 0 AS CREDIT_CORP_SECTOR_USD_PV01SPRD, 0 AS CREDIT_CORP_SECTOR_USD_PV10_BENCH, 0 AS CREDIT_CORP_ISSUER_USD_PV01SPRD, 0 AS CREDIT_CORP_ISSUER_USD_PV10_BENCH, max(abs(A.USD_EXPOSURE)) AS CREDIT_CMBS_ISSUER_USD_EXPOSURE, 0 AS CREDIT_CLO_ISSUER_USD_EXPOSURE, 0 AS CREDIT_AUTO_ISSUER_USD_EXPOSURE FROM ( SELECT a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME, SUM(COALESCE((USD_EXPOSURE) :: numeric(15,5), 0)) as USD_EXPOSURE from CDWUSER.U_DM_WM_POSITION A where a.cob_date in ( '2018-02-28', '2018-02-27', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31' ) and a.book in ('BKCMB') and a.ccc_taps_company in ('1633') GROUP BY a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME ) a group by a.COB_DATE /*CREDIT CLO ISSUER*/ UNION ALL SELECT a.cob_date, 0 AS CREDIT_CORP_SECTOR_USD_PV01SPRD, 0 AS CREDIT_CORP_SECTOR_USD_PV10_BENCH, 0 AS CREDIT_CORP_ISSUER_USD_PV01SPRD, 0 AS CREDIT_CORP_ISSUER_USD_PV10_BENCH, 0 AS CREDIT_CMBS_ISSUER_USD_EXPOSURE, max(abs(A.USD_EXPOSURE)) AS CREDIT_CLO_ISSUER_USD_EXPOSURE, 0 AS CREDIT_AUTO_ISSUER_USD_EXPOSURE FROM ( SELECT a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME, SUM(COALESCE((USD_EXPOSURE) :: numeric(15,5), 0)) as USD_EXPOSURE from CDWUSER.U_DM_WM_POSITION A where a.cob_date in ( '2018-02-28', '2018-02-27', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31' ) and a.book in ('BKCLO') and a.ccc_taps_company in ('1633') GROUP BY a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME ) a group by a.COB_DATE /*CREDIT AUTO ISSUER*/ UNION ALL SELECT a.cob_date, 0 AS CREDIT_CORP_SECTOR_USD_PV01SPRD, 0 AS CREDIT_CORP_SECTOR_USD_PV10_BENCH, 0 AS CREDIT_CORP_ISSUER_USD_PV01SPRD, 0 AS CREDIT_CORP_ISSUER_USD_PV10_BENCH, 0 AS CREDIT_CMBS_ISSUER_USD_EXPOSURE, 0 AS CREDIT_CLO_ISSUER_USD_EXPOSURE, max(abs(A.USD_EXPOSURE)) AS CREDIT_AUTO_ISSUER_USD_EXPOSURE FROM ( SELECT a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME, SUM(COALESCE((USD_EXPOSURE) :: numeric(15,5), 0)) as USD_EXPOSURE from CDWUSER.U_DM_WM_POSITION A where a.cob_date in ( '2018-02-28', '2018-02-27', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31' ) and a.book in ('BKCAR') and a.ccc_taps_company in ('1633') GROUP BY a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME ) a group by a.COB_DATE