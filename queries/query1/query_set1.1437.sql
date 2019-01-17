SELECT RANK() OVER(ORDER BY ABS(sum(coalesce(a.SLIDE_EQ_MIN_30_USD,0))/1000) DESC) as RANK, a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH as TICK_DECOMP, sum(coalesce(a.SLIDE_EQ_MIN_30_USD,0))/1000 as D30, sum(coalesce(a.SLIDE_EQ_MIN_20_USD,0))/1000 as D20, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0))/1000 as D10, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0))/1000 as D05, sum(coalesce(a.SLIDE_EQ_MIN_02_USD,0))/1000 as D02, sum(coalesce(a.SLIDE_EQ_PLS_02_USD,0))/1000 as P02, sum(coalesce(a.SLIDE_EQ_PLS_05_USD,0))/1000 as P05, sum(coalesce(a.SLIDE_EQ_PLS_10_USD,0))/1000 as P10, sum(coalesce(a.SLIDE_EQ_PLS_20_USD,0))/1000 as P20 FROM CDWUSER.U_EXP_MSR a WHERE a.COB_DATE ='2018-02-28' AND a.CCC_BANKING_TRADING='TRADING' AND a.BOOK = 'ETP' AND a.CCC_RISK_MANAGER_LOGIN = 'freemric' AND a.CCC_BOOK_DETAIL IN('DE_EQUITY', 'DSP ETP EQUITY') GROUP BY a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH