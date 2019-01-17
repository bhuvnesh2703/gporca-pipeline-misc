with src as (SELECT max(legal_ultimate_namee) as legal_ultimate_name, legal_ultimate_id, ccc_business_area, rating, sum(VAL03*cob_multiplier) AS pv10_cob, sum(VAL03*change_multiplier) AS pv10_chng, sum(usd_pv01sprd*cob_multiplier) AS usd_pv01sprd_cob, sum(usd_pv01sprd*change_multiplier) AS usd_pv01sprd_chng, sum(usd_net_exposure*cob_multiplier) AS usd_net_exposure_cob, sum(usd_net_exposure*change_multiplier) AS usd_net_exposure_chng FROM ( SELECT coalesce(POSITION_ISSUER_PARTY_DARWIN_NAME, POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME, fid1_index_family) as legal_ultimate_namee, POSITION_ISSUER_PARTY_DARWIN_ID as legal_ultimate_id, case when cob_date = '2018-02-28' then 1 else 0 end as cob_multiplier, case when cob_date = '2018-02-28' then 1 else -1 end as change_multiplier, ccc_business_area, mrd_rating as rating, usd_pv01sprd, slide_pv_pls_10pct_usd as val03, usd_exposure as usd_net_exposure FROM ( SELECT POSITION_ISSUER_PARTY_DARWIN_NAME, POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME, fid1_index_family, POSITION_ISSUER_PARTY_DARWIN_ID, cob_date, ccc_business_area, mrd_rating, 0 as usd_pv01sprd, coalesce(slide_ir_pls_200bp_usd,0) as slide_pv_pls_10pct_usd, 0 as usd_exposure FROM CDWUSER.U_IR_MSR WHERE cob_date in ('2018-02-28', '2018-02-21') AND PARENT_LEGAL_ENTITY = '0302(G)' and VERTICAL_SYSTEM LIKE ('SPG%') AND ccc_business_area not in ('CPM TRADING (MPE)', 'CPM', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') AND CCC_STRATEGY NOT IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING') AND upper(sectype2) Not In (upper('Govts'),'FX',upper('Swaps'),upper('RateFuture')) AND CCC_STRATEGY <> 'CORE PRIMARY' and ccc_product_line <> 'CORE PRIMARY' AND NOT (vertical_system LIKE 'PIPELINE_%' and ccc_business_area = 'LENDING') AND product_type_code <> 'CP' AND upper(FID1_INDUSTRY_NAME_LEVEL1) <> upper('Sovereign') AND var_excl_fl <> 'Y' AND ccc_banking_trading = 'TRADING' UNION ALL SELECT POSITION_ISSUER_PARTY_DARWIN_NAME, POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME, fid1_index_family, POSITION_ISSUER_PARTY_DARWIN_ID, cob_date, ccc_business_area, mrd_rating, 0 as usd_pv01sprd, coalesce(slide_spgcc_min_10pct_usd,0) + coalesce(slide_ptlpv_min_20pct_usd,0) + coalesce(slide_cmbx_min_10pct_usd,0) as slide_pv_pls_10pct_usd, 0 as usd_exposure FROM CDWUSER.U_SP_MSR WHERE cob_date in ('2018-02-28', '2018-02-21') AND PARENT_LEGAL_ENTITY = '0302(G)' and VERTICAL_SYSTEM LIKE ('SPG%') AND ccc_business_area not in ('CPM TRADING (MPE)', 'CPM', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') AND CCC_STRATEGY NOT IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING') AND upper(sectype2) Not In (upper('Govts'),'FX',upper('Swaps'),upper('RateFuture')) AND CCC_STRATEGY <> 'CORE PRIMARY' and ccc_product_line <> 'CORE PRIMARY' AND NOT (vertical_system LIKE 'PIPELINE_%' and ccc_business_area = 'LENDING') AND product_type_code <> 'CP' AND upper(FID1_INDUSTRY_NAME_LEVEL1) <> upper('Sovereign') AND var_excl_fl <> 'Y' AND ccc_banking_trading = 'TRADING' UNION ALL SELECT POSITION_ISSUER_PARTY_DARWIN_NAME, POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME, fid1_index_family, POSITION_ISSUER_PARTY_DARWIN_ID, cob_date, ccc_business_area, mrd_rating, coalesce(usd_pv01sprd,0) as usd_pv01sprd, 0 as slide_pv_pls_10pct_usd, coalesce(usd_exposure,0) as usd_exposure FROM CDWUSER.U_CR_MSR WHERE cob_date in ('2018-02-28', '2018-02-21') AND PARENT_LEGAL_ENTITY = '0302(G)' and VERTICAL_SYSTEM LIKE ('SPG%') AND ccc_business_area not in ('CPM TRADING (MPE)', 'CPM', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') AND CCC_STRATEGY NOT IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING') AND upper(sectype2) Not In (upper('Govts'),'FX',upper('Swaps'),upper('RateFuture')) AND CCC_STRATEGY <> 'CORE PRIMARY' and ccc_product_line <> 'CORE PRIMARY' AND NOT (vertical_system LIKE 'PIPELINE_%' and ccc_business_area = 'LENDING') AND product_type_code <> 'CP' AND upper(FID1_INDUSTRY_NAME_LEVEL1) <> upper('Sovereign') AND var_excl_fl <> 'Y' AND ccc_banking_trading = 'TRADING' ) Y ) X GROUP BY legal_ultimate_id, ccc_business_area, rating ), ungrped as (SELECT legal_ultimate_name, ccc_business_area, rating, rank() over(partition by legal_ultimate_name order by coalesce(abs(usd_pv01sprd_cob),0) desc) as in_group_rank FROM src), grped as (SELECT max(legal_ultimate_name) as legal_ultimate_name, sum(pv10_cob) pv10_cob, sum(pv10_chng) pv10_chng, sum(usd_pv01sprd_cob) usd_pv01sprd_cob, sum(usd_pv01sprd_chng) usd_pv01sprd_chng, sum(usd_net_exposure_cob) usd_net_exposure_cob, sum(usd_net_exposure_chng) usd_net_exposure_chng FROM src GROUP BY legal_ultimate_id) select u.*, usd_pv01sprd_cob, usd_pv01sprd_chng, pv10_cob, pv10_chng, usd_net_exposure_cob, usd_net_exposure_chng , RANK() OVER(ORDER BY ABS(USD_PV01SPRD_COB) DESC) as rank from grped g, ungrped u where g.legal_ultimate_name = u.legal_ultimate_name and u.in_group_rank=1 order by coalesce(abs(usd_pv01sprd_cob),0) desc FETCH FIRST 10 ROWS ONLY