SELECT a.COB_DATE, a.CCC_PL_REPORTING_REGION, a.CCC_BUSINESS_AREA, a.CCC_PRODUCT_LINE, a.CCC_STRATEGY, a.CCC_TAPS_COMPANY, sum(coalesce(a.USD_DELTA,0)) as USD_DELTA, sum(coalesce(a.USD_EQ_DELTA_DECOMP,0)) as USD_EQ_DELTA_DECOMP, sum(coalesce(a.USD_CM_DELTA_DECOMP,0)) as USD_CM_DELTA_DECOMP, sum(a.USD_IR_UNIFIED_PV01) as USD_IR_UNIFIED_PV01, sum(a.USD_PV01SPRD) as USD_PV01SPRD, sum(a.USD_FX) as USD_FX, sum(a.USD_FX_KAPPA) as USD_FX_KAPPA, sum(coalesce(a.USD_CREDIT_PV10PCT,0)) + sum(coalesce(a.USD_PV10_BENCH,0)) as CRPV10, sum(a.USD_EQ_KAPPA) as USD_EQ_KAPPA, sum(a.USD_EQ_GAMMA) as USD_EQ_GAMMA, sum(a.USD_THETA_GAMMA) as USD_THETA_GAMMA, sum(a.USD_EQ_KAPPA_PLS100BP_TIMEADJ) as USD_EQ_TA_KAPPA, sum(a.CORR_EQEQ)/1000000 as CORR_EQEQ, sum(a.USD_EQ_DISC_RISK) as USD_EQ_DISC_RISK, sum(a.SLIDE_EQ_MIN_30_USD) + 0.3*sum(a.USD_DELTA) as D30, (sum(a.SLIDE_EQ_MIN_30_USD) + sum(a.SLIDE_EQ_MIN_20_USD))/2 + 0.25 * sum(a.USD_DELTA) as D25, sum(a.SLIDE_EQ_MIN_20_USD) + 0.2*sum(a.USD_DELTA) as D20, (sum(a.SLIDE_EQ_MIN_20_USD) + sum(a.SLIDE_EQ_MIN_10_USD))/2 + 0.15*sum(a.USD_DELTA) as D15, sum(a.SLIDE_EQ_MIN_10_USD) + 0.1*sum(a.USD_DELTA) as D10, sum(a.SLIDE_EQ_MIN_05_USD) + 0.05*sum(a.USD_DELTA) as D05, sum(a.SLIDE_EQ_PLS_05_USD) - 0.05*sum(a.USD_DELTA) as P05, sum(a.SLIDE_EQ_PLS_10_USD) - 0.10*sum(a.USD_DELTA) as P10, (sum(a.SLIDE_EQ_PLS_10_USD) + sum(a.SLIDE_EQ_PLS_20_USD))/2 - 0.15*sum(a.USD_DELTA) as P15, sum(a.SLIDE_EQ_PLS_20_USD) - 0.20*sum(a.USD_DELTA) as P20 FROM CDWUSER.U_DM_EQ a WHERE a.COB_DATE in ('2018-02-28','2018-02-21') AND a.CCC_BANKING_TRADING = 'TRADING' AND a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' GROUP BY a.COB_DATE, a.CCC_PL_REPORTING_REGION, a.CCC_BUSINESS_AREA, a.CCC_PRODUCT_LINE, a.CCC_STRATEGY, a.CCC_TAPS_COMPANY