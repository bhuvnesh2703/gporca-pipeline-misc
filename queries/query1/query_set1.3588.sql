SELECT abc.EMFLAG, abc.SOVNN, abc.population, abc.rating2, abc.industry, abc.BASEL_III_GROUP_BTI, abc.USD_PV01SPRDUK, abc.USD_PV10_BENCH FROM ( SELECT CASE WHEN A.ISSUER_COUNTRY_CODE IN ('XS', 'VGB', 'USA', 'SWE', 'PRT', 'NZL', 'NOR', 'NLD', 'LUX', 'JPN', 'JEY', 'ITA', 'ISL', 'IRL', 'IRL', 'IMN', 'GRC', 'GGY', 'GBR', 'FRA', 'FIN', 'ESP', 'DNK', 'DEU', 'CYP', 'CYM', 'CHE', 'CAN', 'BMU', 'BEL', 'AUT', 'AUS') THEN 'G10' ELSE 'EM' END as EMFLAG, CASE WHEN (a.FID1_INDUSTRY_NAME_LEVEL1 IN ('SOVEREIGN', 'GOVERNMENT SPONSORED') OR (a.FID1_INDUSTRY_NAME_LEVEL1 = 'N/A' AND a.ISSUER_COUNTRY_CODE = 'XS')) THEN 'SOVEREIGN' WHEN a.UNDERLIER_TICK ||'.'||a.underlier_Exch IN ('tlt.p') THEN 'SOVEREIGN' WHEN (a.vertical_system LIKE '%EQUITY%' AND a.product_type_code IN ('FUTURE')) THEN 'SOVEREIGN' ELSE 'NNSOVEREIGN' END AS SOVNN, CASE WHEN A.MRD_RATING IN ('AAA', 'AA', 'A', 'BBB') THEN 'IG' ELSE 'NIG' END AS RATING2, a.BASEL_III_GROUP_BTI, CASE WHEN A.FID1_SENIORITY IN ('AT1', 'SUBT1', 'SUBUT2') THEN 'Junior Subordinate' WHEN A.CCC_PRODUCT_LINE IN ('DISTRESSED TRADING') THEN 'Distressed Trading' WHEN (a.CCC_BUSINESS_AREA IN ('CREDIT-SECURITIZED PRODS', 'SECURITIZED PRODUCTS GRP', 'COMMERCIAL RE (PTG)', 'RESIDENTIAL') AND A.SPG_DESC NOT IN ('CORPORATE BONDS', 'CORPORATE DEFAULT SWAP', 'SWAP', 'GOVERNMENT')) THEN 'SPG' ELSE 'spreadsensexpo' END AS population, CASE WHEN FID1_INDUSTRY_NAME_LEVEL2 LIKE '%FINANCIAL%' THEN 'FINANCIALS' WHEN FID1_INDUSTRY_NAME_LEVEL2 = 'ENERGY' THEN 'ENERGY' ELSE 'Others' END AS industry, /* SUM (CASE WHEN (a.CCC_BUSINESS_AREA IN ('CPM', 'CPM TRADING (MPE)', 'CREDIT') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 0 WHEN (a.vertical_system like'%EQUITY%') THEN A.USD_PV01SPRD/1000 ELSE A.USD_PV01SPRD END) AS USD_PV01SPRDUKxCVA, */ SUM (CASE WHEN (a.vertical_system like'%EQUITY%') THEN A.USD_PV01SPRD/1000 ELSE A.USD_PV01SPRD END) AS USD_PV01SPRDUK, /* SUM (CASE WHEN (a.CCC_BUSINESS_AREA IN ('CPM', 'CPM TRADING (MPE)', 'CREDIT') OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING')) THEN 0 ELSE COALESCE(A.USD_PV10_BENCH,a.USD_CREDIT_PV10PCT) END) AS USD_PV10_BENCHexCVA, */ SUM (COALESCE(A.USD_PV10_BENCH,a.USD_CREDIT_PV10PCT)) AS USD_PV10_BENCH FROM cdwuser.U_EXP_MSR A WHERE a.cob_date IN ('2018-02-28') AND a.LE_GROUP = 'UK' AND a.BASEL_III_GROUP_BTI <> 'UNDEFINED' AND CCC_DIVISION NOT IN ('FID DVA','FIC DVA') AND CCC_STRATEGY NOT IN ('MS DVA STR NOTES IED') GROUP BY CASE WHEN A.ISSUER_COUNTRY_CODE IN ('XS', 'VGB', 'USA', 'SWE', 'PRT', 'NZL', 'NOR', 'NLD', 'LUX', 'JPN', 'JEY', 'ITA', 'ISL', 'IRL', 'IRL', 'IMN', 'GRC', 'GGY', 'GBR', 'FRA', 'FIN', 'ESP', 'DNK', 'DEU', 'CYP', 'CYM', 'CHE', 'CAN', 'BMU', 'BEL', 'AUT', 'AUS') THEN 'G10' ELSE 'EM' END, CASE WHEN (a.FID1_INDUSTRY_NAME_LEVEL1 IN ('SOVEREIGN', 'GOVERNMENT SPONSORED') OR (a.FID1_INDUSTRY_NAME_LEVEL1 = 'N/A' AND a.ISSUER_COUNTRY_CODE = 'XS')) THEN 'SOVEREIGN' WHEN a.UNDERLIER_TICK ||'.'||a.underlier_Exch IN ('tlt.p') THEN 'SOVEREIGN' WHEN (a.vertical_system LIKE '%EQUITY%' AND a.product_type_code IN ('FUTURE')) THEN 'SOVEREIGN' ELSE 'NNSOVEREIGN' END, CASE WHEN A.MRD_RATING IN ('AAA', 'AA', 'A', 'BBB') THEN 'IG' ELSE 'NIG' END, a.BASEL_III_GROUP_BTI, CASE WHEN A.FID1_SENIORITY IN ('AT1', 'SUBT1', 'SUBUT2') THEN 'Junior Subordinate' WHEN A.CCC_PRODUCT_LINE IN ('DISTRESSED TRADING') THEN 'Distressed Trading' WHEN (a.CCC_BUSINESS_AREA IN ('CREDIT-SECURITIZED PRODS', 'SECURITIZED PRODUCTS GRP', 'COMMERCIAL RE (PTG)', 'RESIDENTIAL') AND A.SPG_DESC NOT IN ('CORPORATE BONDS', 'CORPORATE DEFAULT SWAP', 'SWAP', 'GOVERNMENT')) THEN 'SPG' ELSE 'spreadsensexpo' END, CASE WHEN FID1_INDUSTRY_NAME_LEVEL2 LIKE '%FINANCIAL%' THEN 'FINANCIALS' WHEN FID1_INDUSTRY_NAME_LEVEL2 = 'ENERGY' THEN 'ENERGY' ELSE 'Others' END ) abc WHERE abc.EMFLAG = 'G10' AND abc.population = 'spreadsensexpo' AND abc.SOVNN = 'NNSOVEREIGN' GROUP BY abc.EMFLAG, abc.SOVNN, abc.population, abc.rating2, abc.BASEL_III_GROUP_BTI, abc.industry, abc.BASEL_III_GROUP_BTI, abc.USD_PV01SPRDUK, abc.USD_PV10_BENCH