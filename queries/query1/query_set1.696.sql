SELECT      a.COB_DATE,     sum(coalesce(CAST(a.SLIDE_EQ_MIN_05_USD AS DOUBLE PRECISION), 0)) AS SLIDE_EQ_MIN_05_USD,     sum(coalesce(CAST(a.SLIDE_EQ_MIN_10_USD AS DOUBLE PRECISION), 0)) AS SLIDE_EQ_MIN_10_USD,     sum(coalesce(CAST(a.SLIDE_EQ_MIN_20_USD AS DOUBLE PRECISION), 0)) AS SLIDE_EQ_MIN_20_USD,     sum(coalesce(CAST(a.SLIDE_EQ_MIN_30_USD AS DOUBLE PRECISION), 0)) AS SLIDE_EQ_MIN_30_USD,      sum(coalesce(CAST(a.SLIDE_EQ_PLS_05_USD AS DOUBLE PRECISION), 0)) AS SLIDE_EQ_PLS_05_USD,     sum(coalesce(CAST(a.SLIDE_EQ_PLS_10_USD AS DOUBLE PRECISION), 0)) AS SLIDE_EQ_PLS_10_USD,     sum(coalesce(CAST(a.SLIDE_EQ_PLS_20_USD AS DOUBLE PRECISION), 0)) AS SLIDE_EQ_PLS_20_USD FROM      CDWUSER.U_EQ_MSR_INTRPLT a WHERE  (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and A.CCC_TAPS_COMPANY in ('1050') AND      a.CCC_BANKING_TRADING = 'TRADING' AND      (a.ccc_business_area <> 'INTERNATIONAL WEALTH MGMT') AND      a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' GROUP BY      a.COB_DATE