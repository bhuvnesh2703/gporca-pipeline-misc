SELECT a.level2, a.level3, sum(case when a.COB_DATE = '2018-02-28' then coalesce(a.value,0) else 0 end ) as GNURAM_cob, sum(case when a.COB_DATE = '2018-02-28' then coalesce(a.value,0) else -coalesce(a.value,0) end ) as GNURAM_change FROM CDWUSER.U_Aggregation_Detail a, CDWUSER.U_Aggregation_Schema b WHERE a.cob_date in ('2018-02-28', '2018-01-31') AND b.hierarchy_name='parent_le_region' AND a.aggregation_name='EQ_GNURAM' AND b.is_latest=1 AND a.level1='0111' AND a.COB_DATE=b.COB_DATE AND a.version_id=b.version_id AND a.hierarchy_id=b.hierarchy_id AND a.aggregation_name=b.aggregation_name AND a.level4 is null GROUP BY a.level2, a.level3