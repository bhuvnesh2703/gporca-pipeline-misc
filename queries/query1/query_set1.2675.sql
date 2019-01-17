SELECT COB_DATE, CCC_DIVISION, 'CVA' AS CR_BREAKDOWN, CASE WHEN A.CCC_HIERARCHY_LEVEL9 IN ('MNE CVA RISK MGMT', 'MNE FVA RISK MGMT', 'MS CVA MNE DERIVS IED') THEN 'MNE CVA/FVA' WHEN A.CCC_HIERARCHY_LEVEL9 IN ('MPE CVA RISK MGMT', 'MPE FVA RISK MGMT', 'MS CVA MPE- DERIVS IED') THEN 'MPE CVA/FVA' ELSE A.CCC_HIERARCHY_LEVEL9 END AS CCC_HIERARCHY_LEVEL9, SUM(A.USD_PV10_BENCH)/1000 AS BPV10 FROM CDWUSER.U_DM_FIRMWIDE A WHERE COB_DATE IN ('02/28/2018', '02/27/2018') AND ( CCC_BUSINESS_AREA IN ('CPM') OR CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES') ) GROUP BY COB_DATE, A.CCC_DIVISION, CASE WHEN A.CCC_HIERARCHY_LEVEL9 IN ('MNE CVA RISK MGMT', 'MNE FVA RISK MGMT', 'MS CVA MNE DERIVS IED') THEN 'MNE CVA/FVA' WHEN A.CCC_HIERARCHY_LEVEL9 IN ('MPE CVA RISK MGMT', 'MPE FVA RISK MGMT', 'MS CVA MPE- DERIVS IED') THEN 'MPE CVA/FVA' ELSE A.CCC_HIERARCHY_LEVEL9 END