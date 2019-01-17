SELECT a.COB_DATE, sum(a.USD_CM_KAPPA) as USD_CM_KAPPA FROM CDWUSER.U_DM_EQ a WHERE a.COB_DATE in ('2018-02-28','2018-01-31') AND a.CCC_BANKING_TRADING = 'TRADING' AND a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.PRODUCT_TYPE_CODE = 'COMM' GROUP BY a.COB_DATE