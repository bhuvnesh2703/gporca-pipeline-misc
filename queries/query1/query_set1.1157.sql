SELECT CASE WHEN a.CCC_PL_REPORTING_REGION='AMERICAS' THEN 'US' WHEN a.CCC_PL_REPORTING_REGION='EMEA' THEN 'EUROPE' ELSE 'ASIA' END AS CCC_PL_REPORTING_REGION, a.COB_DATE, SUM (a.USD_CREDIT_PV10PCT) / 1000 AS Credit_PV10 FROM CDWUSER.U_EXP_MSR a WHERE a.COB_DATE IN ('2018-02-28') AND a.CCC_BANKING_TRADING = 'TRADING' AND a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' GROUP BY CASE WHEN a.CCC_PL_REPORTING_REGION='AMERICAS' THEN 'US' WHEN a.CCC_PL_REPORTING_REGION='EMEA' THEN 'EUROPE' ELSE 'ASIA' END, a.COB_DATE