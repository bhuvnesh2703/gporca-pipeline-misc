SELECT SUM (USD_IR_KAPPA) / 10 AS IR_KAPPA, cob_date, currency_of_measure, ccc_business_area, a.ccc_division, CASE WHEN a.term_new <= 0.25 THEN '03M' WHEN a.term_new <= 0.5 THEN '06M' WHEN a.term_new <= 1 THEN '01Y' WHEN a.term_new <= 2 THEN '02Y' WHEN a.term_new <= 5 THEN '05Y' WHEN a.term_new <= 7 THEN '07Y' WHEN a.term_new <= 10 THEN '10Y' ELSE '10Y+' END AS term_bucket FROM cdwuser.U_DM_IR a WHERE cob_date in ('2018-02-28', '2018-02-27') and currency_of_measure in ('ILS') AND a.ccc_division IN ('FIXED INCOME DIVISION', 'INSTITUTIONAL EQUITY DIVISION') AND ccc_banking_trading_localreg = 'TRADING' AND ccc_business_area NOT IN ('CPM', 'DSP - CREDIT', 'LENDING', 'OTC CLIENT CLEARING') GROUP BY cob_date, currency_of_measure, ccc_business_area, a.ccc_division, CASE WHEN a.term_new <= 0.25 THEN '03M' WHEN a.term_new <= 0.5 THEN '06M' WHEN a.term_new <= 1 THEN '01Y' WHEN a.term_new <= 2 THEN '02Y' WHEN a.term_new <= 5 THEN '05Y' WHEN a.term_new <= 7 THEN '07Y' WHEN a.term_new <= 10 THEN '10Y' ELSE '10Y+' END