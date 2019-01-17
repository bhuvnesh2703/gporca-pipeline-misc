SELECT  a.COB_DATE, a.CURRENCY_OF_MEASURE, a.type_flag, CASE When a.CCC_PRODUCT_LINE = 'XVA HEDGING'  Then 'FIC' ELSE 'EQ' END AS DIVISION, SUM(a.USD_FX) AS FX FROM cdwuser.U_DM_CVA a WHERE  (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and CCC_PL_REPORTING_REGION in ('EMEA') AND    (a.CCC_BUSINESS_AREA IN ('CPM', 'CPM TRADING (MPE)','CREDIT','MS CVA MNE - FID', 'MS CVA MNE - COMMOD')  OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES','EQ XVA HEDGING')) and a.ccc_product_line not in ('CREDIT LOAN PORTFOLIO','CMD STRUCTURED FINANCE') GROUP BY a.COB_DATE, a.CURRENCY_OF_MEASURE, CCC_PRODUCT_LINE ,a.type_flag