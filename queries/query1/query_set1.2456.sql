with src as( SELECT X.*, sum(usd_pv01sprd_cob) over(partition by fid1_industry_name_level2) AS PV01_COB_RANK FROM ( SELECT fid1_industry_name_level2, RATING_GRADE_CD AS rating_type, SUM (case when cob_date = '2018-02-28' then coalesce(usd_pv01sprd, 0) else 0 end) AS usd_pv01sprd_cob, SUM (case when cob_date = '2018-02-28' then coalesce(usd_pv01sprd, 0) else -coalesce(usd_pv01sprd, 0) end) AS usd_pv01sprd_change FROM CDWUSER.u_cr_msr WHERE cob_date IN ('2018-02-28', '2018-02-27') AND PARENT_LEGAL_ENTITY = '0517(G)' AND var_excl_fl <> 'Y' AND ccc_business_area IN ('CREDIT-CORPORATES', 'LENDING', 'STRUCTURED CREDIT PROD') AND ccc_banking_trading = 'BANKING' GROUP BY fid1_industry_name_level2, RATING_GRADE_CD ) X ) select case when rank >= 16 then 16 else rank end as rank, case when rank >= 16 then 'Other' else fid1_industry_name_level2 end as fid1_industry_name_level2, rating_type, sum(usd_pv01sprd_cob) as usd_pv01sprd_cob, sum(usd_pv01sprd_change) as usd_pv01sprd_change from ( select dense_rank() over(order by abs(PV01_COB_RANK) desc) as rank, src.* from src ) M group by case when rank >= 16 then 16 else rank end, case when rank >= 16 then 'Other' else fid1_industry_name_level2 end, rating_type