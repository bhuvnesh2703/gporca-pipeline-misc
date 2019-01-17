WITH z as ( SELECT COB_DATE,CCC_DIVISION,UNDERLIER,ISSUER_COUNTRY_CODE_DECOMP, NUMERATOR /(CASE WHEN (DENOMINATOR = 0 OR DENOMINATOR IS NULL) THEN 1 ELSE DENOMINATOR END) RATIO FROM ( SELECT COB_DATE,CCC_DIVISION,UNDERLIER,ISSUER_COUNTRY_CODE_DECOMP, ABS(USD_EQ_DELTA_DECOMP) NUMERATOR , ABS(SUM(USD_EQ_DELTA_DECOMP) OVER(PARTITION BY COB_DATE,CCC_DIVISION,UNDERLIER)) DENOMINATOR FROM ( SELECT a.COB_DATE, CASE WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA' WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA' WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM' WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM' WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE' WHEN ((a.CCC_DIVISION = 'FID UNDEFINED') OR (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE'))) THEN 'OTHER FID' WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER' ELSE a.CCC_BUSINESS_AREA END AS CCC_DIVISION, a.UNDERLIER_TICK || '.' || a.UNDERLIER_EXCH as UNDERLIER, a.ISSUER_COUNTRY_CODE_DECOMP, (sum(coalesce(a.USD_EQ_DELTA_DECOMP,0))) as USD_EQ_DELTA_DECOMP FROM CDWUSER.U_DECOMP_MSR a WHERE a.COB_DATE in ('2018-02-28','2018-02-21') AND a.USD_EQ_DELTA_DECOMP <> 0 AND a.CCC_BANKING_TRADING = 'TRADING' AND a.LE_GROUP = 'UK' GROUP BY 1,2,3,4 )a )b ), x as ( SELECT a.COB_DATE,a.CCC_DIVISION,a.TICKER_PARTIAL,a.UNDERLIER, CASE WHEN p.UNDERLIER IS NOT NULL THEN TICKER_PARTIAL ELSE a.UNDERLIER END AS TICKER_FINAL, SUM(USD_EQ_PARTIAL_KAPPA) USD_EQ_PARTIAL_KAPPA FROM ( SELECT a.COB_DATE, CASE WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM','CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 'CVA' WHEN (a.CCC_DIVISION = 'FID DVA' OR a.CCC_DIVISION='FIC DVA' OR CCC_STRATEGY = 'MS DVA STR NOTES IED') THEN 'DVA' WHEN a.CCC_DIVISION = 'BANK RESOURCE MANAGEMENT' THEN 'BRM' WHEN a.CCC_DIVISION = 'TREASURY CAPITAL MARKETS' THEN 'TCM' WHEN a.CCC_DIVISION ='NON CORE' THEN 'NON CORE' WHEN ((a.CCC_DIVISION = 'FID UNDEFINED') OR (a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CREDIT-CORPORATES','EM CREDIT TRADING','FXEM MACRO TRADING','STRUCTURED RATES','LIQUID FLOW RATES','SECURITIZED PRODUCTS GRP','COMMODITIES','NON CORE'))) THEN 'OTHER FID' WHEN (a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BUSINESS_AREA NOT IN ('CASH EQUITIES','DERIVATIVES','OTHER IED','PRIME BROKERAGE')) THEN 'IED OTHER' ELSE a.CCC_BUSINESS_AREA END AS CCC_DIVISION, a.PARTIAL_DECOMP_TICK || '.' || a.PARTIAL_DECOMP_EXCHANGE AS TICKER_PARTIAL, a.UNDERLIER_TICK || '.' || a.UNDERLIER_EXCH AS UNDERLIER, SUM(CASE WHEN a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' THEN (COALESCE (a.USD_EQ_PARTIAL_KAPPA,0)) ELSE (COALESCE (a.USD_EQ_KAPPA,0)) END) AS USD_EQ_PARTIAL_KAPPA FROM CDWUSER.U_EXP_MSR_PARTIAL a WHERE a.COB_DATE in ('2018-02-28','2018-02-21') AND (a.USD_EQ_KAPPA <> 0 OR a.USD_EQ_PARTIAL_KAPPA <> 0) AND a.CCC_BANKING_TRADING = 'TRADING' AND a.LE_GROUP = 'UK' GROUP BY 1,2,3,4 ) a LEFT OUTER JOIN ( SELECT UNDERLIER_TICK || '.' || UNDERLIER_EXCH UNDERLIER FROM CDWUSER.U_DECOMP_MSR WHERE COB_DATE in ('2018-02-28','2018-02-21') AND USD_EQ_DELTA_DECOMP <> 0 AND CCC_BANKING_TRADING = 'TRADING' AND LE_GROUP = 'UK' GROUP BY 1 ) p ON a.TICKER_PARTIAL = p.UNDERLIER GROUP BY 1,2,3,4,5 ) SELECT x.COB_DATE, x.CCC_DIVISION, x.TICKER_FINAL, CASE WHEN z.ISSUER_COUNTRY_CODE_DECOMP IN ('USA','CAN') THEN 'NAM' WHEN z.ISSUER_COUNTRY_CODE_DECOMP IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR') THEN 'Europe' WHEN z.ISSUER_COUNTRY_CODE_DECOMP IN ('GBR') THEN 'UK' WHEN z.ISSUER_COUNTRY_CODE_DECOMP IN ('CHN') THEN 'China' WHEN z.ISSUER_COUNTRY_CODE_DECOMP IN ('HKG') THEN 'Hong Kong' WHEN z.ISSUER_COUNTRY_CODE_DECOMP IN ('JPN') THEN 'Japan' ELSE 'Other' END as AREA, z.ISSUER_COUNTRY_CODE_DECOMP, SUM(x.USD_EQ_PARTIAL_KAPPA * z.Ratio ) AS USD_KAPPA_COUNTRY FROM x LEFT JOIN z ON (x.COB_DATE, x.CCC_DIVISION,x.TICKER_FINAL) = (z.COB_DATE,z.CCC_DIVISION,z.UNDERLIER) group by 1,2,3,4,5