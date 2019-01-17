Select RANK() OVER(ORDER BY abs(sum(a.USD_DELTA)) DESC) as RANK, a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH as MdSymbol, sum(a.USD_DELTA)/1000 as Delta From CDWUSER.U_EQ_MSR a Where a.COB_DATE ='2018-02-28' And a.CCC_RISK_MANAGER_LOGIN ='freemric' And a.PRODUCT_TYPE_CODE not in ('STOCK', 'FUTURE', 'ADR', 'COMM') And a.USD_DELTA <> '0' Group by a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH