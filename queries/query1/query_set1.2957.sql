Select T.COB_DATE, T.LE, CASE WHEN CCC_DIVISION in ('INSTITUTIONAL EQUITY DIVISION') AND PRODUCT_TYPE_CODE IN ('COMM','ETF','OPTION','SWAP','GSCI','INDEX') AND PRODUCT_DESCRIPTION_DECOMP IN ('SILVER','GOLD','PLATINUM','PALLADIUM','S&P GSCI GOLD INDEX EXCESS RETURN','COMEX SILVER') THEN 'PRECIOUS METALS' WHEN CCC_DIVISION in ('INSTITUTIONAL EQUITY DIVISION') AND PRODUCT_TYPE_CODE IN ('COMM','ETF','OPTION','SWAP','GSCI','INDEX') AND PRODUCT_DESCRIPTION_DECOMP IN ('COPPER','LME NICKEL','LME ZINC','HG COPPER') THEN 'BASE METALS' WHEN (CCC_DIVISION in ('INSTITUTIONAL EQUITY DIVISION') AND PRODUCT_TYPE_CODE IN ('COMM','ETF','OPTION','SWAP','GSCI','INDEX') AND (PRODUCT_DESCRIPTION_DECOMP IN ('WTI CRUDE OIL','S&P GSCI BRENT INDEX EXCESS RETURN','S&P GSCI CRUDE OIL INDEX EXCS RETURN', 'LIGHT_CRUDE NEAR ALIAS','BRENT CRUDE OIL','Reformulated Gasoline Blendstock for Oxygen Blending (RBOB)', 'Reformulated Gasoline Blendstock for Oxygen Blending (RBOB) Futu','ICE NYH RBOB GASOLINE') or PRODUCT_DESCRIPTION_DECOMP LIKE 'LIGHT_CRUDE%' or PRODUCT_DESCRIPTION_DECOMP IN ('HEATING OIL','GAS OIL','NATURAL GAS','UK NATURAL GAS'))) THEN 'ENERGY' WHEN T.PRODUCT_TYPE_CODE IN ('BASEMETAL') THEN 'BASE METALS' WHEN T.PRODUCT_TYPE_CODE IN ('PRECIOUSMETAL') THEN 'PRECIOUS METALS' WHEN T.CCC_PRODUCT_LINE IN ('NA POWER & GAS','EU POWER & GAS', 'OIL & PRODUCTS') THEN 'ENERGY' ELSE 'OTHER' END AS TYPE, CASE WHEN T.LE NOT IN ('MSCGI') THEN SUM(T.CM_DELTA)*1000*0.01 END AS CM_DELTA From ( SELECT A.COB_DATE, A.CCC_PRODUCT_LINE, A.CCC_BUSINESS_AREA,A.PRODUCT_TYPE_CODE,A.PRODUCT_DESCRIPTION_DECOMP,A. CCC_DIVISION, CASE when A.CCC_TAPS_COMPANY in ( '0201','0103','0205','0206','0530','5924') then 'MSCO' when A.CCC_TAPS_COMPANY in ('0111') then 'MSCS' when A.CCC_TAPS_COMPANY in ('1633') then 'MSBNA' when A.CCC_TAPS_COMPANY in ('0362') then 'MSMS' when A.PARENT_LEGAL_ENTITY in ('0302(G)') then 'MSIP' when A.PARENT_LEGAL_ENTITY in ('0517(G)') then 'MSBIL' when A.CCC_TAPS_COMPANY in ('8890', '8840') then 'MSMCB' when A.CCC_TAPS_COMPANY in ('5745') then 'MSCAP' when A.CCC_TAPS_COMPANY in ('0105', '0513', '1133', '1614', '2042', '4442', '4919', '4920', '5122', '6399', '7025', '7038', '7114', '7323', '7410', '7504', '7516', '8296', '8304', '8562', '8747', '8934', '7706', '7549', '6706', '5427', '7414', '7465', '7493', '7278', '7279', '7705', '7624', '7681', '7800', '5656', '7708', '7707', '7801', '7627', '7759', '7710', '7762', '7630', '7628', '7761', '7684', '5923', '7609') then 'MSCGI' end as LE, sum(A.USD_CM_DELTA_DECOMP) as CM_DELTA FROM CDWUSER.u_decomp_msr A WHERE COB_DATE in ('2018-02-28') and (A.CCC_TAPS_COMPANY in ('1633', '0362', '8890', '8840','0201','0103','0205','0206','0530','5924','0111','5745','0105', '0513', '1133', '1614', '2042', '4442', '4919', '4920', '5122', '6399', '7025', '7038', '7114', '7323', '7410', '7504', '7516', '8296', '8304', '8562', '8747', '8934', '7706', '7549', '6706', '5427', '7414', '7465', '7493', '7278', '7279', '7705', '7624', '7681', '7800', '5656', '7708', '7707', '7801', '7627', '7759', '7710', '7762', '7630', '7628', '7761', '7684', '5923', '7609','5745') or A.PARENT_LEGAL_ENTITY in ('0302(G)','0517(G)')) AND A.VAR_EXCL_FL <> 'Y' GROUP BY A.COB_DATE, A.CCC_PRODUCT_LINE, A.CCC_BUSINESS_AREA,A.PRODUCT_TYPE_CODE,A.PRODUCT_DESCRIPTION_DECOMP,A.CCC_DIVISION, CASE when A.CCC_TAPS_COMPANY in ( '0201','0103','0205','0206','0530','5924') then 'MSCO' when A.CCC_TAPS_COMPANY in ('0111') then 'MSCS' when A.CCC_TAPS_COMPANY in ('1633') then 'MSBNA' when A.CCC_TAPS_COMPANY in ('0362') then 'MSMS' when A.PARENT_LEGAL_ENTITY in ('0302(G)') then 'MSIP' when A.PARENT_LEGAL_ENTITY in ('0517(G)') then 'MSBIL' when A.CCC_TAPS_COMPANY in ('8890', '8840') then 'MSMCB' when A.CCC_TAPS_COMPANY in ('5745') then 'MSCAP' when A.CCC_TAPS_COMPANY in ('0105', '0513', '1133', '1614', '2042', '4442', '4919', '4920', '5122', '6399', '7025', '7038', '7114', '7323', '7410', '7504', '7516', '8296', '8304', '8562', '8747', '8934', '7706', '7549', '6706', '5427', '7414', '7465', '7493', '7278', '7279', '7705', '7624', '7681', '7800', '5656', '7708', '7707', '7801', '7627', '7759', '7710', '7762', '7630', '7628', '7761', '7684', '5923', '7609') then 'MSCGI' end ) T GROUP BY T.COB_DATE, T.LE, T.CCC_BUSINESS_AREA,T.CCC_DIVISION, CASE WHEN CCC_DIVISION in ('INSTITUTIONAL EQUITY DIVISION') AND PRODUCT_TYPE_CODE IN ('COMM','ETF','OPTION','SWAP','GSCI','INDEX') AND PRODUCT_DESCRIPTION_DECOMP IN ('SILVER','GOLD','PLATINUM','PALLADIUM','S&P GSCI GOLD INDEX EXCESS RETURN','COMEX SILVER') THEN 'PRECIOUS METALS' WHEN CCC_DIVISION in ('INSTITUTIONAL EQUITY DIVISION') AND PRODUCT_TYPE_CODE IN ('COMM','ETF','OPTION','SWAP','GSCI','INDEX') AND PRODUCT_DESCRIPTION_DECOMP IN ('COPPER','LME NICKEL','LME ZINC','HG COPPER') THEN 'BASE METALS' WHEN (CCC_DIVISION in ('INSTITUTIONAL EQUITY DIVISION') AND PRODUCT_TYPE_CODE IN ('COMM','ETF','OPTION','SWAP','GSCI','INDEX') AND (PRODUCT_DESCRIPTION_DECOMP IN ('WTI CRUDE OIL','S&P GSCI BRENT INDEX EXCESS RETURN','S&P GSCI CRUDE OIL INDEX EXCS RETURN', 'LIGHT_CRUDE NEAR ALIAS','BRENT CRUDE OIL','Reformulated Gasoline Blendstock for Oxygen Blending (RBOB)', 'Reformulated Gasoline Blendstock for Oxygen Blending (RBOB) Futu','ICE NYH RBOB GASOLINE') or PRODUCT_DESCRIPTION_DECOMP LIKE 'LIGHT_CRUDE%' or PRODUCT_DESCRIPTION_DECOMP IN ('HEATING OIL','GAS OIL','NATURAL GAS','UK NATURAL GAS'))) THEN 'ENERGY' WHEN T.PRODUCT_TYPE_CODE IN ('BASEMETAL') THEN 'BASE METALS' WHEN T.PRODUCT_TYPE_CODE IN ('PRECIOUSMETAL') THEN 'PRECIOUS METALS' WHEN T.CCC_PRODUCT_LINE IN ('NA POWER & GAS','EU POWER & GAS', 'OIL & PRODUCTS') THEN 'ENERGY' ELSE 'OTHER' END UNION ALL SELECT D.COB_DATE, 'MSCGI' AS LE, CASE WHEN D.PRODUCT_TYPE_CODE IN ('BASEMETAL') THEN 'BASE METALS' WHEN D.PRODUCT_TYPE_CODE IN ('PRECIOUSMETAL') THEN 'PRECIOUS METALS' WHEN D.CCC_PRODUCT_LINE IN ('NA POWER & GAS','EU POWER & GAS', 'OIL & PRODUCTS') THEN 'ENERGY' ELSE 'OTHER' END AS TYPE, SUM(case when D.PRODUCT_TYPE_CODE NOT IN ('EQUITY','EQUITY INDEX','ERROR','IGNORE', 'INFLATION','INTEREST RATE','CURRENCY','TBD') then coalesce(D.USD_CM_DELTA,0) else 0 end)*1000*0.01 +sum(case when D.VERTICAL_SYSTEM ='NY-NG-SUPPLYLINK' and D.CCC_STRATEGY in ('NAPG NAT GAS','NA NATURAL GAS') and D.PRODUCT_SUB_TYPE_NAME ='OTC OPTION PREMIUM' then D.LCY_BALSHEET else 0 end )*0.01 AS CM_DELTA FROM cdwuser.U_EXP_MSR D WHERE d.COB_DATE in ('2018-02-28') and d.CCC_TAPS_COMPANY in ('0105', '0513', '1133', '1614', '2042', '4442', '4919', '4920', '5122', '6399', '7025', '7038', '7114', '7323', '7410', '7504', '7516', '8296', '8304', '8562', '8747', '8934', '7706', '7549', '6706', '5427', '7414', '7465', '7493', '7278', '7279', '7705', '7624', '7681', '7800', '5656', '7708', '7707', '7801', '7627', '7759', '7710', '7762', '7630', '7628', '7761', '7684', '5923', '7609') AND D.var_excl_fl <> 'Y' group by D.COB_DATE, CASE WHEN D.PRODUCT_TYPE_CODE IN ('BASEMETAL') THEN 'BASE METALS' WHEN D.PRODUCT_TYPE_CODE IN ('PRECIOUSMETAL') THEN 'PRECIOUS METALS' WHEN D.CCC_PRODUCT_LINE IN ('NA POWER & GAS','EU POWER & GAS', 'OIL & PRODUCTS') THEN 'ENERGY' ELSE 'OTHER' END