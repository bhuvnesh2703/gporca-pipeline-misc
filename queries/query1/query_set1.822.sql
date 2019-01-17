SELECT a.cob_date         ,a.CURRENCY_OF_MEASURE ,TYPE_FLAG   ,CASE When a.CCC_PRODUCT_LINE = 'XVA HEDGING'  Then 'FIC'         ELSE 'EQ' END AS DIVISION         ,SUM(a.USD_IR_PV01_BREAKEVEN) AS BREAKEVEN FROM cdwuser.U_DM_CVA a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-21') and                  (a.CCC_BUSINESS_AREA IN (                         'CPM'                         ,'CPM TRADING (MPE)'                         ,'CREDIT'                         ,'MS CVA MNE - FID'                         ,'MS CVA MNE - COMMOD'                         )                 OR a.CCC_STRATEGY IN (                         'MS CVA MPE - DERIVATIVES'                         ,'MS CVA MNE - DERIVATIVES','EQ XVA HEDGING'                         )                 )         AND a.ccc_product_line NOT IN (                 'CREDIT LOAN PORTFOLIO'                 ,'CMD STRUCTURED FINANCE'                 )         AND a.PRODUCT_SUB_TYPE_CODE NOT IN (                 'MNE'                 ,'MNE_FVA_NET'                 )         AND a.USD_IR_PV01_BREAKEVEN IS NOT NULL AND A.CURVE_NAME <> 'ms_seccpm' GROUP BY a.cob_date         ,a.CURRENCY_OF_MEASURE ,TYPE_FLAG         ,a.CCC_PRODUCT_LINE