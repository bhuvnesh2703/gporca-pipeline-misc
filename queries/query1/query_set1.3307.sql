SELECT process_id, bu_risk_system, grid_measure_name, scenario_name, cob_date, SUM (grid_measure_value) grid_measure_value, expiration_date, ticket FROM oeruser.u_grid_msr a WHERE cob_date in ('2018-02-28') and process_id = 2212 AND grid_measure_name IN ('USD_IREQ_SPOT', 'USD_EQEQ_SPOT') AND CCC_STRATEGY IN ('HYBRIDS INT RATES NA') AND grid_measure_value IS NOT NULL AND scenario_name = 'IR+0/EQ-0.3' AND
 product_type_code NOT IN ('EQFUT') GROUP BY process_id, bu_risk_system, grid_measure_name, scenario_name, cob_date, expiration_date, ticket