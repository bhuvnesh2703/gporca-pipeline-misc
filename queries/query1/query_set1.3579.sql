SELECT CASE WHEN CURRENCY_COMBINED IN ('CNH') THEN ('CNY') WHEN CURRENCY_COMBINED IN ('BRD') THEN ('BRL') WHEN CURRENCY_COMBINED IN ('BHR','QAT','KWT','SAU','ARE') THEN 'OTHER_PEGGED' WHEN CURRENCY_COMBINED IN ('EUR','CHF','GBP','SEK','NOK','DKK','JPY','AUD','NZD','CAD','USD') THEN 'G10' ELSE CURRENCY_COMBINED END AS CURRENCY, abc.neg20, abc.pos20 FROM (SELECT CASE WHEN base_ccy = 'UNDEFINED' THEN CURRENCY_OF_RISK_CCY1 ELSE base_ccy END AS currency_COMBINED, SUM(V.SLIDE_FXOPTVAR_MIN_20PCT_USD) AS neg20, SUM(V.SLIDE_FXOPTVAR_PLS_20PCT_USD) AS pos20 FROM cdwuser.U_dm_fx V WHERE V.cob_date IN ('2018-02-28') AND ( ( V.CURRENCY_PAIR LIKE '%AUD%' AND risk_currency_combined='AUD') OR ( V.CURRENCY_PAIR LIKE '%ZAR%' AND risk_currency_combined='ZAR') OR (V.CURRENCY_PAIR LIKE '%EUR%' AND risk_currency_combined='EUR') OR (V.CURRENCY_PAIR LIKE '%CHF%' AND risk_currency_combined='CHF' ) OR (V.CURRENCY_PAIR LIKE '%JPY%' AND risk_currency_combined='JPY') OR (V.CURRENCY_PAIR LIKE '%GBP%' AND risk_currency_combined='GBP') OR (V.CURRENCY_PAIR LIKE '%NZD%' AND risk_currency_combined='NZD') OR (V.CURRENCY_PAIR LIKE '%CAD%' AND risk_currency_combined='CAD') OR (V.CURRENCY_PAIR LIKE '%SEK%' AND risk_currency_combined='SEK') OR (V.CURRENCY_PAIR LIKE '%NOK%' AND risk_currency_combined='NOK') OR (V.CURRENCY_PAIR LIKE '%DKK%' AND risk_currency_combined='DKK') OR (V.CURRENCY_PAIR LIKE '%RUB%' AND risk_currency_combined='RUB') OR (V.CURRENCY_PAIR LIKE '%TRY%' AND risk_currency_combined='TRY' ) OR ((V.CURRENCY_PAIR LIKE '%CNY%' OR V.CURRENCY_PAIR LIKE '%CNH%') AND risk_currency_combined='CNY') OR (V.CURRENCY_PAIR LIKE '%INR%' AND risk_currency_combined='INR') OR ((V.CURRENCY_PAIR LIKE '%KRW%' OR v.CURRENCY_PAIR like '%KRX%') AND risk_currency_combined='KRW') OR ((V.CURRENCY_PAIR LIKE '%BRL%' OR V.CURRENCY_PAIR LIKE '%BRX%') AND risk_currency_combined='BRL') OR (V.CURRENCY_PAIR LIKE '%MXN%' AND risk_currency_combined='MXN') OR ( V.CURRENCY_PAIR LIKE '%HKD%' AND risk_currency_combined='HKD') OR ( V.CURRENCY_PAIR LIKE '%CZK%' AND risk_currency_combined='CZK') OR ( V.CURRENCY_PAIR LIKE '%THB%' AND risk_currency_combined='THB')) AND IS_UK_GROUP = 'Y' AND vertical_system like '%FXOPT%' AND PRODUCT_TYPE_CODE='FXOPT' AND is_basketbook='N' AND CCC_DIVISION NOT IN ('FID DVA','FIC DVA') AND CCC_STRATEGY NOT IN ('MS DVA STR NOTES IED') GROUP BY CURRENCY_OF_RISK_CCY1, base_ccy) abc