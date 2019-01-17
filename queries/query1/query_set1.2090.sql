SELECT A.COB_DATE, CASE WHEN A.CCC_TAPS_COMPANY IN ( '0201','0103','0205','0206','0530','5924') THEN 'MSCO' WHEN A.CCC_TAPS_COMPANY in ('0111') THEN 'MSCS' ELSE A.CCC_TAPS_COMPANY END AS LE, SUM (A.USD_PV10_BENCH) AS USD_PV10_BENCH, 0 AS USD_PV10_BENCH_GCT_NIG, 0 as EQ_DELTA, 0 as EQ_KAPPA FROM CDWUSER.U_EXP_MSR A WHERE A.CCC_TAPS_COMPANY in ( '0201','0103','0205','0206','0530','5924','0111') AND A.COB_DATE >= '02/01/2017' AND A.COB_DATE <= '02/28/2018' AND A.CCC_DIVISION = 'FIXED INCOME DIVISION' AND ((A.PRODUCT_TYPE_CODE IN ('CDSOPTIDX', 'CRDINDEX', 'LOANINDEX')) OR (A.CCC_STRATEGY NOT IN ('DISTRESSED TRADING1', 'NON MSMS1'))) AND ((A.FID1_SENIORITY NOT IN ('SUBT1', 'SUBUT2', 'AT1')) OR (A.PRODUCT_TYPE_CODE NOT IN ('BOND', 'BONDFUT', 'BONDFUTOPT', 'BONDIL', 'BONDOPT', 'PREF'))) AND ((a.COUNTRY_CD_OF_RISK NOT IN ('USA')) OR (a.FID1_INDUSTRY_NAME_LEVEL2 NOT IN ('AGENCIES'))) AND a.FID1_INDUSTRY_NAME_LEVEL1 NOT IN ('SOVEREIGN') AND A.PRODUCT_TYPE_CODE NOT IN ('ARSMUNI', 'ARSPREF', 'ARSSL', 'MUNI', 'TOB') AND a.COUNTRY_OF_RISK_TIER NOT IN ('2') AND a.BOOK NOT IN ('CPYRM', 'SCCDS', 'TOTMT', 'SCALL') AND A.CCC_STRATEGY NOT LIKE '%EVENT' AND A.CCC_STRATEGY NOT LIKE 'EVENT%' AND A.CCC_STRATEGY NOT LIKE '%CVA' AND A.CCC_STRATEGY NOT LIKE 'CVA%' AND A.CCC_STRATEGY NOT IN ('CPM OTHER', 'TRADE CLAIMS', 'DERIVATIVES FUNDING') AND A.CCC_BUSINESS_AREA NOT IN ('LENDING', 'MS CVA MNE - FID') GROUP BY A.COB_DATE, CASE WHEN A.CCC_TAPS_COMPANY IN ( '0201','0103','0205','0206','0530','5924') THEN 'MSCO' WHEN A.CCC_TAPS_COMPANY in ('0111') THEN 'MSCS' ELSE A.CCC_TAPS_COMPANY END UNION SELECT B.COB_DATE, CASE WHEN B.CCC_TAPS_COMPANY IN ( '0201','0103','0205','0206','0530','5924') and B.book not in ('DCMSA') THEN 'MSCO' WHEN B.CCC_TAPS_COMPANY in ('0111') THEN 'MSCS' ELSE B.CCC_TAPS_COMPANY END AS LE, 0 as USD_PV10_BENCH, SUM (B.USD_PV10_BENCH) AS USD_PV10_BENCH_GCT_NIG, 0 as EQ_DELTA, 0 as EQ_KAPPA FROM CDWUSER.U_EXP_MSR B WHERE B.CCC_TAPS_COMPANY in ( '0201','0103','0205','0206','0530','5924','0111') AND B.COB_DATE >= '02/01/2017' AND B.COB_DATE <= '02/28/2018' AND B.CCC_DIVISION = 'FIXED INCOME DIVISION' AND ((B.PRODUCT_TYPE_CODE IN ('CDSOPTIDX', 'CRDINDEX', 'LOANINDEX')) OR (B.CCC_STRATEGY NOT IN ('DISTRESSED TRADING1', 'NON MSMS1'))) AND ((B.FID1_SENIORITY NOT IN ('SUBT1', 'SUBUT2', 'AT1')) OR (B.PRODUCT_TYPE_CODE NOT IN ('BOND', 'BONDFUT', 'BONDFUTOPT', 'BONDIL', 'BONDOPT', 'PREF'))) AND B.PRODUCT_TYPE_CODE NOT IN ('ARSMUNI', 'ARSPREF', 'MUNI', 'TOB') AND B.COUNTRY_OF_RISK_TIER NOT IN ('2') AND B.CCC_BUSINESS_AREA IN ('CREDIT-CORPORATES', 'DSP - CREDIT' /*, 'FXEM MACRO TRADING', 'EM CREDIT TRADING', 'MUNICIPAL SECURITIES'*/) AND B.CCC_STRATEGY NOT LIKE 'EVENT%' AND B.CCC_STRATEGY NOT LIKE '%EVENT' AND B.MRD_RATING IN ('B', 'BB', 'C', 'CC', 'CCC', 'D', 'NR') AND B.book not in ('TOTMT') GROUP BY B.COB_DATE, CASE WHEN B.CCC_TAPS_COMPANY IN ( '0201','0103','0205','0206','0530','5924') and B.book not in ('DCMSA') THEN 'MSCO' WHEN B.CCC_TAPS_COMPANY in ('0111') THEN 'MSCS' ELSE B.CCC_TAPS_COMPANY END UNION SELECT C.COB_DATE, CASE WHEN C.CCC_TAPS_COMPANY in ('0111') THEN 'MSCS' ELSE C.CCC_TAPS_COMPANY END AS LE, 0 as USD_PV10_BENCH, 0 AS USD_PV10_BENCH_GCT_NIG, SUM (C.USD_DELTA) AS EQ_DELTA, SUM (C.USD_EQ_KAPPA) AS EQ_KAPPA FROM CDWUSER.U_EXP_msr C WHERE C.CCC_TAPS_COMPANY in ( '0201','0103','0205','0206','0530','5924','0111') AND C.COB_DATE >= '02/01/2017' AND C.COB_DATE <= '02/28/2018' AND C.VAR_EXCL_FL <> 'Y' AND C.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND C.CCC_BANKING_TRADING_FEED = 'TRADING' GROUP BY C.COB_DATE, CASE WHEN C.CCC_TAPS_COMPANY in ('0111') THEN 'MSCS' ELSE C.CCC_TAPS_COMPANY END ORDER BY cob_date