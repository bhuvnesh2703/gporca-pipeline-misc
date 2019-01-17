SELECT            COB_DATE,            source_scn_name,            CURRENCY_PAIR,            BU_RISK_SYSTEM,             SUM (raw_pnl) / 1000 AS PNL         FROM DWUSER.U_RAW_SCENARIO_PNL  WHERE COB_DATE = '2018-02-28'            and CCC_BUSINESS_AREA = 'FXEM MACRO TRADING' AND             PRODUCT_TYPE IN ('FXOPT') AND            source_scn_name in ( 'BHC2017_S1_FX_ALL' ,'BHC2017_S1_FX_Spot','BHC2017_S1_FX_ATM_Vol')            AND             BU_RISK_SYSTEM LIKE '%FXOPT%'         GROUP BY             COB_DATE,             source_scn_name             ,CURRENCY_PAIR             ,BU_RISK_SYSTEM                          union all                          SELECT            COB_DATE,            CASE WHEN SOURCE_SCN_NAME in ( 'BHC2017_S1_FX_Spot', 'BHC2017_S1_FX_ATM_Vol')             THEN 'BHC2017_S1_FX_ALL' END,            CURRENCY_PAIR,            BU_RISK_SYSTEM,             SUM (raw_pnl) / 1000 AS PNL         FROM DWUSER.U_RAW_SCENARIO_PNL  WHERE COB_DATE = '2018-02-28'            and CCC_BUSINESS_AREA = 'FXEM MACRO TRADING' AND             PRODUCT_TYPE IN ('FXOPT') AND             SOURCE_SCN_NAME in (  'BHC2017_S1_FX_Spot',  'BHC2017_S1_FX_ATM_Vol'  )              AND BU_RISK_SYSTEM LIKE '%FXOPT%'                          and ticket in  (SELECT distinct ticket  FROM DWUSER.U_MODULAR_SCENARIO_DQ WHERE COB_DATE = '2018-02-28' AND FULL_REVAL_SCENARIO_NAME = 'BHC2017_S1_FX_ALL'  and slice_name like '%FXOPT%' )         GROUP BY             COB_DATE,             source_scn_name             ,CURRENCY_PAIR             ,BU_RISK_SYSTEM