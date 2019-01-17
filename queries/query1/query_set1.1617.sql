SELECT 'CVA incl.' as CVAFlag, 'UK Group' as Cut, a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END AS CCC_PL_REPORTING_REGION,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END AS CCC_BUSINESS_AREA,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END as AREA,   sum(coalesce(a.USD_EQ_DELTA_DECOMP,0))/1000 as USD_DELTA, sum(coalesce(a.USD_CM_DELTA_DECOMP,0))/1000 as USD_CM_DELTA, sum(coalesce(a.USD_EQ_PARTIAL_KAPPA,0))/1000 as USD_EQ_KAPPA, sum(coalesce(a.USD_EQ_KAPPA_PLS100BP_TIMEADJ,0))/1000 as TA_EQ_KAPPA, sum(coalesce(a.USD_EQ_GAMMA,0))/1000 as USD_EQ_GAMMA, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0))/1000 as SLIDE_EQ_MIN_05_USD, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0))/1000 as SLIDE_EQ_MIN_10_USD, sum(coalesce(a.USD_THETA_GAMMA,0))/1000 as USD_THETA_GAMMA, sum(coalesce(a.CORR_EQEQ,0))/1000000 as CORR_EQEQ, sum(coalesce(a.USD_EQ_DISC_RISK,0))/1000 as USD_DISC_RISK    FROM CDWUSER.U_DM_EQ a WHERE a.COB_DATE in ('2018-02-28','2018-02-21') AND a.IS_UK_GROUP = 'Y' AND a.CCC_DIVISION <> 'FID DVA' AND a.CCC_DIVISION <> 'FIC DVA' AND CCC_STRATEGY <> 'MS DVA STR NOTES IED'  GROUP BY a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END  UNION ALL  SELECT 'CVA incl.' as CVAFlag, 'EMEA' as Cut, a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END AS CCC_PL_REPORTING_REGION,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END AS CCC_BUSINESS_AREA,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END as AREA,   sum(coalesce(a.USD_EQ_DELTA_DECOMP,0))/1000 as USD_DELTA, sum(coalesce(a.USD_CM_DELTA,0))/1000 as USD_CM_DELTA, sum(coalesce(a.USD_EQ_PARTIAL_KAPPA,0))/1000 as USD_EQ_KAPPA, sum(coalesce(a.USD_EQ_KAPPA_PLS100BP_TIMEADJ,0))/1000 as TA_EQ_KAPPA, sum(coalesce(a.USD_THETA_GAMMA,0))/1000 as USD_THETA_GAMMA, sum(coalesce(a.USD_EQ_GAMMA,0))/1000 as USD_EQ_GAMMA, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0))/1000 as SLIDE_EQ_MIN_05_USD, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0))/1000 as SLIDE_EQ_MIN_10_USD, sum(coalesce(a.CORR_EQEQ,0))/1000000 as CORR_EQEQ, sum(coalesce(a.USD_EQ_DISC_RISK,0))/1000 as USD_DISC_RISK    FROM CDWUSER.U_DM_EQ a WHERE a.COB_DATE in ('2018-02-28','2018-02-21') AND a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.CCC_DIVISION <> 'FID DVA' AND a.CCC_DIVISION <> 'FIC DVA' AND CCC_STRATEGY <> 'MS DVA STR NOTES IED'  GROUP BY a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END  UNION ALL  SELECT 'CVA excl.' as CVAFlag, 'UK Group' as Cut, a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END AS CCC_PL_REPORTING_REGION,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END AS CCC_BUSINESS_AREA,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END as AREA,   sum(coalesce(a.USD_EQ_DELTA_DECOMP,0))/1000 as USD_DELTA, sum(coalesce(a.USD_CM_DELTA_DECOMP,0))/1000 as USD_CM_DELTA, sum(coalesce(a.USD_EQ_PARTIAL_KAPPA,0))/1000 as USD_EQ_KAPPA, sum(coalesce(a.USD_EQ_KAPPA_PLS100BP_TIMEADJ,0))/1000 as TA_EQ_KAPPA, sum(coalesce(a.USD_EQ_GAMMA,0))/1000 as USD_EQ_GAMMA, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0))/1000 as SLIDE_EQ_MIN_05_USD, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0))/1000 as SLIDE_EQ_MIN_10_USD, sum(coalesce(a.USD_THETA_GAMMA,0))/1000 as USD_THETA_GAMMA, sum(coalesce(a.CORR_EQEQ,0))/1000000 as CORR_EQEQ, sum(coalesce(a.USD_EQ_DISC_RISK,0))/1000 as USD_DISC_RISK    FROM CDWUSER.U_DM_EQ a WHERE a.COB_DATE in ('2018-02-28','2018-02-21') AND a.IS_UK_GROUP = 'Y' AND (a.CCC_BUSINESS_AREA NOT IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') AND a.CCC_STRATEGY NOT IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) AND a.CCC_DIVISION <> 'FID DVA' AND a.CCC_DIVISION <> 'FIC DVA' AND CCC_STRATEGY <> 'MS DVA STR NOTES IED' GROUP BY a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END  UNION ALL  SELECT 'CVA excl.' as CVAFlag, 'EMEA' as Cut, a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END AS CCC_PL_REPORTING_REGION,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END AS CCC_BUSINESS_AREA,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END as AREA,   sum(coalesce(a.USD_EQ_DELTA_DECOMP,0))/1000 as USD_DELTA, sum(coalesce(a.USD_CM_DELTA,0))/1000 as USD_CM_DELTA, sum(coalesce(a.USD_EQ_PARTIAL_KAPPA,0))/1000 as USD_EQ_KAPPA, sum(coalesce(a.USD_EQ_KAPPA_PLS100BP_TIMEADJ,0))/1000 as TA_EQ_KAPPA, sum(coalesce(a.USD_THETA_GAMMA,0))/1000 as USD_THETA_GAMMA, sum(coalesce(a.USD_EQ_GAMMA,0))/1000 as USD_EQ_GAMMA, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0))/1000 as SLIDE_EQ_MIN_05_USD, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0))/1000 as SLIDE_EQ_MIN_10_USD, sum(coalesce(a.CORR_EQEQ,0))/1000000 as CORR_EQEQ, sum(coalesce(a.USD_EQ_DISC_RISK,0))/1000 as USD_DISC_RISK    FROM CDWUSER.U_DM_EQ a WHERE a.COB_DATE in ('2018-02-28','2018-02-21') AND a.CCC_PL_REPORTING_REGION = 'EMEA' AND (a.CCC_BUSINESS_AREA NOT IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') AND a.CCC_STRATEGY NOT IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) AND a.CCC_DIVISION <> 'FID DVA' AND a.CCC_DIVISION <> 'FIC DVA' AND CCC_STRATEGY <> 'MS DVA STR NOTES IED' GROUP BY a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END  UNION ALL  SELECT 'IED only - CVA incl.' as CVAFlag, 'UK Group' as Cut, a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END AS CCC_PL_REPORTING_REGION,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END AS CCC_BUSINESS_AREA,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END as AREA,   sum(coalesce(a.USD_EQ_DELTA_DECOMP,0))/1000 as USD_DELTA, sum(coalesce(a.USD_CM_DELTA_DECOMP,0))/1000 as USD_CM_DELTA, sum(coalesce(a.USD_EQ_PARTIAL_KAPPA,0))/1000 as USD_EQ_KAPPA, sum(coalesce(a.USD_EQ_KAPPA_PLS100BP_TIMEADJ,0))/1000 as TA_EQ_KAPPA, sum(coalesce(a.USD_EQ_GAMMA,0))/1000 as USD_EQ_GAMMA, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0))/1000 as SLIDE_EQ_MIN_05_USD, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0))/1000 as SLIDE_EQ_MIN_10_USD, sum(coalesce(a.USD_THETA_GAMMA,0))/1000 as USD_THETA_GAMMA, sum(coalesce(a.CORR_EQEQ,0))/1000000 as CORR_EQEQ, sum(coalesce(a.USD_EQ_DISC_RISK,0))/1000 as USD_DISC_RISK    FROM CDWUSER.U_DM_EQ a WHERE a.COB_DATE in ('2018-02-28','2018-02-21') AND a.IS_UK_GROUP = 'Y' AND a.CCC_DIVISION   = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_DIVISION <> 'FID DVA' AND a.CCC_DIVISION <> 'FIC DVA' AND CCC_STRATEGY <> 'MS DVA STR NOTES IED'  GROUP BY a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END  UNION ALL  SELECT 'IED only - CVA incl.' as CVAFlag, 'EMEA' as Cut, a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END AS CCC_PL_REPORTING_REGION,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END AS CCC_BUSINESS_AREA,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END as AREA,  sum(coalesce(a.USD_EQ_DELTA_DECOMP,0))/1000 as USD_DELTA, sum(coalesce(a.USD_CM_DELTA,0))/1000 as USD_CM_DELTA, sum(coalesce(a.USD_EQ_PARTIAL_KAPPA,0))/1000 as USD_EQ_KAPPA, sum(coalesce(a.USD_EQ_KAPPA_PLS100BP_TIMEADJ,0))/1000 as TA_EQ_KAPPA, sum(coalesce(a.USD_THETA_GAMMA,0))/1000 as USD_THETA_GAMMA, sum(coalesce(a.USD_EQ_GAMMA,0))/1000 as USD_EQ_GAMMA, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0))/1000 as SLIDE_EQ_MIN_05_USD, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0))/1000 as SLIDE_EQ_MIN_10_USD, sum(coalesce(a.CORR_EQEQ,0))/1000000 as CORR_EQEQ, sum(coalesce(a.USD_EQ_DISC_RISK,0))/1000 as USD_DISC_RISK    FROM CDWUSER.U_DM_EQ a WHERE a.COB_DATE in ('2018-02-28','2018-02-21') AND a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.CCC_DIVISION   = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_DIVISION <> 'FID DVA' AND a.CCC_DIVISION <> 'FIC DVA' AND CCC_STRATEGY <> 'MS DVA STR NOTES IED' GROUP BY a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END  UNION ALL  SELECT 'IED Only - CVA excl.' as CVAFlag, 'UK Group' as Cut, a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END AS CCC_PL_REPORTING_REGION,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END AS CCC_BUSINESS_AREA,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END as AREA,   sum(coalesce(a.USD_EQ_DELTA_DECOMP,0))/1000 as USD_DELTA, sum(coalesce(a.USD_CM_DELTA_DECOMP,0))/1000 as USD_CM_DELTA, sum(coalesce(a.USD_EQ_PARTIAL_KAPPA,0))/1000 as USD_EQ_KAPPA, sum(coalesce(a.USD_EQ_KAPPA_PLS100BP_TIMEADJ,0))/1000 as TA_EQ_KAPPA, sum(coalesce(a.USD_EQ_GAMMA,0))/1000 as USD_EQ_GAMMA, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0))/1000 as SLIDE_EQ_MIN_05_USD, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0))/1000 as SLIDE_EQ_MIN_10_USD, sum(coalesce(a.USD_THETA_GAMMA,0))/1000 as USD_THETA_GAMMA, sum(coalesce(a.CORR_EQEQ,0))/1000000 as CORR_EQEQ, sum(coalesce(a.USD_EQ_DISC_RISK,0))/1000 as USD_DISC_RISK    FROM CDWUSER.U_DM_EQ a WHERE a.COB_DATE in ('2018-02-28','2018-02-21') AND a.IS_UK_GROUP = 'Y' AND (a.CCC_BUSINESS_AREA NOT IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') AND a.CCC_STRATEGY NOT IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) AND a.CCC_DIVISION   = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_DIVISION <> 'FID DVA' AND a.CCC_DIVISION <> 'FIC DVA' AND CCC_STRATEGY <> 'MS DVA STR NOTES IED' GROUP BY a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END  UNION ALL  SELECT 'IED only - CVA excl.' as CVAFlag, 'EMEA' as Cut, a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END AS CCC_PL_REPORTING_REGION,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END AS CCC_BUSINESS_AREA,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END as AREA,   sum(coalesce(a.USD_EQ_DELTA_DECOMP,0))/1000 as USD_DELTA, sum(coalesce(a.USD_CM_DELTA,0))/1000 as USD_CM_DELTA, sum(coalesce(a.USD_EQ_PARTIAL_KAPPA,0))/1000 as USD_EQ_KAPPA, sum(coalesce(a.USD_EQ_KAPPA_PLS100BP_TIMEADJ,0))/1000 as TA_EQ_KAPPA, sum(coalesce(a.USD_THETA_GAMMA,0))/1000 as USD_THETA_GAMMA, sum(coalesce(a.USD_EQ_GAMMA,0))/1000 as USD_EQ_GAMMA, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0))/1000 as SLIDE_EQ_MIN_05_USD, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0))/1000 as SLIDE_EQ_MIN_10_USD, sum(coalesce(a.CORR_EQEQ,0))/1000000 as CORR_EQEQ, sum(coalesce(a.USD_EQ_DISC_RISK,0))/1000 as USD_DISC_RISK    FROM CDWUSER.U_DM_EQ a WHERE a.COB_DATE in ('2018-02-28','2018-02-21') AND a.CCC_PL_REPORTING_REGION = 'EMEA' AND (a.CCC_BUSINESS_AREA NOT IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') AND a.CCC_STRATEGY NOT IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) AND a.CCC_DIVISION   = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_DIVISION <> 'FID DVA' AND a.CCC_DIVISION <> 'FIC DVA' AND CCC_STRATEGY <> 'MS DVA STR NOTES IED' GROUP BY a.COB_DATE, CASE      WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA'     WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'AMERICAS'     WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'ASIA'     ELSE 'OTHER' END,  CASE      WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA'     WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA'     WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM'     WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM'     WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE'     WHEN (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE')) THEN 'OTHER FID'     WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER'     ELSE a.CCC_BUSINESS_AREA  END,  CASE      WHEN a.ISSUER_COUNTRY_CODE IN ('USA','CAN') THEN 'NAM'      WHEN a.ISSUER_COUNTRY_CODE IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe'     WHEN a.ISSUER_COUNTRY_CODE IN ('GBR') THEN 'UK'     WHEN a.ISSUER_COUNTRY_CODE IN ('CHN') THEN 'China'     WHEN a.ISSUER_COUNTRY_CODE IN ('JPN') THEN 'Japan'     ELSE 'Other' END