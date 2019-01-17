SELECT a.COB_DATE, sum(a.USD_CM_DELTA_DECOMP) as USD_CM_DELTA FROM CDWUSER.U_DM_EQ a WHERE a.COB_DATE in ('2018-02-28','2018-02-27') AND a.CCC_BANKING_TRADING = 'TRADING' AND a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' GROUP BY a.COB_DATE