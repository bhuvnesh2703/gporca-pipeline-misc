SELECT COB_DATE, CASE WHEN POSITION_ISSUER_PARTY_DARWIN_NAME LIKE '%TESCO%' THEN 1 ELSE 0 END AS RANKING, POSITION_ISSUER_PARTY_DARWIN_NAME, TAPSCUSIP, CCC_BUSINESS_AREA, CCC_PL_REPORTING_REGION, CCC_BANKING_TRADING, PARENT_LEGAL_ENTITY, CCC_PRODUCT_LINE, CCC_STRATEGY, BOOK, CURRENCY_OF_MEASURE, CONSOLIDATED_RATING, SPG_DESC, PRODUCT_DESCRIPTION, PRODUCT_TYPE_CODE, VINTAGE, INSURER_RATING, COUNTRY_CD_OF_RISK, SPG_PRODUCT_TYPE, SPG_PRODUCT_TYPE_GROUP, DETACHMENT, ATTACHMENT, SECURITIZATION_TYPE, SUM (NET_EXPOSURE) AS NET_EXPOSURE, SUM (NOTIONAL) AS NOTIONAL, SUM (PV01) AS PV01, SUM (PV01_SPREAD) AS PV01_SPREAD FROM ( SELECT SUM (USD_EXPOSURE) AS NET_EXPOSURE, 0 AS NOTIONAL, 0 AS PV01, SUM (USD_PV01SPRD) AS PV01_SPREAD, COB_DATE, CCC_BUSINESS_AREA, CCC_PL_REPORTING_REGION, CCC_BANKING_TRADING, PARENT_LEGAL_ENTITY, CCC_PRODUCT_LINE, CCC_STRATEGY, BOOK, CURRENCY_OF_MEASURE, CONSOLIDATED_RATING, SPG_DESC, PRODUCT_DESCRIPTION, PRODUCT_TYPE_CODE, VINTAGE, INSURER_RATING, COUNTRY_CD_OF_RISK, POSITION_ISSUER_PARTY_DARWIN_NAME, SPG_PRODUCT_TYPE, SPG_PRODUCT_TYPE_GROUP, DETACHMENT, ATTACHMENT, SECURITIZATION_TYPE, VERTICAL_SYSTEM, TAPSCUSIP, POSITION_ULTIMATE_CREDIT_PARTY_DARWIN FROM CDWUSER.U_CR_MSR a GROUP BY COB_DATE, CCC_BUSINESS_AREA, CCC_PL_REPORTING_REGION, CCC_BANKING_TRADING, PARENT_LEGAL_ENTITY, CCC_PRODUCT_LINE, CCC_STRATEGY, BOOK, CURRENCY_OF_MEASURE, CONSOLIDATED_RATING, SPG_DESC, PRODUCT_DESCRIPTION, PRODUCT_TYPE_CODE, VINTAGE, INSURER_RATING, COUNTRY_CD_OF_RISK, POSITION_ISSUER_PARTY_DARWIN_NAME, SPG_PRODUCT_TYPE, SPG_PRODUCT_TYPE_GROUP, DETACHMENT, ATTACHMENT, SECURITIZATION_TYPE, VERTICAL_SYSTEM, TAPSCUSIP, POSITION_ULTIMATE_CREDIT_PARTY_DARWIN UNION ALL SELECT 0 AS NET_EXPOSURE, 0 AS NOTIONAL, SUM (USD_IR_UNIFIED_PV01) AS PV01, 0 AS PV01_SPREAD, COB_DATE, CCC_BUSINESS_AREA, CCC_PL_REPORTING_REGION, CCC_BANKING_TRADING, PARENT_LEGAL_ENTITY, CCC_PRODUCT_LINE, CCC_STRATEGY, BOOK, CURRENCY_OF_MEASURE, CONSOLIDATED_RATING, SPG_DESC, PRODUCT_DESCRIPTION, PRODUCT_TYPE_CODE, VINTAGE, INSURER_RATING, COUNTRY_CD_OF_RISK, POSITION_ISSUER_PARTY_DARWIN_NAME, SPG_PRODUCT_TYPE, SPG_PRODUCT_TYPE_GROUP, DETACHMENT, ATTACHMENT, SECURITIZATION_TYPE, VERTICAL_SYSTEM, TAPSCUSIP, POSITION_ULTIMATE_CREDIT_PARTY_DARWIN FROM CDWUSER.U_IR_MSR a GROUP BY COB_DATE, CCC_BUSINESS_AREA, CCC_PL_REPORTING_REGION, CCC_BANKING_TRADING, PARENT_LEGAL_ENTITY, CCC_PRODUCT_LINE, CCC_STRATEGY, BOOK, CURRENCY_OF_MEASURE, CONSOLIDATED_RATING, SPG_DESC, PRODUCT_DESCRIPTION, PRODUCT_TYPE_CODE, VINTAGE, INSURER_RATING, COUNTRY_CD_OF_RISK, POSITION_ISSUER_PARTY_DARWIN_NAME, SPG_PRODUCT_TYPE, SPG_PRODUCT_TYPE_GROUP, DETACHMENT, ATTACHMENT, SECURITIZATION_TYPE, VERTICAL_SYSTEM, TAPSCUSIP, POSITION_ULTIMATE_CREDIT_PARTY_DARWIN UNION ALL SELECT 0 AS NET_EXPOSURE, SUM (USD_NOTIONAL) AS NOTIONAL, 0 AS PV01, 0 AS PV01_SPREAD, COB_DATE, CCC_BUSINESS_AREA, CCC_PL_REPORTING_REGION, CCC_BANKING_TRADING, PARENT_LEGAL_ENTITY, CCC_PRODUCT_LINE, CCC_STRATEGY, BOOK, CURRENCY_OF_MEASURE, CONSOLIDATED_RATING, SPG_DESC, PRODUCT_DESCRIPTION, PRODUCT_TYPE_CODE, VINTAGE, INSURER_RATING, COUNTRY_CD_OF_RISK, POSITION_ISSUER_PARTY_DARWIN_NAME, SPG_PRODUCT_TYPE, SPG_PRODUCT_TYPE_GROUP, DETACHMENT, ATTACHMENT, SECURITIZATION_TYPE, VERTICAL_SYSTEM, TAPSCUSIP, POSITION_ULTIMATE_CREDIT_PARTY_DARWIN FROM CDWUSER.U_OT_MSR a GROUP BY COB_DATE, CCC_BUSINESS_AREA, CCC_PL_REPORTING_REGION, CCC_BANKING_TRADING, PARENT_LEGAL_ENTITY, CCC_PRODUCT_LINE, CCC_STRATEGY, BOOK, CURRENCY_OF_MEASURE, CONSOLIDATED_RATING, SPG_DESC, PRODUCT_DESCRIPTION, PRODUCT_TYPE_CODE, VINTAGE, INSURER_RATING, COUNTRY_CD_OF_RISK, POSITION_ISSUER_PARTY_DARWIN_NAME, SPG_PRODUCT_TYPE, SPG_PRODUCT_TYPE_GROUP, DETACHMENT, ATTACHMENT, SECURITIZATION_TYPE, VERTICAL_SYSTEM, TAPSCUSIP, POSITION_ULTIMATE_CREDIT_PARTY_DARWIN ) X WHERE CCC_BUSINESS_AREA IN ('CREDIT-SECURITIZED PRODS', 'SECURITIZED PRODUCTS GRP', 'RESIDENTIAL', 'COMMERCIAL RE (PTG)') AND CCC_BANKING_TRADING='TRADING' AND PARENT_LEGAL_ENTITY LIKE '0302(G)' AND COB_DATE IN ('2018-02-28' ) AND DETACHMENT=1 AND ATTACHMENT=0 AND SECURITIZATION_TYPE = 'Y' GROUP BY COB_DATE, CASE WHEN POSITION_ISSUER_PARTY_DARWIN_NAME LIKE '%TESCO%' THEN 1 ELSE 0 END, POSITION_ISSUER_PARTY_DARWIN_NAME, TAPSCUSIP, CCC_BUSINESS_AREA, CCC_PL_REPORTING_REGION, CCC_BANKING_TRADING, PARENT_LEGAL_ENTITY, CCC_PRODUCT_LINE, CCC_STRATEGY, BOOK, CURRENCY_OF_MEASURE, CONSOLIDATED_RATING, SPG_DESC, PRODUCT_DESCRIPTION, PRODUCT_TYPE_CODE, VINTAGE, INSURER_RATING, COUNTRY_CD_OF_RISK, SPG_PRODUCT_TYPE, SPG_PRODUCT_TYPE_GROUP, DETACHMENT, ATTACHMENT, SECURITIZATION_TYPE ORDER BY CASE WHEN POSITION_ISSUER_PARTY_DARWIN_NAME LIKE '%TESCO%' THEN 1 ELSE 0 END DESC