With a as ( SELECT a.COB_DATE, a.REFERENCE_INDEX_ENTITY_NAME, a.REFERENCE_ENTITY_NAME, a.PRODUCT_TYPE_CODE, a.TICKET, a.CR_OPTION_EXPIRY_DATE, CASE WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 7 ) THEN '<1W' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 7 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 14 ) THEN '1-2W' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 14 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 30 ) THEN '2W-1M' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 30 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 91 ) THEN '1-3M' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 91 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 183 ) THEN '3-6M' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 183 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 365 ) THEN '6-12M' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 365 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 1096 ) THEN '1-3Y' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 1096 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 1826 ) THEN '3-5Y' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 1826 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 3652 ) THEN '5-10Y' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 3652 ) THEN '>10Y' ELSE 'N/A' END AS EXPIRY_BUCKET, a.STRIKE, sum(coalesce(a.USD_INDEX_PV01,0)) as USD_INDEX_PV01, sum(coalesce(a.USD_CREDIT_GAMMA,0))/10000 as USD_CREDIT_GAMMA, sum(coalesce(a.USD_CR_KAPPA,0)) as USD_CR_KAPPA, sum(coalesce(a.USD_IR_THETA,0)) as USD_IR_THETA, sum(coalesce(a.USD_OPTION_POSITION,0)) as USD_OPTION_POSITION, sum(coalesce(a.USD_MARKET_VALUE,0)) as USD_MARKET_VALUE, sum(coalesce(a.USD_NOTIONAL,0)) as USD_NOTIONAL, sum(coalesce(a.LCY_NOTIONAL,0)) as LCY_NOTIONAL, sum(coalesce(a.USD_DELTA_ADJ_NOTIONAL,0)) as USD_DELTA_ADJ_NOTIONAL, sum(coalesce(a.USD_REALIZED_PL,0)) as USD_REALIZED_PL, sum(coalesce(a.LCY_REALIZED_PL,0)) as LCY_REALIZED_PL, sum(coalesce(a.SLIDE_PVSPRCOMP_MIN_50PCT_USD,0)) as SLIDE_PVSPRCOMP_MIN_50PCT_USD, sum(coalesce(a.SLIDE_PVSPRCOMP_PLS_100BP_USD,0)) as SLIDE_PVSPRCOMP_PLS_100BP_USD, sum(coalesce(a.SLIDE_PVSPRCOMP_PLS_100PCT_USD,0)) as SLIDE_PVSPRCOMP_PLS_100PCT_USD FROM CDWUSER.U_EXP_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.LE_GROUP = 'UK' AND a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_BUSINESS_AREA = 'DSP - CREDIT' AND ((a.CCC_STRATEGY IN ('EU INDEX OPTIONS') and a.book not in ('ABNMG')) or a.book in ('ABCHN')) AND a.PRODUCT_TYPE_CODE ='CDSOPTIDX' AND a.REFERENCE_INDEX_ENTITY_NAME = a.REFERENCE_ENTITY_NAME GROUP BY a.COB_DATE, a.REFERENCE_INDEX_ENTITY_NAME, a.REFERENCE_ENTITY_NAME, a.PRODUCT_TYPE_CODE, a.TICKET, a.STRIKE, a.CR_OPTION_EXPIRY_DATE, CASE WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 7 ) THEN '<1W' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 7 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 14 ) THEN '1-2W' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 14 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 30 ) THEN '2W-1M' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 30 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 91 ) THEN '1-3M' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 91 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 183 ) THEN '3-6M' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 183 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 365 ) THEN '6-12M' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 365 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 1096 ) THEN '1-3Y' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 1096 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 1826 ) THEN '3-5Y' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 1826 AND (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) <= 3652 ) THEN '5-10Y' WHEN ( (a.CR_OPTION_EXPIRY_DATE) - (a.COB_DATE) > 3652 ) THEN '>10Y' ELSE 'N/A' END ), b as ( SELECT DISTINCT b.COB_DATE, b.TICKET, b.CREDIT_SPREAD, b.STRIKE, b.CREDIT_VOL_MARK, b.MONEYNESS_PERCENTAGE, CASE WHEN b.MONEYNESS_PERCENTAGE+1 IS NULL THEN CAST (NULL AS VARCHAR(7)) WHEN (b.MONEYNESS_PERCENTAGE+1 <= 0.7) THEN '< 70%' WHEN b.MONEYNESS_PERCENTAGE+1 > 0.7 AND b.MONEYNESS_PERCENTAGE+1 <= 0.75 THEN '70-75%' WHEN b.MONEYNESS_PERCENTAGE+1 > 0.75 AND b.MONEYNESS_PERCENTAGE+1 <= 0.8 THEN '75-80%' WHEN b.MONEYNESS_PERCENTAGE+1 > 0.8 AND b.MONEYNESS_PERCENTAGE+1 <= 0.85 THEN '80-85%' WHEN b.MONEYNESS_PERCENTAGE+1 > 0.85 AND b.MONEYNESS_PERCENTAGE+1 <= 0.9 THEN '85-90%' WHEN b.MONEYNESS_PERCENTAGE+1 > 0.9 AND b.MONEYNESS_PERCENTAGE+1 <= 0.95 THEN '90-95%' WHEN b.MONEYNESS_PERCENTAGE+1 > 0.95 AND b.MONEYNESS_PERCENTAGE+1 <= 0.96 THEN '95-96%' WHEN b.MONEYNESS_PERCENTAGE+1 > 0.96 AND b.MONEYNESS_PERCENTAGE+1 <= 0.97 THEN '96-97%' WHEN b.MONEYNESS_PERCENTAGE+1 > 0.97 AND b.MONEYNESS_PERCENTAGE+1 <= 0.98 THEN '97-98%' WHEN b.MONEYNESS_PERCENTAGE+1 > 0.98 AND b.MONEYNESS_PERCENTAGE+1 <= 0.99 THEN '98-99%' WHEN b.MONEYNESS_PERCENTAGE+1 > 0.99 AND b.MONEYNESS_PERCENTAGE+1 <= 1.0 THEN '99-100%' WHEN b.MONEYNESS_PERCENTAGE+1 > 1.0 AND b.MONEYNESS_PERCENTAGE+1 <= 1.01 THEN '100-101%' WHEN b.MONEYNESS_PERCENTAGE+1 > 1.01 AND b.MONEYNESS_PERCENTAGE+1 <= 1.02 THEN '101-102%' WHEN b.MONEYNESS_PERCENTAGE+1 > 1.02 AND b.MONEYNESS_PERCENTAGE+1 <= 1.03 THEN '102-103%' WHEN b.MONEYNESS_PERCENTAGE+1 > 1.03 AND b.MONEYNESS_PERCENTAGE+1 <= 1.04 THEN '103-104%' WHEN b.MONEYNESS_PERCENTAGE+1 > 1.04 AND b.MONEYNESS_PERCENTAGE+1 <= 1.05 THEN '104-105%' WHEN b.MONEYNESS_PERCENTAGE+1 > 1.05 AND b.MONEYNESS_PERCENTAGE+1 <= 1.1 THEN '105-110%' WHEN b.MONEYNESS_PERCENTAGE+1 > 1.1 AND b.MONEYNESS_PERCENTAGE+1 <= 1.15 THEN '110-115%' WHEN b.MONEYNESS_PERCENTAGE+1 > 1.15 AND b.MONEYNESS_PERCENTAGE+1 <= 1.2 THEN '115-120%' WHEN b.MONEYNESS_PERCENTAGE+1 > 1.2 AND b.MONEYNESS_PERCENTAGE+1 <= 1.25 THEN '120-125%' WHEN b.MONEYNESS_PERCENTAGE+1 > 1.25 AND b.MONEYNESS_PERCENTAGE+1 <= 1.3 THEN '125-130%' WHEN b.MONEYNESS_PERCENTAGE+1 > 1.3 THEN '>130%' ELSE CAST (NULL AS VARCHAR(7)) END As MONEYNESS_BUCKET FROM CDWUSER.U_EXP_MSR b WHERE b.COB_DATE = '2018-02-28' AND b.LE_GROUP = 'UK' AND b.CCC_DIVISION = 'FIXED INCOME DIVISION' AND b.CCC_BUSINESS_AREA = 'DSP - CREDIT' AND ((b.CCC_STRATEGY IN ('EU INDEX OPTIONS') and b.book not in ('ABNMG')) or b.book in ('ABCHN')) AND b.PRODUCT_TYPE_CODE ='CDSOPTIDX' AND b.REFERENCE_INDEX_ENTITY_NAME = b.REFERENCE_ENTITY_NAME AND b.CREDIT_SPREAD <> 0 ), z as ( SELECT a.TICKET, CASE WHEN a.USD_CR_KAPPA > 0 THEN 'Buy' ELSE 'Sell' END AS LONG_SHORT_FLAG, CASE WHEN a.USD_CR_KAPPA > 0 AND a.USD_INDEX_PV01 > 0 THEN 'Payer' WHEN a.USD_CR_KAPPA > 0 AND a.USD_INDEX_PV01 < 0 THEN 'Receiver' WHEN a.USD_CR_KAPPA < 0 AND a.USD_INDEX_PV01 > 0 THEN 'Receiver' WHEN a.USD_CR_KAPPA < 0 AND a.USD_INDEX_PV01 < 0 THEN 'Payer' END AS PAYER_RECEIVER_FLAG, a.REFERENCE_INDEX_ENTITY_NAME, a.CR_OPTION_EXPIRY_DATE, a.EXPIRY_BUCKET, a.STRIKE, b.CREDIT_SPREAD, b.CREDIT_VOL_MARK, b.MONEYNESS_PERCENTAGE +1 as MONEYNESS_PERCENTAGE, b.MONEYNESS_BUCKET, a.USD_INDEX_PV01, a.USD_CREDIT_GAMMA, a.USD_CR_KAPPA, a.USD_OPTION_POSITION, a.USD_MARKET_VALUE, a.USD_NOTIONAL, a.LCY_NOTIONAL, a.USD_DELTA_ADJ_NOTIONAL, a.USD_REALIZED_PL, a.LCY_REALIZED_PL, a.SLIDE_PVSPRCOMP_MIN_50PCT_USD, a.SLIDE_PVSPRCOMP_PLS_100BP_USD, a.SLIDE_PVSPRCOMP_PLS_100PCT_USD FROM a JOIN b ON (a.COB_DATE,a.TICKET) = (b.COB_DATE,b.TICKET) WHERE a.USD_OPTION_POSITION <> 0 ) SELECT TICKET || ' ' || extract(DAY from (CR_OPTION_EXPIRY_DATE)) || SUBSTR(to_char(CR_OPTION_EXPIRY_DATE,'mon'), 1, 3) || SUBSTR(extract(YEAR from (CR_OPTION_EXPIRY_DATE)), 3, 2) || ' ' || CASE WHEN posstr(CAST (STRIKE AS DECIMAL(20,2)),'.') <> 0 AND SUBSTR(CAST (STRIKE AS DECIMAL(20,2)),posstr(CAST (STRIKE AS DECIMAL(20,2)),'.')+1,1) <> 0 THEN CAST(CAST(STRIKE AS DECIMAL(20, 1)) AS DECIMAL(20, 2)) WHEN posstr(CAST (STRIKE AS DECIMAL(20,2)),'.') <> 0 AND SUBSTR(CAST (STRIKE AS DECIMAL(20,2)),posstr(CAST (STRIKE AS DECIMAL(20,2)),'.')+2,1) <> 0 THEN CAST(CAST(STRIKE AS DECIMAL(20, 2)) AS DECIMAL(20, 2)) ELSE STRIKE END || ' ' || LONG_SHORT_FLAG AS POSITION_ID, MONEYNESS_PERCENTAGE, CREDIT_VOL_MARK, USD_CREDIT_GAMMA FROM z WHERE PAYER_RECEIVER_FLAG = 'Receiver' AND CR_OPTION_EXPIRY_DATE <= '2018-03-21' AND (MONEYNESS_PERCENTAGE >= 0.95 AND MONEYNESS_PERCENTAGE <= 1.05) ORDER BY abs(USD_CREDIT_GAMMA) desc FETCH FIRST 25 ROWS ONLY