SELECT a.cob_date,  sum(coalesce(a.USD_DELTA,0)) as USD_DELTA, sum(coalesce(a.SLIDE_EQ_MIN_20_USD,0)) as D20, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0)) as D05, sum(coalesce(a.SLIDE_EQ_MIN_30_USD,0)) as D30, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0)) as D10, sum(coalesce(a.SLIDE_EQ_PLS_05_USD,0)) as P05, sum(coalesce(a.SLIDE_EQ_PLS_10_USD,0)) as P10, sum(coalesce(a.SLIDE_EQ_PLS_20_USD,0)) as P20,    sum(coalesce(a.SLIDE_EQ_DERIVED_MIN_25_USD, 0)) AS D25,    sum(coalesce(a.SLIDE_EQ_DERIVED_MIN_15_USD, 0)) AS D15,    sum(coalesce(a.SLIDE_EQ_DERIVED_PLS_15_USD, 0)) AS P15  FROM cdwuser.U_DM_EQ a  WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and a.CCC_PL_REPORTING_REGION = 'EMEA' AND  a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION'    AND a.CCC_BANKING_TRADING <> 'BANKING' GROUP BY a.cob_date   UNION ALL   SELECT null as ExpiryDate, sum(coalesce(a.USD_DELTA,0)) as USD_DELTA, sum(coalesce(a.SLIDE_EQ_MIN_20_USD,0)+0.2*coalesce(a.USD_DELTA,0)) as D20, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0)+0.05*coalesce(a.USD_DELTA,0)) as D05, sum(coalesce(a.SLIDE_EQ_MIN_30_USD,0)+0.3*coalesce(a.USD_DELTA,0)) as D30, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0)+0.1*coalesce(a.USD_DELTA,0)) as D10, sum(coalesce(a.SLIDE_EQ_PLS_05_USD,0)-0.05*coalesce(a.USD_DELTA,0)) as P05, sum(coalesce(a.SLIDE_EQ_PLS_10_USD,0)-0.1*coalesce(a.USD_DELTA,0)) as P10, sum(coalesce(a.SLIDE_EQ_PLS_20_USD,0)-0.2*coalesce(a.USD_DELTA,0)) as P20, sum(coalesce(a.SLIDE_EQ_MIN_30_USD,0)*0.5+coalesce(a.SLIDE_EQ_MIN_20_USD,0)*0.5+0.25*coalesce(a.USD_DELTA,0)) AS D25, sum(coalesce(a.SLIDE_EQ_MIN_20_USD,0)*0.5+coalesce(a.SLIDE_EQ_MIN_10_USD,0)*0.5+0.15*coalesce(a.USD_DELTA,0)) AS D15, sum(coalesce(a.SLIDE_EQ_PLS_10_USD,0)*0.5+coalesce(a.SLIDE_EQ_PLS_20_USD,0)*0.5-0.15*coalesce(a.USD_DELTA,0)) AS P15  From  CDWUSER.U_EQ_MSR a where a.COB_DATE = '2018-02-28' and a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.DIVISION='IED'  AND  a.CCC_BANKING_TRADING = 'TRADING' AND a.SILO_SRC = 'IED' AND (coalesce(a.EXPIRATION_DATE,'1970-01-01') > '2018-03-16' OR a.EXPIRATION_DATE='1970-01-01')