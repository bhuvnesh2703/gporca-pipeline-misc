WITH TICKET_LIST AS      (     SELECT         USD|| '/' || REGION AS MAPPING,         C.CURRENCY_PAIR,         C.TICKET,         C.SPOT,         C.VOL,         SUM             (             VOL200 + VOL100 +              CAST(1 AS FLOAT) / 2 * VOL60 +              CAST(1 AS FLOAT) / 2 * VOL40 +             VOL0 + VOLM50             )         AS SCENARIO_PNL     FROM         (         SELECT                 CURRENCY_PAIR,                 TICKET,                 SPOT,                 CASE                     WHEN                         VOL IN ('40%','60%')                         THEN '50%'                     ELSE                         VOL                 END                 AS VOL,                 CASE                     WHEN                         VOL IN ('200%')                          THEN COALESCE (SCENARIO_PNL,0)                     ELSE 0                 END                  AS VOL200,                 CASE                     WHEN                         VOL IN ('100%')                          THEN COALESCE (SCENARIO_PNL,0)                     ELSE 0                 END                  AS VOL100,                 CASE                     WHEN                         VOL IN ('40%')                          THEN COALESCE (SCENARIO_PNL,0)                     ELSE 0                 END                  AS VOL40,                 CASE                     WHEN                         VOL IN ('60%')                          THEN COALESCE (SCENARIO_PNL,0)                     ELSE 0                 END                  AS VOL60,                 CASE                     WHEN                         VOL IN ('0%')                          THEN COALESCE (SCENARIO_PNL,0)                     ELSE 0                 END                  AS VOL0,                 CASE                     WHEN                         VOL IN ('-50%')                          THEN COALESCE (SCENARIO_PNL,0)                     ELSE 0                 END                  AS VOLM50,                 'USD' AS USD,                 CASE                     WHEN                         SUBSTR(SOURCE_SCN_NAME,5,3) IN                              (                             'BDT','BND','BTN','CNY','FJD','IDR','INR','KGS','KHR','KPW',                             'KRW','LAK','LKR','MMK','MNT','MOP','MYR','NPR','PGK','PHP',                             'PKR','SBD','SGD','THB','TJS','TMM','TOP','TWD','UZS','VND',                             'VUV','WST','KRX','CNH'                             ) THEN 'ASIA'                     WHEN                                   SUBSTR(SOURCE_SCN_NAME,5,3) IN                              (                             'AMD','AZM','AZN','BAM','BGN','BYR','CSD','CZK','EEK','GEL','HRK',                             'HUF','ISK','KZT','LTL','LVL','MDL','MKD','PLN','ROL','RON','RSD',                             'RUB','SIT','SKK','TRL','TRY','UAH','AOA','BHD','BIF','BWP','CDF',                             'CVE','DEM','DJF','DZD','EGP','ERN','ETB','GHC','GHS','GMD','GNF',                             'GWP','ILS','IQD','IRR','JOD','KES','KMF','KWD','LBP','LRD','LSL',                             'LYD','MAD','MRO','MUR','MVR','MWK','MZM','NAD','NGN','OMR',                             'RWF','SCR','SDD','SHP','SLL','SOS','STD','SYP','SZL','TND','TZS',                             'UGX','XOF','YER','ZAR','ZMK','ZWD','RBX','RU1','DKK'                             ) THEN 'EMEA'                     WHEN                                 SUBSTR(SOURCE_SCN_NAME,5,3) IN                             (                             'ANG','ARS','AWG','BBD','BMD','BOB','BOV','BRL','BSD','BZD',                             'CLF','CLP','COP','CRC','CUP','DOP','ECU','FKP','GTQ','GYD','HNL',                             'HTG','JMD','KYD','MXN','MXV','NIO','PAB','PEN','PYG','SVC',                             'TTD','UYU','VEB','BRX'                             ) THEN 'LATAM'                     WHEN                         SUBSTR(SOURCE_SCN_NAME,5,3) IN                             (                             'AUD','CAD','CHF','EUR','GBP','JPY','NOK','NZD','SEK'                             ) THEN 'MAJORS'                     WHEN                         SUBSTR(SOURCE_SCN_NAME,5,3) IN                             (                             'HKD','AED','QAR','SAR'                             ) THEN 'PEGGED'                     WHEN                         SUBSTR(SOURCE_SCN_NAME,5,3) IN                             (                             'USD','UBD'                             ) THEN 'USD'                     ELSE                         SUBSTR(SOURCE_SCN_NAME,5,3)                 END                 AS REGION         FROM             (             SELECT                   RAW_PNL AS SCENARIO_PNL,                 SOURCE_SCN_NAME,                 TICKET,                 CASE                     WHEN                         STRPOS(SOURCE_SCN_NAME, 'spot 0%') > 0                         THEN CAST (SUBSTR(SOURCE_SCN_NAME,26,4) AS VARCHAR(4))                     WHEN                         STRPOS(SOURCE_SCN_NAME, 'spot -10%') > 0                         THEN CAST (SUBSTR(SOURCE_SCN_NAME,28,4) AS VARCHAR(4))                     WHEN                         STRPOS(SOURCE_SCN_NAME, 'spot -20%') > 0                         THEN CAST (SUBSTR(SOURCE_SCN_NAME,28,4) AS VARCHAR(4))                     ELSE                         CAST(SUBSTR(SOURCE_SCN_NAME,27,4) AS VARCHAR(4))                 END                 AS VOL,                 CASE                     WHEN                         STRPOS(SOURCE_SCN_NAME, 'spot 0%') > 0                         THEN CAST(SUBSTR(SOURCE_SCN_NAME,14,2) AS VARCHAR(4))                     WHEN                         STRPOS(SOURCE_SCN_NAME, 'spot -10%') > 0                         THEN CAST(SUBSTR(SOURCE_SCN_NAME,14,4) AS VARCHAR(4))                     WHEN                         STRPOS(SOURCE_SCN_NAME, 'spot -20%') > 0                         THEN CAST(SUBSTR(SOURCE_SCN_NAME,14,4) AS VARCHAR(4))                     ELSE                         CAST (SUBSTR(SOURCE_SCN_NAME,14,3) AS VARCHAR(4))                 END                 AS SPOT,                 CASE                      WHEN                          STRPOS(CURRENCY_PAIR, 'CNH') > 0                         THEN REPLACE(CURRENCY_PAIR, 'CNH', 'CNY')                     WHEN                          STRPOS(CURRENCY_PAIR, 'KRX') > 0                         THEN REPLACE(CURRENCY_PAIR, 'KRX', 'KRW')                     WHEN                          STRPOS(CURRENCY_PAIR, 'RBX') > 0                         THEN REPLACE(CURRENCY_PAIR, 'RBX', 'RUB')                     WHEN                          STRPOS(CURRENCY_PAIR, 'RU1') > 0                         THEN REPLACE(CURRENCY_PAIR, 'RU1', 'RUB')                     WHEN                          CURRENCY_PAIR IN ('UBDBRL','UBDBRX','USDBRL')                         THEN 'USDBRL'                     ELSE                          CURRENCY_PAIR                 END                  AS CURRENCY_PAIR             FROM                  DWUSER.U_RAW_SCENARIO_PNL A             WHERE      COB_DATE = '2018-01-31' AND     CCC_TAPS_COMPANY IN ('0111') AND                 CCC_BUSINESS_AREA = 'FXEM MACRO TRADING' AND                  BOOK NOT IN                      (                     'BASKET', 'BASKET HEDGES', 'CEEMEA MULTICCY', 'CORRELATION SWAP',                      'CORRELATION SWAP 2', 'CORRELATION SWAP 3', 'CORRELATION SWAP 4',                      'DUAL CURRENCY', 'MULTICCY SPEC'                     ) AND                  PRODUCT_TYPE IN ('FXOPT') AND                  BU_RISK_SYSTEM LIKE '%FXOPT%' AND                  PROCESS_ID = '62000' AND                  (                     (                     SOURCE_SCN_NAME LIKE '%spot -20%' OR                                 SOURCE_SCN_NAME LIKE '%spot -10%' OR                        SOURCE_SCN_NAME LIKE '%spot 0%' OR                     SOURCE_SCN_NAME LIKE '%spot 10%' OR                     SOURCE_SCN_NAME LIKE '%spot 20%'                      ) AND                      SOURCE_SCN_NAME NOT LIKE '%spot 100%' AND                     (                     SOURCE_SCN_NAME LIKE '%vol -50%' OR                      SOURCE_SCN_NAME LIKE '%vol 0%' OR                      SOURCE_SCN_NAME LIKE '%vol 40%' OR                      SOURCE_SCN_NAME LIKE '%vol 60%' OR                      SOURCE_SCN_NAME LIKE '%vol 100%' OR                      SOURCE_SCN_NAME LIKE '%vol 200%'                     ) AND                     SOURCE_SCN_NAME NOT LIKE '%vol 1000%' AND                     SOURCE_SCN_NAME NOT LIKE '%vol 500%'                 ) AND                 CURRENCY_PAIR LIKE '%USD%' AND                 SOURCE_SCN_NAME LIKE 'USD%'             ) B         ) C     GROUP BY         USD|| '/' || REGION,         C.CURRENCY_PAIR,         C.TICKET,         C.SPOT,         C.VOL     )   SELECT     G.MAPPING,     G.CURRENCY_PAIR,     G.SPOT,     G.VOL,     SUM(COALESCE(G.SCENARIO_PNL,0)) AS SCENARIO_PNL FROM     (     SELECT         F.MAPPING,         F.CURRENCY_PAIR,         F.SPOT,         F.VOL,         TK.SPOT AS SPOT2,         TK.VOL AS VOL2,         SUM(COALESCE(F.SCENARIO_PNL,0)) AS SCENARIO_PNL     FROM         (         SELECT             E.*,             CCY1|| '/' || REGION AS MAPPING,             CASE                 WHEN                     SUBSTR(STRESS_SCENARIO,4,3) IN ('EUR')                     THEN                         (                         CASE                             WHEN                                 STRPOS(STRESS_SCENARIO, 'XXX_M') > 0                                 THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,12,2) AS VARCHAR(4))||'%'                             WHEN                                 STRPOS(STRESS_SCENARIO, 'XXX_0') > 0                                 THEN CAST (SUBSTR(STRESS_SCENARIO,11,1) AS VARCHAR(4))||'%'                             ELSE                                 CAST (SUBSTR(STRESS_SCENARIO,11,2) AS VARCHAR(4))||'%'                         END                         )                 ELSE                         (                         CASE                             WHEN                                 STRPOS(STRESS_SCENARIO, 'FX_M') > 0                                 THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,5,2) AS VARCHAR(4))||'%'                             WHEN                                 STRPOS(STRESS_SCENARIO, 'FX_0') > 0                                 THEN CAST (SUBSTR(STRESS_SCENARIO,4,1) AS VARCHAR(4))||'%'                             ELSE                                 CAST (SUBSTR(STRESS_SCENARIO,4,2) AS VARCHAR(4))||'%'                         END                         )             END             AS SPOT,             CASE                 WHEN                     SUBSTR(STRESS_SCENARIO,4,3) IN ('EUR')                     THEN                         (                         CASE                             WHEN                                 STRPOS(STRESS_SCENARIO, 'XXX_M') > 0                                 THEN                                     (                                     CASE                                         WHEN                                             STRPOS(STRESS_SCENARIO, 'VOL_M') > 0                                             THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,20,4) AS VARCHAR(4))||'%'                                         ELSE                                             CAST (SUBSTR(STRESS_SCENARIO,19,4) AS VARCHAR(4))||'%'                                     END                                     )                             WHEN                                 STRPOS(STRESS_SCENARIO, 'XXX_0') > 0                                 THEN                                     (                                     CASE                                         WHEN                                             STRPOS(STRESS_SCENARIO, 'VOL_M') > 0                                             THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,18,4) AS VARCHAR(4))||'%'                                         ELSE                                             CAST (SUBSTR(STRESS_SCENARIO,17,4) AS VARCHAR(4))||'%'                                     END                                     )                             ELSE                                 (                                 CASE                                     WHEN                                         STRPOS(STRESS_SCENARIO, 'VOL_M') > 0                                         THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,19,4) AS VARCHAR(4))||'%'                                     ELSE                                         CAST (SUBSTR(STRESS_SCENARIO,18,4) AS VARCHAR(4))||'%'                                 END                                 )                         END                         )                 ELSE                     (                     CASE                         WHEN                             STRPOS(STRESS_SCENARIO, 'FX_M') > 0                             THEN                                 (                                 CASE                                     WHEN                                         STRPOS(STRESS_SCENARIO, 'VOL_M') > 0                                         THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,13,4) AS VARCHAR(4))||'%'                                     ELSE                                         CAST (SUBSTR(STRESS_SCENARIO,12,4) AS VARCHAR(4))||'%'                                 END                                 )                         WHEN                             STRPOS(STRESS_SCENARIO, 'FX_0') > 0                             THEN                                 (                                 CASE                                     WHEN                                         STRPOS(STRESS_SCENARIO, 'VOL_M') > 0                                         THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,11,4) AS VARCHAR(4))||'%'                                       ELSE                                         CAST (SUBSTR(STRESS_SCENARIO,10,4) AS VARCHAR(4))||'%'                                  END                                 )                         ELSE                             (                             CASE                                 WHEN                                     STRPOS(STRESS_SCENARIO, 'VOL_M') > 0                                     THEN '-'||CAST (SUBSTR(STRESS_SCENARIO,12,4) AS VARCHAR(4))||'%'                                   ELSE                                     CAST (SUBSTR(STRESS_SCENARIO,11,4) AS VARCHAR(4))||'%'                              END                             )                     END                     )             END             AS VOL         FROM                 (             SELECT                 D.*,                 CASE                     WHEN                         CCY1 IN ('USD')                          THEN                             (                             CASE                                 WHEN                                     CCY2 IN                                          (                                         'BDT','BND','BTN','CNY','FJD','IDR','INR','KGS','KHR','KPW',                                         'KRW','LAK','LKR','MMK','MNT','MOP','MYR','NPR','PGK','PHP',                                         'PKR','SBD','SGD','THB','TJS','TMM','TOP','TWD','UZS','VND',                                         'VUV','WST','KRX','CNH'                                         ) THEN 'ASIA'                                 WHEN                                               CCY2 IN                                          (                                         'AMD','AZM','AZN','BAM','BGN','BYR','CSD','CZK','EEK','GEL','HRK',                                         'HUF','ISK','KZT','LTL','LVL','MDL','MKD','PLN','ROL','RON','RSD',                                         'RUB','SIT','SKK','TRL','TRY','UAH','AOA','BHD','BIF','BWP','CDF',                                         'CVE','DEM','DJF','DZD','EGP','ERN','ETB','GHC','GHS','GMD','GNF',                                         'GWP','ILS','IQD','IRR','JOD','KES','KMF','KWD','LBP','LRD','LSL',                                         'LYD','MAD','MRO','MUR','MVR','MWK','MZM','NAD','NGN','OMR',                                         'RWF','SCR','SDD','SHP','SLL','SOS','STD','SYP','SZL','TND','TZS',                                         'UGX','XOF','YER','ZAR','ZMK','ZWD','RBX','RU1','DKK'                                         ) THEN 'EMEA'                                 WHEN                                             CCY2 IN                                         (                                         'ANG','ARS','AWG','BBD','BMD','BOB','BOV','BRL','BSD','BZD',                                         'CLF','CLP','COP','CRC','CUP','DOP','ECU','FKP','GTQ','GYD','HNL',                                         'HTG','JMD','KYD','MXN','MXV','NIO','PAB','PEN','PYG','SVC',                                         'TTD','UYU','VEB','BRX'                                         ) THEN 'LATAM'                                 WHEN                                     CCY2 IN                                         (                                         'AUD','CAD','CHF','EUR','GBP','JPY','NOK','NZD','SEK'                                         ) THEN 'MAJORS'                                 WHEN                                     CCY2 IN                                         (                                         'HKD','AED','QAR','SAR'                                         ) THEN 'PEGGED'                                 WHEN                                     CCY2 IN                                         (                                         'USD','UBD'                                         ) THEN 'USD'                                 ELSE                                     CCY2                             END                             )                     ELSE                         (                             CASE                                 WHEN                                     CCY2 IN                                          (                                         'BDT','BND','BTN','CNY','FJD','IDR','INR','KGS','KHR','KPW',                                         'KRW','LAK','LKR','MMK','MNT','MOP','MYR','NPR','PGK','PHP',                                         'PKR','SBD','SGD','THB','TJS','TMM','TOP','TWD','UZS','VND',                                         'VUV','WST','HKD'                                         ) THEN 'ASIA'                                 WHEN                                               CCY2 IN                                          (                                         'AMD','AZM','AZN','BAM','BGN','BYR','CSD','CZK','EEK','GEL','HRK',                                         'HUF','ISK','KZT','LTL','LVL','MDL','MKD','PLN','ROL','RON','RSD',                                         'RUB','SIT','SKK','TRL','TRY','UAH','AOA','BHD','BIF','BWP','CDF',                                         'CVE','DEM','DJF','DZD','EGP','ERN','ETB','GHC','GHS','GMD','GNF',                                         'GWP','ILS','IQD','IRR','JOD','KES','KMF','KWD','LBP','LRD','LSL',                                         'LYD','MAD','MRO','MUR','MVR','MWK','MZM','NAD','NGN','OMR',                                         'RWF','SCR','SDD','SHP','SLL','SOS','STD','SYP','SZL','TND','TZS',                                         'UGX','XOF','YER','ZAR','ZMK','ZWD','AED','QAR','SAR'                                         ) THEN 'EMEA'                                 WHEN                                             CCY2 IN                                         (                                         'ANG','ARS','AWG','BBD','BMD','BOB','BOV','BRL','BSD','BZD',                                         'CLF','CLP','COP','CRC','CUP','DOP','ECU','FKP','GTQ','GYD','HNL',                                         'HTG','JMD','KYD','MXN','MXV','NIO','PAB','PEN','PYG','SVC',                                         'TTD','UYU','VEB'                                         ) THEN 'LATAM'                                 WHEN                                     CCY2 IN                                         (                                         'AUD','CAD','CHF','EUR','GBP','JPY','NOK','NZD','SEK'                                         ) THEN 'MAJORS'                                 WHEN                                     CCY2 IN                                         (                                         'DKK'                                         ) THEN 'PEGGED'                                 WHEN                                     CCY2 IN                                         (                                         'USD','UBD'                                         ) THEN 'USD'                                 ELSE                                     CCY2                             END                         )                 END                 AS REGION             FROM                     (                 SELECT                     C.*,                     CASE                         WHEN                             SUBSTR(C.CURRENCY_PAIR,1,3) IN ('EUR')                              THEN                                 (                                 CASE                                     WHEN                                          C.CURRENCY_PAIR IN ('EURUSD') THEN 'USD'                                     ELSE                                          'EUR'                                 END                                 )                         WHEN                             SUBSTR(C.CURRENCY_PAIR,1,3) IN ('USD') OR                             C.CURRENCY_PAIR IN ('GBPUSD','AUDUSD','NZDUSD')                              THEN 'USD'                         ELSE                             'OTHER'                     END                     AS CCY1,                     CASE                         WHEN                             SUBSTR(C.CURRENCY_PAIR,1,3) IN ('EUR')                              THEN                                 (                                 CASE                                     WHEN                                          C.CURRENCY_PAIR IN ('EURUSD') THEN 'EUR'                                     ELSE                                          SUBSTR(C.CURRENCY_PAIR,4,6)                                 END                                 )                         WHEN                             C.CURRENCY_PAIR IN ('GBPUSD','AUDUSD','NZDUSD')                             THEN SUBSTR(C.CURRENCY_PAIR,1,3)                         WHEN                             SUBSTR(C.CURRENCY_PAIR,1,3) IN ('USD')                             THEN SUBSTR(C.CURRENCY_PAIR,4,6)                         ELSE                             'OTHER'                     END                     AS CCY2                 FROM                     (                     SELECT                          A.STRESS_SCENARIO,                         TICKET,                         SUM                             (                             CASE                                  WHEN                                     PRODUCT_TYPE = 'FXOPT' AND                                      SCENARIO_TYPE = 'GREEK'                                      THEN SCENARIO_PNL                                 ELSE 0                             END                             ) AS SCENARIO_PNL,                          CASE                              WHEN                                  STRPOS(CURRENCY_PAIR, 'CNH') > 0                                 THEN REPLACE(CURRENCY_PAIR, 'CNH', 'CNY')                             WHEN                                  STRPOS(CURRENCY_PAIR, 'KRX') > 0                                 THEN REPLACE(CURRENCY_PAIR, 'KRX', 'KRW')                             WHEN                                  STRPOS(CURRENCY_PAIR, 'RBX') > 0                                 THEN REPLACE(CURRENCY_PAIR, 'RBX', 'RUB')                             WHEN                                 STRPOS(CURRENCY_PAIR, 'BRX') > 0                                 THEN REPLACE(CURRENCY_PAIR, 'BRX', 'BRL')                             WHEN                                 STRPOS(CURRENCY_PAIR, 'UBD') > 0                                 THEN REPLACE(CURRENCY_PAIR, 'UBD', 'USD')                             ELSE CURRENCY_PAIR                         END                          AS CURRENCY_PAIR                     FROM                          DWUSER.U_MODULAR_SCENARIOS A                     WHERE      COB_DATE = '2018-01-31' AND     CCC_TAPS_COMPANY IN ('0111') AND                         A.RUN_PROFILE = 'FXOPT_MOD_SCN_RUN' AND                          A.CCC_BUSINESS_AREA = 'FXEM MACRO TRADING' AND                          A.BOOK NOT IN                              (                             'BASKET','BASKET HEDGES','CEEMEA MULTICCY','CORRELATION SWAP',                             'CORRELATION SWAP 2','CORRELATION SWAP 3','CORRELATION SWAP 4',                             'DUAL CURRENCY','MULTICCY SPEC'                             ) AND                          A.PRODUCT_TYPE <> 'FXBSKT' AND                          A.STRESS_SCENARIO LIKE 'FX%' AND                         (                         STRESS_SCENARIO LIKE '%XXX%' AND                          SUBSTR(CURRENCY_PAIR, 1, 3) <> 'USD' AND                          SUBSTR(CURRENCY_PAIR, 4, 3) <> 'USD' AND                              (                             SUBSTR(CURRENCY_PAIR, 1, 3) = 'EUR' OR                              SUBSTR(CURRENCY_PAIR, 1, 3) = 'GBP' OR                              SUBSTR(CURRENCY_PAIR, 1, 3) = 'JPY' OR                              SUBSTR(CURRENCY_PAIR, 4, 3) = 'EUR' OR                              SUBSTR(CURRENCY_PAIR, 4, 3) = 'GBP' OR                              SUBSTR(CURRENCY_PAIR, 4, 3) = 'JPY'                             ) OR                          STRESS_SCENARIO NOT LIKE '%XXX%' AND                              (                             SUBSTR(CURRENCY_PAIR, 1, 3) <> 'EUR' AND                              SUBSTR(CURRENCY_PAIR, 1, 3) <> 'GBP' AND                              SUBSTR(CURRENCY_PAIR, 1, 3) <> 'JPY' AND                              SUBSTR(CURRENCY_PAIR, 4, 3) <> 'EUR' AND                              SUBSTR(CURRENCY_PAIR, 4, 3) <> 'GBP' AND                              SUBSTR(CURRENCY_PAIR, 4, 3) <> 'JPY'                             ) OR                          STRESS_SCENARIO NOT LIKE '%XXX%' AND                          CURRENCY_PAIR IN ('EURUSD','GBPUSD','USDJPY')                         ) AND                          EXCLUDE_CODE = 'Not Applicable' AND                         PRODUCT_TYPE IN ('FXOPT') AND                         STRESS_SCENARIO IN                              (                             'FX_M20_VOL_200','FX_M20_VOL_100','FX_M20_VOL_50','FX_M20_VOL_0','FX_M20_VOL_M50',                             'FX_M10_VOL_200','FX_M10_VOL_100','FX_M10_VOL_50','FX_M10_VOL_0','FX_M10_VOL_M50',                             'FX_0_VOL_200','FX_0_VOL_100','FX_0_VOL_50','FX_0_VOL_0','FX_0_VOL_M50',                             'FX_10_VOL_200','FX_10_VOL_100','FX_10_VOL_50','FX_10_VOL_0','FX_10_VOL_M50',                             'FX_20_VOL_200','FX_20_VOL_100','FX_20_VOL_50','FX_20_VOL_0','FX_20_VOL_M50',                             'FX_EURXXX_M20_VOL_200','FX_EURXXX_M20_VOL_100','FX_EURXXX_M20_VOL_50',                             'FX_EURXXX_M20_VOL_0','FX_EURXXX_M20_VOL_M50','FX_EURXXX_M10_VOL_200',                             'FX_EURXXX_M10_VOL_100','FX_EURXXX_M10_VOL_50','FX_EURXXX_M10_VOL_0',                             'FX_EURXXX_M10_VOL_M50','FX_EURXXX_0_VOL_200','FX_EURXXX_0_VOL_100',                             'FX_EURXXX_0_VOL_50','FX_EURXXX_0_VOL_0','FX_EURXXX_0_VOL_M50','FX_EURXXX_10_VOL_200',                             'FX_EURXXX_10_VOL_100','FX_EURXXX_10_VOL_50','FX_EURXXX_10_VOL_0','FX_EURXXX_10_VOL_M50',                             'FX_EURXXX_20_VOL_200','FX_EURXXX_20_VOL_100','FX_EURXXX_20_VOL_50','FX_EURXXX_20_VOL_0',                             'FX_EURXXX_20_VOL_M50'                             )                     GROUP BY                          A.STRESS_SCENARIO,                         A.TICKET,                         CASE                              WHEN                                  STRPOS(CURRENCY_PAIR, 'CNH') > 0                                 THEN REPLACE(CURRENCY_PAIR, 'CNH', 'CNY')                             WHEN                                  STRPOS(CURRENCY_PAIR, 'KRX') > 0                                 THEN REPLACE(CURRENCY_PAIR, 'KRX', 'KRW')                             WHEN                                  STRPOS(CURRENCY_PAIR, 'RBX') > 0                                 THEN REPLACE(CURRENCY_PAIR, 'RBX', 'RUB')                             WHEN                                 STRPOS(CURRENCY_PAIR, 'BRX') > 0                                 THEN REPLACE(CURRENCY_PAIR, 'BRX', 'BRL')                             WHEN                                 STRPOS(CURRENCY_PAIR, 'UBD') > 0                                 THEN REPLACE(CURRENCY_PAIR, 'UBD', 'USD')                             ELSE CURRENCY_PAIR                         END                      ) C                 ) D             ) E         ) F     LEFT JOIN          TICKET_LIST TK     ON          F.MAPPING = TK.MAPPING AND         F.CURRENCY_PAIR = TK.CURRENCY_PAIR AND         F.TICKET = TK.TICKET AND          F.SPOT = TK.SPOT AND         F.VOL = TK.VOL     GROUP BY         F.MAPPING,         F.CURRENCY_PAIR,         F.SPOT,         F.VOL,             TK.SPOT,         TK.VOL     ) G WHERE     G.SPOT2 IS NULL OR     G.VOL2 IS NULL GROUP BY     G.MAPPING,     G.CURRENCY_PAIR,     G.SPOT,     G.VOL