SELECT case when a.level2 = 'IED' then 'INSTITUTIONAL EQUITY DIVISION' else a.level2 end AS CCC_DIVISION, a.level3 AS CCC_BUSINESS_AREA, a.level4 AS CCC_PRODUCT_LINE, a.level5 AS CCC_STRATEGY, a.level6, sum(case when a.COB_DATE = '2018-02-28' then coalesce(a.value,0) else 0 end ) as GNURAM_cob, sum(case when a.COB_DATE = '2018-02-28' then coalesce(a.value,0) else -coalesce(a.value,0) end ) as GNURAM_change FROM CDWUSER.U_Aggregation_Detail a, CDWUSER.U_Aggregation_Schema b WHERE a.cob_date in ('2018-02-28', '2018-02-27') AND b.hierarchy_name='parent_le_primary' AND a.aggregation_name='EQ_GNURAM' AND b.is_latest=1 AND a.level1='1633' AND a.COB_DATE=b.COB_DATE AND a.version_id=b.version_id AND a.hierarchy_id=b.hierarchy_id AND a.aggregation_name=b.aggregation_name AND a.level7 is null GROUP BY case when a.level2 = 'IED' then 'INSTITUTIONAL EQUITY DIVISION' else a.level2 end, a.level3, a.level4, a.level5, a.level6