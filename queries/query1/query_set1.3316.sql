SELECT COB_DATE, POSITIONS, sum(bpv10)/1000 as bpv10, sum(TOP10)/1000 as TOP10 FROM ( SELECT COB_DATE, POSITION_ULT_ISSUER_PARTY_DARWIN_NAME, bpv10, POSITIONS, CASE WHEN RANK_LONG BETWEEN 1 AND 10 OR RANK_SHORT BETWEEN 1 AND 10 THEN bpv10 ELSE 0 END as TOP10 FROM (SELECT COB_DATE, POSITION_ULT_ISSUER_PARTY_DARWIN_NAME, bpv10, POSITIONS, RANK() OVER(PARTITION BY COB_DATE ORDER BY bpv10 ASC) as RANK_LONG, RANK() OVER(PARTITION BY COB_DATE ORDER BY bpv10 DESC) as RANK_SHORT FROM (SELECT a.COB_DATE, a.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME, SUM (a.usd_pv10_BENCH) AS bpv10, CASE WHEN SUM (a.usd_pv10_BENCH) >0 THEN 'Short' ELSE 'Long' END as POSITIONS FROM cdwuser.U_DM_CC a WHERE a.COB_DATE >='2016-09-30' AND a.COB_DATE <'2018-02-28' AND a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.CCC_BANKING_TRADING = 'TRADING' AND a.CCC_BUSINESS_AREA = 'CREDIT-CORPORATES' AND a.PRODUCT_TYPE_CODE = 'BOND' AND a.CCC_PRODUCT_LINE not in ('DISTRESSED TRADING', 'PRIMARY - LOANS', 'PAR LOANS TRADING') AND FID1_SENIORITY NOT IN('AT1','SUBT1', 'SUBUT2') GROUP BY a.COB_DATE, a.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME ) x WHERE bpv10 IS NOT NULL ) y ) z GROUP BY COB_DATE, POSITIONS