SELECT a.cob_date, a.book, A.ACCOUNT, a.CCC_TAPS_COMPANY, a.CCC_PRODUCT_LINE, /*case when a.CCC_PRODUCT_LINE ='CRA GSP' THEN 'CRE SECURITIES' when a.CCC_PRODUCT_LINE is null THEN 'CRA' when a.CCC_PRODUCT_LINE ='GWM COMMUNITY REINVESTMENT ACT LOANS' THEN 'CARVER CRA' END AS CCC_PRODUCT_LINE,*/ SUM (COALESCE (cast(a.USD_NOTIONAL as numeric(15,5)), 0)) AS usd_notional, SUM (COALESCE (cast(a.USD_MARKET_VALUE as numeric(15,5)) , 0)) AS usd_market_value, SUM (COALESCE (cast(a.USD_NET_EXPOSURE as numeric(15,5)),0)) as usd_net_expousre FROM Cdwuser.u_dm_wm a WHERE a.cob_date IN ( '2018-02-28', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31', '2017-09-29', '2017-08-31', '2017-07-31' ) AND (a.CCC_BUSINESS_AREA IN ('NON-JV UNALLOCATED OTHER', 'US BANKS-CRA PORTFOLIO') OR a.MSPBNA_MORTGAGE_TYPE LIKE ('%CRA%')) GROUP BY a.cob_date, a.book, A.ACCOUNT, a.CCC_TAPS_COMPANY, a.CCC_PRODUCT_LINE UNION ALL SELECT a.cob_date, a.book, A.ACCOUNT, a.CCC_TAPS_COMPANY, a.CCC_PRODUCT_LINE, SUM (COALESCE (cast(a.USD_NOTIONAL as numeric(15,5)), 0)) AS usd_notional, SUM (COALESCE (cast(a.USD_MARKET_VALUE as numeric(15,5)), 0)) AS usd_market_value, SUM (COALESCE (cast(a.USD_EXPOSURE as numeric(15,5)),0)) as usd_net_expousre FROM Cdwuser.u_exp_msr a WHERE a.cob_date IN ( '2018-02-28', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31', '2017-09-29', '2017-08-31', '2017-07-31' ) AND a.CCC_BUSINESS_AREA IN ('US BANKS-CRA PORTFOLIO') AND a.CCC_TAPS_COMPANY NOT IN ('6635', '1633') GROUP BY a.cob_date, a.book, A.ACCOUNT, a.CCC_TAPS_COMPANY, a.CCC_PRODUCT_LINE