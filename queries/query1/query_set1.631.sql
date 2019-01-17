Select A.COB_DATE, CASE WHEN A.PRODUCT_SUB_TYPE_CODE IN ('N EAST CONSUMPTI', 'N EAST CONSUMPTION') THEN 'N EAST CONSUMPTI' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('N EAST APPALACHI', 'N EAST APPALACHIA') THEN 'N EAST APPALACHI' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('POLYPROPELENE HO', 'POLYPROPELENE HOMOPOLYMER') THEN 'POLYPROPELENE HO' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('POLYPROPYLENE CO', 'POLYPROPYLENE COPOLYMER') THEN 'POLYPROPYLENE CO' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('PURE TEREPHTHALI', 'PURE TEREPHTHALIC ACID') THEN 'PURE TEREPHTHALI' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('GSCI-PRECIOUS ME', 'GSCI-PRECIOUS METALS') THEN 'GSCI-PRECIOUS ME' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('ZERO PRICED EXPO', 'ZERO PRICED EXPOSURE') THEN 'ZERO PRICED EXPO' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('DJUBS-BASE METAL', 'DJUBS-BASE METALS') THEN 'DJUBS-BASE METAL' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('GAS SULFUR CREDI', 'GAS SULFUR CREDIT') THEN 'GAS SULFUR CREDI' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('GASOIL TIMESPREA', 'GASOIL TIMESPREAD') THEN 'GASOIL TIMESPREA' WHEN A.PRODUCT_SUB_TYPE_CODE IN ('USD INTEREST RAT', 'USD INTEREST RATE') THEN 'USD INTEREST RAT' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('GOLD') AND a.PRODUCT_DESCRIPTION LIKE '%GLD' THEN 'GLD' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('GOLD') AND a.PRODUCT_DESCRIPTION NOT LIKE '%GLD' THEN 'XAU' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('SILVER') AND a.PRODUCT_DESCRIPTION LIKE '%SLV' THEN 'SLV' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('SILVER') AND a.PRODUCT_DESCRIPTION NOT LIKE '%SLV' THEN 'XAG' WHEN a.PRODUCT_TYPE_CODE IN ('FUND') THEN 'FUND' ELSE A.PRODUCT_SUB_TYPE_CODE END AS PRODUCT_SUB_TYPE_CODE, PROD_POS_NAME_DESCRIPTION, a.Dollar_Gamma, a.Dollar_Vega, a.Raw_Vega, a.Dollar_Theta, a.Raw_Theta, a.Dollar_Delta, a.Raw_Delta, Interest_Rate, case when DAYS2exp >=720 then '2+yrs' when (DAYS2exp <720 and DAYS2exp >=360) then '2yrs'when (DAYS2exp <360 and DAYS2exp >=90)then '1yr' when (DAYS2exp <90 and DAYS2exp >=30) then '3m' when (DAYS2exp <30 and DAYS2exp >=7.5) then '1m' when (DAYS2exp <7.5 and DAYS2exp >=1.5)then '1wk'when DAYS2exp < 1.5 then'1day' else 'Check' end as MetalsTerm from ( SELECT A.COB_DATE, A.PRODUCT_SUB_TYPE_CODE, PROD_POS_NAME_DESCRIPTION, A.PRODUCT_DESCRIPTION, A.PRODUCT_TYPE_CODE, sum(cast(a.USD_CM_GAMMA/20 as numeric(15,5))) as Dollar_Gamma, sum(cast(a.USD_CM_KAPPA as numeric (15,5))) as Dollar_Vega, sum(cast(a.RAW_CM_KAPPA as numeric (15,5))) as Raw_Vega, sum(cast(a.USD_CM_THETA as numeric (15,5))) as Dollar_Theta, sum(cast(a.Raw_CM_THETA as numeric (15,5))) as Raw_Theta, sum(cast(a.USD_CM_DELTA as numeric (15,5))) as Dollar_Delta, sum(cast(a.Raw_CM_DELTA as numeric (15,5))) as Raw_Delta, sum(cast(coalesce(USD_CM_LEASE_RATE,0) as numeric (15,5)) + cast(coalesce(USD_IR_RHO,0) as numeric (15,5)))/10000 as Interest_Rate, (extract(YEAR FROM (a.EXPIRATION_DATE)) - extract(YEAR FROM (a.COB_DATE))) * 360 + (extract(MONTH FROM (a.EXPIRATION_DATE)) - extract(MONTH FROM (a.COB_DATE))) * 30 + (extract(DAY FROM (a.EXPIRATION_DATE)) - extract(DAY FROM (a.COB_DATE))) AS DAYS2exp FROM cdwuser.U_EXP_MSR A WHERE ((A.CCC_DIVISION='COMMODITIES' AND A.CCC_BUSINESS_AREA in ('METALS') AND A.PRODUCT_TYPE_CODE IN ('PRECIOUSMETAL', 'FUND')) /* OLD LOGIC*/ or (A.CCC_DIVISION = 'FIXED INCOME DIVISION' AND A.CCC_BUSINESS_AREA = 'COMMODITIES' and (a.CCC_PRODUCT_LINE IN ('PRECIOUS METALS')) AND A.CCC_STRATEGY NOT IN ('MS CVA MNE - COMMOD'))/* NEW LOGIC*/ ) AND A.COB_DATE IN ('2018-02-28','2018-02-21') AND PRODUCT_TYPE_CODE NOT IN ('CURRENCY', 'INTEREST RATE', 'INFLATION', 'TBD', 'MISC','CVA', 'FVA', 'ERROR') GROUP BY A.COB_DATE, A.PRODUCT_SUB_TYPE_CODE,A.PRODUCT_TYPE_CODE, A.PRODUCT_DESCRIPTION, PROD_POS_NAME_DESCRIPTION, a.EXPIRATION_DATE)A