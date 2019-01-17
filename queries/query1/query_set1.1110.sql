WITH ETF_EQ_MSR     AS (         SELECT             a.COB_DATE,             a.PARTIAL_DECOMP_ISSUE_ID,             CASE                  WHEN a.PRODUCT_TYPE_CODE = 'ETF' THEN a.TICKER             ELSE a.PARTIAL_DECOMP_RT_TICK END AS ETF_TICK,             CASE                  WHEN a.PRODUCT_TYPE_CODE = 'ETF' THEN a.PRODUCT_DESCRIPTION             ELSE a.PARTIAL_DECOMP_PRODUCT_DESCRIPTION END AS ETF_DESCRIPTION,             COALESCE(a.USD_EQ_PARTIAL_DELTA ,0) AS USD_EQ_DELTA          FROM             cdwuser.U_EXP_MSR_PARTIAL a         WHERE  (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and A.CCC_PL_REPORTING_REGION in ('JAPAN','ASIA PACIFIC') AND A.CCC_TAPS_COMPANY in ('0302','0347','0853','4043','4298','4863','6120','6899','6837','6893','4044','5869','0856','6325','0301','0893','0993') AND        CCC_BANKING_TRADING='TRADING' AND             a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND             (a.VAR_EXCL_FL <> 'Y') AND             (a.ccc_business_area <> 'INTERNATIONAL WEALTH MGMT') AND             (a.PRODUCT_TYPE_CODE = 'ETF' OR a.PARTIAL_DECOMP_PRODUCT_TYPE_CODE = 'ETF')AND             NOT (a.USD_DELTA IS NULL AND a.USD_EQ_PARTIAL_DELTA IS NULL)     ),     ETF_NOEQ_MSR     AS (         SELECT             a.COB_DATE,             a.PARTIAL_DECOMP_ISSUE_ID,             CASE                  WHEN a.PRODUCT_TYPE_CODE = 'ETF' THEN a.TICKER             ELSE a.PARTIAL_DECOMP_RT_TICK END AS ETF_TICK,             CASE                  WHEN a.PRODUCT_TYPE_CODE = 'ETF' THEN a.PRODUCT_DESCRIPTION             ELSE a.PARTIAL_DECOMP_PRODUCT_DESCRIPTION END AS ETF_DESCRIPTION,             COALESCE(a.USD_MARKET_VALUE ,0) AS USD_EQ_DELTA          FROM             cdwuser.U_EXP_MSR_PARTIAL a         WHERE  (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') and A.CCC_PL_REPORTING_REGION in ('JAPAN','ASIA PACIFIC') AND A.CCC_TAPS_COMPANY in ('0302','0347','0853','4043','4298','4863','6120','6899','6837','6893','4044','5869','0856','6325','0301','0893','0993') AND        CCC_BANKING_TRADING='TRADING' AND             a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND             (a.VAR_EXCL_FL <> 'Y') AND             (a.ccc_business_area <> 'INTERNATIONAL WEALTH MGMT') AND             a.PRODUCT_TYPE_CODE = 'ETF' AND             a.USD_MARKET_VALUE IS NOT NULL AND             a.PARTIAL_DECOMP_ISSUE_ID NOT IN (                 SELECT                     PARTIAL_DECOMP_ISSUE_ID                 FROM                     ETF_EQ_MSR             )     ),     ALL_ETF_EXP     AS (         SELECT             *         FROM             ETF_EQ_MSR         WHERE COB_DATE = '2018-02-28'         UNION ALL         SELECT             *         FROM             ETF_NOEQ_MSR         WHERE COB_DATE = '2018-02-28'     ),     ALL_ETF_PREV     AS(         SELECT             ETF_TICK AS TICK,             sum(USD_EQ_DELTA) AS DELTA         FROM             ETF_EQ_MSR         WHERE COB_DATE = '2018-02-27'         GROUP BY             ETF_TICK         UNION ALL         SELECT             ETF_TICK AS TICK,             sum(USD_EQ_DELTA) AS DELTA         FROM             ETF_NOEQ_MSR         WHERE COB_DATE = '2018-02-27'         GROUP BY             ETF_TICK     ) SELECT     ETF_DESCRIPTION,     ETF_TICK,     usd_eq_delta/1000 AS NET_EXPOSURE,     (COALESCE(USD_EQ_DELTA, 0) - COALESCE(b.DELTA, 0))/1000 AS CHANGE,     ABS(usd_eq_delta/1000) AS ABS_NET_EXPOSURE FROM (     SELECT         A.cob_date,         A.ETF_DESCRIPTION,         sum(A.USD_EQ_DELTA) AS usd_eq_delta,         A.ETF_TICK,         rank() OVER (PARTITION BY A.cob_date ORDER BY abs(sum(A.usd_eq_delta)) DESC) AS etf_ranK     FROM         ALL_ETF_EXP A     GROUP BY         A.cob_date,         A.ETF_DESCRIPTION,         A.ETF_TICK     ) t LEFT JOIN     ALL_ETF_PREV B ON     ETF_TICK=B.TICK ORDER BY     ETF_RANK FETCH FIRST 10 ROWS ONLY