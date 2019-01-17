SELECT 'UK Group ALL' as Region, SUM (ABS (vega)) AS Grossvega FROM ( SELECT UNDERLIER_TICK || '.' || UNDERLIER_EXCH AS Underlier, SUM (COALESCE (a.USD_EQ_PARTIAL_KAPPA, 0))/1000 AS vega FROM CDWUSER.U_EQ_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.LE_GROUP = 'UK' AND a.EXECUTIVE_MODEL IN ('VARIANCESWAP', 'CAPPEDVARIANCESWAP', 'VOLATILITYSWAP', 'CAPPEDVOLATILITYSWAP') GROUP BY UNDERLIER_TICK || '.' || UNDERLIER_EXCH ) x UNION ALL SELECT Region, SUM (ABS (vega)) AS Grossvega FROM ( SELECT UNDERLIER_TICK || '.' || UNDERLIER_EXCH AS Underlier, SUM (COALESCE (a.USD_EQ_PARTIAL_KAPPA, 0))/1000 AS vega, CASE WHEN a.CCC_TAPS_COMPANY = '0302' THEN 'UK Group ALL MSIP' WHEN a.CCC_TAPS_COMPANY = '0342' THEN 'UK Group ALL MSBIL' WHEN a.CCC_TAPS_COMPANY = '0319' THEN 'UK Group ALL MSIM' WHEN a.CCC_TAPS_COMPANY NOT IN ('0342','0319','0302') THEN 'UK Group ALL OTHER' END AS Region FROM CDWUSER.U_EQ_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.LE_GROUP = 'UK' AND a.EXECUTIVE_MODEL IN ('VARIANCESWAP', 'CAPPEDVARIANCESWAP', 'VOLATILITYSWAP', 'CAPPEDVOLATILITYSWAP') GROUP BY UNDERLIER_TICK || '.' || UNDERLIER_EXCH, CASE WHEN a.CCC_TAPS_COMPANY = '0302' THEN 'UK Group ALL MSIP' WHEN a.CCC_TAPS_COMPANY = '0342' THEN 'UK Group ALL MSBIL' WHEN a.CCC_TAPS_COMPANY = '0319' THEN 'UK Group ALL MSIM' WHEN a.CCC_TAPS_COMPANY NOT IN ('0342','0319','0302') THEN 'UK Group ALL OTHER' END ) x GROUP BY Region UNION ALL SELECT Region, SUM (ABS (vega)) AS Grossvega FROM ( SELECT UNDERLIER_TICK || '.' || UNDERLIER_EXCH AS Underlier, SUM (COALESCE (a.USD_EQ_PARTIAL_KAPPA, 0))/1000 AS vega, CASE WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'UK Group EMEA ALL' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'UK Group AMERICAS ALL' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'UK Group ASIA ALL' WHEN a.CCC_PL_REPORTING_REGION NOT IN ('EMEA','AMERICAS','ASIA PACIFIC','JAPAN') THEN 'UK Group OTHER ALL' END AS Region FROM CDWUSER.U_EQ_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.LE_GROUP = 'UK' AND a.EXECUTIVE_MODEL IN ('VARIANCESWAP', 'CAPPEDVARIANCESWAP', 'VOLATILITYSWAP', 'CAPPEDVOLATILITYSWAP') GROUP BY UNDERLIER_TICK || '.' || UNDERLIER_EXCH, CASE WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'UK Group EMEA ALL' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' THEN 'UK Group AMERICAS ALL' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') THEN 'UK Group ASIA ALL' WHEN a.CCC_PL_REPORTING_REGION NOT IN ('EMEA','AMERICAS','ASIA PACIFIC','JAPAN') THEN 'UK Group OTHER ALL' END ) x GROUP BY Region UNION ALL SELECT Region, SUM (ABS (vega)) AS Grossvega FROM ( SELECT UNDERLIER_TICK || '.' || UNDERLIER_EXCH AS Underlier, SUM (COALESCE (a.USD_EQ_PARTIAL_KAPPA, 0))/1000 AS vega, CASE WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.CCC_TAPS_COMPANY = '0302' THEN 'UK Group EMEA MSIP' WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.CCC_TAPS_COMPANY = '0342' THEN 'UK Group EMEA MSBIL' WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.CCC_TAPS_COMPANY = '0319' THEN 'UK Group EMEA MSIM' WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.CCC_TAPS_COMPANY NOT IN ('0342','0319','0302') THEN 'UK Group EMEA OTHER' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' AND a.CCC_TAPS_COMPANY = '0302' THEN 'UK Group AMERICAS MSIP' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' AND a.CCC_TAPS_COMPANY = '0342' THEN 'UK Group AMERICAS MSBIL' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' AND a.CCC_TAPS_COMPANY = '0319' THEN 'UK Group AMERICAS MSIM' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' AND a.CCC_TAPS_COMPANY NOT IN ('0342','0319','0302') THEN 'UK Group AMERICAS OTHER' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY = '0302' THEN 'UK Group ASIA MSIP' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY = '0342' THEN 'UK Group ASIA MSBIL' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY = '0319' THEN 'UK Group ASIA MSIM' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY NOT IN ('0342','0319','0302') THEN 'UK Group ASIA OTHER' WHEN a.CCC_PL_REPORTING_REGION NOT IN ('EMEA','AMERICAS','ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY = '0302' THEN 'UK Group OTHER MSIP' WHEN a.CCC_PL_REPORTING_REGION NOT IN ('EMEA','AMERICAS','ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY = '0342' THEN 'UK Group OTHER MSBIL' WHEN a.CCC_PL_REPORTING_REGION NOT IN ('EMEA','AMERICAS','ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY = '0319' THEN 'UK Group OTHER MSIM' WHEN a.CCC_PL_REPORTING_REGION NOT IN ('EMEA','AMERICAS','ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY NOT IN ('0342','0319','0302') THEN 'UK Group OTHER OTHER' END AS Region FROM CDWUSER.U_EQ_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.LE_GROUP = 'UK' AND a.EXECUTIVE_MODEL IN ('VARIANCESWAP', 'CAPPEDVARIANCESWAP', 'VOLATILITYSWAP', 'CAPPEDVOLATILITYSWAP') GROUP BY UNDERLIER_TICK || '.' || UNDERLIER_EXCH, CASE WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.CCC_TAPS_COMPANY = '0302' THEN 'UK Group EMEA MSIP' WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.CCC_TAPS_COMPANY = '0342' THEN 'UK Group EMEA MSBIL' WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.CCC_TAPS_COMPANY = '0319' THEN 'UK Group EMEA MSIM' WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.CCC_TAPS_COMPANY NOT IN ('0342','0319','0302') THEN 'UK Group EMEA OTHER' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' AND a.CCC_TAPS_COMPANY = '0302' THEN 'UK Group AMERICAS MSIP' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' AND a.CCC_TAPS_COMPANY = '0342' THEN 'UK Group AMERICAS MSBIL' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' AND a.CCC_TAPS_COMPANY = '0319' THEN 'UK Group AMERICAS MSIM' WHEN a.CCC_PL_REPORTING_REGION = 'AMERICAS' AND a.CCC_TAPS_COMPANY NOT IN ('0342','0319','0302') THEN 'UK Group AMERICAS OTHER' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY = '0302' THEN 'UK Group ASIA MSIP' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY = '0342' THEN 'UK Group ASIA MSBIL' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY = '0319' THEN 'UK Group ASIA MSIM' WHEN a.CCC_PL_REPORTING_REGION IN ('ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY NOT IN ('0342','0319','0302') THEN 'UK Group ASIA OTHER' WHEN a.CCC_PL_REPORTING_REGION NOT IN ('EMEA','AMERICAS','ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY = '0302' THEN 'UK Group OTHER MSIP' WHEN a.CCC_PL_REPORTING_REGION NOT IN ('EMEA','AMERICAS','ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY = '0342' THEN 'UK Group OTHER MSBIL' WHEN a.CCC_PL_REPORTING_REGION NOT IN ('EMEA','AMERICAS','ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY = '0319' THEN 'UK Group OTHER MSIM' WHEN a.CCC_PL_REPORTING_REGION NOT IN ('EMEA','AMERICAS','ASIA PACIFIC','JAPAN') AND a.CCC_TAPS_COMPANY NOT IN ('0342','0319','0302') THEN 'UK Group OTHER OTHER' END ) x GROUP BY Region UNION ALL SELECT 'EMEA' as Region, SUM (ABS (vega)) AS Grossvega FROM ( SELECT UNDERLIER_TICK || '.' || UNDERLIER_EXCH AS Underlier, SUM (COALESCE (a.USD_EQ_PARTIAL_KAPPA, 0))/1000 AS vega FROM CDWUSER.U_EQ_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.CCC_PL_REPORTING_REGION IN ('EMEA') AND a.EXECUTIVE_MODEL IN ('VARIANCESWAP', 'CAPPEDVARIANCESWAP', 'VOLATILITYSWAP', 'CAPPEDVOLATILITYSWAP') GROUP BY UNDERLIER_TICK || '.' || UNDERLIER_EXCH ) x UNION ALL SELECT 'UK Group ALL Prev. CoB' as Region, SUM (ABS (vega)) AS Grossvega FROM ( SELECT UNDERLIER_TICK || '.' || UNDERLIER_EXCH AS Underlier, SUM (COALESCE (a.USD_EQ_PARTIAL_KAPPA, 0))/1000 AS vega FROM CDWUSER.U_EQ_MSR a WHERE a.COB_DATE = '2018-02-27' AND a.LE_GROUP = 'UK' AND a.EXECUTIVE_MODEL IN ('VARIANCESWAP', 'CAPPEDVARIANCESWAP', 'VOLATILITYSWAP', 'CAPPEDVOLATILITYSWAP') GROUP BY UNDERLIER_TICK || '.' || UNDERLIER_EXCH ) x