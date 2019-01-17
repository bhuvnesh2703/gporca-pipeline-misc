SELECT a.COB_DATE, (sum(a.USD_PV10_BENCH) + sum(a.USD_CREDIT_PV10PCT)) as CRPV10, sum(coalesce(a.USD_CR_KAPPA,0)) as USD_CR_KAPPA, sum(a.USD_FX_KAPPA) as USD_FX_KAPPA, sum(coalesce(a.USD_CORR01_ATTACH,0)) as USD_CORR01_ATTACH, sum(a.USD_EQ_DISC_RISK) as USD_EQ_DISC_RISK FROM CDWUSER.U_DM_EQ a WHERE a.COB_DATE in ('2018-02-28','2018-02-27') AND a.CCC_BANKING_TRADING = 'TRADING' AND a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' GROUP BY a.COB_DATE