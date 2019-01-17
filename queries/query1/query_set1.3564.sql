SELECT a.COB_DATE as COB_DATE, a.CURRENCY_OF_MEASURE as CURRENCY_OF_MEASURE, a.CURRENCY_BASIS_STYLE as CURRENCY_BASIS_STYLE, a.BASIS_TYPE as BASIS_TYPE, sum(a.usd_irpv01sprd) as LIBOR_BASIS, abs(sum(a.usd_irpv01sprd)) as LIBOR_BASIS_ABS FROM ( SELECT COB_DATE, CURRENCY_OF_MEASURE, '3M LIBOR based' as CURRENCY_BASIS_STYLE, SUM(case when book not in ('TSTCH', 'TSTGB', 'TSTOL') then usd_irpv01sprd else 0 end) AS usd_irpv01sprd, '3M-OIS' as BASIS_TYPE FROM cdwuser.u_ir_msr where CCC_DIVISION = 'TREASURY CAPITAL MARKETS' and CCC_BUSINESS_AREA not in ('MS BANK - PRIVATE BANK1') and CCC_STRATEGY not in ('STRUCTURED N', 'L-TERM DEBT SN', 'L-TERM DEBT SN ALLOC') and curve_name in ('eurnw_3m') and book NOT IN ('AEOEQ', 'LIABB', 'TRPFD', 'PRFEQ', 'TDET2', 'TDET4', 'TDET5', 'TDET6', 'TDET7', 'TDET8', 'LHRO1', 'LHRO2','TSYGLRCSH') and cob_date in ('2018-02-28', '2018-02-27') group by cob_date, currency_of_measure UNION ALL SELECT COB_DATE, CURRENCY_OF_MEASURE, 'OIS based' as CURRENCY_BASIS_STYLE, CASE WHEN currency_of_measure in ('JPY', 'CHF') THEN SUM(usd_irpv01sprd) - SUM(usd_ir_unified_pv01) WHEN currency_of_measure in ('GBP') THEN SUM(case when book not in ('TSTCH', 'TSTGB', 'TSTOL') then usd_irpv01sprd else 0 end) - SUM(usd_ir_unified_pv01) ELSE sum(usd_irpv01sprd) END as usd_irpv01sprd, '3M-OIS' as BASIS_TYPE from cdwuser.u_ir_msr where CCC_DIVISION = 'TREASURY CAPITAL MARKETS' and CCC_BUSINESS_AREA not in ('MS BANK - PRIVATE BANK1') and CCC_STRATEGY not in ('STRUCTURED N', 'L-TERM DEBT SN', 'L-TERM DEBT SN ALLOC') and curve_name in ('chfnw_3m', 'chfnw_disc','gbpnw_disc', 'jpynw_3m','jpynw_disc') and book NOT IN ('AEOEQ', 'LIABB', 'TRPFD', 'PRFEQ', 'TDET2', 'TDET4', 'TDET5', 'TDET6', 'TDET7', 'TDET8', 'LHRO1', 'LHRO2','TSYGLRCSH') and cob_date in ('2018-02-28', '2018-02-27') group by cob_date, currency_of_measure UNION ALL SELECT COB_DATE, CURRENCY_OF_MEASURE, '3M LIBOR based' as CURRENCY_BASIS_STYLE, sum(usd_irpv01sprd) as USD_IRPV01SPRD, '3M-OIS' AS BASIS_TYPE from cdwuser.u_ir_msr where CCC_DIVISION = 'TREASURY CAPITAL MARKETS' and CCC_BUSINESS_AREA not in ('MS BANK - PRIVATE BANK1') and CCC_STRATEGY not in ('STRUCTURED N', 'L-TERM DEBT SN', 'L-TERM DEBT SN ALLOC') and curve_name in ('audn_disc','cadnw_disc','nzdn_disc','jpymu_3m','jpymu_disc') and book NOT IN ('AEOEQ', 'LIABB', 'TRPFD', 'PRFEQ', 'TDET2', 'TDET4', 'TDET5', 'TDET6', 'TDET7', 'TDET8', 'LHRO1', 'LHRO2','TSYGLRCSH') and cob_date in ('2018-02-28', '2018-02-27') GROUP BY COB_DATE, CURRENCY_OF_MEASURE UNION ALL SELECT COB_DATE, CURRENCY_OF_MEASURE, CASE WHEN CURVE_NAME in ('audn_1m', 'audn_6m', 'hkdn_1m', 'jpymu_6m', 'usdn_6m') then '3M LIBOR based' WHEN CURVE_NAME in ('gbpnw_6m', 'seknw_3m', 'usdnw_1m') then 'OIS based' ELSE 'Other' END AS CURRENCY_BASIS_STYLE, SUM(usd_irpv01sprd) AS USD_IRPV01SPRD, CASE WHEN CURVE_NAME IN ('audn_1m', 'hkdn_1m', 'usdnw_1m') then '3M-1M' WHEN CURVE_NAME IN ('seknw_3m') then '3M-OIS' WHEN CURVE_NAME IN ('gbpnw_6m', 'jpymu_6m', 'usdn_6m', 'audn_6m','sgdn_3m') then '6M-3M' WHEN CURVE_Name IN ('sgdn_disc') then '6M-OIS' WHEN CURVE_NAME IN ('sgdn_1m') then '6M-1M' ELSE 'Unmapped' END AS BASIS_TYPE FROM cdwuser.u_ir_msr where CCC_DIVISION = 'TREASURY CAPITAL MARKETS' and CCC_BUSINESS_AREA not in ('MS BANK - PRIVATE BANK1') and CCC_STRATEGY not in ('STRUCTURED N', 'L-TERM DEBT SN', 'L-TERM DEBT SN ALLOC') and USD_IRPV01SPRD is not null and CURVE_TYPE = 'IRBASISYIELDCURVE' and curve_name not in ('audn_disc','cadnw_disc','nzdn_disc','chfnw_3m','chfnw_disc','gbpnw_3m','gbpnw_disc', 'jpynw_3m', 'jpynw_disc', 'jpymu_3m', 'jpymu_disc', 'eurnw_3m', 'eurnw_disc', 'usdff', 'usdlibor1m', 'usdn_1m', 'usdn_disc', 'usdnw_3m', 'eurnw_disc', 'gbpnw_3m', 'eurnw_6m') and book NOT IN ('AEOEQ', 'LIABB', 'TRPFD', 'PRFEQ', 'TDET2', 'TDET4', 'TDET5', 'TDET6', 'TDET7', 'TDET8', 'LHRO1', 'LHRO2','TSYGLRCSH') and cob_date in ('2018-02-28', '2018-02-27') GROUP BY COB_DATE, CURRENCY_OF_MEASURE, CURVE_NAME ) a GROUP BY COB_DATE, CURRENCY_OF_MEASURE, CURRENCY_BASIS_STYLE, BASIS_TYPE ORDER BY CURRENCY_OF_MEASURE