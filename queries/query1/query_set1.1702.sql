select A.COB_DATE, a.CURRENCY_OF_MEASURE, a.CURVE_NAME,  CASE WHEN a.CCC_DIVISION IN('FIXED INCOME DIVISION','INSTITUTIONAL EQUITY DIVISION') THEN a.CCC_DIVISION ELSE 'OTHER' END AS CCC_DIVISION, CASE WHEN CCC_TAPS_COMPANY IN('7325','5972') THEN 'Caieiras Fundo de Investimento (5972, 7325)'  WHEN CCC_TAPS_COMPANY IN('4171','0921','6411') THEN 'Banco Morgan Stanley S.A. (0921, 4171, 6411)'  WHEN CCC_TAPS_COMPANY='0925' THEN  'Morgan Stanley Corretora de Titulos e Valores Mobiliarios (0925)'  WHEN CCC_TAPS_COMPANY IN('8890','8840','4171','0921','0925','5972','7325','6411') THEN CCC_TAPS_COMPANY ELSE 'OTHERS' END AS LEGAL_ENTITY, CASE WHEN A.PRODUCT_TYPE_CODE IN('CAP','FLOOR','SWAPTION') THEN 'OPTION' ELSE A.PRODUCT_TYPE_CODE END AS PRODUCT_TYPE_CODE, sum(a.USD_FX_KAPPA) as USD_FX_KAPPA from cdwuser.U_fx_MSR a WHERE cob_date in ('2018-02-28','2018-02-27') and a.VAR_EXCL_FL='N' and a.CCC_TAPS_COMPANY in ('8890','8840') GROUP BY a.CURRENCY_OF_MEASURE, a.CURVE_NAME,a.CCC_DIVISION,A.CCC_TAPS_COMPANY,A.COB_DATE,A.TERM_OF_MEASURE, CASE WHEN A.PRODUCT_TYPE_CODE IN('CAP','FLOOR','SWAPTION') THEN 'OPTION' ELSE A.PRODUCT_TYPE_CODE END