WITH x AS (SELECT e.cob_date, e.CCC_PL_REPORTING_REGION, e.PRODUCT_DESCRIPTION, e.UNDERLIER_PRODUCT_DESCRIPTION, SUM (COALESCE (e.SLIDE_PAL_STK_JTD_USD, 0)) AS D99, SUM (COALESCE (e.SLIDE_PAL_STK_30_DOWN_USD, 0)) AS D30, SUM (COALESCE (e.SLIDE_PAL_STK_20_DOWN_USD, 0)) AS D20 FROM cdwuser.U_EQ_EXT_MSR e WHERE e.COB_DATE IN ('2018-02-28','2018-02-21') AND e.DIVISION = 'IED' AND SLIDE_TYPE_FL = 'D' AND e.CCC_BUSINESS_AREA NOT IN ('EQUITY FINANCING PRODUCTS', 'PRIME BROKERAGE') AND e.EXECUTIVE_MODEL LIKE '%MARGIN-LOAN%' GROUP BY e.cob_date, e.CCC_PL_REPORTING_REGION, e.PRODUCT_DESCRIPTION, e.UNDERLIER_PRODUCT_DESCRIPTION) ( SELECT RANK () OVER (ORDER BY ABS (SUM (CASE WHEN cob_date = '2018-02-28' THEN D99 ELSE 0 END)) DESC) || '_' || 'TopMarginLoans' AS Concentration, product_description, underlier_product_description, SUM (CASE WHEN cob_date = '2018-02-28' THEN D99 ELSE 0 END) AS JTD_COB, SUM (CASE WHEN cob_date = '2018-02-28'THEN D99 ELSE - D99 END) AS JTD_DOD, SUM (CASE WHEN cob_date = '2018-02-28'THEN D20 ELSE 0 END) AS D20_COB, SUM (CASE WHEN cob_date = '2018-02-28' THEN D20 ELSE - D20 END) AS D20_DOD, SUM (CASE WHEN cob_date = '2018-02-28' THEN D30 ELSE 0 END) AS D30_COB, SUM (CASE WHEN cob_date = '2018-02-28' THEN D30 ELSE - D30 END) AS D30_DOD FROM x GROUP BY product_Description, underlier_product_description FETCH FIRST 10 ROWS ONLY ) UNION ALL SELECT CUR.RANK || '_' || CUR.RANK_NAME AS CONCENTRATION, CUR.PRODUCT_DESCRIPTION, CUR.UNDERLIER_PRODUCT_DESCRIPTION, CUR.SLIDE_PAL_STK_JTD_USD AS JTD_COB, COALESCE (CUR.SLIDE_PAL_STK_JTD_USD, 0) - COALESCE (PREV.SLIDE_PAL_STK_JTD_USD, 0) AS JTD_DOD, CUR.SLIDE_PAL_STK_20_DOWN_USD AS D20_RAW, COALESCE (CUR.SLIDE_PAL_STK_20_DOWN_USD,0) - COALESCE (PREV.SLIDE_PAL_STK_20_DOWN_USD,0) AS D20_DOD, CUR.SLIDE_PAL_STK_30_DOWN_USD AS D30_RAW, COALESCE (CUR.SLIDE_PAL_STK_30_DOWN_USD, 0) - COALESCE (PREV.SLIDE_PAL_STK_30_DOWN_USD,0) AS D30_DOD FROM CDWUSER.U_DM_CONC CUR LEFT OUTER JOIN CDWUSER.U_DM_CONC PREV ON CUR.RANK_TYPE = PREV.RANK_TYPE AND CUR.RANK_NAME = PREV.RANK_NAME AND CUR.PRODUCT_DESCRIPTION = PREV.PRODUCT_DESCRIPTION AND CUR.UNDERLIER_PRODUCT_DESCRIPTION = PREV.UNDERLIER_PRODUCT_DESCRIPTION AND PREV.RANK_TYPE = 'MARGINLOAN' AND PREV.COB_DATE = '2018-02-21' WHERE CUR.RANK_TYPE = 'MARGINLOAN' AND CUR.COB_DATE = '2018-02-28'