SELECT a.COB_DATE, CASE WHEN a.TERM_NEW <= 1 THEN '<=1Y' ELSE '>1Y' END AS term_bucket, CASE WHEN a.CURRENCY_OF_MEASURE IN ('BRX','BR1') THEN 'BRL' WHEN a.CURRENCY_OF_MEASURE IN ('KRX') THEN 'KRW' WHEN a.CURRENCY_OF_MEASURE IN ('RU1','RBX') THEN 'RUB' WHEN a.CURRENCY_OF_MEASURE IN ('CNH') THEN 'CNY' ELSE a.CURRENCY_OF_MEASURE END AS currency, CASE WHEN (a.CURRENCY_OF_MEASURE IN ('EUR','CHF','GBP','SEK','NOK','DKK','JPY','AUD','NZD','CAD','USD') OR (substr(a.CURRENCY_OF_MEASURE,1,3) IN ('EUR','CHF','GBP','SEK','NOK','DKK','JPY','AUD','NZD','CAD','USD') AND substr(a.CURRENCY_OF_MEASURE,4,3) IN ('EUR','CHF','GBP','SEK','NOK','DKK','JPY','AUD','NZD','CAD','USD'))) THEN 'MAJOR' ELSE 'EM' END AS MAJOR_EM, SUM (a.USD_FX_KAPPA) AS Vega, CASE WHEN (a.CCC_BUSINESS_AREA IN ( 'CPM TRADING (MPE)','CPM', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA' WHEN (a.CCC_DIVISION IN ('FID DVA', 'FIC DVA') OR a.CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA' WHEN a.CCC_DIVISION = 'COMMODITIES' THEN 'FIXED INCOME DIVISION' ELSE a.CCC_DIVISION END AS CCC_DIVISION, a.IS_UK_GROUP, CASE WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA' ELSE 'OTHER' END AS CCC_PL_REPORTING_REGION, CASE WHEN a.CCC_DIVISION = 'COMMODITIES' THEN 'COMMODITIES' WHEN (a.CCC_DIVISION='INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'OTHERS' WHEN (a.CCC_DIVISION='FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','FXEM MACRO TRADING','EM CREDIT TRADING','LIQUID FLOW RATES','STRUCTURED RATES','SECURITIZED PRODUCTS GRP','COMMODITIES')) THEN 'OTHERS FID' ELSE a.CCC_BUSINESS_AREA END AS CCC_BUSINESS_AREA, CASE WHEN a.CCC_TAPS_COMPANY='0319' THEN 'MSIM' WHEN a.CCC_TAPS_COMPANY IN ('4663','7281','5274','5254','8179','7280','6262','1311','8292','0721','4391','0517') THEN 'MSBIL' WHEN a.CCC_TAPS_COMPANY='0302' THEN 'MSIP' WHEN a.IS_UK_GROUP = 'Y' THEN 'OtherUKG' ELSE 'NOTUKG' END AS entityclassification FROM cdwuser.U_DM_FX a WHERE a.cob_date IN ('2018-02-28','2018-02-21') AND a.USD_FX_KAPPA IS NOT NULL GROUP BY a.COB_DATE, CASE WHEN a.TERM_NEW <= 1 THEN '<=1Y' ELSE '>1Y' END, CASE WHEN a.CURRENCY_OF_MEASURE IN ('BRX','BR1') THEN 'BRL' WHEN a.CURRENCY_OF_MEASURE IN ('KRX') THEN 'KRW' WHEN a.CURRENCY_OF_MEASURE IN ('RU1','RBX') THEN 'RUB' WHEN a.CURRENCY_OF_MEASURE IN ('CNH') THEN 'CNY' ELSE a.CURRENCY_OF_MEASURE END, CASE WHEN (a.CURRENCY_OF_MEASURE IN ('EUR','CHF','GBP','SEK','NOK','DKK','JPY','AUD','NZD','CAD','USD') OR (substr(a.CURRENCY_OF_MEASURE,1,3) IN ('EUR','CHF','GBP','SEK','NOK','DKK','JPY','AUD','NZD','CAD','USD') AND substr(a.CURRENCY_OF_MEASURE,4,3) IN ('EUR','CHF','GBP','SEK','NOK','DKK','JPY','AUD','NZD','CAD','USD'))) THEN 'MAJOR' ELSE 'EM' END, CASE WHEN (a.CCC_BUSINESS_AREA IN ( 'CPM TRADING (MPE)','CPM', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA' WHEN (a.CCC_DIVISION IN ('FID DVA', 'FIC DVA') OR a.CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA' WHEN a.CCC_DIVISION = 'COMMODITIES' THEN 'FIXED INCOME DIVISION' ELSE a.CCC_DIVISION END, a.IS_UK_GROUP, CASE WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA' ELSE 'OTHER' END, CASE WHEN a.CCC_DIVISION = 'COMMODITIES' THEN 'COMMODITIES' WHEN (a.CCC_DIVISION='INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'OTHERS' WHEN (a.CCC_DIVISION='FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','FXEM MACRO TRADING','EM CREDIT TRADING','LIQUID FLOW RATES','STRUCTURED RATES','SECURITIZED PRODUCTS GRP','COMMODITIES')) THEN 'OTHERS FID' ELSE a.CCC_BUSINESS_AREA END, CASE WHEN a.CCC_TAPS_COMPANY='0319' THEN 'MSIM' WHEN a.CCC_TAPS_COMPANY IN ('4663','7281','5274','5254','8179','7280','6262','1311','8292','0721','4391','0517') THEN 'MSBIL' WHEN a.CCC_TAPS_COMPANY='0302' THEN 'MSIP' WHEN a.IS_UK_GROUP = 'Y' THEN 'OtherUKG' ELSE 'NOTUKG' END