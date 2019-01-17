WITH x AS ( SELECT UL_TICKER || ' ' || EXPIRATION_DATE || ' ' || STRIKE AS Instrument ,CASE WHEN substr(PRODUCT_DESCRIPTION, length(PRODUCT_DESCRIPTION)+1- 2) = 'ON' THEN UL_TICKER || ' ' || extract(DAY from (EXPIRATION_DATE)) || to_char(EXPIRATION_DATE,'Mon') || SUBSTR(extract(YEAR from (EXPIRATION_DATE)), 3, 2) || ' ' || STRIKE || ' ' || substr(PRODUCT_DESCRIPTION, length(PRODUCT_DESCRIPTION)+1- 14) ELSE UL_TICKER || ' ' || extract(DAY from (EXPIRATION_DATE)) || to_char(EXPIRATION_DATE,'Mon') || SUBSTR(extract(YEAR from (EXPIRATION_DATE)), 3, 2) || ' ' || STRIKE || ' ' || substr(PRODUCT_DESCRIPTION, length(PRODUCT_DESCRIPTION)+1- 2) END AS Instrument2 ,OPTION_MONEYNESS ,CCC_RISK_MANAGER_LOGIN ,ROUND(sum(NOTIONAL) / 1000000, 1) AS NOTIONAL ,ROUND(ABS(sum(NOTIONAL)) / 1000000, 1) AS ABS_NOTIONAL from ( SELECT V.POSITION_ID ,v.COB_DATE ,CASE WHEN v.CCC_STRATEGY = 'CORE' THEN v.CCC_PRODUCT_LINE WHEN v.CCC_STRATEGY = 'OTHER IED' THEN v.CCC_PRODUCT_LINE ELSE v.CCC_STRATEGY END AS CCC_STRATEGY ,v.CCC_RISK_MANAGER_LOGIN ,v.PRODUCT_DESCRIPTION ,V.UNDERLIER_TICK || '.' || V.UNDERLIER_EXCH AS UL_TICKER ,v.EXPIRATION_DATE ,CASE WHEN position('.' in CAST (STRIKE AS DECIMAL(20,2))) <> 0 AND SUBSTR(CAST (STRIKE AS DECIMAL(20,2)),position('.' in CAST (STRIKE AS DECIMAL(20,2)))+1,1) <> 0 THEN (CAST(STRIKE AS DECIMAL(20, 1)) ) WHEN position('.' in CAST (STRIKE AS DECIMAL(20,2))) <> 0 AND SUBSTR(CAST (STRIKE AS DECIMAL(20,2)),position('.' in CAST (STRIKE AS DECIMAL(20,2)))+2,1) <> 0 THEN (CAST(STRIKE AS DECIMAL(20, 2))) ELSE STRIKE END as STRIKE ,v.OPTION_MONEYNESS ,CASE WHEN ((V.USD_DELTA IS NOT NULL) OR (V.USD_DELTA IS NULL AND v.BASKET_FL IN ('Y'))) THEN COALESCE(v.TRADE_SIZE*V.LOT_SIZE*V.MEASURE_CONVERSION_FACTOR*V.STRIKE,0) ELSE 1000*v.USD_DELTA END AS NOTIONAL FROM CDWUSER.U_EQ_MSR v WHERE v.CCC_DIVISION IN ('INSTITUTIONAL EQUITY DIVISION') AND v.CCC_BUSINESS_AREA = 'DERIVATIVES' AND V.CCC_STRATEGY IN ('EXOTICS') AND v.SILO_SRC = 'IED' AND v.CCC_BANKING_TRADING IN ('TRADING') AND v.PRODUCT_TYPE_CODE IN ('OPTION') AND V.COB_DATE IN ('2018-02-28') AND v.CASH_ISSUE_TYPE IN ('STOCK','ADR') AND v.EXECUTIVE_MODEL IN ('AMERICAN-OPTION','EUROPEAN-OPTION') AND V.CCC_PL_REPORTING_REGION IN ('EMEA') AND (coalesce(v.EXPIRATION_DATE, '1970-01-01') <= '2018-03-16' AND coalesce(v.EXPIRATION_DATE, '1970-01-01') >= '2018-02-28') AND v.OPTION_MONEYNESS >= 0.95 AND v.OPTION_MONEYNESS <= 1.05 GROUP BY 1,2,3,4,5,6,7,8,9,10 )sub_qry WHERE NOTIONAL <> 0 GROUP BY UL_TICKER || ' ' || EXPIRATION_DATE || ' ' || STRIKE ,CASE WHEN substr(PRODUCT_DESCRIPTION, length(PRODUCT_DESCRIPTION)+1- 2) = 'ON' THEN UL_TICKER || ' ' || extract(DAY from (EXPIRATION_DATE)) || to_char(EXPIRATION_DATE,'Mon') || SUBSTR(extract(YEAR from (EXPIRATION_DATE)), 3, 2) || ' ' || STRIKE || ' ' || substr(PRODUCT_DESCRIPTION, length(PRODUCT_DESCRIPTION)+1- 14) ELSE UL_TICKER || ' ' || extract(DAY from (EXPIRATION_DATE)) || to_char(EXPIRATION_DATE,'Mon') || SUBSTR(extract(YEAR from (EXPIRATION_DATE)), 3, 2) || ' ' || STRIKE || ' ' || substr(PRODUCT_DESCRIPTION, length(PRODUCT_DESCRIPTION)+1- 2) END ,OPTION_MONEYNESS ,CCC_RISK_MANAGER_LOGIN ) ,y AS ( SELECT Instrument ,Instrument2 ,Option_moneyness ,CCC_RISK_MANAGER_LOGIN ,sum(NOTIONAL) AS NOTIONAL ,sum(ABS_NOTIONAL) AS ABS_NOTIONAL ,RANK() OVER ( PARTITION BY Instrument ORDER BY sum(ABS_NOTIONAL) DESC ) AS RISK_MANAGER_RANK FROM x GROUP BY Instrument ,Instrument2 ,CCC_RISK_MANAGER_LOGIN ,Option_moneyness ) ,z AS ( SELECT UL_TICKER ,ROUND(sum(DELTA) / sum(LIQUIDITY_DAYS) / 1000, 1) AS VOLUME from ( SELECT v.UNDERLIER_TICK || '.' || v.UNDERLIER_EXCH AS UL_TICKER ,sum(COALESCE(v.USD_EQ_DELTA_DECOMP,0)) + sum(COALESCE(v.USD_CM_DELTA_DECOMP,0)) AS DELTA ,suM(COALESCE(v.LIQUIDITY_DAYS_DECOMP,0)) AS LIQUIDITY_DAYS FROM CDWUSER.U_DECOMP_MSR v WHERE v.PRODUCT_TYPE_CODE IN ('OPTION') AND V.COB_DATE IN ('2018-02-28') AND v.LIQUIDITY_DAYS_DECOMP IS NOT NULL AND v.LIQUIDITY_DAYS_DECOMP <> 0 GROUP BY v.PRODUCT_TYPE_CODE_DECOMP ,v.UNDERLIER_TICK || '.' || v.UNDERLIER_EXCH )sub_qry WHERE DELTA <> 0 AND LIQUIDITY_DAYS <> 0 GROUP BY UL_TICKER HAVING SUM(LIQUIDITY_DAYS) <> 0 ) SELECT Instrument2 ,OPTION_MONEYNESS ,CCC_RISK_MANAGER_LOGIN AS RISK_MANAGER ,NOTIONAL ,VOLUME from ( SELECT x.Instrument2 ,x.OPTION_MONEYNESS ,y.CCC_RISK_MANAGER_LOGIN ,ROUND(sum(x.NOTIONAL), 1) AS NOTIONAL ,ROUND(z.VOLUME, 0) AS VOLUME ,ROUND(ABS(sum(x.NOTIONAL)), 1) AS ABS_NOTIONAL FROM x INNER JOIN y ON x.Instrument2 = y.Instrument2 LEFT JOIN z ON SUBSTR(x.Instrument2, 1, position(' ' in x.Instrument2) - 1) = z.UL_TICKER WHERE y.RISK_MANAGER_RANK = 1 GROUP BY x.Instrument2 ,x.OPTION_MONEYNESS ,y.CCC_RISK_MANAGER_LOGIN ,z.VOLUME )sub_qry ORDER BY ABS_NOTIONAL DESC FETCH FIRST 25 ROWS ONLY