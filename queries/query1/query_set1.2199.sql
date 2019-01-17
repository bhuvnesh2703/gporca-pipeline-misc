with SOURCE AS (select Currency_Type, ccc_division, ccc_business_area, currency_group, pegged, case when ccy_fx in ('USD','UBD','UBL') then 'USD' when ccy_fx in ('BRL','BR1','BRX') then 'BRL' when ccy_fx in ('RU1','RUB','RUX') then 'RUB' when ccy_fx in ('KRX','KRW') then 'KRW' else ccy_fx end as ccy_fx, sum(usd_fx_kappa_cob) as usd_fx_kappa_cob, sum(usd_fx_kappa_change) as usd_fx_kappa_change, case when Currency_Type = 'Major_Ccy' then 10 when Currency_Type = 'EM_Ccy' then 8 end AS Rank_LIMIT from (select t2.*, CASE WHEN curr1_final IN ('BHD', 'BAK', 'EGP', 'GHC', 'IQD', 'KES', 'KWD', 'LBP', 'LRD', 'ROL', 'SAR', 'SIT', 'TND', 'TRL', 'AED', 'ZMK') OR (curr1_final IN ('N/A', 'USD', 'AUD', 'CAD', 'CHF', 'DKK', 'EUR', 'GBP', 'JPY', 'NOK', 'NZD', 'SEK', 'UBD') AND curr2_final IN ('BHD', 'BAK', 'EGP', 'GHC', 'IQD', 'KES', 'KWD', 'LBP', 'LRD', 'ROL', 'SAR', 'SIT', 'TND', 'TRL', 'AED', 'ZMK')) THEN 'EEMEA_OTHER' WHEN curr1_final IN ('ILS', 'MAD', 'NGN', 'TRY', 'XAF', 'XOF', 'QAR', 'ZAR', 'OMR') OR (curr1_final IN ('N/A', 'USD', 'AUD', 'CAD', 'CHF', 'DKK', 'EUR', 'GBP', 'JPY', 'NOK', 'NZD', 'SEK', 'UBD') AND curr2_final IN ('ILS', 'MAD', 'NGN', 'TRY', 'XAF', 'XOF', 'QAR', 'ZAR', 'OMR')) THEN 'AFRICA_ME' WHEN curr1_final IN ('SKK', 'CYP', 'EEK', 'LVL', 'LTL') OR (curr1_final IN ('N/A', 'USD', 'AUD', 'CAD', 'CHF', 'DKK', 'EUR', 'GBP', 'JPY', 'NOK', 'NZD', 'SEK', 'UBD') AND curr2_final IN ('SKK', 'CYP', 'EEK', 'LVL', 'LTL')) THEN 'ERM_II' WHEN curr1_final IN ('BGN', 'HRK', 'CZK', 'HUF', 'ISK', 'PLN', 'RON', 'RSD') OR (curr1_final IN ('N/A', 'USD', 'AUD', 'CAD', 'CHF', 'DKK', 'EUR', 'GBP', 'JPY', 'NOK', 'NZD', 'SEK', 'UBD') AND curr2_final IN ('BGN', 'HRK', 'CZK', 'HUF', 'ISK', 'PLN', 'RON', 'RSD')) THEN 'EUROPE' WHEN curr1_final IN ('AZN', 'KZT', 'UAH', 'RUB','RBX','RU1') OR (curr1_final IN ('N/A', 'USD', 'AUD', 'CAD', 'CHF', 'DKK', 'EUR', 'GBP', 'JPY', 'NOK', 'NZD', 'SEK', 'UBD') AND curr2_final IN ('AZN', 'KZT', 'UAH', 'RUB','RU1','RBX')) THEN 'CIS' WHEN curr1_final IN ('CNY', 'HKD', 'INR', 'IDR', 'KRW', 'MYR', 'PKR', 'PHP', 'SGD', 'LKR', 'TWD', 'THB', 'VND', 'CNH','KRX','BDT') OR (curr1_final IN ('N/A', 'USD', 'AUD', 'CAD', 'CHF', 'DKK', 'EUR', 'GBP', 'JPY', 'NOK', 'NZD', 'SEK', 'UBD') AND curr2_final IN ('CNY', 'HKD', 'INR', 'IDR', 'KRW', 'MYR', 'PKR', 'PHP', 'SGD', 'LKR', 'TWD', 'THB', 'VND', 'CNH','KRX','BDT')) THEN 'ASIA' WHEN curr1_final IN ('ARS', 'BBD', 'BRL', 'BR1','BRX','CLP', 'COP', 'CRC', 'DOP', 'ECU', 'SVC', 'GTQ', 'GYD', 'TTD', 'JMD', 'MXN', 'PAB', 'PEN', 'UYU', 'VEB','VEF') OR (curr1_final IN ('N/A', 'USD', 'AUD', 'CAD', 'CHF', 'DKK', 'EUR', 'GBP', 'JPY', 'NOK', 'NZD', 'SEK', 'UBD') AND curr2_final IN ('ARS', 'BBD', 'BRL', 'BR1', 'BRX','CLP', 'COP', 'CRC', 'DOP', 'ECU', 'SVC', 'GTQ', 'GYD', 'TTD', 'JMD', 'MXN', 'PAB', 'PEN', 'UYU', 'VEB','VEF')) THEN 'LATAM' ELSE 'Other' END AS Currency_group, CASE WHEN ccy_fx IN ('N/A', 'USD', 'AUD', 'CAD', 'CHF', 'DKK', 'EUR', 'GBP', 'JPY', 'NOK', 'NZD', 'SEK', 'UBD') THEN 'Major_Ccy' ELSE 'EM_Ccy' END AS Currency_Type FROM (select t.*, CASE WHEN curr1 IN ('AUD', 'GBP', 'EUR', 'NZD') AND curr2 = '' then curr1 WHEN curr2 IN ('', 'UBD') THEN 'USD' WHEN curr1 = 'UBD' THEN 'USD' ELSE substr(currency,1,3) END AS curr1_final, CASE WHEN curr1 IN ('AUD', 'GBP', 'EUR', 'NZD') AND curr2 = '' then 'USD' WHEN curr2 IN ('', 'UBD') THEN curr1 WHEN curr1 = 'UBD' THEN curr2 ELSE substr(currency,4,3) END AS curr2_final, CASE WHEN curr1 IN ('N/A', 'USD', 'AUD', 'CAD', 'CHF', 'DKK', 'EUR', 'GBP', 'JPY', 'NOK', 'NZD', 'SEK', 'UBD') AND curr2 <> '' THEN curr2 ELSE curr1 END AS ccy_fx FROM (SELECT currency_of_measure as currency, ccc_division, SUBSTR(currency_of_measure,1,3) as curr1, SUBSTR(currency_of_measure,4,3) as curr2, CASE WHEN currency_of_measure IN ('AED', 'CNY', 'EGP', 'GHS', 'HKD', 'JOD', 'KWD', 'MYR', 'PKR', 'RUB', 'RBX','RU1', 'ARS', 'SAR', 'VND') THEN 'Pegged' ELSE 'NotPegged' END AS Pegged, CASE WHEN ccc_business_area LIKE 'FXEM%' THEN 'FXEM' ELSE ccc_business_area END AS ccc_business_area, sum(case when COB_DATE = '2018-02-28' then coalesce(usd_fx, 0) else 0 end ) as usd_fx_kappa_cob, sum(case when COB_DATE = '2018-02-28' then coalesce(usd_fx, 0) else -coalesce(usd_fx, 0) end ) as usd_fx_kappa_change FROM ( select case when currency_of_measure = 'CNY' and onshore_fl = 'N' then 'CNH' when currency_of_measure = 'KRW' and onshore_fl = 'N' then 'KRX' when currency_of_measure = 'BRL' and onshore_fl = 'N' then 'BRX' else currency_of_measure end as currency_of_measure, ccc_division, ccc_business_area, COB_DATE, usd_fx, CCC_TAPS_COMPANY, parent_legal_entity, var_excl_fl, ccc_banking_trading from cdwuser.U_exp_msr ) X WHERE COB_DATE IN ('2018-02-28', '2018-01-31') AND PARENT_LEGAL_ENTITY = '0201(G)' and coalesce(usd_fx, 0) <> 0 and var_excl_fl <> 'Y' AND currency_of_measure not in ('UBD', 'USD') group by currency_of_measure, ccc_division, SUBSTR(currency_of_measure,1,3), SUBSTR(currency_of_measure,4,3), CASE WHEN currency_of_measure IN ('AED', 'CNY', 'EGP', 'GHS', 'HKD', 'JOD', 'KWD', 'MYR', 'PKR', 'RUB', 'RBX', 'RU1', 'ARS', 'SAR', 'VND') THEN 'Pegged' ELSE 'NotPegged' END, CASE WHEN ccc_business_area LIKE 'FXEM%' THEN 'FXEM' ELSE ccc_business_area END ) t ) t2 ) J group by Currency_Type, case when ccy_fx in ('USD','UBD','UBL') then 'USD' when ccy_fx in ('BRL','BR1','BRX') then 'BRL' when ccy_fx in ('RU1','RUB','RUX') then 'RUB' when ccy_fx in ('KRX','KRW') then 'KRW' else ccy_fx end, pegged, ccc_business_area, ccc_division, ccy_fx, currency_group) SELECT Major_EM, pegged, currency_group, ccy_fx, rank, sum(usd_fx_kappa_cob) as total_fx_kappa_cob, sum(CM_usd_fx_kappa_cob) as CM_usd_fx_kappa_cob, sum(IED_usd_fx_kappa_cob) as IED_usd_fx_kappa_cob, sum(OTHER_usd_fx_kappa_cob) as OTHER_usd_fx_kappa_cob, sum(FID_usd_fx_kappa_cob) as FID_usd_fx_kappa_cob, sum(FXEM_usd_fx_kappa_cob) as FXEM_usd_fx_kappa_cob, sum(SR_usd_fx_kappa_cob) as SR_usd_fx_kappa_cob, sum(FLOW_usd_fx_kappa_cob) as FLOW_usd_fx_kappa_cob, sum(CVA_usd_fx_kappa_cob) as CVA_usd_fx_kappa_cob, sum(FID_OTHER_usd_fx_kappa_cob) as FID_OTHER_usd_fx_kappa_cob, sum(usd_fx_kappa_change) as total_fx_kappa_change, sum(CM_usd_fx_kappa_change) as CM_usd_fx_kappa_change, sum(IED_usd_fx_kappa_change) as IED_usd_fx_kappa_change, sum(OTHER_usd_fx_kappa_change) as OTHER_usd_fx_kappa_change, sum(FID_usd_fx_kappa_change) as FID_usd_fx_kappa_change, sum(FXEM_usd_fx_kappa_change) as FXEM_usd_fx_kappa_change, sum(SR_usd_fx_kappa_change) as SR_usd_fx_kappa_change, sum(FLOW_usd_fx_kappa_change) as FLOW_usd_fx_kappa_change, sum(CVA_usd_fx_kappa_change) as CVA_usd_fx_kappa_change, sum(FID_OTHER_usd_fx_kappa_change) as FID_OTHER_usd_fx_kappa_change FROM ( SELECT Major_EM, pegged, currency_group, case when rank_limit+1 > rank() over (PARTITION BY Major_EM, pegged, currency_group ORDER BY case when ccy_fx in ('GBP', 'JPY', 'EUR') then 1 else 2 end, abs(usd_fx_kappa_cob) DESC, rownum) then ccy_fx else 'Other' end as ccy_fx, LEAST(rank_limit+1, rank() over (PARTITION BY Major_EM, pegged, currency_group ORDER BY case when ccy_fx in ('GBP', 'JPY', 'EUR') then 1 else 2 end, abs(usd_fx_kappa_cob) DESC, rownum)) as rank, usd_fx_kappa_cob, CM_usd_fx_kappa_cob, IED_usd_fx_kappa_cob, OTHER_usd_fx_kappa_cob, FID_usd_fx_kappa_cob, FXEM_usd_fx_kappa_cob, SR_usd_fx_kappa_cob, FLOW_usd_fx_kappa_cob, CVA_usd_fx_kappa_cob, FID_OTHER_usd_fx_kappa_cob, usd_fx_kappa_change, CM_usd_fx_kappa_change, IED_usd_fx_kappa_change, OTHER_usd_fx_kappa_change, FID_usd_fx_kappa_change, FXEM_usd_fx_kappa_change, SR_usd_fx_kappa_change, FLOW_usd_fx_kappa_change, CVA_usd_fx_kappa_change, FID_OTHER_usd_fx_kappa_change FROM (SELECT Currency_Type AS Major_EM, ccy_fx, pegged, currency_group, max(rank_limit) rank_limit, ROW_NUMBER() OVER() AS ROWNUM, sum(usd_fx_kappa_cob) as usd_fx_kappa_cob, sum(usd_fx_kappa_change) as usd_fx_kappa_change, sum(case when (ccc_division = 'COMMODITIES' OR(CCC_DIVISION = 'FIXED INCOME DIVISION' AND CCC_BUSINESS_AREA = 'COMMODITIES')) then usd_fx_kappa_cob else 0 end) as CM_usd_fx_kappa_cob, sum(case when ccc_division = 'INSTITUTIONAL EQUITY DIVISION' then usd_fx_kappa_cob else 0 end) as IED_usd_fx_kappa_cob, sum(case when ccc_division <> 'COMMODITIES' and ccc_division <> 'INSTITUTIONAL EQUITY DIVISION' and ccc_division <> 'FIXED INCOME DIVISION' then usd_fx_kappa_cob else 0 end) as OTHER_usd_fx_kappa_cob, sum(case when ccc_division = 'FIXED INCOME DIVISION' then usd_fx_kappa_cob else 0 end) as FID_usd_fx_kappa_cob, sum(case when ccc_division = 'FIXED INCOME DIVISION' and ccc_business_area = 'FXEM' then usd_fx_kappa_cob else 0 end) as FXEM_usd_fx_kappa_cob, sum(case when ccc_division = 'FIXED INCOME DIVISION' and ccc_business_area = 'STRUCTURED RATES' then usd_fx_kappa_cob else 0 end) as SR_usd_fx_kappa_cob, sum(case when ccc_division = 'FIXED INCOME DIVISION' and ccc_business_area = 'LIQUID FLOW RATES' then usd_fx_kappa_cob else 0 end) as FLOW_usd_fx_kappa_cob, sum(case when ccc_division = 'FIXED INCOME DIVISION' and ccc_business_area IN ('CPM','CPM TRADING (MPE)', 'MS CVA MNE - FID') then usd_fx_kappa_cob else 0 end) as CVA_usd_fx_kappa_cob, sum(case when ccc_division = 'FIXED INCOME DIVISION' and ccc_business_area <> 'FXEM' and ccc_business_area <> 'STRUCTURED RATES' and ccc_business_area <> 'LIQUID FLOW RATES' and ccc_business_area NOT IN ('CPM','CPM TRADING (MPE)', 'MS CVA MNE - FID') then usd_fx_kappa_cob else 0 end) as FID_OTHER_usd_fx_kappa_cob, sum(case when (ccc_division = 'COMMODITIES' OR(CCC_DIVISION = 'FIXED INCOME DIVISION' AND CCC_BUSINESS_AREA = 'COMMODITIES')) then usd_fx_kappa_change else 0 end) as CM_usd_fx_kappa_change, sum(case when ccc_division = 'INSTITUTIONAL EQUITY DIVISION' then usd_fx_kappa_change else 0 end) as IED_usd_fx_kappa_change, sum(case when ccc_division <> 'COMMODITIES' and ccc_division <> 'INSTITUTIONAL EQUITY DIVISION' and ccc_division <> 'FIXED INCOME DIVISION' then usd_fx_kappa_change else 0 end) as OTHER_usd_fx_kappa_change, sum(case when ccc_division = 'FIXED INCOME DIVISION' then usd_fx_kappa_change else 0 end) as FID_usd_fx_kappa_change, sum(case when ccc_division = 'FIXED INCOME DIVISION' and ccc_business_area = 'FXEM' then usd_fx_kappa_change else 0 end) as FXEM_usd_fx_kappa_change, sum(case when ccc_division = 'FIXED INCOME DIVISION' and ccc_business_area = 'STRUCTURED RATES' then usd_fx_kappa_change else 0 end) as SR_usd_fx_kappa_change, sum(case when ccc_division = 'FIXED INCOME DIVISION' and ccc_business_area = 'LIQUID FLOW RATES' then usd_fx_kappa_change else 0 end) as FLOW_usd_fx_kappa_change, sum(case when ccc_division = 'FIXED INCOME DIVISION' and ccc_business_area IN ('CPM','CPM TRADING (MPE)', 'MS CVA MNE - FID') then usd_fx_kappa_change else 0 end) as CVA_usd_fx_kappa_change, sum(case when ccc_division = 'FIXED INCOME DIVISION' and ccc_business_area <> 'FXEM' and ccc_business_area <> 'STRUCTURED RATES' and ccc_business_area <> 'LIQUID FLOW RATES' and ccc_business_area NOT IN ('CPM','CPM TRADING (MPE)', 'MS CVA MNE - FID') then usd_fx_kappa_change else 0 end) as FID_OTHER_usd_fx_kappa_change FROM SOURCE GROUP BY Currency_Type, ccy_fx, pegged, currency_group) Y ) Z GROUP by Major_EM, pegged, currency_group, ccy_fx, rank order by Major_EM, pegged, currency_group, rank