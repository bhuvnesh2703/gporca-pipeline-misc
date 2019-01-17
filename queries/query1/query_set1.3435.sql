select a.COB_DATE, a.BUCKETED_TERM, a.TERM_BUCKET, a.CURRENCY_MAPPING, a.CURRENCY_OF_MEASURE, a.VAR_EXCL_FL, a.CCC_BUSINESS_AREA, Case WHEN var_excl_fl ='Y' THEN 'Excluded' ELSE 'Included' END AS Var_Inclusion, a.CURRENCY_OF_MEASURE, a.BANK_FLAG, a.BOOK, a.BOOK_STRATEGY, a.account, sum(a.USD_IR_UNIFIED_PV01) as usd_pv01 from cdwuser.U_DM_Treasury a where cob_date in ('2018-02-28', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31') and a.ccc_division = 'TREASURY CAPITAL MARKETS' and a.BOOK not in ('TSYGLRCSH') group by a.COB_DATE, a.BUCKETED_TERM, a.TERM_BUCKET, a.CURRENCY_MAPPING, a.CURRENCY_OF_MEASURE, a.VAR_EXCL_FL, a.CCC_BUSINESS_AREA, Case WHEN var_excl_fl ='Y' THEN 'Excluded' ELSE 'Included' END, a.CURRENCY_OF_MEASURE, a.BANK_FLAG, a.BOOK, a.BOOK_STRATEGY, a.account