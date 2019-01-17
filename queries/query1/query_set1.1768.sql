SELECT a.cob_date, a.ccc_business_area, a.ccc_division, COALESCE (SUM (a.usd_fx_kappa), 0) AS usd_fx_kappa, CASE WHEN a.term_new <= 0.25 THEN '03M' WHEN a.term_new <= 0.5 THEN '06M' WHEN a.term_new <= 1 THEN '01Y' WHEN a.term_new <= 2 THEN '02Y' WHEN a.term_new <= 5 THEN '05Y' ELSE '05Y+' END AS term_bucket, CASE WHEN a.currency_pair LIKE '%DKK%' THEN 'XXXG10' WHEN a.currency_pair LIKE '%SEK%' THEN 'XXXG10' WHEN a.currency_pair LIKE '%AUD%' THEN 'XXXG10' WHEN a.currency_pair LIKE '%CAD%' THEN 'XXXG10' WHEN a.currency_pair LIKE '%CHF%' THEN 'XXXG10' WHEN a. currency_pair LIKE '%NOK%' THEN 'XXXG10' WHEN a.currency_pair LIKE '%NZD%' THEN 'XXXG10' WHEN a.currency_pair LIKE '%JPY%' THEN 'JPY' WHEN a.currency_pair LIKE '%EUR%' THEN 'EUR' WHEN a.currency_pair LIKE '%USD%' THEN 'USD' ELSE 'XXXEM' END AS group_ccypair FROM cdwuser.U_DM_FX a WHERE cob_date in ('2018-02-28', '2018-02-27') and a.currency_pair like '%HUF%' AND a.ccc_division IN ('FIXED INCOME DIVISION', 'INSTITUTIONAL EQUITY DIVISION') AND a.usd_fx_kappa <> 0 AND a.ccc_business_area NOT IN ('CPM', 'DSP - CREDIT', 'LENDING', 'OTC CLIENT CLEARING') AND a.CCC_BANKING_TRADING_LOCALREG = 'TRADING' GROUP BY a.cob_date, a.ccc_business_area, a.ccc_division, CASE WHEN a.term_new <= 0.25 THEN '03M' WHEN a.term_new <= 0.5 THEN '06M' WHEN a.term_new <= 1 THEN '01Y' WHEN a.term_new <= 2 THEN '02Y' WHEN a.term_new <= 5 THEN '05Y' ELSE '05Y+' END, CASE WHEN a.currency_pair LIKE '%DKK%' THEN 'XXXG10' WHEN a.currency_pair LIKE '%SEK%' THEN 'XXXG10' WHEN a.currency_pair LIKE '%AUD%' THEN 'XXXG10' WHEN a.currency_pair LIKE '%CAD%' THEN 'XXXG10' WHEN a.currency_pair LIKE '%CHF%' THEN 'XXXG10' WHEN a. currency_pair LIKE '%NOK%' THEN 'XXXG10' WHEN a.currency_pair LIKE '%NZD%' THEN 'XXXG10' WHEN a.currency_pair LIKE '%JPY%' THEN 'JPY' WHEN a.currency_pair LIKE '%EUR%' THEN 'EUR' WHEN a.currency_pair LIKE '%USD%' THEN 'USD' ELSE 'XXXEM' END