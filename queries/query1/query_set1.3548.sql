WITH rawTable AS ( SELECT i.CCC_STRATEGY, I.ACCOUNT, I.CURRENCY_OF_POSITION ,i.COB_DATE ,i.BASEL_III_GLOBAL_BTI ,i.VERTICAL_SYSTEM ,i.BOOK ,i.CCC_BUSINESS_AREA ,I.CCC_TAPS_COMPANY ,i.CCC_DIVISION ,I.CCC_BANKING_TRADING ,i.ccc_product_line ,i.PRODUCT_TYPE_NAME ,i.PRODUCT_TYPE_CODE ,i.CURRENCY_OF_MEASURE ,i.PRODUCT_HIERARCHY_LEVEL7 ,CASE WHEN ( i.VERTICAL_SYSTEM LIKE '%C1%' AND i.BOOK IN ('TDEBT', 'TDET2', 'TDET5', 'TDET7', 'TDET8','TDCLH') ) THEN 0 ELSE sum(i.USD_IR_UNIFIED_PV01) END AS USD_IR_UNIFIED_PV01 ,term_of_measure ,sum(i.USD_MARKET_VALUE) AS USD_MARKET_VALUE ,sum(i.USD_NOTIONAL) AS USD_notional ,sum(i.usd_convx) as USD_CONVX ,sum(CASE WHEN i.PRODUCT_TYPE_CODE IN ('BONDIL', 'ETF', 'FX', 'LOC', 'OPTION', 'ZBOND') THEN usd_market_value ELSE usd_notional END) AS nontial_2 FROM DWUSER.u_exp_msr i where COB_DATE in ('2018-02-28')      and BASEL_III_GLOBAL_BTI <> 'TRADING' AND i.CCC_TAPS_COMPANY NOT IN ('1633', '6635') AND USD_IR_UNIFIED_PV01 IS NOT NULL AND USD_IR_UNIFIED_PV01 <> 0 AND ccc_banking_trading = 'BANKING' AND ccc_taps_company NOT IN ('1633', '6635') AND ccc_business_area NOT IN ('LIQUID FLOW RATES', 'MUNICIPAL SECURITIES', 'OLYMPUS', 'SECURITIZED PRODUCTS GRP') AND ccc_strategy NOT IN ('CPM FUNDING','XVA CREDIT', 'MS CVA MNE - DERIVATIVES', 'MS CVA MPE - DERIVATIVES','XVA FUNDING') AND product_type_code not in ('FVA','CVA') AND ((CCC_STRATEGY <> 'STRUCTURED N' OR  BOOK IN ('TSYCSNLN','CALTB','LCATB','CALFB','MSF_CALLABLES_BRM','NY_CALLABLES_BRM','TCM_MSF_CALL_BRM'))  AND (CCC_DIVISION NOT IN ('FIC DVA', 'FID DVA') OR CCC_BOOK_DETAIL NOT LIKE '%FRN%')) AND (ccc_division NOT IN ('INSTITUTIONAL EQUITY DIVISION') OR account NOT IN ('077002SS3', '077002SS', '0770001V9', '0770001V', '074008T03', '074008T0', '072006G45', '072006FS3', '072006G4', '072006FS', '072005UD1', '072005UD', '072004X82', '072004X8', '072000ET5', '072000ET', '071004EY7', '071004EY', '07800A971', '07800A97', '07700AGS8', '077000BB2', '07700NFD', '07700AGR', '07700AGG4', '07700AGG', '07700AGR0' , '07700AG3', '07700AGP4', '07700NFE2', '07700AGS', '07700NFE', '077000BB', '07700AGH', '07700AGP', '07700AGJ8', '07700AGJ', '07700AG58', '07700AG41', '07700AG33', '07700AG5', '07700AG4', '07700A1Y1', '07700A1Y', '07700NFD4', '07700AGH2', '07400XMD7', '07400XMD', '07400XM54', '07400XM5', '07400XK64', '07400XK07', '07400XK6', '07400XK0' , '07200CT89', '07200XA4', '07200CVG', '07200XA42', '07200CT8', '07200NFC1', '07200CVG8', '07200CTT', '07200CA89', '07200BUB', '07200CTT3', '07200BUB2', '07200NFC', '07200CA8', '07100CXB')) GROUP BY i.ccc_strategy, I.ACCOUNT, I.CURRENCY_OF_POSITION, I.USD_MARKET_VALUE ,term_of_measure ,i.COB_DATE ,i.BASEL_III_GLOBAL_BTI ,i.BOOK ,i.VERTICAL_SYSTEM ,i.CCC_BUSINESS_AREA ,i.CCC_DIVISION ,I.CCC_TAPS_COMPANY ,i.ccc_product_line ,i.PRODUCT_TYPE_CODE ,i.PRODUCT_TYPE_NAME ,i.CURRENCY_OF_MEASURE ,i.PRODUCT_HIERARCHY_LEVEL7 ,i.currency_of_position ,I.CCC_BANKING_TRADING ) , WEIGHT AS ( SELECT A.*, CASE WHEN TERM_OF_MEASURE/365 <= 0.25 THEN 0.25 ELSE TERM_OF_MEASURE/365 END AS TERM_OF_MEASURE_WEIGHT FROM rawtable A  ) , NEWWEIGHT AS ( SELECT A.*, CASE WHEN TERM_OF_MEASURE_WEIGHT >= 30 THEN 30  WHEN TERM_OF_MEASURE_WEIGHT >= 20 THEN 20 WHEN TERM_OF_MEASURE_WEIGHT >= 15 THEN 15  WHEN TERM_OF_MEASURE_WEIGHT >= 10 THEN 10  WHEN TERM_OF_MEASURE_WEIGHT >= 7 THEN 7 WHEN TERM_OF_MEASURE_WEIGHT >= 5 THEN 5 WHEN TERM_OF_MEASURE_WEIGHT >= 3 THEN 3 WHEN TERM_OF_MEASURE_WEIGHT >= 2 THEN 2 WHEN TERM_OF_MEASURE_WEIGHT >= 1 THEN 1  WHEN TERM_OF_MEASURE_WEIGHT >= 0.5 THEN 0.5  ELSE 0.25 END AS LOW_BUCKET ,CASE  WHEN TERM_OF_MEASURE_WEIGHT < 0.25 THEN 0.25 WHEN TERM_OF_MEASURE_WEIGHT < 0.5 THEN 0.5  WHEN TERM_OF_MEASURE_WEIGHT < 1 THEN 1 WHEN TERM_OF_MEASURE_WEIGHT < 2 THEN 2 WHEN TERM_OF_MEASURE_WEIGHT < 3 THEN 3 WHEN TERM_OF_MEASURE_WEIGHT < 5 THEN 5 WHEN TERM_OF_MEASURE_WEIGHT < 7 THEN 7  WHEN TERM_OF_MEASURE_WEIGHT < 10 THEN 10  WHEN TERM_OF_MEASURE_WEIGHT < 15 THEN 15 WHEN TERM_OF_MEASURE_WEIGHT < 20 THEN 20  WHEN TERM_OF_MEASURE_WEIGHT < 30 THEN 30 ELSE 30 END AS HIGH_BUCKET FROM WEIGHT A ) ,  FINAL_WEIGHT AS ( SELECT A.*, (HIGH_BUCKET - LOW_BUCKET) AS BUCKET_WIDTH ,CASE WHEN TERM_OF_MEASURE_WEIGHT <=0.25 THEN 1 WHEN TERM_OF_MEASURE_WEIGHT >=30 THEN 0 ELSE 1-((TERM_OF_MEASURE_WEIGHT - LOW_BUCKET)/(HIGH_BUCKET - LOW_BUCKET)) END AS LOW_BUCKET_WEIGHT ,CASE WHEN TERM_OF_MEASURE_WEIGHT <=0.25 THEN 0 WHEN TERM_OF_MEASURE_WEIGHT >=30 THEN 1 ELSE ((TERM_OF_MEASURE_WEIGHT - LOW_BUCKET)/(HIGH_BUCKET - LOW_BUCKET)) END AS HIGH_BUCKET_WEIGHT FROM NEWWEIGHT A  ) , RAWTABLE_WEIGHTED as ( SELECT i.CCC_STRATEGY ,i.COB_DATE ,i.BASEL_III_GLOBAL_BTI ,i.VERTICAL_SYSTEM ,i.BOOK ,i.CCC_BUSINESS_AREA ,i.CCC_DIVISION ,i.ccc_product_line ,i.PRODUCT_TYPE_NAME ,i.PRODUCT_TYPE_CODE ,i.CURRENCY_OF_MEASURE ,i.PRODUCT_HIERARCHY_LEVEL7 ,CASE WHEN ( i.VERTICAL_SYSTEM LIKE '%C1%' AND i.BOOK IN ('TDEBT', 'TDET2', 'TDET5', 'TDET7', 'TDET8','TDCLH') ) THEN 0 ELSE sum(i.USD_IR_UNIFIED_PV01*LOW_BUCKET_WEIGHT) END AS USD_IR_UNIFIED_PV01 ,LOW_BUCKET AS term_new ,sum(i.USD_MARKET_VALUE*LOW_BUCKET_WEIGHT) AS market_value ,sum(i.USD_NOTIONAL*LOW_BUCKET_WEIGHT) AS notional ,sum(i.usd_convx*LOW_BUCKET_WEIGHT) as gamma ,sum(CASE WHEN i.PRODUCT_TYPE_CODE IN ('BONDIL', 'ETF', 'FX', 'LOC', 'OPTION', 'ZBOND') THEN usd_market_value*LOW_BUCKET_WEIGHT ELSE usd_notional*LOW_BUCKET_WEIGHT END) AS nontial_2 FROM FINAL_WEIGHT i where COB_DATE in ('2018-02-28')      and BASEL_III_GLOBAL_BTI <> 'TRADING' AND i.CCC_TAPS_COMPANY NOT IN ('1633', '6635') AND USD_IR_UNIFIED_PV01 IS NOT NULL AND USD_IR_UNIFIED_PV01 <> 0 AND ccc_banking_trading = 'BANKING' AND ccc_taps_company NOT IN ('1633', '6635') AND ccc_business_area NOT IN ('LIQUID FLOW RATES', 'MUNICIPAL SECURITIES', 'OLYMPUS', 'SECURITIZED PRODUCTS GRP') AND ccc_strategy NOT IN ('CPM FUNDING','XVA CREDIT', 'MS CVA MNE - DERIVATIVES', 'MS CVA MPE - DERIVATIVES','XVA FUNDING') AND product_type_code not in ('FVA','CVA') AND (ccc_division NOT IN ('INSTITUTIONAL EQUITY DIVISION') OR account NOT IN ('077002SS3', '077002SS', '0770001V9', '0770001V', '074008T03', '074008T0', '072006G45', '072006FS3', '072006G4', '072006FS', '072005UD1', '072005UD', '072004X82', '072004X8', '072000ET5', '072000ET', '071004EY7', '071004EY', '07800A971', '07800A97', '07700AGS8', '077000BB2', '07700NFD', '07700AGR', '07700AGG4', '07700AGG', '07700AGR0' , '07700AG3', '07700AGP4', '07700NFE2', '07700AGS', '07700NFE', '077000BB', '07700AGH', '07700AGP', '07700AGJ8', '07700AGJ', '07700AG58', '07700AG41', '07700AG33', '07700AG5', '07700AG4', '07700A1Y1', '07700A1Y', '07700NFD4', '07700AGH2', '07400XMD7', '07400XMD', '07400XM54', '07400XM5', '07400XK64', '07400XK07', '07400XK6', '07400XK0' , '07200CT89', '07200XA4', '07200CVG', '07200XA42', '07200CT8', '07200NFC1', '07200CVG8', '07200CTT', '07200CA89', '07200BUB', '07200CTT3', '07200BUB2', '07200NFC', '07200CA8', '07100CXB')) GROUP BY i.ccc_strategy ,LOW_BUCKET ,i.COB_DATE ,i.BASEL_III_GLOBAL_BTI ,i.BOOK ,i.VERTICAL_SYSTEM ,i.CCC_BUSINESS_AREA ,i.CCC_DIVISION ,i.ccc_product_line ,i.PRODUCT_TYPE_CODE ,i.PRODUCT_TYPE_NAME ,i.CURRENCY_OF_MEASURE ,i.PRODUCT_HIERARCHY_LEVEL7 ,i.currency_of_position  UNION ALL SELECT i.CCC_STRATEGY ,i.COB_DATE ,i.BASEL_III_GLOBAL_BTI ,i.VERTICAL_SYSTEM ,i.BOOK ,i.CCC_BUSINESS_AREA ,i.CCC_DIVISION ,i.ccc_product_line ,i.PRODUCT_TYPE_NAME ,i.PRODUCT_TYPE_CODE ,i.CURRENCY_OF_MEASURE ,i.PRODUCT_HIERARCHY_LEVEL7 ,CASE WHEN ( i.VERTICAL_SYSTEM LIKE '%C1%' AND i.BOOK IN ('TDEBT', 'TDET2', 'TDET5', 'TDET7', 'TDET8','TDCLH') ) THEN 0 ELSE sum(i.USD_IR_UNIFIED_PV01*HIGH_BUCKET_WEIGHT) END AS USD_IR_UNIFIED_PV01 ,HIGH_BUCKET AS term_new ,sum(i.USD_MARKET_VALUE*HIGH_BUCKET_WEIGHT) AS market_value ,sum(i.USD_NOTIONAL*HIGH_BUCKET_WEIGHT) AS notional ,sum(i.usd_convx*HIGH_BUCKET_WEIGHT) as gamma ,sum(CASE WHEN i.PRODUCT_TYPE_CODE IN ('BONDIL', 'ETF', 'FX', 'LOC', 'OPTION', 'ZBOND') THEN usd_market_value*HIGH_BUCKET_WEIGHT ELSE usd_notional*HIGH_BUCKET_WEIGHT END) AS nontial_2 FROM FINAL_WEIGHT i where COB_DATE in ('2018-02-28')      and BASEL_III_GLOBAL_BTI <> 'TRADING' AND i.CCC_TAPS_COMPANY NOT IN ('1633', '6635') AND USD_IR_UNIFIED_PV01 IS NOT NULL AND USD_IR_UNIFIED_PV01 <> 0 AND ccc_banking_trading = 'BANKING' AND ccc_taps_company NOT IN ('1633', '6635') AND ccc_business_area NOT IN ('LIQUID FLOW RATES', 'MUNICIPAL SECURITIES', 'OLYMPUS', 'SECURITIZED PRODUCTS GRP') AND ccc_strategy NOT IN ('CPM FUNDING','XVA CREDIT', 'MS CVA MNE - DERIVATIVES', 'MS CVA MPE - DERIVATIVES','XVA FUNDING') AND product_type_code not in ('FVA','CVA') AND (ccc_division NOT IN ('INSTITUTIONAL EQUITY DIVISION') OR account NOT IN ('077002SS3', '077002SS', '0770001V9', '0770001V', '074008T03', '074008T0', '072006G45', '072006FS3', '072006G4', '072006FS', '072005UD1', '072005UD', '072004X82', '072004X8', '072000ET5', '072000ET', '071004EY7', '071004EY', '07800A971', '07800A97', '07700AGS8', '077000BB2', '07700NFD', '07700AGR', '07700AGG4', '07700AGG', '07700AGR0' , '07700AG3', '07700AGP4', '07700NFE2', '07700AGS', '07700NFE', '077000BB', '07700AGH', '07700AGP', '07700AGJ8', '07700AGJ', '07700AG58', '07700AG41', '07700AG33', '07700AG5', '07700AG4', '07700A1Y1', '07700A1Y', '07700NFD4', '07700AGH2', '07400XMD7', '07400XMD', '07400XM54', '07400XM5', '07400XK64', '07400XK07', '07400XK6', '07400XK0' , '07200CT89', '07200XA4', '07200CVG', '07200XA42', '07200CT8', '07200NFC1', '07200CVG8', '07200CTT', '07200CA89', '07200BUB', '07200CTT3', '07200BUB2', '07200NFC', '07200CA8', '07100CXB')) GROUP BY i.ccc_strategy ,HIGH_BUCKET ,i.COB_DATE ,i.BASEL_III_GLOBAL_BTI ,i.BOOK ,i.VERTICAL_SYSTEM ,i.CCC_BUSINESS_AREA ,i.CCC_DIVISION ,i.ccc_product_line ,i.PRODUCT_TYPE_CODE ,i.PRODUCT_TYPE_NAME ,i.CURRENCY_OF_MEASURE ,i.PRODUCT_HIERARCHY_LEVEL7 ,i.currency_of_position ) select e.*, case when ccc_business_area in ('JV ATTRIBUTED BANKING') and category in ('Loans Account') then 'Other Short Term Assets' when e.category in ('Cash Equivalents') then 'Other Short Term Assets' when e.category in ('MSAIL Assets') then 'Other Short Term Assets' when e.category in ('Non-Bank AFS Portfolio') then 'Investment Portfolio' when e.category in ('Other Securities') then 'Other Short Term Assets' when e.category in ('Other Assets') then 'Other Short Term Assets' when e.category in ('Treasury FX hedges') then 'Hedges Against: Long Term Debt' when e.category in ('Long Term Funding - Hedges') then 'Hedges Against: Long Term Debt' when e.category in ('Long Term Funding - Plain Vanilla') then 'Long - Term Debt' when e.category in ('Structured Notes Accrual Callable') then 'Long - Term Debt' when e.category in ('Structured Notes Accrual FID') then 'Long - Term Debt' when e.category in ('Structured Notes Accrual IED') then 'Long - Term Debt' when e.category in ('Short Term Funding') then 'Short - Term Debt' when e.category in ('Total Equity') then 'Long - Term Debt' when e.category in ('Asia Deposits') then 'Retail Deposits:Interest Bearing NMD (Foreign)' when e.category in ('Other') then 'Other Liabilities' when e.category in ('Loans Account') then 'Loans/Leases: Other Loans and Leases' else 'NULL' end as Mapped_Group from (select d.* ,CASE WHEN LEVELD IS NOT NULL THEN LEVELD WHEN LEVELC IS NOT NULL THEN LEVELC WHEN LEVELB IS NOT NULL THEN LEVELB WHEN LEVELA IS NOT NULL THEN LEVELA END AS category from (SELECT a.* ,CASE WHEN a.product_type_code IN ('WAREHOUSE', 'BANKDEBT', 'LOAN', 'SVC_RIGHT') THEN 'Loans Account' WHEN a.ccc_business_area IN ('INTERNATIONAL WEALTH MGMT') THEN 'Asia Deposits' WHEN a.levelb IN ('Assets', 'Liabilities', 'Total Equity') THEN 'Treasury' ELSE 'Other' END AS levela FROM ( SELECT b.* ,CASE WHEN b.levelc IN ('Non-Cash Assets', 'Cash Equivalents', 'Other Assets', 'Treasury FX hedges') THEN 'Assets' WHEN b.levelc IN ('Short Term Funding', 'Long Term Funding - Structured', 'Long Term Funding - Plain Vanilla and Hedges') THEN 'Liabilities' WHEN b.Book IN ('TRPFD', 'PRFEQ') THEN 'Total Equity' END AS levelb FROM ( SELECT c.* ,CASE WHEN c.leveld IN ('Non-Bank AFS Portfolio', 'MSAIL Assets', 'Other Securities') THEN 'Non-Cash Assets' WHEN c.leveld IN ('Structured Notes Accrual FID', 'Structured Notes Accrual IED', 'Structured Notes Accrual Callable') THEN 'Long Term Funding - Structured' WHEN c.leveld IN ('Long Term Funding - Plain Vanilla', 'Long Term Funding - Hedges') THEN 'Long Term Funding - Plain Vanilla and Hedges' WHEN c.BOOK IN ('CT0101LIQ1', 'EULT', 'NYDI', 'NYTU', 'RPOAF', 'TSTHK', 'TSTLN', 'TSTNY', 'TSTTK', 'EUG7', 'EUIP', 'INDMF', 'LIABB', 'NYCO', 'NYN2', 'RWILX', 'RWUIP', 'TMSSC', 'TNSAP', 'TNSLN', 'TNSNY', 'TSBR1', 'TSTTO', 'EUPB', 'EUUK', 'MSBKD', 'RWIBK', 'RWPO1', 'RWPO3', 'RWUPB', 'TBSAP', 'TBSHK', 'TBSLN', 'TBSSG', 'TDPSD', 'TSAGD') THEN 'Cash Equivalents' WHEN c.BOOK IN ('NYN1', 'RPOKE', 'TNYSL', 'RWBIC', 'TBICD') THEN 'Other Assets' WHEN c.book IN ('CT0101SPT', 'CT0101SPT6262', 'CT0201SPT', 'CT0201SPT2', 'CT0302SPT', 'CT1633SPT', 'GLFX1', 'HNKRW', 'ROBIC', 'RVKRW', 'TOMCP', 'TYBRL', 'CT0101FWD', 'CT0101FWDP', 'TYSJV') THEN 'Treasury FX hedges' WHEN c.BOOK IN ('TBICL', 'CT0101SWP', 'CT0101SWP-AP', 'CT0101SWP-LN', 'CT0101SWP-TK', 'CT0101XE', 'CT0302SWP', 'CT0302XE', 'CT0362SWP', 'CT0870SWP', 'KRSWP', 'TICIP', 'TICMS', 'TOMFS', 'TSGFX', 'EUGS') THEN 'Short Term Funding' END AS levelc FROM ( SELECT d.* ,CASE WHEN d.book IN ('TSHTM', 'TSTPM') THEN 'Non-Bank AFS Portfolio' WHEN d.book IN ('TAPRZ', 'TAPTY', 'TAPTZ', 'TAPUY', 'TAPUZ') THEN 'MSAIL Assets' WHEN d.BOOK IN ('CTFTB', 'TSTJY') THEN 'Other Securities' WHEN d.BOOK IN ('CAEMR', 'CALLT', 'CALTB', 'CEEMR', 'COMSN', 'CSCPR', 'CTHKR', 'CTNUR', 'CTTKR', 'HKFAM', 'HKFAP', 'HKFAS', 'TAEMR', 'TAIRR', 'TBAGR', 'TEEMR', 'TKFVL', 'TKFVS', 'TSYFE', 'TTIRR') OR d.ccc_division IN ('FIC DVA', 'FID DVA') THEN 'Structured Notes Accrual FID' WHEN d.BOOK IN ('LN ELNLT', 'LN_ELNLT', 'MS DVA STRUCTURED NO', 'NY_ELNLT', 'TCM_TNY') THEN 'Structured Notes Accrual IED' WHEN d.BOOK IN ('TSYCSNLN') THEN 'Structured Notes Accrual Callable' WHEN d.BOOK IN ('TDEBT', 'TDET7', 'TDET8', 'TDET5', 'TDET2', 'TDET6', 'TDET3','TDCLH') THEN 'Long Term Funding - Plain Vanilla' WHEN d.BOOK IN ('AEOCT', 'SUBTR', 'SWPTR', 'SUBIN', 'SUBLH', 'SWPIN', 'SWPLH', 'TST31', 'TST3F', 'TSTCH', 'TSTEU', 'TSTGB', 'TSTOH', 'TSTOL', 'TSTON', 'TSTSB', 'TAPOZ', 'AEONE', 'AEOST') THEN 'Long Term Funding - Hedges' END AS leveld FROM rawTable_weighted d ) c ) b ) a ) d ) e