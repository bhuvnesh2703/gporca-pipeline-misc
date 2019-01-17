SELECT     CCY1|| '/' || REGION AS MAPPING,     CURRENCY_PAIR,     CASE         WHEN             SUBSTR(STRESS_SCENARIO,4,3) IN ('EUR')             THEN                 (                 CASE                     WHEN                         STRPOS(STRESS_SCENARIO, 'XXX_M') > 0                         THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,12,2) AS VARCHAR(4))||'%'                     WHEN                         STRPOS(STRESS_SCENARIO, 'XXX_0') > 0                         THEN CAST (SUBSTR(STRESS_SCENARIO,11,1) AS VARCHAR(4))||'%'                     ELSE                         CAST (SUBSTR(STRESS_SCENARIO,11,2) AS VARCHAR(4))||'%'                 END                 )         ELSE                 (                 CASE                     WHEN                         STRPOS(STRESS_SCENARIO, 'FX_M') > 0                         THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,5,2) AS VARCHAR(4))||'%'                     WHEN                         STRPOS(STRESS_SCENARIO, 'FX_0') > 0                         THEN CAST (SUBSTR(STRESS_SCENARIO,4,1) AS VARCHAR(4))||'%'                     ELSE                         CAST (SUBSTR(STRESS_SCENARIO,4,2) AS VARCHAR(4))||'%'                 END                 )     END     AS SPOT,     CASE         WHEN             SUBSTR(STRESS_SCENARIO,4,3) IN ('EUR')             THEN                 (                 CASE                     WHEN                         STRPOS(STRESS_SCENARIO, 'XXX_M') > 0                         THEN                             (                             CASE                                 WHEN                                     STRPOS(STRESS_SCENARIO, 'VOL_M') > 0                                     THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,20,4) AS VARCHAR(4))||'%'                                 ELSE                                     CAST (SUBSTR(STRESS_SCENARIO,19,4) AS VARCHAR(4))||'%'                             END                             )                     WHEN                         STRPOS(STRESS_SCENARIO, 'XXX_0') > 0                         THEN                             (                             CASE                                 WHEN                                     STRPOS(STRESS_SCENARIO, 'VOL_M') > 0                                     THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,18,4) AS VARCHAR(4))||'%'                                 ELSE                                     CAST (SUBSTR(STRESS_SCENARIO,17,4) AS VARCHAR(4))||'%'                             END                             )                     ELSE                         (                         CASE                             WHEN                                 STRPOS(STRESS_SCENARIO, 'VOL_M') > 0                                 THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,19,4) AS VARCHAR(4))||'%'                             ELSE                                 CAST (SUBSTR(STRESS_SCENARIO,18,4) AS VARCHAR(4))||'%'                         END                         )                 END                 )         ELSE             (             CASE                 WHEN                     STRPOS(STRESS_SCENARIO, 'FX_M') > 0                     THEN                         (                         CASE                             WHEN                                 STRPOS(STRESS_SCENARIO, 'VOL_M') > 0                                 THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,13,4) AS VARCHAR(4))||'%'                             ELSE                                 CAST (SUBSTR(STRESS_SCENARIO,12,4) AS VARCHAR(4))||'%'                         END                         )                 WHEN                     STRPOS(STRESS_SCENARIO, 'FX_0') > 0                     THEN                         (                         CASE                             WHEN                                 STRPOS(STRESS_SCENARIO, 'VOL_M') > 0                                 THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,11,4) AS VARCHAR(4))||'%'                               ELSE                                 CAST (SUBSTR(STRESS_SCENARIO,10,4) AS VARCHAR(4))||'%'                          END                         )                 ELSE                     (                     CASE                         WHEN                             STRPOS(STRESS_SCENARIO, 'VOL_M') > 0                             THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,12,4) AS VARCHAR(4))||'%'                           ELSE                             CAST (SUBSTR(STRESS_SCENARIO,11,4) AS VARCHAR(4))||'%'                      END                     )             END             )     END     AS VOL,     SUM(COALESCE(SCENARIO_PNL,0)) AS SCENARIO_PNL FROM         (     SELECT         D.*,         CASE             WHEN                 CCY1 IN ('USD')                  THEN                     (                     CASE                         WHEN                             CCY2 IN                                  (                                 'BDT','BND','BTN','CNY','FJD','IDR','INR','KGS','KHR','KPW',                                 'KRW','LAK','LKR','MMK','MNT','MOP','MYR','NPR','PGK','PHP',                                 'PKR','SBD','SGD','THB','TJS','TMM','TOP','TWD','UZS','VND',                                 'VUV','WST','KRX','CNH'                                 ) THEN 'ASIA'                         WHEN                                       CCY2 IN                                  (                                 'AMD','AZM','AZN','BAM','BGN','BYR','CSD','CZK','EEK','GEL','HRK',                                 'HUF','ISK','KZT','LTL','LVL','MDL','MKD','PLN','ROL','RON','RSD',                                 'RUB','SIT','SKK','TRL','TRY','UAH','AOA','BHD','BIF','BWP','CDF',                                 'CVE','DEM','DJF','DZD','EGP','ERN','ETB','GHC','GHS','GMD','GNF',                                 'GWP','ILS','IQD','IRR','JOD','KES','KMF','KWD','LBP','LRD','LSL',                                 'LYD','MAD','MRO','MUR','MVR','MWK','MZM','NAD','NGN','OMR',                                 'RWF','SCR','SDD','SHP','SLL','SOS','STD','SYP','SZL','TND','TZS',                                 'UGX','XOF','YER','ZAR','ZMK','ZWD','RBX','RU1','DKK'                                 ) THEN 'EMEA'                         WHEN                                     CCY2 IN                                 (                                 'ANG','ARS','AWG','BBD','BMD','BOB','BOV','BRL','BSD','BZD',                                 'CLF','CLP','COP','CRC','CUP','DOP','ECU','FKP','GTQ','GYD','HNL',                                 'HTG','JMD','KYD','MXN','MXV','NIO','PAB','PEN','PYG','SVC',                                 'TTD','UYU','VEB','BRX'                                 ) THEN 'LATAM'                         WHEN                             CCY2 IN                                 (                                 'AUD','CAD','CHF','EUR','GBP','JPY','NOK','NZD','SEK'                                 ) THEN 'MAJORS'                         WHEN                             CCY2 IN                                 (                                 'HKD','AED','QAR','SAR'                                 ) THEN 'PEGGED'                         WHEN                             CCY2 IN                                 (                                 'USD','UBD'                                 ) THEN 'USD'                         ELSE                             CCY2                     END                     )             ELSE                 (                     CASE                         WHEN                             CCY2 IN                                  (                                 'BDT','BND','BTN','CNY','FJD','IDR','INR','KGS','KHR','KPW',                                 'KRW','LAK','LKR','MMK','MNT','MOP','MYR','NPR','PGK','PHP',                                 'PKR','SBD','SGD','THB','TJS','TMM','TOP','TWD','UZS','VND',                                 'VUV','WST','HKD'                                 ) THEN 'ASIA'                         WHEN                                       CCY2 IN                                  (                                 'AMD','AZM','AZN','BAM','BGN','BYR','CSD','CZK','EEK','GEL','HRK',                                 'HUF','ISK','KZT','LTL','LVL','MDL','MKD','PLN','ROL','RON','RSD',                                 'RUB','SIT','SKK','TRL','TRY','UAH','AOA','BHD','BIF','BWP','CDF',                                 'CVE','DEM','DJF','DZD','EGP','ERN','ETB','GHC','GHS','GMD','GNF',                                 'GWP','ILS','IQD','IRR','JOD','KES','KMF','KWD','LBP','LRD','LSL',                                 'LYD','MAD','MRO','MUR','MVR','MWK','MZM','NAD','NGN','OMR',                                 'RWF','SCR','SDD','SHP','SLL','SOS','STD','SYP','SZL','TND','TZS',                                 'UGX','XOF','YER','ZAR','ZMK','ZWD','AED','QAR','SAR'                                 ) THEN 'EMEA'                         WHEN                                     CCY2 IN                                 (                                 'ANG','ARS','AWG','BBD','BMD','BOB','BOV','BRL','BSD','BZD',                                 'CLF','CLP','COP','CRC','CUP','DOP','ECU','FKP','GTQ','GYD','HNL',                                 'HTG','JMD','KYD','MXN','MXV','NIO','PAB','PEN','PYG','SVC',                                 'TTD','UYU','VEB'                                 ) THEN 'LATAM'                         WHEN                             CCY2 IN                                 (                                 'AUD','CAD','CHF','EUR','GBP','JPY','NOK','NZD','SEK'                                 ) THEN 'MAJORS'                         WHEN                             CCY2 IN                                 (                                 'DKK'                                 ) THEN 'PEGGED'                         WHEN                             CCY2 IN                                 (                                 'USD','UBD'                                 ) THEN 'USD'                         ELSE                             CCY2                     END                 )         END         AS REGION     FROM             (         SELECT             C.*,             CASE                 WHEN                     SUBSTR(C.CURRENCY_PAIR,1,3) IN ('EUR')                      THEN                         (                         CASE                             WHEN                                  C.CURRENCY_PAIR IN ('EURUSD') THEN 'USD'                             ELSE                                  'EUR'                         END                         )                 WHEN                     SUBSTR(C.CURRENCY_PAIR,1,3) IN ('USD') OR                     C.CURRENCY_PAIR IN ('GBPUSD','AUDUSD','NZDUSD')                      THEN 'USD'                 ELSE                     'OTHER'             END             AS CCY1,             CASE                 WHEN                     SUBSTR(C.CURRENCY_PAIR,1,3) IN ('EUR')                      THEN                         (                         CASE                             WHEN                                  C.CURRENCY_PAIR IN ('EURUSD') THEN 'EUR'                             ELSE                                  SUBSTR(C.CURRENCY_PAIR,4,6)                         END                         )                 WHEN                     C.CURRENCY_PAIR IN ('GBPUSD','AUDUSD','NZDUSD')                     THEN SUBSTR(C.CURRENCY_PAIR,1,3)                 WHEN                     SUBSTR(C.CURRENCY_PAIR,1,3) IN ('USD')                     THEN SUBSTR(C.CURRENCY_PAIR,4,6)                 ELSE                     'OTHER'             END             AS CCY2         FROM             (             SELECT                  A.STRESS_SCENARIO,                 SUM                     (                     CASE                          WHEN                              PRODUCT_TYPE <> 'FXOPT' AND                              SCENARIO_TYPE = 'GREEK' AND                              ATTRIBUTION <> 'FX GAMMA'                             THEN SCENARIO_PNL                         ELSE 0                     END                     ) AS SCENARIO_PNL,                  CASE                      WHEN                          STRPOS(CURRENCY_PAIR, 'CNH') > 0                         THEN REPLACE(CURRENCY_PAIR, 'CNH', 'CNY')                     WHEN                          STRPOS(CURRENCY_PAIR, 'KRX') > 0                         THEN REPLACE(CURRENCY_PAIR, 'KRX', 'KRW')                     WHEN                          STRPOS(CURRENCY_PAIR, 'RBX') > 0                         THEN REPLACE(CURRENCY_PAIR, 'RBX', 'RUB')                     WHEN                         STRPOS(CURRENCY_PAIR, 'BRX') > 0                         THEN REPLACE(CURRENCY_PAIR, 'BRX', 'BRL')                     WHEN                         STRPOS(CURRENCY_PAIR, 'UBD') > 0                         THEN REPLACE(CURRENCY_PAIR, 'UBD', 'USD')                     ELSE CURRENCY_PAIR                 END                  AS CURRENCY_PAIR             FROM                  DWUSER.U_MODULAR_SCENARIOS A             WHERE      COB_DATE = '2018-02-28' AND     CCC_TAPS_COMPANY IN ('0111') AND                 A.RUN_PROFILE = 'FXOPT_MOD_SCN_RUN' AND                  A.CCC_BUSINESS_AREA = 'FXEM MACRO TRADING' AND                  A.BOOK NOT IN                      (                     'BASKET','BASKET HEDGES','CEEMEA MULTICCY','CORRELATION SWAP',                     'CORRELATION SWAP 2','CORRELATION SWAP 3','CORRELATION SWAP 4',                     'DUAL CURRENCY','MULTICCY SPEC'                     ) AND                  A.PRODUCT_TYPE <> 'FXBSKT' AND                  A.STRESS_SCENARIO LIKE 'FX%' AND                 (                 STRESS_SCENARIO LIKE '%XXX%' AND                  SUBSTR(CURRENCY_PAIR, 1, 3) <> 'USD' AND                  SUBSTR(CURRENCY_PAIR, 4, 3) <> 'USD' AND                      (                     SUBSTR(CURRENCY_PAIR, 1, 3) = 'EUR' OR                      SUBSTR(CURRENCY_PAIR, 1, 3) = 'GBP' OR                      SUBSTR(CURRENCY_PAIR, 1, 3) = 'JPY' OR                      SUBSTR(CURRENCY_PAIR, 4, 3) = 'EUR' OR                      SUBSTR(CURRENCY_PAIR, 4, 3) = 'GBP' OR                      SUBSTR(CURRENCY_PAIR, 4, 3) = 'JPY'                     ) OR                  STRESS_SCENARIO NOT LIKE '%XXX%' AND                      (                     SUBSTR(CURRENCY_PAIR, 1, 3) <> 'EUR' AND                      SUBSTR(CURRENCY_PAIR, 1, 3) <> 'GBP' AND                      SUBSTR(CURRENCY_PAIR, 1, 3) <> 'JPY' AND                      SUBSTR(CURRENCY_PAIR, 4, 3) <> 'EUR' AND                      SUBSTR(CURRENCY_PAIR, 4, 3) <> 'GBP' AND                      SUBSTR(CURRENCY_PAIR, 4, 3) <> 'JPY'                     ) OR                  STRESS_SCENARIO NOT LIKE '%XXX%' AND                  CURRENCY_PAIR IN ('EURUSD','GBPUSD','USDJPY')                 ) AND                  EXCLUDE_CODE = 'Not Applicable' AND                 PRODUCT_TYPE NOT IN ('FXOPT') AND                 STRESS_SCENARIO IN                      (                     'FX_M20_VOL_200','FX_M20_VOL_100','FX_M20_VOL_50','FX_M20_VOL_0','FX_M20_VOL_M50',                     'FX_M10_VOL_200','FX_M10_VOL_100','FX_M10_VOL_50','FX_M10_VOL_0','FX_M10_VOL_M50',                     'FX_0_VOL_200','FX_0_VOL_100','FX_0_VOL_50','FX_0_VOL_0','FX_0_VOL_M50',                     'FX_10_VOL_200','FX_10_VOL_100','FX_10_VOL_50','FX_10_VOL_0','FX_10_VOL_M50',                     'FX_20_VOL_200','FX_20_VOL_100','FX_20_VOL_50','FX_20_VOL_0','FX_20_VOL_M50',                     'FX_EURXXX_M20_VOL_200','FX_EURXXX_M20_VOL_100','FX_EURXXX_M20_VOL_50',                     'FX_EURXXX_M20_VOL_0','FX_EURXXX_M20_VOL_M50','FX_EURXXX_M10_VOL_200',                     'FX_EURXXX_M10_VOL_100','FX_EURXXX_M10_VOL_50','FX_EURXXX_M10_VOL_0',                     'FX_EURXXX_M10_VOL_M50','FX_EURXXX_0_VOL_200','FX_EURXXX_0_VOL_100',                     'FX_EURXXX_0_VOL_50','FX_EURXXX_0_VOL_0','FX_EURXXX_0_VOL_M50','FX_EURXXX_10_VOL_200',                     'FX_EURXXX_10_VOL_100','FX_EURXXX_10_VOL_50','FX_EURXXX_10_VOL_0','FX_EURXXX_10_VOL_M50',                     'FX_EURXXX_20_VOL_200','FX_EURXXX_20_VOL_100','FX_EURXXX_20_VOL_50','FX_EURXXX_20_VOL_0',                     'FX_EURXXX_20_VOL_M50'                     )             GROUP BY                  A.STRESS_SCENARIO,                 CASE                      WHEN                          STRPOS(CURRENCY_PAIR, 'CNH') > 0                         THEN REPLACE(CURRENCY_PAIR, 'CNH', 'CNY')                     WHEN                          STRPOS(CURRENCY_PAIR, 'KRX') > 0                         THEN REPLACE(CURRENCY_PAIR, 'KRX', 'KRW')                     WHEN                          STRPOS(CURRENCY_PAIR, 'RBX') > 0                         THEN REPLACE(CURRENCY_PAIR, 'RBX', 'RUB')                     WHEN                         STRPOS(CURRENCY_PAIR, 'BRX') > 0                         THEN REPLACE(CURRENCY_PAIR, 'BRX', 'BRL')                     WHEN                         STRPOS(CURRENCY_PAIR, 'UBD') > 0                         THEN REPLACE(CURRENCY_PAIR, 'UBD', 'USD')                     ELSE CURRENCY_PAIR                 END              ) C         ) D     ) E GROUP BY     CCY1|| '/' || REGION,     CURRENCY_PAIR,     STRESS_SCENARIO