SELECT x.COB_DATE, x.SOURCE, x.CCC_PL_REPORTING_REGION, SUM(x.DELTA) AS DELTA, SUM(x.ABS_Delta) AS GROSS_DELTA FROM  (SELECT  d.COB_DATE, 'EMEA' as SOURCE, d.ISSUE_ID_DECOMP,  d.CCC_PL_REPORTING_REGION, SUM(COALESCE(d.USD_EQ_DELTA_DECOMP,0)) AS Delta, ABS(SUM(COALESCE(d.USD_EQ_DELTA_DECOMP,0))) AS ABS_Delta FROM CDWUSER.U_DECOMP_MSR d WHERE  (d.COB_DATE = '2018-02-28' or d.COB_DATE = '2018-02-21')  AND d.SILO_SRC = 'IED' AND d.DIVISION = 'IED' AND d.CCC_BANKING_TRADING<>'BANKING' AND d.CCC_PL_REPORTING_REGION = 'EMEA' AND (d.CASH_ISSUE_TYPE <>'COMM' OR d.CASH_ISSUE_TYPE IS NULL)      GROUP BY  d.COB_DATE, d.CCC_PL_REPORTING_REGION, d.ISSUE_ID_DECOMP) x      GROUP BY x.COB_DATE, x.SOURCE, x.CCC_PL_REPORTING_REGION