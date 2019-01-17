SELECT COB_DATE, Case when CCC_BUSINESS_AREA = 'SECURITIZED PRODUCTS GRP' then 'SPG' else CCC_BUSINESS_AREA end as CCC_BUSINESS_AREA, CASE WHEN COUNTRY_CD_OF_RISK = 'ITA' THEN 'ITALY' WHEN COUNTRY_CD_OF_RISK = 'ESP' THEN 'SPAIN' WHEN COUNTRY_CD_OF_RISK = 'PRT' THEN 'PORTUGAL' WHEN COUNTRY_CD_OF_RISK = 'GRC' THEN 'GREECE' WHEN COUNTRY_CD_OF_RISK IN ('CYP','EST','LVA','LTU','MLT','SVK','SVN') THEN 'Other' END AS COUNTRY_CD_OF_RISK, CASE WHEN TERM_NEW <=5 THEN '0-5y' WHEN TERM_NEW > 5 AND TERM_NEW <= 10 THEN '5-10y' WHEN TERM_NEW > 10 THEN '10y+' END AS TERM_NEW, SUM (USD_EXPOSURE) AS USD_EXPOSURE, sum(USD_PV10_BENCH) as USD_PV10_BENCH FROM CDWUSER.U_DM_IR WHERE cob_date IN ('2018-02-28', '2018-02-27') AND CCC_BUSINESS_AREA = 'LIQUID FLOW RATES' AND CCC_PL_REPORTING_REGION = 'EMEA' AND CCC_division IN ('FIXED INCOME DIVISION') AND USD_EXPOSURE IS NOT NULL AND USD_EXPOSURE <> 0 AND CCC_BUSINESS_AREA NOT IN ('LENDING') AND CCC_BUSINESS_AREA NOT LIKE '%CVA%' AND CCC_BUSINESS_AREA NOT LIKE '%CPM%' AND (ccc_strategy NOT IN ('CREL BANK HFI/HFS', 'CREL SECURITIZATION') OR PRODUCT_TYPE_CODE NOT IN ('LOAN')) AND CCC_BUSINESS_AREA NOT IN ('DSP - CREDIT') AND COUNTRY_CD_OF_RISK IN ('ESP', 'ITA', 'GRC', 'PRT','CYP','EST','LVA','LTU','MLT','SVK','SVN') AND PRODUCT_TYPE_CODE NOT IN ('WAREHOUSE') AND NOT (CCC_BUSINESS_AREA = 'CREDIT-CORPORATES' AND (CCC_PRODUCT_LINE IN ('NON INVSMT GRADE PRIMARY', 'NON IG PRIMARY - LOANS', 'PRIMARY - LOANS', 'NON IG PRIMARY - HY BOND', 'INVESTMENT GRADE PRIMARY')OR CCC_STRATEGY IN ('NON IG PRIMARY - HY BOND', 'INVESTMENT GRADE PRIMARY'))) GROUP BY COB_DATE, Case when CCC_BUSINESS_AREA = 'SECURITIZED PRODUCTS GRP' then 'SPG' else CCC_BUSINESS_AREA end, COUNTRY_CD_OF_RISK, CASE WHEN TERM_NEW <= 5 THEN '0-5y' WHEN TERM_NEW > 5 AND TERM_NEW <= 10 THEN '5-10y' WHEN TERM_NEW > 10 THEN '10y+' END