SELECT COB_DATE, SUM (COALESCE(USD_IR_UNIFIED_PV01::numeric(15,5), 0)) AS USD_IR_UNIFIED_PV01 FROM CDWUSER.U_EXP_TRENDS WHERE cob_date in ('2018-02-28', '2018-01-31') AND book='TSTJY' GROUP BY COB_DATE