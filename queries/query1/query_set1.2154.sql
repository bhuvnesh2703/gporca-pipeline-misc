with src as (select case CREDIT_SPREAD_BUCKET when '-0' then 1 when '0' then 2 when '0-10' then 3 when '10-25' then 4 when '25-50' then 5 when '50-100' then 6 when '100-200' then 7 when '200-400' then 8 when '400-800' then 9 when '800+' then 10 end as rank, CREDIT_SPREAD_BUCKET, mrd_rating as rating, sum (case when cob_date = '2018-02-28' then usd_pv01sprd else 0 end) as usd_pv01sprd, sum (case when cob_date = '2018-02-28' then usd_pv01sprd else -usd_pv01sprd end) as usd_pv01sprd_chng from CDWUSER.U_CR_MSR WHERE cob_date in ('2018-02-28', '2018-01-31') AND PARENT_LEGAL_ENTITY = '0111' AND VAR_EXCL_FL <> 'Y' GROUP BY CREDIT_SPREAD_BUCKET, mrd_rating) SELECT rank, CREDIT_SPREAD_BUCKET, sum(case when rating = 'AAA' then usd_pv01sprd end) as spv01_aaa, sum(case when rating = 'AAA' then usd_pv01sprd_chng end) as spv01_aaa_c, sum(case when rating = 'AA' then usd_pv01sprd end) as spv01_aa, sum(case when rating = 'AA' then usd_pv01sprd_chng end) as spv01_aa_c, sum(case when rating = 'A' then usd_pv01sprd end) as spv01_a, sum(case when rating = 'A' then usd_pv01sprd_chng end) as spv01_a_c, sum(case when rating = 'BBB' then usd_pv01sprd end) as spv01_bbb, sum(case when rating = 'BBB' then usd_pv01sprd_chng end) as spv01_bbb_c, sum(case when rating = 'BB' then usd_pv01sprd end) as spv01_bb, sum(case when rating = 'BB' then usd_pv01sprd_chng end) as spv01_bb_c, sum(case when rating = 'B' then usd_pv01sprd end) as spv01_b, sum(case when rating = 'B' then usd_pv01sprd_chng end) as spv01_b_c, sum(case when rating in ('CCC','CC','C','D') then usd_pv01sprd end) as spv01_b_low, sum(case when rating in ('CCC','CC','C','D') then usd_pv01sprd_chng end) as spv01_b_low_c, sum(case when coalesce(rating,'NR') not in ('AAA','AA','A', 'BBB','BB','B', 'CCC','CC','C','D') then usd_pv01sprd end) as spv01_nr, sum(case when coalesce(rating,'NR') not in ('AAA','AA','A', 'BBB','BB','B', 'CCC','CC','C','D') then usd_pv01sprd_chng end) as spv01_nr_c, sum(usd_pv01sprd) AS pv01sprd, sum(usd_pv01sprd_chng) AS pv01sprd_c FROM src GROUP BY rank, CREDIT_SPREAD_BUCKET