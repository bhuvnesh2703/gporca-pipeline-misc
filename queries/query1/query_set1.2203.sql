SELECT CASE WHEN currency_code IN ('USD', 'EUR', 'GBP', 'JPY') THEN currency_code ELSE 'OTHER' END AS currency, CASE WHEN val_in IN (0.25, 0.50, 1, 2, 5, 10, 20) THEN val_in ELSE 0 END AS val_in, CASE WHEN val_for IN (0.25, 1, 2, 5, 10, 20, 30) THEN val_for ELSE 0 END AS val_for, SUM(CASE WHEN cob_date = '2018-02-28' THEN COALESCE(grid_measure_value,0)/10 ELSE 0 END ) AS IR_KAPPA_COB, SUM(CASE WHEN cob_date = '2018-02-28' THEN COALESCE(grid_measure_value,0)/10 ELSE -COALESCE(grid_measure_value,0)/10 END ) AS IR_KAPPA_CHANGE FROM CDWUSER.U_GRID_MSR WHERE cob_date IN ('2018-02-28', '2018-01-31') AND PARENT_LEGAL_ENTITY = '0201(G)' and grid_measure_name = 'USD_KAPPA' AND VAR_EXCL_FL <> 'Y' GROUP BY CASE WHEN currency_code IN ('USD', 'EUR', 'GBP', 'JPY') THEN currency_code ELSE 'OTHER' END, CASE WHEN val_in IN (0.25, 0.50, 1, 2, 5, 10, 20) THEN val_in ELSE 0 END, CASE WHEN val_for IN (0.25, 1, 2, 5, 10, 20, 30) THEN val_for ELSE 0 END