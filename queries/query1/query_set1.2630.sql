with src as (SELECT max(legal_ultimate_namee) as legal_ultimate_name, legal_ultimate_id, ccc_product_line, rating, sum(VAL03*cob_multiplier) AS pv10_cob, sum(VAL03*change_multiplier) AS pv10_chng, sum(usd_pv01sprd*cob_multiplier) AS usd_pv01sprd_cob, sum(usd_pv01sprd*change_multiplier) AS usd_pv01sprd_chng, sum(usd_net_exposure*cob_multiplier) AS usd_net_exposure_cob, sum(usd_net_exposure*change_multiplier) AS usd_net_exposure_chng FROM ( SELECT coalesce(POSITION_ISSUER_PARTY_DARWIN_NAME, POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME, fid1_index_family) as legal_ultimate_namee, POSITION_ISSUER_PARTY_DARWIN_ID as legal_ultimate_id, case when cob_date = '2018-02-28' then 1 else 0 end as cob_multiplier, case when cob_date = '2018-02-28' then 1 else -1 end as change_multiplier, ccc_product_line, mrd_rating as rating, usd_pv01sprd, slide_pv_pls_10pct_usd as val03, usd_exposure as usd_net_exposure FROM CDWUSER.U_CR_MSR WHERE cob_date in ('2018-02-28', '2018-02-27') AND PARENT_LEGAL_ENTITY = '1633' and VERTICAL_SYSTEM NOT LIKE ('SPG%') AND ccc_business_area not in ('CPM TRADING (MPE)', 'CPM', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') AND CCC_STRATEGY NOT IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES', 'EQ XVA HEDGING') AND UPPER(sectype2) Not In ('FX',UPPER('Swaps'),UPPER('RateFuture')) AND CCC_STRATEGY <> 'CORE PRIMARY' AND CCC_PRODUCT_LINE <> 'CORE PRIMARY' AND NOT (vertical_system LIKE 'PIPELINE_%' and ccc_business_area = 'LENDING') AND product_type_code <> 'CP' AND UPPER(FID1_INDUSTRY_NAME_LEVEL1) <> UPPER('Sovereign') AND var_excl_fl <> 'Y' AND ccc_business_area = 'LENDING' ) X GROUP BY legal_ultimate_id, ccc_product_line, rating ), ungrped as (SELECT legal_ultimate_name, ccc_product_line as ccc_business_area, rating, rank() over(partition by legal_ultimate_name order by coalesce(abs(usd_net_exposure_cob),0) desc) as in_group_rank FROM src), grped as (SELECT max(legal_ultimate_name) as legal_ultimate_name, sum(pv10_cob) pv10_cob, sum(pv10_chng) pv10_chng, sum(usd_pv01sprd_cob) usd_pv01sprd_cob, sum(usd_pv01sprd_chng) usd_pv01sprd_chng, sum(usd_net_exposure_cob) usd_net_exposure_cob, sum(usd_net_exposure_chng) usd_net_exposure_chng FROM src GROUP BY legal_ultimate_id) select u.*, usd_pv01sprd_cob, usd_pv01sprd_chng, pv10_cob, pv10_chng, usd_net_exposure_cob, usd_net_exposure_chng , RANK() OVER(ORDER BY ABS(USD_NET_EXPOSURE_COB) DESC) as rank from grped g, ungrped u where g.legal_ultimate_name = u.legal_ultimate_name and u.in_group_rank=1 order by coalesce(abs(usd_net_exposure_cob),0) desc FETCH FIRST 10 ROWS ONLY