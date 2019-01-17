With x as (select d.COB_DATE, case when CCC_Hierarchy_Level8='STRATEGIC IDEAS GROUP' then 'CASH EQUITIES' when CCC_BUSINESS_AREA = 'DELTA ONE' then 'CASH EQUITIES' when CCC_BUSINESS_AREA = 'EQUITY FINANCING PRODUCTS' then 'PRIME BROKERAGE' else CCC_BUSINESS_AREA end as BUSINESS_AREA, d.ISSUER_COUNTRY_CODE_DECOMP as Country, CASE WHEN d.ISSUER_COUNTRY_CODE_DECOMP IN('USA','CAN') THEN 'North America' WHEN d.ISSUER_COUNTRY_CODE_DECOMP IN('GBR','DEU','FRA','ITA','ESP','NLD','BEL','FIN','CHE','SWE','NOR','AUT','DNK','IRL','LUX','GRC','CYP','PRT','HUN','ROU','ISL','POL','CZE','RUS') THEN 'Europe' WHEN d.ISSUER_COUNTRY_CODE_DECOMP IN('JPN','AUS','NZL','IND','KOR','HKG','TWN','PHL','IDN','SGP','THA','CHN','MYS') THEN 'Asia' WHEN d.ISSUER_COUNTRY_CODE_DECOMP IN('BRA','MEX','ARG','CHL','COL','PER') THEN 'Latin America' WHEN d.ISSUER_COUNTRY_CODE_DECOMP IN('ISR','ZAF','TUR','NGA','EGY','KWT','MAR','PAK','JOR','LBN','QAT','ARE','SAU','KEN', 'BHR', 'OMN') THEN 'Middle East/Africa' ELSE 'Others' END AS IssuerRegion, SUM(COALESCE(d.USD_EQ_DELTA_DECOMP,0)) as EQ_DELTA, CASE WHEN d.FID1_INDUSTRY_NAME_LEVEL2 like 'FINANCIAL%' then 'FINANCIALS' WHEN (d.FID1_INDUSTRY_NAME_LEVEL2 in ('AGENCIES', 'SOVEREIGNS') or d.FID1_INDUSTRY_NAME_LEVEL2 is null or d.FID1_INDUSTRY_NAME_LEVEL2 = 'UNDEFINED') then 'Others' ELSE d.FID1_INDUSTRY_NAME_LEVEL2 END AS INDUSTRY from cdwuser.U_DECOMP_MSR d where d.DIVISION = 'IED' and d.CCC_BANKING_TRADING = 'TRADING' and d.COB_DATE in ('2018-02-28', '2018-02-21') and d.CCC_PL_REPORTING_REGION = 'EMEA' and d.CCC_RISK_MANAGER_LOGIN <> 'chriswo' and d.PRODUCT_TYPE_CODE_DECOMP <> 'COMM' group by d.COB_DATE, d.ISSUER_COUNTRY_CODE_DECOMP, case when CCC_Hierarchy_Level8='STRATEGIC IDEAS GROUP' then 'CASH EQUITIES' when CCC_BUSINESS_AREA = 'DELTA ONE' then 'CASH EQUITIES' when CCC_BUSINESS_AREA = 'EQUITY FINANCING PRODUCTS' then 'PRIME BROKERAGE' else CCC_BUSINESS_AREA end, CASE WHEN d.ISSUER_COUNTRY_CODE_DECOMP IN('USA','CAN') THEN 'North America' WHEN d.ISSUER_COUNTRY_CODE_DECOMP IN('GBR','DEU','FRA','ITA','ESP','NLD','BEL','FIN','CHE','SWE','NOR','AUT','DNK','IRL','LUX','GRC','CYP','PRT','HUN','ROU','ISL','POL','CZE','RUS') THEN 'Europe' WHEN d.ISSUER_COUNTRY_CODE_DECOMP IN('JPN','AUS','NZL','IND','KOR','HKG','TWN','PHL','IDN','SGP','THA','CHN','MYS') THEN 'Asia' WHEN d.ISSUER_COUNTRY_CODE_DECOMP IN('BRA','MEX','ARG','CHL','COL','PER') THEN 'Latin America' WHEN d.ISSUER_COUNTRY_CODE_DECOMP IN('ISR','ZAF','TUR','NGA','EGY','KWT','MAR','PAK','JOR','LBN','QAT','ARE','SAU','KEN', 'BHR', 'OMN') THEN 'Middle East/Africa' ELSE 'Others' END, CASE WHEN d.FID1_INDUSTRY_NAME_LEVEL2 like 'FINANCIAL%' then 'FINANCIALS' WHEN (d.FID1_INDUSTRY_NAME_LEVEL2 in ('AGENCIES', 'SOVEREIGNS') or d.FID1_INDUSTRY_NAME_LEVEL2 is null or d.FID1_INDUSTRY_NAME_LEVEL2 = 'UNDEFINED') then 'Others' ELSE d.FID1_INDUSTRY_NAME_LEVEL2 END), y as (select Country, sum(case when cob_date = '2018-02-28' then EQ_DELTA else 0 end) as EQ_DELTA_COB, sum(case when cob_date = '2018-02-28' then 0 else EQ_DELTA end) as EQ_DELTA_COMP from x group by Country order by abs(sum(case when cob_date = '2018-02-28' then EQ_DELTA else 0 end)) desc fetch first 10 rows only) (Select BUSINESS_AREA, x.COUNTRY as Category, sum(case when COB_DATE = '2018-02-28' then EQ_DELTA else 0 end) AS EQ_DELTA_COB, sum(case when COB_DATE = '2018-02-28' then EQ_DELTA else - EQ_DELTA end) as EQ_DELTA_DOD from x inner join y on x.country = y.country where business_area IN('CASH EQUITIES','DERIVATIVES', 'PRIME BROKERAGE') group by BUSINESS_AREA, x.COUNTRY Union All Select Rank() over (order by abs(EQ_DELTA_COB) desc)||'_'||'TOTALCOUNTRY' as BUSINESS_AREA, Country as Category, EQ_DELTA_COB, (EQ_DELTA_COB - EQ_DELTA_COMP) as EQ_DELTA_DOD from y Union All Select BUSINESS_AREA, x.IssuerRegion as Category, sum(case when COB_DATE = '2018-02-28' then EQ_DELTA else 0 end) AS EQ_DELTA_COB, sum(case when COB_DATE = '2018-02-28' then EQ_DELTA else - EQ_DELTA end) as EQ_DELTA_DOD from x where business_area IN('CASH EQUITIES','DERIVATIVES', 'PRIME BROKERAGE') group by BUSINESS_AREA, x.IssuerRegion Union All Select Rank() over (order by abs(sum(case when COB_DATE = '2018-02-28' and IssuerRegion <> 'Others' then EQ_DELTA else 0 end)) desc)||'_'||'TOTALREGION' as BUSINESS_AREA, IssuerRegion as Category, sum(case when COB_DATE = '2018-02-28' then EQ_DELTA else 0 end) AS EQ_DELTA_COB, sum(case when COB_DATE = '2018-02-28' then EQ_DELTA else - EQ_DELTA end) as EQ_DELTA_DOD from x group by x.IssuerRegion Union All Select BUSINESS_AREA||'_'||Industry as Business_Area, 'Industry' as Category, sum(case when COB_DATE = '2018-02-28' then EQ_DELTA else 0 end) AS EQ_DELTA_COB, sum(case when COB_DATE = '2018-02-28' then EQ_DELTA else - EQ_DELTA end) as EQ_DELTA_DOD from x where business_area IN('CASH EQUITIES','DERIVATIVES', 'PRIME BROKERAGE') group by BUSINESS_AREA, Industry Union All Select 'TOTAL'||'_'||Industry as BUSINESS_AREA, 'Industry' as Category, sum(case when COB_DATE = '2018-02-28' then EQ_DELTA else 0 end) AS EQ_DELTA_COB, sum(case when COB_DATE = '2018-02-28' then EQ_DELTA else - EQ_DELTA end) as EQ_DELTA_DOD from x group by Industry)