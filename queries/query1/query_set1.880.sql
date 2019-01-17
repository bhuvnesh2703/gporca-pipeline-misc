SELECT a.COB_DATE,  CASE WHEN (A.CCC_BUSINESS_AREA NOT IN ('OTHER IED')) AND (A.CCC_STRATEGY NOT IN ('CPM OTHER','XVA OTHER')) THEN 'CPM' WHEN (A.CCC_BUSINESS_AREA NOT IN ('OTHER IED')) AND (A.CCC_STRATEGY IN ('CPM OTHER','XVA OTHER')) THEN 'CPM OTHER' ELSE A.CCC_BUSINESS_AREA END AS CCC_BUSINESS_AREA, CASE WHEN COALESCE(a.CURVE_TYPE,'') = 'CPCRMNE' THEN 'MS CDS' WHEN COALESCE(a.CURVE_TYPE,'') = 'MS_SECCPM' THEN 'MS Bond' WHEN COALESCE(a.CURVE_TYPE,'') IN ('CPCRFUND', 'CPCR_MPEFUND') THEN 'Dealer Bond' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('MPE', 'MPE_CVA', 'MNE', 'MNE_CVA', 'MNE_CP', 'MPE_PROXY','MPE_FVA_PROXY', 'MPE_FVA', 'MPE_FVA_RAW', 'MNE_FVA_NET', 'MNE_FVA') THEN 'MPE CVA' WHEN a.PRODUCT_TYPE_CODE IN ('CDSOPTIDX', 'CRDBSKT', 'CRDINDEX', 'LOANINDEX', 'MUNICDX') THEN 'INDEX' ELSE 'SN' END AS CVA_Type_Flag, SUM(a.USD_PV10_BENCH) AS PV10 FROM cdwuser.U_DM_CVA  a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-01-01') and IS_UK_GROUP in ('Y') AND   (a.CCC_BUSINESS_AREA IN ('CPM','CPM TRADING (MPE)', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD')  OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES','EQ XVA HEDGING')) AND a.USD_PV10_BENCH IS NOT NULL and a.ccc_product_line not in ('CREDIT LOAN PORTFOLIO','CMD STRUCTURED FINANCE') AND A.CURVE_TYPE NOT IN ('CPCR_CLEAR')  GROUP BY a.COB_DATE, a.CCC_BUSINESS_AREA, a.CCC_STRATEGY, CASE WHEN COALESCE(a.CURVE_TYPE,'') = 'CPCRMNE' THEN 'MS CDS' WHEN COALESCE(a.CURVE_TYPE,'') = 'MS_SECCPM' THEN 'MS Bond' WHEN COALESCE(a.CURVE_TYPE,'') IN ('CPCRFUND', 'CPCR_MPEFUND') THEN 'Dealer Bond' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('MPE', 'MPE_CVA', 'MNE', 'MNE_CVA', 'MNE_CP', 'MPE_PROXY','MPE_FVA_PROXY', 'MPE_FVA', 'MPE_FVA_RAW', 'MNE_FVA_NET', 'MNE_FVA') THEN 'MPE CVA' WHEN a.PRODUCT_TYPE_CODE IN ('CDSOPTIDX', 'CRDBSKT', 'CRDINDEX', 'LOANINDEX', 'MUNICDX') THEN 'INDEX' ELSE 'SN' END