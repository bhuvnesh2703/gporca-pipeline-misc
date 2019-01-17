select a.cob_date ,sum(coalesce(a. USD_IR_UNIFIED_PV01,0)) as USD_IR_UNIFIED_PV01 ,sum(coalesce(a.USD_PV10_Bench,0)+coalesce(a.USD_Credit_PV10PCT,0)) as USD_CR_PV10 ,sum(coalesce(a.USD_CR_KAPPA,0)) as USD_CR_Kappa ,sum(coalesce(a.USD_FX_KAPPA,0)) as USD_FX_KAPPA ,sum(coalesce(a.USD_FX,0)) as USD_FX , sum(coalesce(a. USD_PV01SPRD,0)) as USD_PV01SPRD From cdwuser.U_DM_EQ a where (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-21') and a.IS_UK_GROUP = 'Y' AND a.CCC_DIVISION='INSTITUTIONAL EQUITY DIVISION'  AND  a.CCC_BANKING_TRADING<>'BANKING' Group by a.cob_date