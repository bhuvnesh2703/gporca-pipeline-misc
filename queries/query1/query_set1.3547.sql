WITH rawTable AS (  SELECT     i.COB_DATE,     i.BASEL_III_GLOBAL_BTI,     i.VERTICAL_SYSTEM,     i.BOOK,     i.CCC_BUSINESS_AREA,     I.CCC_BANKING_TRADING,     i.CCC_DIVISION,     i.ccc_product_line,     i.PRODUCT_TYPE_NAME,     i.PRODUCT_TYPE_CODE,     I.CURRENCY_OF_POSITION,     i.CURRENCY_OF_MEASURE,     i.PRODUCT_HIERARCHY_LEVEL7,     i.ACCOUNT,     i.TICKET,     I.CCC_STRATEGY,     I.CCC_TAPS_COMPANY,     SUM (i.USD_IR_UNIFIED_PV01) AS USD_IR_UNIFIED_PV01,     term_of_measure FROM DWUSER.u_exp_msr i  where COB_DATE in ('2018-02-28')     and  BASEL_III_GLOBAL_BTI <> 'TRADING' AND     i.CCC_TAPS_COMPANY NOT IN ('1633', '6635') AND     USD_IR_UNIFIED_PV01 IS NOT NULL AND     USD_IR_UNIFIED_PV01 <> 0 AND     CCC_BUSINESS_AREA NOT IN ('MUNICIPAL SECURITIES', 'SECURITIZED PRODUCTS GRP', 'LIQUID FLOW RATES', 'OLYMPUS') AND     ccc_strategy NOT IN ('CPM FUNDING','XVA CREDIT', 'MS CVA MNE - DERIVATIVES', 'MS CVA MPE - DERIVATIVES','XVA FUNDING') AND     ccc_banking_trading = 'BANKING' AND     i.VERTICAL_SYSTEM LIKE '%C1%' AND     i.BOOK IN ('TDEBT', 'TDET2', 'TDET5', 'TDET7', 'TDET8','TDCLH') AND product_type_code not in ('FVA','CVA') AND      ((I.CCC_STRATEGY <> 'STRUCTURED N' OR       BOOK IN ('TSYCSNLN','CALTB','LCATB','CALFB','MSF_CALLABLES_BRM','NY_CALLABLES_BRM','TCM_MSF_CALL_BRM'))      AND (CCC_DIVISION NOT IN ('FIC DVA', 'FID DVA') OR CCC_BOOK_DETAIL NOT LIKE '%FRN%'))     AND (ccc_division NOT IN ('INSTITUTIONAL EQUITY DIVISION') OR      account NOT IN ('077002SS3', '077002SS', '0770001V9', '0770001V', '074008T03', '074008T0', '072006G45', '072006FS3', '072006G4',                           '072006FS', '072005UD1', '072005UD', '072004X82', '072004X8', '072000ET5', '072000ET', '071004EY7', '071004EY',                           '07800A971', '07800A97', '07700AGS8', '077000BB2', '07700NFD', '07700AGR', '07700AGG4', '07700AGG', '07700AGR0'          , '07700AG3', '07700AGP4', '07700NFE2', '07700AGS', '07700NFE', '077000BB', '07700AGH', '07700AGP', '07700AGJ8', '07700AGJ',                           '07700AG58', '07700AG41', '07700AG33', '07700AG5', '07700AG4', '07700A1Y1', '07700A1Y', '07700NFD4',                           '07700AGH2', '07400XMD7', '07400XMD', '07400XM54', '07400XM5', '07400XK64', '07400XK07', '07400XK6', '07400XK0'          , '07200CT89', '07200XA4', '07200CVG', '07200XA42', '07200CT8', '07200NFC1', '07200CVG8', '07200CTT', '07200CA89', '07200BUB',                           '07200CTT3', '07200BUB2', '07200NFC', '07200CA8', '07100CXB')) GROUP BY     term_of_measure,     I.CCC_TAPS_COMPANY,     I.CCC_BANKING_TRADING,     i.COB_DATE,     i.BASEL_III_GLOBAL_BTI,     i.BOOK,       I.CURRENCY_OF_POSITION,     i.VERTICAL_SYSTEM,     i.CCC_BUSINESS_AREA,     i.CCC_DIVISION,     i.ccc_product_line,     I.CCC_STRATEGY,     i.PRODUCT_TYPE_CODE,     i.PRODUCT_TYPE_NAME,     i.CURRENCY_OF_MEASURE,     i.PRODUCT_HIERARCHY_LEVEL7,     i.ACCOUNT,     i.currency_of_position,     i.TICKET  ) , WEIGHT AS  ( SELECT A.*, CASE         WHEN TERM_OF_MEASURE/365 <= 0.25 THEN 0.25         ELSE TERM_OF_MEASURE/365 END AS TERM_OF_MEASURE_WEIGHT FROM rawtable A  ) , NEWWEIGHT AS  ( SELECT A.*, CASE         WHEN TERM_OF_MEASURE_WEIGHT >= 30 THEN 30          WHEN TERM_OF_MEASURE_WEIGHT >= 20 THEN 20         WHEN TERM_OF_MEASURE_WEIGHT >= 15 THEN 15          WHEN TERM_OF_MEASURE_WEIGHT >= 10 THEN 10          WHEN TERM_OF_MEASURE_WEIGHT >= 7 THEN 7         WHEN TERM_OF_MEASURE_WEIGHT >= 5 THEN 5         WHEN TERM_OF_MEASURE_WEIGHT >= 3 THEN 3         WHEN TERM_OF_MEASURE_WEIGHT >= 2 THEN 2         WHEN TERM_OF_MEASURE_WEIGHT >= 1 THEN 1          WHEN TERM_OF_MEASURE_WEIGHT >= 0.5 THEN 0.5          ELSE 0.25 END AS LOW_BUCKET     ,CASE          WHEN TERM_OF_MEASURE_WEIGHT < 0.25 THEN 0.25         WHEN TERM_OF_MEASURE_WEIGHT < 0.5 THEN 0.5          WHEN TERM_OF_MEASURE_WEIGHT < 1 THEN 1         WHEN TERM_OF_MEASURE_WEIGHT < 2 THEN 2         WHEN TERM_OF_MEASURE_WEIGHT < 3 THEN 3         WHEN TERM_OF_MEASURE_WEIGHT < 5 THEN 5         WHEN TERM_OF_MEASURE_WEIGHT < 7 THEN 7          WHEN TERM_OF_MEASURE_WEIGHT < 10 THEN 10          WHEN TERM_OF_MEASURE_WEIGHT < 15 THEN 15         WHEN TERM_OF_MEASURE_WEIGHT < 20 THEN 20          WHEN TERM_OF_MEASURE_WEIGHT < 30 THEN 30         ELSE 30 END AS HIGH_BUCKET         FROM WEIGHT A ) ,  FINAL_WEIGHT AS ( SELECT A.*, (HIGH_BUCKET - LOW_BUCKET) AS BUCKET_WIDTH     ,CASE         WHEN TERM_OF_MEASURE_WEIGHT <=0.25 THEN 1         WHEN TERM_OF_MEASURE_WEIGHT >=30 THEN 0         ELSE 1-((TERM_OF_MEASURE_WEIGHT - LOW_BUCKET)/(HIGH_BUCKET - LOW_BUCKET)) END AS LOW_BUCKET_WEIGHT     ,CASE         WHEN TERM_OF_MEASURE_WEIGHT <=0.25 THEN 0         WHEN TERM_OF_MEASURE_WEIGHT >=30 THEN 1         ELSE ((TERM_OF_MEASURE_WEIGHT - LOW_BUCKET)/(HIGH_BUCKET - LOW_BUCKET)) END AS HIGH_BUCKET_WEIGHT FROM NEWWEIGHT A  ) , RAWTABLE_WEIGHTED as (  SELECT     i.COB_DATE,     i.BASEL_III_GLOBAL_BTI,     i.VERTICAL_SYSTEM,     i.BOOK,     i.CCC_BUSINESS_AREA,     i.CCC_DIVISION,     i.ccc_product_line,     i.PRODUCT_TYPE_NAME,     i.PRODUCT_TYPE_CODE,     i.CURRENCY_OF_MEASURE,     i.PRODUCT_HIERARCHY_LEVEL7,     i.ACCOUNT,     i.TICKET,    LOW_BUCKET AS term_new,      SUM (i.USD_IR_UNIFIED_PV01*LOW_BUCKET_WEIGHT) AS USD_IR_UNIFIED_PV01 FROM FINAL_WEIGHT i  where COB_DATE in ('2018-02-28')   and    BASEL_III_GLOBAL_BTI <> 'TRADING' AND     i.CCC_TAPS_COMPANY NOT IN ('1633', '6635') AND     USD_IR_UNIFIED_PV01 IS NOT NULL AND     USD_IR_UNIFIED_PV01 <> 0 AND     CCC_BUSINESS_AREA NOT IN ('MUNICIPAL SECURITIES', 'SECURITIZED PRODUCTS GRP', 'LIQUID FLOW RATES', 'OLYMPUS') AND     ccc_strategy NOT IN ('CPM FUNDING','XVA CREDIT', 'MS CVA MNE - DERIVATIVES', 'MS CVA MPE - DERIVATIVES','XVA FUNDING') AND     ccc_banking_trading = 'BANKING' AND     i.VERTICAL_SYSTEM LIKE '%C1%' AND     i.BOOK IN ('TDEBT', 'TDET2', 'TDET5', 'TDET7', 'TDET8','TDCLH') AND product_type_code not in ('FVA','CVA') AND     (ccc_division NOT IN ('INSTITUTIONAL EQUITY DIVISION') OR      account NOT IN ('077002SS3', '077002SS', '0770001V9', '0770001V', '074008T03', '074008T0', '072006G45', '072006FS3', '072006G4',                           '072006FS', '072005UD1', '072005UD', '072004X82', '072004X8', '072000ET5', '072000ET', '071004EY7', '071004EY',                           '07800A971', '07800A97', '07700AGS8', '077000BB2', '07700NFD', '07700AGR', '07700AGG4', '07700AGG', '07700AGR0'          , '07700AG3', '07700AGP4', '07700NFE2', '07700AGS', '07700NFE', '077000BB', '07700AGH', '07700AGP', '07700AGJ8', '07700AGJ',                           '07700AG58', '07700AG41', '07700AG33', '07700AG5', '07700AG4', '07700A1Y1', '07700A1Y', '07700NFD4',                           '07700AGH2', '07400XMD7', '07400XMD', '07400XM54', '07400XM5', '07400XK64', '07400XK07', '07400XK6', '07400XK0'          , '07200CT89', '07200XA4', '07200CVG', '07200XA42', '07200CT8', '07200NFC1', '07200CVG8', '07200CTT', '07200CA89', '07200BUB',                           '07200CTT3', '07200BUB2', '07200NFC', '07200CA8', '07100CXB')) GROUP BY     LOW_BUCKET,     i.COB_DATE,     i.BASEL_III_GLOBAL_BTI,     i.BOOK,     i.VERTICAL_SYSTEM,     i.CCC_BUSINESS_AREA,     i.CCC_DIVISION,     i.ccc_product_line,     i.PRODUCT_TYPE_CODE,     i.PRODUCT_TYPE_NAME,     i.CURRENCY_OF_MEASURE,     i.PRODUCT_HIERARCHY_LEVEL7,     i.ACCOUNT,     i.currency_of_position,     i.TICKET  UNION ALL SELECT     i.COB_DATE,     i.BASEL_III_GLOBAL_BTI,     i.VERTICAL_SYSTEM,     i.BOOK,     i.CCC_BUSINESS_AREA,     i.CCC_DIVISION,     i.ccc_product_line,     i.PRODUCT_TYPE_NAME,     i.PRODUCT_TYPE_CODE,     i.CURRENCY_OF_MEASURE,     i.PRODUCT_HIERARCHY_LEVEL7,     i.ACCOUNT,     i.TICKET,    HIGH_BUCKET AS term_new,      SUM (i.USD_IR_UNIFIED_PV01*HIGH_BUCKET_WEIGHT) AS USD_IR_UNIFIED_PV01 FROM FINAL_WEIGHT i  where COB_DATE in ('2018-02-28')   and    BASEL_III_GLOBAL_BTI <> 'TRADING' AND     i.CCC_TAPS_COMPANY NOT IN ('1633', '6635') AND     USD_IR_UNIFIED_PV01 IS NOT NULL AND     USD_IR_UNIFIED_PV01 <> 0 AND     CCC_BUSINESS_AREA NOT IN ('MUNICIPAL SECURITIES', 'SECURITIZED PRODUCTS GRP', 'LIQUID FLOW RATES', 'OLYMPUS') AND     ccc_strategy NOT IN ('CPM FUNDING','XVA CREDIT', 'MS CVA MNE - DERIVATIVES', 'MS CVA MPE - DERIVATIVES','XVA FUNDING') AND     ccc_banking_trading = 'BANKING' AND     i.VERTICAL_SYSTEM LIKE '%C1%' AND     i.BOOK IN ('TDEBT', 'TDET2', 'TDET5', 'TDET7', 'TDET8','TDCLH') AND product_type_code not in ('FVA','CVA') AND     (ccc_division NOT IN ('INSTITUTIONAL EQUITY DIVISION') OR      account NOT IN ('077002SS3', '077002SS', '0770001V9', '0770001V', '074008T03', '074008T0', '072006G45', '072006FS3', '072006G4',                           '072006FS', '072005UD1', '072005UD', '072004X82', '072004X8', '072000ET5', '072000ET', '071004EY7', '071004EY',                           '07800A971', '07800A97', '07700AGS8', '077000BB2', '07700NFD', '07700AGR', '07700AGG4', '07700AGG', '07700AGR0'          , '07700AG3', '07700AGP4', '07700NFE2', '07700AGS', '07700NFE', '077000BB', '07700AGH', '07700AGP', '07700AGJ8', '07700AGJ',                           '07700AG58', '07700AG41', '07700AG33', '07700AG5', '07700AG4', '07700A1Y1', '07700A1Y', '07700NFD4',                           '07700AGH2', '07400XMD7', '07400XMD', '07400XM54', '07400XM5', '07400XK64', '07400XK07', '07400XK6', '07400XK0'          , '07200CT89', '07200XA4', '07200CVG', '07200XA42', '07200CT8', '07200NFC1', '07200CVG8', '07200CTT', '07200CA89', '07200BUB',                           '07200CTT3', '07200BUB2', '07200NFC', '07200CA8', '07100CXB')) GROUP BY     HIGH_BUCKET,     i.COB_DATE,     i.BASEL_III_GLOBAL_BTI,     i.BOOK,     i.VERTICAL_SYSTEM,     i.CCC_BUSINESS_AREA,     i.CCC_DIVISION,     i.ccc_product_line,     i.PRODUCT_TYPE_CODE,     i.PRODUCT_TYPE_NAME,     i.CURRENCY_OF_MEASURE,     i.PRODUCT_HIERARCHY_LEVEL7,     i.ACCOUNT,     i.currency_of_position,     i.TICKET    )  select * from rawtable_weighted