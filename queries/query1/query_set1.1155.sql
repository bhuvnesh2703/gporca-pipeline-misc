Select CASE WHEN a.CCC_PL_REPORTING_REGION='AMERICAS' THEN 'US' WHEN a.CCC_PL_REPORTING_REGION='EMEA' THEN 'EUROPE' ELSE 'ASIA' END AS CCC_PL_REPORTING_REGION, CASE WHEN a.CREDIT_SPREAD>250 THEN '>250' ELSE '<250' END AS CREDIT_SPREAD_BUCKETS, sum(a.USD_PV01SPRD)/1000 as CS01 From CDWUSER.U_EXP_MSR a WHERE a.COB_DATE IN ('2018-02-28') AND a.CCC_BANKING_TRADING='TRADING' AND a.CCC_DIVISION='INSTITUTIONAL EQUITY DIVISION' Group by CASE WHEN a.CCC_PL_REPORTING_REGION='AMERICAS' THEN 'US' WHEN a.CCC_PL_REPORTING_REGION='EMEA' THEN 'EUROPE' ELSE 'ASIA' END, CASE WHEN a.CREDIT_SPREAD>250 THEN '>250' ELSE '<250' END