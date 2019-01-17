SELECT A.COB_DATE, A.BOOK, a.BOOK_STRATEGY, A.CURRENCY_OF_MEASURE, A.INDEX_MAPPING, A.XCCY_MAPPING, A.DEBT_PROFILE_MAPPING, A.CUSIP, CASE WHEN A.DEBT_PROFILE_MAPPING IN ('FIXED DEBT', 'FLOATING RATE DEBT','EQ SN','FID SN') THEN 'DEBT ISSUANCE' WHEN A.DEBT_PROFILE_MAPPING IN ('FIXED-FLOAT SWAP') THEN 'FIXED-FLOAT SWAP' WHEN A.DEBT_PROFILE_MAPPING IN ('FLOAT-FLOAT SWAP') THEN 'FLOAT-FLOAT SWAP' ELSE A.DEBT_PROFILE_MAPPING END AS DEBT_STACK_BUCKETING, SUM (A.USD_NOTIONAL) AS USD_NOTIONAL FROM ( select A.COB_DATE, a.BOOK, a.BOOK_STRATEGY, case when a.CURRENCY_OF_MEASURE not in ('USD','EUR','GBP', 'JPY') THEN 'OTHER' ELSE A.CURRENCY_OF_MEASURE END AS CURRENCY_OF_MEASURE, a.INDEX_MAPPING, a.XCCY_MAPPING, A.CUSIP, case WHEN A.BOOK IN ('TYGAS') THEN 'FID SN' when a.BOOK in ('TDCLH', 'TKLON') then 'FIXED DEBT' when a.BOOK in ('SWCLH') THEN 'FIXED-FLOAT SWAP' WHEN A.BOOK IN ('SWCOH') THEN 'FLOAT-FLOAT SWAP' ELSE A.DEBT_PROFILE_MAPPING END AS DEBT_PROFILE_MAPPING, A.USD_NOTIONAL from cdwuser.U_DM_TREASURY a WHERE cob_date in ('2018-02-28', '2018-02-21', '2018-01-31', '2017-12-29', '2017-11-30') AND A.DATASET_TYPE = 'LRV' AND A.EXPIRATION_DATE > A.COB_DATE union all select A.COB_DATE, a.BOOK, a.BOOK_STRATEGY, case when a.CURRENCY_OF_MEASURE not in ('USD','EUR','GBP', 'JPY') THEN 'OTHER' ELSE A.CURRENCY_OF_MEASURE END AS CURRENCY_OF_MEASURE, case when a.INDEX_MAPPING IS NULL then 'Fixed' else a.INDEX_MAPPING end as INDEX_MAPPING, a.XCCY_MAPPING, A.CUSIP, CASE WHEN A.DEBT_PROFILE_MAPPING IS NULL THEN 'FIXED DEBT' else a.DEBT_PROFILE_MAPPING end as DEBT_PROFILE_MAPPING, abs(A.USD_NOTIONAL*1000) from cdwuser.U_DM_TREASURY a WHERE cob_date in ('2018-02-28', '2018-02-21', '2018-01-31', '2017-12-29', '2017-11-30') AND A.DATASET_TYPE = 'MRD' AND A.BOOK_STRATEGY = 'Accrual Callable' )A where a.DEBT_PROFILE_MAPPING <> 'EXCLUDED' GROUP BY A.COB_DATE, A.BOOK, a.BOOK_STRATEGY, A.CURRENCY_OF_MEASURE, A.INDEX_MAPPING, A.XCCY_MAPPING, A.DEBT_PROFILE_MAPPING, A.CUSIP, CASE WHEN A.DEBT_PROFILE_MAPPING IN ('FIXED DEBT', 'FLOATING RATE DEBT','EQ SN','FID SN') THEN 'DEBT ISSUANCE' WHEN A.DEBT_PROFILE_MAPPING IN ('FIXED-FLOAT SWAP') THEN 'FIXED-FLOAT SWAP' WHEN A.DEBT_PROFILE_MAPPING IN ('FLOAT-FLOAT SWAP') THEN 'FLOAT-FLOAT SWAP' ELSE A.DEBT_PROFILE_MAPPING END