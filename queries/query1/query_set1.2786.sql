select t.cob_date, t.limit_id, t.child_description, t.risk_value_override from cdwuser.u_flow_limits t where t.cob_date >= '2018-02-14' and t.cob_date <= '2018-02-28' and t.limit_id in ('10232','7443')