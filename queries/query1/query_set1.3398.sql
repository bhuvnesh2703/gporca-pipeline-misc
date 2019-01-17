SELECT b.COB_DATE, b.ACCOUNT, B.BANK_FLAG, B.BOOK, B.CURRENCY_MAPPING, B.CURRENCY_OF_MEASURE, B.LIQUIDITY_SECTYPE, B.LIQUIDITY_SUB_SECTYPE, B.MTM_BOOK_POPULATION, SUM(B.USD_NOTIONAL) AS USD_NOTIONAL, SUM(B.USD_PV01) AS USD_PV01 FROM ( select a.COB_DATE, A.ACCOUNT, a.CURRENCY_MAPPING, a.CURRENCY_OF_MEASURE, a.BOOK, a.BANK_FLAG, a.LIQUIDITY_SECTYPE, a.LIQUIDITY_SUB_SECTYPE, a.MTM_BOOK_POPULATION, sum(coalesce(CASE WHEN book in('SWPIN','TDET6', 'TAIRR', 'TAEMR', 'TEEMR', 'HKFAP', 'TTIRR', 'HKFAM', 'TKFVS', 'HKFAS', 'TBAGR') THEN -usd_notional WHEN (book in('CALLT', 'CALTB', 'LCALT', 'LCATB')) THEN usd_MARKET_VALUE else usd_notional END, 0)) as USD_NOTIONAL, SUM (USD_IR_UNIFIED_PV01) AS USD_PV01 from cdwuser.U_DM_TREASURY a where COB_DATE IN ('2018-02-28', '2018-02-27', '2018-02-27', '2018-02-26', '2018-02-23', '2018-02-22', '2018-02-27', '2018-01-31', '2017-12-29', '2017-11-30') and CCC_DIVISION = 'TREASURY CAPITAL MARKETS' and CCC_BUSINESS_AREA = 'LIQUIDITY RESERVE1' AND CCC_HIERARCHY_LEVEL10 <> ('INELIGIBLE SEC POOL') AND CCC_HIERARCHY_LEVEL10 NOT LIKE ('%INELIG%') and (mtm_book_population = 'MTM BOOKS' or BOOK = 'TSTOL') GROUP BY a.COB_DATE, A.ACCOUNT, a.CURRENCY_MAPPING, a.CURRENCY_OF_MEASURE, a.BOOK, a.BANK_FLAG, a.LIQUIDITY_SECTYPE, a.LIQUIDITY_SUB_SECTYPE, a.MTM_BOOK_POPULATION UNION ALL select a.COB_DATE, A.ACCOUNT, a.CURRENCY_MAPPING, a.CURRENCY_OF_MEASURE, a.BOOK, a.BANK_FLAG, a.LIQUIDITY_SECTYPE, a.LIQUIDITY_SUB_SECTYPE, a.MTM_BOOK_POPULATION, sum(coalesce(CASE WHEN book in('SWPIN','TDET6', 'TAIRR', 'TAEMR', 'TEEMR', 'HKFAP', 'TTIRR', 'HKFAM', 'TKFVS', 'HKFAS', 'TBAGR') THEN -usd_notional WHEN (book in('CALLT', 'CALTB', 'LCALT', 'LCATB')) THEN usd_MARKET_VALUE else usd_notional END, 0)) as USD_NOTIONAL, SUM (USD_IR_UNIFIED_PV01) AS USD_PV01 from cdwuser.U_DM_TREASURY a where COB_DATE IN ('2018-02-28', '2018-02-27', '2018-02-27', '2018-02-26', '2018-02-23', '2018-02-22', '2018-02-27', '2018-01-31', '2017-12-29', '2017-11-30') and CCC_DIVISION = 'OVERHEAD INTEREST' and CCC_PRODUCT_LINE='MSSB TREASURY LIQUIDITY' and PRODUCT_TYPE_CODE='REPO' AND CCC_HIERARCHY_LEVEL10 <> ('INELIGIBLE SEC POOL') AND CCC_HIERARCHY_LEVEL10 NOT LIKE ('%INELIG%') and (mtm_book_population = 'MTM BOOKS' or BOOK = 'TSTOL') GROUP BY a.COB_DATE, A.ACCOUNT, a.CURRENCY_MAPPING, a.CURRENCY_OF_MEASURE, a.BOOK, a.BANK_FLAG, a.LIQUIDITY_SECTYPE, a.LIQUIDITY_SUB_SECTYPE, a.MTM_BOOK_POPULATION UNION ALL select a.COB_DATE, A.ACCOUNT, a.CURRENCY_MAPPING, a.CURRENCY_OF_MEASURE, a.BOOK, a.BANK_FLAG, a.LIQUIDITY_SECTYPE, a.LIQUIDITY_SUB_SECTYPE, a.MTM_BOOK_POPULATION, sum(coalesce(CASE WHEN book in('SWPIN','TDET6', 'TAIRR', 'TAEMR', 'TEEMR', 'HKFAP', 'TTIRR', 'HKFAM', 'TKFVS', 'HKFAS', 'TBAGR') THEN -usd_notional WHEN (book in('CALLT', 'CALTB', 'LCALT', 'LCATB')) THEN usd_MARKET_VALUE else usd_notional END, 0)) as USD_NOTIONAL, SUM (USD_IR_UNIFIED_PV01) AS USD_PV01 from cdwuser.U_DM_TREASURY a where COB_DATE IN ('2018-02-28', '2018-02-27', '2018-02-27', '2018-02-26', '2018-02-23', '2018-02-22', '2018-02-27', '2018-01-31', '2017-12-29', '2017-11-30') and CCC_DIVISION = 'TREASURY CAPITAL MARKETS' and CCC_BUSINESS_AREA = 'LIQUIDITY RESERVE1' and liquidity_sectype = 'Defunding' and (mtm_book_population = 'MTM BOOKS' or BOOK = 'TSTOL') GROUP BY a.COB_DATE, A.ACCOUNT, a.CURRENCY_MAPPING, a.CURRENCY_OF_MEASURE, a.BOOK, a.BANK_FLAG, a.LIQUIDITY_SECTYPE, a.LIQUIDITY_SUB_SECTYPE, a.MTM_BOOK_POPULATION) B GROUP BY b.COB_DATE, b.ACCOUNT, B.BANK_FLAG, B.BOOK, B.CURRENCY_MAPPING, B.CURRENCY_OF_MEASURE, B.LIQUIDITY_SECTYPE, B.LIQUIDITY_SUB_SECTYPE, B.MTM_BOOK_POPULATION