WITH MARKET_DECOMP(INDEX_NAME, TICK_DECOMP) AS (values ('omxs30.stor','swma.st'), ('omxs30.stor','alivSDB.st'), ('omxs30.stor','scaB.st'), ('omxs30.stor','ssabA.st'), ('omxs30.stor','swedA.st'), ('omxs30.stor','tel2B.st'), ('omxs30.stor','eluxB.st'), ('omxs30.stor','inveB.st'), ('omxs30.stor','telia.st'), ('omxs30.stor','sebA.st'), ('omxs30.stor','atcoA.st'), ('omxs30.stor','atcoB.st'), ('omxs30.stor','shbA.st'), ('omxs30.stor','ericB.st'), ('omxs30.stor','lupe.st'), ('omxs30.stor','bol.st'), ('omxs30.stor','alfa.st'), ('omxs30.stor','fingB.st'), ('omxs30.stor','essityB.st'), ('omxs30.stor','abb.st'), ('omxs30.stor','ndaSEK.st'), ('omxs30.stor','getiB.st'), ('omxs30.stor','assaB.st'), ('omxs30.stor','skfB.st'), ('omxs30.stor','sand.st'), ('omxs30.stor','volvB.st'), ('omxs30.stor','kinvB.st'), ('omxs30.stor','hmB.st'), ('omxs30.stor','skaB.st'), ('omxs30.stor','secuB.st'), ('omxs30.stor','azn.st') ), DATABASE_DECOMP as( SELECT DISTINCT d.UNDERLIER_TICK||'.'||d.UNDERLIER_EXCH as INDEX_NAME, d.TICKER_DECOMP||'.'||d.EXCHANGE_DECOMP as TICK_DECOMP FROM CDWUSER.U_DECOMP_MSR d WHERE d.COB_DATE ='2018-02-28' AND d.CCC_BANKING_TRADING='TRADING' AND d.BOOK = 'ETP' AND d.CCC_RISK_MANAGER_LOGIN = 'freemric' AND d.CCC_BOOK_DETAIL IN('DE_INDEX', 'DSP ETP INDEX', 'DSP ETP CC') ), POSSIBLE_DECOMP as( SELECT * FROM MARKET_DECOMP UNION SELECT * FROM DATABASE_DECOMP ), UNDERLIER_DESC as ( SELECT a.UNDERLIER_PRODUCT_DESCRIPTION AS UNDERLIER_PRODUCT_DESCRIPTION_HEDGED, a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH as UNDERLIER_TICK FROM CDWUSER.U_EQ_MSR a WHERE a.COB_DATE ='2018-02-28' AND a.BOOK = 'ETP' AND a.EXECUTIVE_MODEL in ('MINIFUTURECERTIFICATE','CONSTANTLEVERAGECERTIFICATE','DELTAONECERTIFICATE','OPENENDEDTURBOCERTIFICATE') AND a.MRD_ASSET_CLASS = 'EQ' AND a.CASH_ISSUE_TYPE = 'INDEX' AND a.CASH_ISSUE_TYPE <> 'CMDT' AND UPPER(a.UNDERLIER_PRODUCT_DESCRIPTION) NOT LIKE '%SOLACTIVE%' GROUP BY a.UNDERLIER_PRODUCT_DESCRIPTION, a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH UNION SELECT CASE WHEN a.UNDERLIER_PRODUCT_DESCRIPTION IN (SELECT DISTINCT a.PRODUCT_DESCRIPTION_DECOMP FROM DWUSER.U_DECOMP_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.UNDERLIER_PRODUCT_DESCRIPTION = 'EU Referendum Index' AND a.SILO_SRC = 'IED') THEN 'EU Referendum Index' WHEN a.UNDERLIER_PRODUCT_DESCRIPTION IN (SELECT DISTINCT a.PRODUCT_DESCRIPTION_DECOMP FROM DWUSER.U_DECOMP_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.UNDERLIER_PRODUCT_DESCRIPTION = 'GMINERS' AND a.SILO_SRC = 'IED') THEN 'GMINERS' WHEN a.UNDERLIER_PRODUCT_DESCRIPTION IN (SELECT DISTINCT a.PRODUCT_DESCRIPTION_DECOMP FROM DWUSER.U_DECOMP_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.UNDERLIER_PRODUCT_DESCRIPTION = 'SMINERS' AND a.SILO_SRC = 'IED') THEN 'SMINERS' WHEN a.UNDERLIER_PRODUCT_DESCRIPTION IN (SELECT DISTINCT a.PRODUCT_DESCRIPTION_DECOMP FROM DWUSER.U_DECOMP_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.UNDERLIER_PRODUCT_DESCRIPTION = 'Best of Gold Miners Index' AND a.SILO_SRC = 'IED') THEN 'Best of Gold Miners Index' WHEN a.UNDERLIER_PRODUCT_DESCRIPTION IN (SELECT DISTINCT a.PRODUCT_DESCRIPTION_DECOMP FROM DWUSER.U_DECOMP_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.UNDERLIER_PRODUCT_DESCRIPTION = 'Best of Silver Miners Index' AND a.SILO_SRC = 'IED') THEN 'Best of Silver Miners Index' WHEN a.UNDERLIER_PRODUCT_DESCRIPTION IN (SELECT DISTINCT a.PRODUCT_DESCRIPTION_DECOMP FROM DWUSER.U_DECOMP_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.UNDERLIER_PRODUCT_DESCRIPTION = 'TSI Deutschland 30 Index' AND a.SILO_SRC = 'IED') THEN 'TSI Deutschland 30 Index' WHEN a.UNDERLIER_PRODUCT_DESCRIPTION IN (SELECT DISTINCT a.PRODUCT_DESCRIPTION_DECOMP FROM DWUSER.U_DECOMP_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.UNDERLIER_PRODUCT_DESCRIPTION = 'DER AKTIONAR TITAN 20' AND a.SILO_SRC = 'IED') THEN 'DER AKTIONAR TITAN 20' WHEN a.UNDERLIER_PRODUCT_DESCRIPTION IN (SELECT DISTINCT a.PRODUCT_DESCRIPTION_DECOMP FROM DWUSER.U_DECOMP_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.UNDERLIER_PRODUCT_DESCRIPTION = 'X-DAX Index PR (gdaxi)' AND a.SILO_SRC = 'IED') THEN 'X-DAX Index PR (gdaxi)' WHEN a.UNDERLIER_PRODUCT_DESCRIPTION IN (SELECT DISTINCT a.PRODUCT_DESCRIPTION_DECOMP FROM DWUSER.U_DECOMP_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.PRODUCT_DESCRIPTION = 'NASDAQ 100 INDEX' AND a.SILO_SRC = 'IED') THEN 'NASDAQ 100 INDEX' WHEN a.UNDERLIER_PRODUCT_DESCRIPTION IN (SELECT DISTINCT a.PRODUCT_DESCRIPTION_DECOMP FROM DWUSER.U_DECOMP_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.PRODUCT_DESCRIPTION = 'EURO STOXX 50' AND a.SILO_SRC = 'IED') THEN 'EURO STOXX 50' WHEN a.UNDERLIER_PRODUCT_DESCRIPTION IN (SELECT DISTINCT a.PRODUCT_DESCRIPTION_DECOMP FROM DWUSER.U_DECOMP_MSR a WHERE a.COB_DATE = '2018-02-28' AND a.PRODUCT_DESCRIPTION = 'S&P 500 INDEX' AND a.SILO_SRC = 'IED') THEN 'S&P 500 INDEX' ELSE a.UNDERLIER_PRODUCT_DESCRIPTION END AS UNDERLIER_PRODUCT_DESCRIPTION_HEDGED, a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH as UNDERLIER_TICK FROM CDWUSER.U_EQ_MSR a WHERE a.COB_DATE ='2018-02-28' AND a.BOOK = 'ETP' AND a.CCC_BOOK_DETAIL IN ('DSP ETP INDEX','DE_EQUITY','DE_INDEX','DE_BASKET','DSP ETP CC') AND a.EXECUTIVE_MODEL not in ('MINIFUTURECERTIFICATE','CONSTANTLEVERAGECERTIFICATE','DELTAONECERTIFICATE','OPENENDEDTURBOCERTIFICATE') AND a.MRD_ASSET_CLASS = 'EQ' AND a.CASH_ISSUE_TYPE <> 'CMDT' GROUP BY a.UNDERLIER_PRODUCT_DESCRIPTION, a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH ) SELECT b.UNDERLIER_PRODUCT_DESCRIPTION_HEDGED, a.* FROM ( SELECT RANK() OVER(ORDER BY abs(sum(coalesce(a.SLIDE_EQ_MIN_30_USD,0))) DESC) as RANK, TICK_HEDGED, sum(coalesce(a.SLIDE_EQ_MIN_30_USD,0)) as SLIDE_EQ_MIN_30_USD, sum(coalesce(a.SLIDE_EQ_MIN_20_USD,0)) as SLIDE_EQ_MIN_20_USD, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0)) as SLIDE_EQ_MIN_10_USD, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0)) as SLIDE_EQ_MIN_05_USD, sum(coalesce(a.SLIDE_EQ_MIN_02_USD,0)) as SLIDE_EQ_MIN_02_USD, sum(coalesce(a.SLIDE_EQ_PLS_02_USD,0)) as SLIDE_EQ_PLS_02_USD, sum(coalesce(a.SLIDE_EQ_PLS_05_USD,0)) as SLIDE_EQ_PLS_05_USD, sum(coalesce(a.SLIDE_EQ_PLS_10_USD,0)) as SLIDE_EQ_PLS_10_USD, sum(coalesce(a.SLIDE_EQ_PLS_20_USD,0)) as SLIDE_EQ_PLS_20_USD, sum(coalesce(a.SLIDE_EQ_PLS_30_USD,0)) as SLIDE_EQ_PLS_30_USD FROM ( SELECT a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH as TICK, CASE WHEN a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH IN (SELECT TICK_DECOMP FROM POSSIBLE_DECOMP WHERE INDEX_NAME='omxs30.stor') THEN 'omxs30.stor' WHEN a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH='daxxdax.ibsr' THEN 'gdaxi.ibsr' ELSE a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH END AS TICK_HEDGED, sum(coalesce(a.SLIDE_EQ_MIN_30_USD,0)) as SLIDE_EQ_MIN_30_USD, sum(coalesce(a.SLIDE_EQ_MIN_20_USD,0)) as SLIDE_EQ_MIN_20_USD, sum(coalesce(a.SLIDE_EQ_MIN_10_USD,0)) as SLIDE_EQ_MIN_10_USD, sum(coalesce(a.SLIDE_EQ_MIN_05_USD,0)) as SLIDE_EQ_MIN_05_USD, sum(coalesce(a.SLIDE_EQ_MIN_02_USD,0)) as SLIDE_EQ_MIN_02_USD, sum(coalesce(a.SLIDE_EQ_PLS_02_USD,0)) as SLIDE_EQ_PLS_02_USD, sum(coalesce(a.SLIDE_EQ_PLS_05_USD,0)) as SLIDE_EQ_PLS_05_USD, sum(coalesce(a.SLIDE_EQ_PLS_10_USD,0)) as SLIDE_EQ_PLS_10_USD, sum(coalesce(a.SLIDE_EQ_PLS_20_USD,0)) as SLIDE_EQ_PLS_20_USD, sum(coalesce(a.SLIDE_EQ_PLS_30_USD,0)) as SLIDE_EQ_PLS_30_USD FROM CDWUSER.U_EXP_MSR a WHERE a.COB_DATE ='2018-02-28' AND a.CCC_BANKING_TRADING='TRADING' AND a.BOOK = 'ETP' AND a.CCC_RISK_MANAGER_LOGIN = 'freemric' AND a.CCC_BOOK_DETAIL IN('DE_INDEX', 'DSP ETP INDEX','DSP ETP CC') GROUP BY a.UNDERLIER_TICK||'.'||a.UNDERLIER_EXCH ) a GROUP BY a.TICK_HEDGED )a JOIN UNDERLIER_DESC b ON a.TICK_HEDGED = b.UNDERLIER_TICK WHERE (a.TICK_HEDGED NOT IN(SELECT TICK_DECOMP FROM POSSIBLE_DECOMP WHERE INDEX_NAME='omxs30.stor') OR a.TICK_HEDGED='omxs30.stor') AND a.TICK_HEDGED NOT IN('daxxdax.ibsr')