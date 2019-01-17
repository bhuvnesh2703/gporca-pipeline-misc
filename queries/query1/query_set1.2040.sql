SELECT     a.COB_DATE,     a.CURRENCY_OF_MEASURE,     CASE          WHEN a.TERM_NEW <= 1 THEN '0-1y'         WHEN a.TERM_NEW > 1 AND a.TERM_NEW <= 5 THEN '1-5y'         WHEN a.TERM_NEW > 5 AND a.TERM_NEW <= 10 THEN '5-10y'         WHEN a.TERM_NEW > 10 AND a.TERM_NEW <= 15 THEN   '10-15y'     ELSE '15+y' END AS TERM_NEW_GROUP,     SUM (a.USD_IR_UNIFIED_PV01) AS usd_ir_unified_pv01 FROM cdwuser.U_IR_MSR_INTRPLT a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and A.CCC_TAPS_COMPANY in ('0362','0816') AND      a.CCC_DIVISION IN ('FIXED INCOME DIVISION') AND     /*a.CCC_BUSINESS_AREA NOT IN ('COMMODITIES') AND*/       CCC_BANKING_TRADING IN ('TRADING') AND     (a.vertical_system LIKE ('FXDDI%') or a.vertical_system LIKE ('FXOPT%')) AND     a.CURRENCY_OF_MEASURE<>'USD' GROUP BY     a.COB_DATE,     a.CURRENCY_OF_MEASURE,     CASE          WHEN a.TERM_NEW <= 1 THEN '0-1y'         WHEN a.TERM_NEW > 1 AND a.TERM_NEW <= 5 THEN '1-5y'         WHEN a.TERM_NEW > 5 AND a.TERM_NEW <= 10 THEN '5-10y'         WHEN a.TERM_NEW > 10 AND a.TERM_NEW <= 15 THEN   '10-15y'     ELSE '15+y' END