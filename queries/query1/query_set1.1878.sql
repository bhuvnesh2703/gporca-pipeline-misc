SELECT extract('year' from a.COB_DATE) AS year, extract('quarter' from a.COB_DATE) AS quarter, extract('month' from a.COB_DATE) as month, a.COB_DATE, a.CCC_PL_REPORTING_REGION as REGION, a.CCC_PRODUCT_LINE, a.PRODUCT_TYPE_CODE, a.CURRENCY_OF_MEASURE as CURRENCY, a.CCC_BUSINESS_AREA as BUSINESS_AREA, a.COUNTRY_CD_OF_RISK as COUNTRY, a.BOOK, CASE WHEN a.COUNTRY_CD_OF_RISK IN ('ITA','ESP','PRT','IRL','GRC') THEN 'Periphery' WHEN a.COUNTRY_CD_OF_RISK IN ('FRA','NLD','BEL') THEN 'Soft-Core' WHEN a.COUNTRY_CD_OF_RISK = 'DEU' THEN 'Germany' WHEN a.COUNTRY_CD_OF_RISK = 'GBR' THEN 'UK' WHEN a.COUNTRY_CD_OF_RISK = 'USA' THEN 'US' ELSE 'Other' END AS country2, CASE WHEN a.PRODUCT_TYPE_CODE IN ('AGN', 'BOND', 'BONDFUT', 'BONDFUTOPT', 'CRDINDEX', 'DEFSWAP', 'GOVTBONDOPT', 'GVTBOND', 'GVTBOND ETF', 'GVTBONDIL', 'GVTBONDIL ETF', 'GVTFRN') THEN 'Treasuries' ELSE 'Swaps' END AS sectype2, SUM(coalesce(a.USD_EXPOSURE,0)) as USD_NET_EXPOSURE, SUM(coalesce(a.USD_IR_UNIFIED_PV01,0)) as USD_PV01, SUM(coalesce(a.USD_PV01SPRD,0)) as USD_PV01SPRD, SUM(coalesce(a.USD_PV10_BENCH,0)) as USD_PV10_BENCH, CASE WHEN a.COUNTRY_CD_OF_RISK IN ('ITA', 'ESP', 'PRT', 'IRL', 'GRC') THEN SUM (a.USD_PV01SPRD) ELSE SUM (a.USD_IR_UNIFIED_PV01) END AS adjust_pv01, a.CCC_STRATEGY FROM CDWUSER.U_DM_IR a WHERE a.cob_date in ('2017-03-31','2017-06-30','2017-09-29','2017-12-29','2018-02-28','2018-02-21') AND a.CCC_DIVISION = 'FIXED INCOME DIVISION' AND a.CCC_PL_REPORTING_REGION = 'EMEA' AND a.CCC_BUSINESS_AREA in ('LIQUID FLOW RATES','STRUCTURED RATES') GROUP BY a.COB_DATE, a.PRODUCT_TYPE_CODE, a.CCC_PL_REPORTING_REGION, a.CCC_PRODUCT_LINE, a.BOOK, a.COUNTRY_CD_OF_RISK, a.CURRENCY_OF_MEASURE, a.CCC_BUSINESS_AREA, a.CCC_STRATEGY