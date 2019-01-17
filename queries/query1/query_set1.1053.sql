SELECT     cob_date,     CASE WHEN (a.VERTICAL_SYSTEM LIKE 'STS%' AND                a.BOOK = 'EQCVA') THEN 'Berkshire Hathaway'     ELSE a.position_ultimate_credit_party_darwin_name END AS CTPY_NAME,     SUM (usd_delta) AS USD_DELTA FROM cdwuser.u_eq_msr a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') AND  LE_GROUP = ('UK') AND      a.book NOT IN ('CVASP') AND     (a.ccc_business_area IN ('CPM TRADING (MPE)', 'CPM', 'CREDIT', 'COMMODS FINANCING') OR      a.ccc_strategy IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES','EQ XVA HEDGING')) AND     a.usd_delta IS NOT NULL GROUP BY     cob_date,         CASE WHEN (a.VERTICAL_SYSTEM LIKE 'STS%' AND                a.BOOK = 'EQCVA') THEN 'Berkshire Hathaway'     ELSE a.position_ultimate_credit_party_darwin_name END