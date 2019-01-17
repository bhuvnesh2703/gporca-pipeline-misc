SELECT a.COB_Date, a.CCC_BUSINESS_AREA,  MNE_FLAG, SUM(a.USD_PV10_BENCH_COMP) AS PV10 FROM cdwuser.U_DM_CVA a WHERE  (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and CCC_PL_REPORTING_REGION in ('EMEA') AND   a.CCC_BUSINESS_AREA IN ('MS CVA MNE - FID', 'MS CVA MNE - COMMOD') and a.ccc_product_line not in ('CREDIT LOAN PORTFOLIO','CMD STRUCTURED FINANCE') AND a.USD_PV10_BENCH_COMP IS NOT NULL GROUP BY a.COB_Date, a.CCC_BUSINESS_AREA, MNE_FLAG