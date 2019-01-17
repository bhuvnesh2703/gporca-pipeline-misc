SELECT a.COB_Date         ,a.CCC_BUSINESS_AREA         ,SUM(a.USD_NOTIONAL) AS NOTIONAL FROM cdwuser.U_DM_CVA a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-01-31') and           a.CCC_BUSINESS_AREA IN (                 'MS CVA MNE - FID'                 ,'MS CVA MNE - COMMOD'                 )         AND a.IS_HEDGE_INSTRUMENT = 'Y'         AND a.USD_NOTIONAL IS NOT NULL         AND a.BU_RISK_SYSTEM LIKE 'C1%'         AND a.ccc_product_line NOT IN (                 'CREDIT LOAN PORTFOLIO'                 ,'CMD STRUCTURED FINANCE'                 )         AND a.PRODUCT_SUB_TYPE_CODE NOT IN (                 'MNE'                 ,'MNE_FVA_NET'                 ) AND A.CURVE_NAME <> 'ms_seccpm' GROUP BY a.COB_Date         ,a.CCC_BUSINESS_AREA