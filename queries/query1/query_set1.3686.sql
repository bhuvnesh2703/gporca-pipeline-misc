SELECT a.COB_DATE, CASE WHEN a.CURRENCY_COMBINED IN ('BHD','QAR','KWD','SAR','AED','OMR','BGN') THEN 'OTHER_PEGGED' ELSE a.CURRENCY_COMBINED END AS Currency, a.MAJOR_EM, CASE WHEN a.term_new < 1 THEN '0-1Y' WHEN a.term_new >=1 AND a.term_new < 5 THEN '1-5Y' ELSE '5Y+' END AS term_bucket, SUM (a.USD_IR_UNIFIED_PV01) AS PV01, CASE WHEN (a.CCC_BUSINESS_AREA IN ( 'CPM TRADING (MPE)','CPM', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA' WHEN (a.CCC_DIVISION IN ('FID DVA', 'FIC DVA') OR a.CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA' WHEN a.CCC_DIVISION = 'COMMODITIES' THEN 'FIXED INCOME DIVISION' ELSE a.CCC_DIVISION END AS CCC_DIVISION, a.IS_UK_GROUP, CASE WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA' ELSE 'OTHER' END AS CCC_PL_REPORTING_REGION, CASE WHEN a.CCC_DIVISION = 'COMMODITIES' THEN 'COMMODITIES' WHEN (a.CCC_DIVISION='INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'OTHERS' WHEN (a.CCC_DIVISION='FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','FXEM MACRO TRADING','EM CREDIT TRADING','LIQUID FLOW RATES','STRUCTURED RATES','SECURITIZED PRODUCTS GRP','COMMODITIES')) THEN 'OTHERS FID' ELSE a.CCC_BUSINESS_AREA END AS CCC_BUSINESS_AREA, CASE WHEN a.CCC_TAPS_COMPANY='0319' THEN 'MSIM' WHEN a.CCC_TAPS_COMPANY IN ('4663','7281','5274','5254','8179','7280','6262','1311','8292','0721','4391','0517') THEN 'MSBIL' WHEN a.CCC_TAPS_COMPANY='0302' THEN 'MSIP' WHEN a.IS_UK_GROUP = 'Y' THEN 'OtherUKG' ELSE 'NOTUKG' END AS entityclassification FROM cdwuser.U_DM_FX a WHERE a.cob_date IN ('2018-02-28','2018-02-21') AND a.USD_IR_UNIFIED_PV01 <> 0 GROUP BY a.COB_DATE, CASE WHEN a.CURRENCY_COMBINED IN ('BHD','QAR','KWD','SAR','AED','OMR','BGN') THEN 'OTHER_PEGGED' ELSE a.CURRENCY_COMBINED END, a.MAJOR_EM, CASE WHEN a.term_new < 1 THEN '0-1Y' WHEN a.term_new >=1 AND a.term_new < 5 THEN '1-5Y' ELSE '5Y+' END, CASE WHEN (a.CCC_BUSINESS_AREA IN ( 'CPM TRADING (MPE)','CPM', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA' WHEN (a.CCC_DIVISION IN ('FID DVA', 'FIC DVA') OR a.CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA' WHEN a.CCC_DIVISION = 'COMMODITIES' THEN 'FIXED INCOME DIVISION' ELSE a.CCC_DIVISION END, a.IS_UK_GROUP, CASE WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA' ELSE 'OTHER' END, CASE WHEN a.CCC_DIVISION = 'COMMODITIES' THEN 'COMMODITIES' WHEN (a.CCC_DIVISION='INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'OTHERS' WHEN (a.CCC_DIVISION='FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','FXEM MACRO TRADING','EM CREDIT TRADING','LIQUID FLOW RATES','STRUCTURED RATES','SECURITIZED PRODUCTS GRP','COMMODITIES')) THEN 'OTHERS FID' ELSE a.CCC_BUSINESS_AREA END, CASE WHEN a.CCC_TAPS_COMPANY='0319' THEN 'MSIM' WHEN a.CCC_TAPS_COMPANY IN ('4663','7281','5274','5254','8179','7280','6262','1311','8292','0721','4391','0517') THEN 'MSBIL' WHEN a.CCC_TAPS_COMPANY='0302' THEN 'MSIP' WHEN a.IS_UK_GROUP = 'Y' THEN 'OtherUKG' ELSE 'NOTUKG' END