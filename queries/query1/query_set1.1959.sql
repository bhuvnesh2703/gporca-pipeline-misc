SELECT COB_DATE, CASE WHEN A.CCC_BUSINESS_AREA IN ('COMMODITIES') THEN 'COMMODITIES' ELSE CCC_DIVISION END AS CCC_DIVISION, CCC_BUSINESS_AREA, SUM(ROUND(COALESCE(A.USD_EQ_DELTA_DECOMP,0))) / 1000 AS EQ_DELTA FROM CDWUSER.U_DM_FIRMWIDE A WHERE COB_DATE IN ( '01/31/2018','02/28/2018') AND A.DIVISION_GROUP IN ('ISG CORE') AND A.CCC_BANKING_TRADING <> 'BANKING' GROUP BY COB_DATE, CASE WHEN A.CCC_BUSINESS_AREA IN ('COMMODITIES') THEN 'COMMODITIES' ELSE CCC_DIVISION END, CCC_BUSINESS_AREA