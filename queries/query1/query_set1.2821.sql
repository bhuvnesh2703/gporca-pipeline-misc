SELECT g.PRODUCT_TYPE, g.PRODUCT_SUB_TYPE, g.SR_CHARGE_FACTOR, CASE WHEN VALUATION > 0 THEN 'LONG' ELSE 'SHORT' END AS LS, sum(case when cob_date = '2018-02-28' then g.NET_VALUE else 0 end) as NET_VALUE_COB, sum(case when cob_date = '2018-02-28' then g.NET_VALUE else -g.NET_VALUE end) as NET_VALUE_CHANGE FROM ( SELECT f.cob_date, f.PRODUCT_TYPE, f.PRODUCT_SUB_TYPE, coalesce(f.NET_VALUE, 0) as NET_VALUE, cast(f.SR_CHARGE_FACTOR as numeric) AS SR_CHARGE_FACTOR, coalesce(f.NET_VALUE, 0) / (cast(f.SR_CHARGE_FACTOR as float) / 100) AS VALUATION FROM CDWUSER.U_FSA_NETTING f WHERE cob_date in ('2018-02-28', '2018-01-31') AND hierarchy_group_id = 202 AND hierarchy_id = 53 AND company_code_group != '-1' AND f.asset_class LIKE 'ALL%' AND f.ORIGINAL_VALUE != 0 AND f.COMPANY_CODE_GROUP = '0302(G)' ) g GROUP BY g.PRODUCT_TYPE, g.PRODUCT_SUB_TYPE, g.SR_CHARGE_FACTOR, CASE WHEN VALUATION > 0 THEN 'LONG' ELSE 'SHORT' END HAVING abs(sum(case when cob_date = '2018-02-28' then g.NET_VALUE else 0 end)) + abs(sum(case when cob_date = '2018-02-28' then g.NET_VALUE else -g.NET_VALUE end)) <> 0