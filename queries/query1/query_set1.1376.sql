with x as (select cob_date, d.PRODUCT_DESCRIPTION_decomp as security_description, d.TICKER_Decomp||'.'||d.exchange_decomp as tick, (sum(coalesce(d.USD_EQ_DELTA_DECOMP,0))) as Delta, sum(d.LIQUIDITY_DAYS_DECOMP) as Liquidity_Days, case when d.CCC_PL_REPORTING_REGION = 'EMEA' then 1 else 0 end as EMEAFlag, case when d.ISSUER_COUNTRY_CODE_DECOMP in ('DNK','BMU','CYM','AUS','AUT','BEL','CAN','CHE','DEU','ESP','FIN','FRA','GBR','GRC','IRL','ITA','JPN','LUX','NLD','NOR','NZL','PRT','SWE','USA','JEY','GGY','SUP','XS','XCI','VGB','CYP') then 0 else 1 end as EMFlag, d.CCC_STRATEGY as Desk ,Case when d.CCC_TAPS_COMPANY = '0302' then 1 else 0 end as MsipFlag, Case when d.CCC_TAPS_COMPANY = '0342' then 1 else 0 end as MsslFlag, case when d.CCC_HIERARCHY_LEVEL8 in('CORE PRIMARY', 'CORE PRIMARY1') then 1 else 0 end as SynFlag, Case when d.CCC_TAPS_COMPANY = '0517' then 1 else 0 end as MsbilFlag from cdwuser.U_DECOMP_MSR d where d.COB_DATE in ('2018-02-28','2018-02-21') and d.DIVISION = 'IED' and d.CCC_BANKING_TRADING = 'TRADING' and d.CCC_BUSINESS_AREA NOT IN ('EQUITY FINANCING PRODUCTS', 'PRIME BROKERAGE') group by cob_date, d.PRODUCT_DESCRIPTION_decomp, d.TICKER_Decomp||'.'||d.exchange_decomp, case when d.CCC_PL_REPORTING_REGION = 'EMEA' then 1 else 0 end, case when d.ISSUER_COUNTRY_CODE_DECOMP in ('DNK','BMU','CYM','AUS','AUT','BEL','CAN','CHE','DEU','ESP','FIN','FRA','GBR','GRC','IRL','ITA','JPN','LUX','NLD','NOR','NZL','PRT','SWE','USA','JEY','GGY','SUP','XS','XCI','VGB','CYP') then 0 else 1 end, d.CCC_STRATEGY ,Case when d.CCC_TAPS_COMPANY = '0302' then 1 else 0 end, Case when d.CCC_TAPS_COMPANY = '0342' then 1 else 0 end, case when d.CCC_HIERARCHY_LEVEL8 in ('CORE PRIMARY', 'CORE PRIMARY1') then 1 else 0 end, Case when d.CCC_TAPS_COMPANY = '0517' then 1 else 0 end) select * from (select RANK() OVER (ORDER BY ABS(SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END)) DESC)||'_'||'TopNRAMV' as Concentration, x.SECURITY_DESCRIPTION, xTick.TICK AS LARGEST_TICK, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END) as DELTACOB, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE -DELTA END) as DELTADOD, SUM(CASE WHEN COB_DATE='2018-02-28' THEN LIQUIDITY_DAYS ELSE 0 END) as LIQUIDITYCOB, xDesk.Desk from x INNER JOIN ( SELECT SECURITY_DESCRIPTION, TICK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) AS RANK FROM x WHERE COB_DATE = '2018-02-28' GROUP BY SECURITY_DESCRIPTION, TICK ) AS xTick ON(x.SECURITY_DESCRIPTION=xTick.SECURITY_DESCRIPTION AND xTick.Rank=1) INNER JOIN ( SELECT SECURITY_DESCRIPTION, DESK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) as RANK FROM x WHERE COB_DATE = '2018-02-28' GROUP BY SECURITY_DESCRIPTION, DESK) as xDesk ON (x.security_description = xDesk.security_description and xDesk.Rank = 1) group by x.SECURITY_DESCRIPTION, xTick.TICK, xDesk.Desk fetch first 15 rows only) a Union All select * from (select RANK() OVER (ORDER BY ABS(SUM(CASE WHEN COB_DATE= '2018-02-28' THEN DELTA ELSE 0 END)) DESC)||'_'||'TopEuNRAMV' as Concentration, x.SECURITY_DESCRIPTION, xTick.TICK AS LARGEST_TICK, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END) as DELTACOB, SUM(CASE WHEN COB_DATE= '2018-02-28'THEN DELTA ELSE -DELTA END) as DELTADOD, SUM(CASE WHEN COB_DATE='2018-02-28' THEN LIQUIDITY_DAYS ELSE 0 END) as LIQUIDITYCOB, xDesk.DESK from x INNER JOIN (SELECT SECURITY_DESCRIPTION, TICK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) AS RANK FROM x WHERE COB_DATE = '2018-02-28' and EMEAFlag = 1 GROUP BY SECURITY_DESCRIPTION, TICK ) AS xTick ON(x.SECURITY_DESCRIPTION=xTick.SECURITY_DESCRIPTION AND xTick.Rank=1) INNER JOIN ( SELECT SECURITY_DESCRIPTION, DESK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) as RANK FROM x WHERE cob_date = '2018-02-28' and EMEAFlag = 1 GROUP BY SECURITY_DESCRIPTION, DESK) as xDesk ON (x.security_description = xDesk.security_description and xDesk.Rank = 1) Where EMEAFlag = 1 group by x.SECURITY_DESCRIPTION, xTick.TICK, xDesk.Desk fetch first 15 rows only ) a Union All select * from (select RANK() OVER (ORDER BY ABS(SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END)) DESC)||'_'||'TopEuEMNRAMV' as Concentration, x.SECURITY_DESCRIPTION, xTick.TICK AS LARGEST_TICK, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END) as DELTACOB, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE -DELTA END) as DELTADOD, SUM(CASE WHEN COB_DATE='2018-02-28' THEN LIQUIDITY_DAYS ELSE 0 END) as LIQUIDITYCOB, xDesk.DESK from x INNER JOIN (SELECT SECURITY_DESCRIPTION, TICK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) AS RANK FROM x WHERE COB_DATE = '2018-02-28' and EMFlag = 1 and EMEAFlag = 1 GROUP BY SECURITY_DESCRIPTION, TICK ) AS xTick ON(x.SECURITY_DESCRIPTION=xTick.SECURITY_DESCRIPTION AND xTick.Rank=1) INNER JOIN ( SELECT SECURITY_DESCRIPTION, DESK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) as RANK FROM x WHERE cob_date = '2018-02-28' and EMEAFlag = 1 and EMFlag = 1 GROUP BY SECURITY_DESCRIPTION, DESK) as xDesk ON (x.security_description = xDesk.security_description and xDesk.Rank = 1) Where EMFlag = 1 and EMEAFlag = 1 group by x.SECURITY_DESCRIPTION, xTick.TICK, xDesk.Desk fetch first 15 rows only ) a Union All select * from (select RANK() OVER (ORDER BY ABS(SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END)) DESC)||'_'||'TopMsipExSNRAMV' as Concentration, x.SECURITY_DESCRIPTION, xTick.TICK AS LARGEST_TICK, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END) as DELTACOB, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE -DELTA END) as DELTADOD, SUM(CASE WHEN COB_DATE= '2018-02-28' THEN LIQUIDITY_DAYS ELSE 0 END) as LIQUIDITYCOB, xDesk.DESK from x INNER JOIN (SELECT SECURITY_DESCRIPTION, TICK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) AS RANK FROM x WHERE COB_DATE = '2018-02-28' and MSIPFlag = 1 and SynFlag = 0 GROUP BY SECURITY_DESCRIPTION, TICK ) AS xTick ON(x.SECURITY_DESCRIPTION=xTick.SECURITY_DESCRIPTION AND xTick.Rank=1) INNER JOIN ( SELECT SECURITY_DESCRIPTION, DESK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) as RANK FROM x WHERE cob_date = '2018-02-28' and MSIPFlag = 1 and SynFlag = 0 GROUP BY SECURITY_DESCRIPTION, DESK) as xDesk ON (x.security_description = xDesk.security_description and xDesk.Rank = 1) Where MSIPFlag = 1 and SynFlag = 0 group by x.SECURITY_DESCRIPTION, xTick.TICK, xDesk.Desk fetch first 6 rows only ) a Union All select * from (select RANK() OVER (ORDER BY ABS(SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END)) DESC)||'_'||'TopMsslExSNRAMV' as Concentration, x.SECURITY_DESCRIPTION, xTick.TICK AS LARGEST_TICK, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END) as DELTACOB, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE -DELTA END) as DELTADOD, SUM(CASE WHEN COB_DATE='2018-02-28' THEN LIQUIDITY_DAYS ELSE 0 END) as LIQUIDITYCOB, xDesk.DESK from x INNER JOIN (SELECT SECURITY_DESCRIPTION, TICK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) AS RANK FROM x WHERE COB_DATE = '2018-02-28' and MsslFlag = 1 and SynFlag = 0 GROUP BY SECURITY_DESCRIPTION, TICK ) AS xTick ON(x.SECURITY_DESCRIPTION=xTick.SECURITY_DESCRIPTION AND xTick.Rank=1) INNER JOIN ( SELECT SECURITY_DESCRIPTION, DESK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) as RANK FROM x WHERE cob_date = '2018-02-28' and MsslFlag = 1 and SynFlag = 0 GROUP BY SECURITY_DESCRIPTION, DESK) as xDesk ON (x.security_description = xDesk.security_description and xDesk.Rank = 1) Where MsslFlag = 1 and SynFlag = 0 group by x.SECURITY_DESCRIPTION, xTick.TICK, xDesk.Desk fetch first 6 rows only ) a Union All select * from (select RANK() OVER (ORDER BY ABS(SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END)) DESC)||'_'||'TopMsipNRAMV' as Concentration, x.SECURITY_DESCRIPTION, xTick.TICK AS LARGEST_TICK, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END) as DELTACOB, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE -DELTA END) as DELTADOD, SUM(CASE WHEN COB_DATE='2018-02-28' THEN LIQUIDITY_DAYS ELSE 0 END) as LIQUIDITYCOB, xDesk.DESK from x INNER JOIN (SELECT SECURITY_DESCRIPTION, TICK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) AS RANK FROM x WHERE COB_DATE = '2018-02-28' and MSIPFlag = 1 GROUP BY SECURITY_DESCRIPTION, TICK ) AS xTick ON(x.SECURITY_DESCRIPTION=xTick.SECURITY_DESCRIPTION AND xTick.Rank=1) INNER JOIN ( SELECT SECURITY_DESCRIPTION, DESK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) as RANK FROM x WHERE cob_date = '2018-02-28' and MSIPFlag = 1 GROUP BY SECURITY_DESCRIPTION, DESK) as xDesk ON (x.security_description = xDesk.security_description and xDesk.Rank = 1) Where MSIPFlag = 1 group by x.SECURITY_DESCRIPTION, xTick.TICK, xDesk.Desk fetch first 6 rows only ) a Union All select * from (select RANK() OVER (ORDER BY ABS(SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END)) DESC)||'_'||'TopMsslNRAMV' as Concentration, x.SECURITY_DESCRIPTION, xTick.TICK AS LARGEST_TICK, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END) as DELTACOB, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE -DELTA END) as DELTADOD, SUM(CASE WHEN COB_DATE='2018-02-28' THEN LIQUIDITY_DAYS ELSE 0 END) as LIQUIDITYCOB, xDesk.DESK from x INNER JOIN (SELECT SECURITY_DESCRIPTION, TICK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) AS RANK FROM x WHERE COB_DATE = '2018-02-28' and MsslFlag = 1 GROUP BY SECURITY_DESCRIPTION, TICK ) AS xTick ON(x.SECURITY_DESCRIPTION=xTick.SECURITY_DESCRIPTION AND xTick.Rank=1) INNER JOIN ( SELECT SECURITY_DESCRIPTION, DESK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) as RANK FROM x WHERE cob_date = '2018-02-28' and MsslFlag = 1 GROUP BY SECURITY_DESCRIPTION, DESK) as xDesk ON (x.security_description = xDesk.security_description and xDesk.Rank = 1) Where MsslFlag = 1 group by x.SECURITY_DESCRIPTION, xTick.TICK, xDesk.Desk fetch first 6 rows only ) a Union All select * from (select RANK() OVER (ORDER BY ABS(SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END)) DESC)||'_'||'TopMsbilNRAMV' as Concentration, x.SECURITY_DESCRIPTION, xTick.TICK AS LARGEST_TICK, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END) as DELTACOB, SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE -DELTA END) as DELTADOD, SUM(CASE WHEN COB_DATE='2018-02-28' THEN LIQUIDITY_DAYS ELSE 0 END) as LIQUIDITYCOB, xDesk.Desk from x INNER JOIN ( SELECT SECURITY_DESCRIPTION, TICK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) AS RANK FROM x WHERE COB_DATE = '2018-02-28' and MsbilFlag = 1 GROUP BY SECURITY_DESCRIPTION, TICK ) AS xTick ON(x.SECURITY_DESCRIPTION=xTick.SECURITY_DESCRIPTION AND xTick.Rank=1) INNER JOIN ( SELECT SECURITY_DESCRIPTION, DESK, RANK() OVER (PARTITION BY SECURITY_DESCRIPTION ORDER BY ABS(SUM(DELTA)) DESC) as RANK FROM x WHERE cob_date = '2018-02-28' and MsbilFlag = 1 GROUP BY SECURITY_DESCRIPTION, DESK) as xDesk ON (x.security_description = xDesk.security_description and xDesk.Rank = 1) where MsbilFlag = 1 group by x.SECURITY_DESCRIPTION, xTick.TICK, xDesk.Desk having SUM(CASE WHEN COB_DATE='2018-02-28' THEN DELTA ELSE 0 END) <> 0 fetch first 6 rows only) a