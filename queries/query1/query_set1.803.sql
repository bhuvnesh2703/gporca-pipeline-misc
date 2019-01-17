SELECT B.COB_DATE,B.CVA_Type_Flag,B.LEFT_TENOR as TERM_NEW_GROUP, B.USD_PV01SPRD*B.LEFT_TENOR_WEIGHT as USD_PV01SPRD FROM  (SELECT a.COB_DATE, a.CCC_BUSINESS_AREA,a.MRD_RATING, CCC_PL_REPORTING_REGION,a.TERM_NEW, CASE WHEN a.TERM_NEW<=1 THEN '1YR' WHEN a.TERM_NEW> 1 and a.TERM_NEW <=5 THEN '1YR' WHEN a.TERM_NEW> 5 and a.TERM_NEW <=10 THEN '5YR' WHEN a.TERM_NEW> 10 and a.TERM_NEW <=30 THEN '10YR' WHEN a.TERM_NEW> 30 and a.TERM_NEW <=50 THEN '30YR' ELSE '50YR' END AS LEFT_TENOR, CASE WHEN a.TERM_NEW<=1 THEN '1YR' WHEN a.TERM_NEW> 1 and a.TERM_NEW <=5 THEN '5YR' WHEN a.TERM_NEW> 5 and a.TERM_NEW <=10 THEN '10YR' WHEN a.TERM_NEW> 10 and a.TERM_NEW <=30 THEN '30YR' WHEN a.TERM_NEW> 30 and a.TERM_NEW <=50 THEN '50YR' ELSE '50YR' END AS RIGHT_TENOR, CASE WHEN a.TERM_NEW<=1 THEN 0 WHEN a.TERM_NEW> 1 and a.TERM_NEW <=5 THEN (5 - a.TERM_NEW)/(5-1) WHEN a.TERM_NEW> 5 and a.TERM_NEW <=10 THEN (10 - a.TERM_NEW)/(10-5) WHEN a.TERM_NEW> 10 and a.TERM_NEW <=30 THEN (30 - a.TERM_NEW)/(30-10) WHEN a.TERM_NEW> 30 and a.TERM_NEW <=50 THEN (50 - a.TERM_NEW)/(50-30) ELSE 1 END AS LEFT_TENOR_WEIGHT, CASE WHEN a.TERM_NEW<=1 THEN 1 WHEN a.TERM_NEW> 1 and a.TERM_NEW <=5 THEN (a.TERM_NEW-1)/(5-1) WHEN a.TERM_NEW> 5 and a.TERM_NEW <=10 THEN (a.TERM_NEW-5)/(10-5) WHEN a.TERM_NEW> 10 and a.TERM_NEW <=30 THEN  (a.TERM_NEW-10)/(30-10) WHEN a.TERM_NEW> 30 and a.TERM_NEW <=50 THEN  (a.TERM_NEW-30)/(50-30) ELSE 0 END AS RIGHT_TENOR_WEIGHT, CASE WHEN COALESCE(a.CURVE_TYPE,'') = 'CPCRMNE' THEN 'MS CDS' WHEN COALESCE(a.CURVE_TYPE,'') = 'MS_SECCPM' THEN 'MS Bond' WHEN COALESCE(a.CURVE_TYPE,'') IN ('CPCRFUND', 'CPCR_MPEFUND') THEN 'Dealer Bond' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('MPE', 'MPE_CVA', 'MNE', 'MNE_CVA', 'MNE_CP', 'MPE_PROXY', 'MPE_FVA', 'MPE_FVA_RAW', 'MNE_FVA_NET', 'MNE_FVA') THEN 'MPE CVA' WHEN a.PRODUCT_TYPE_CODE IN ('CDSOPTIDX', 'CRDBSKT', 'CRDINDEX', 'LOANINDEX', 'MUNICDX') THEN 'INDEX' ELSE 'SN' END AS CVA_Type_Flag, a.TERM_BUCKET as TERM_NEW_GROUP, Sum(usd_pv01sprd) AS USD_PV01SPRD FROM cdwuser.U_CR_MSR_INTRPLT a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-01-31') and      (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM', 'CREDIT','MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR      a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES','EQ XVA HEDGING')) AND     COALESCE (a.CURVE_TYPE,               '') <> 'CPCR_CLEAR' AND      a.usd_pv01sprd IS NOT NULL and  a.PRODUCT_SUB_TYPE_CODE NOT IN ('MNE', 'MNE_FVA_NET') AND     A.CURVE_NAME <> 'ms_seccpm' GROUP BY a.COB_DATE, a.CCC_BUSINESS_AREA, a.MRD_RATING, a.TERM_NEW, CASE WHEN COALESCE(a.CURVE_TYPE,'') = 'CPCRMNE' THEN 'MS CDS' WHEN COALESCE(a.CURVE_TYPE,'') = 'MS_SECCPM' THEN 'MS Bond' WHEN COALESCE(a.CURVE_TYPE,'') IN ('CPCRFUND', 'CPCR_MPEFUND') THEN 'Dealer Bond' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('MPE', 'MPE_CVA', 'MNE', 'MNE_CVA', 'MNE_CP', 'MPE_PROXY', 'MPE_FVA', 'MPE_FVA_RAW', 'MNE_FVA_NET', 'MNE_FVA') THEN 'MPE CVA' WHEN a.PRODUCT_TYPE_CODE IN ('CDSOPTIDX', 'CRDBSKT', 'CRDINDEX', 'LOANINDEX', 'MUNICDX') THEN 'INDEX' ELSE 'SN' END, a.TERM_BUCKET,  CCC_PL_REPORTING_REGION) AS B  UNION   SELECT B.COB_DATE,B.CVA_Type_Flag,B.RIGHT_TENOR as TERM_NEW_GROUP, B.USD_PV01SPRD*B.RIGHT_TENOR_WEIGHT as USD_PV01SPRD FROM  (SELECT a.COB_DATE, a.CCC_BUSINESS_AREA,a.MRD_RATING, CCC_PL_REPORTING_REGION,a.TERM_NEW, CASE WHEN a.TERM_NEW<=1 THEN '1YR' WHEN a.TERM_NEW> 1 and a.TERM_NEW <=5 THEN '1YR' WHEN a.TERM_NEW> 5 and a.TERM_NEW <=10 THEN '5YR' WHEN a.TERM_NEW> 10 and a.TERM_NEW <=30 THEN '10YR' WHEN a.TERM_NEW> 30 and a.TERM_NEW <=50 THEN '30YR' ELSE '50YR' END AS LEFT_TENOR, CASE WHEN a.TERM_NEW<=1 THEN '1YR' WHEN a.TERM_NEW> 1 and a.TERM_NEW <=5 THEN '5YR' WHEN a.TERM_NEW> 5 and a.TERM_NEW <=10 THEN '10YR' WHEN a.TERM_NEW> 10 and a.TERM_NEW <=30 THEN '30YR' WHEN a.TERM_NEW> 30 and a.TERM_NEW <=50 THEN '50YR' ELSE '50YR' END AS RIGHT_TENOR, CASE WHEN a.TERM_NEW<=1 THEN 0 WHEN a.TERM_NEW> 1 and a.TERM_NEW <=5 THEN (5 - a.TERM_NEW)/(5-1) WHEN a.TERM_NEW> 5 and a.TERM_NEW <=10 THEN (10 - a.TERM_NEW)/(10-5) WHEN a.TERM_NEW> 10 and a.TERM_NEW <=30 THEN (30 - a.TERM_NEW)/(30-10) WHEN a.TERM_NEW> 30 and a.TERM_NEW <=50 THEN (50 - a.TERM_NEW)/(50-30) ELSE 1 END AS LEFT_TENOR_WEIGHT, CASE WHEN a.TERM_NEW<=1 THEN 1 WHEN a.TERM_NEW> 1 and a.TERM_NEW <=5 THEN (a.TERM_NEW-1)/(5-1) WHEN a.TERM_NEW> 5 and a.TERM_NEW <=10 THEN (a.TERM_NEW-5)/(10-5) WHEN a.TERM_NEW> 10 and a.TERM_NEW <=30 THEN  (a.TERM_NEW-10)/(30-10) WHEN a.TERM_NEW> 30 and a.TERM_NEW <=50 THEN  (a.TERM_NEW-30)/(50-30) ELSE 0 END AS RIGHT_TENOR_WEIGHT, CASE WHEN COALESCE(a.CURVE_TYPE,'') = 'CPCRMNE' THEN 'MS CDS' WHEN COALESCE(a.CURVE_TYPE,'') = 'MS_SECCPM' THEN 'MS Bond' WHEN COALESCE(a.CURVE_TYPE,'') IN ('CPCRFUND', 'CPCR_MPEFUND') THEN 'Dealer Bond' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('MPE', 'MPE_CVA', 'MNE', 'MNE_CVA', 'MNE_CP', 'MPE_PROXY', 'MPE_FVA', 'MPE_FVA_RAW', 'MNE_FVA_NET', 'MNE_FVA') THEN 'MPE CVA' WHEN a.PRODUCT_TYPE_CODE IN ('CDSOPTIDX', 'CRDBSKT', 'CRDINDEX', 'LOANINDEX', 'MUNICDX') THEN 'INDEX' ELSE 'SN' END AS CVA_Type_Flag, a.TERM_BUCKET as TERM_NEW_GROUP, Sum(usd_pv01sprd) AS USD_PV01SPRD FROM cdwuser.U_CR_MSR_INTRPLT a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-01-31') and      (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)', 'CPM', 'CREDIT','MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR      a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES','EQ XVA HEDGING')) AND     COALESCE (a.CURVE_TYPE,               '') <> 'CPCR_CLEAR' AND      a.usd_pv01sprd IS NOT NULL and a.PRODUCT_SUB_TYPE_CODE NOT IN ('MNE', 'MNE_FVA_NET') AND     A.CURVE_NAME <> 'ms_seccpm' GROUP BY a.COB_DATE, a.CCC_BUSINESS_AREA, a.MRD_RATING, a.TERM_NEW, CASE WHEN COALESCE(a.CURVE_TYPE,'') = 'CPCRMNE' THEN 'MS CDS' WHEN COALESCE(a.CURVE_TYPE,'') = 'MS_SECCPM' THEN 'MS Bond' WHEN COALESCE(a.CURVE_TYPE,'') IN ('CPCRFUND', 'CPCR_MPEFUND') THEN 'Dealer Bond' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('MPE', 'MPE_CVA', 'MNE', 'MNE_CVA', 'MNE_CP', 'MPE_PROXY', 'MPE_FVA', 'MPE_FVA_RAW', 'MNE_FVA_NET', 'MNE_FVA') THEN 'MPE CVA' WHEN a.PRODUCT_TYPE_CODE IN ('CDSOPTIDX', 'CRDBSKT', 'CRDINDEX', 'LOANINDEX', 'MUNICDX') THEN 'INDEX' ELSE 'SN' END, a.TERM_BUCKET,  CCC_PL_REPORTING_REGION) AS B