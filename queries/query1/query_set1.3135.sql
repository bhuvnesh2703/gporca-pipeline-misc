select A.COB_DATE, sum((a.SLIDE_IR_TANGENT_PV01_MIN_100BP_USD) :: numeric(15,5)) as SLIDE_IR_TANGENT_PV01_MIN_100BP_USD, sum((a.SLIDE_IR_TANGENT_PV01_MIN_200BP_USD) :: numeric(15,5)) as SLIDE_IR_TANGENT_PV01_MIN_200BP_USD, sum((a.SLIDE_IR_TANGENT_PV01_MIN_300BP_USD) :: numeric(15,5)) as SLIDE_IR_TANGENT_PV01_MIN_300BP_USD, sum((a.SLIDE_IR_TANGENT_PV01_MIN_50BP_USD) :: numeric(15,5)) as SLIDE_IR_TANGENT_PV01_MIN_50BP_USD, sum((a.SLIDE_IR_TANGENT_PV01_PLS_100BP_USD) :: numeric(15,5)) as SLIDE_IR_TANGENT_PV01_PLS_100BP_USD, sum((a.SLIDE_IR_TANGENT_PV01_PLS_200BP_USD) :: numeric(15,5)) as SLIDE_IR_TANGENT_PV01_PLS_200BP_USD, sum((a.SLIDE_IR_TANGENT_PV01_PLS_300BP_USD) :: numeric(15,5)) as SLIDE_IR_TANGENT_PV01_PLS_300BP_USD, sum((a.SLIDE_IR_TANGENT_PV01_PLS_50BP_USD) :: numeric(15,5)) as SLIDE_IR_TANGENT_PV01_PLS_50BP_USD, sum(d.MV) as MV, sum ((a.USD_IR_UNIFIED_PV01) :: numeric(15,5)) AS IRPV01 FROM cdwuser.u_ir_msr a Left Join (select A.COB_DATE, SUM (COALESCE (((A.USD_PROCEED) :: numeric(15,5)), 0)) / 1000 AS MV FROM cdwuser.u_dm_wm_position a WHERE A.COB_DATE IN ( '2018-02-28', '2018-02-27', '2017-09-30', '2018-01-31', '2018-02-21', '2018-02-14', '2018-01-31', '2017-12-31', '2017-09-30', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31', '2017-12-31', '2017-09-30', '2017-06-30', '2017-03-31' ) AND /* A.CCC_TAPS_COMPANY = '1633' AND*/ A.VAR_EXCL_FL <> 'Y' and A.BOOK IN ('MSDPB', 'MSDPT', 'MSDPB3M','MSDPT3M', 'MSDPB3MREST', 'MSDPT3MREST') GROUP BY A.COB_DATE) D ON A.COB_DATE = D.COB_DATE WHERE A.COB_DATE IN ( '2018-02-28', '2018-02-27', '2017-09-30', '2018-01-31', '2018-02-21', '2018-02-14', '2018-01-31', '2017-12-31', '2017-09-30', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31', '2017-12-31', '2017-09-30', '2017-06-30', '2017-03-31' ) AND /* A.CCC_TAPS_COMPANY = '1633' AND*/ A.VAR_EXCL_FL <> 'Y' and A.BOOK IN ('MSDPB', 'MSDPT', 'MSDPB3M','MSDPT3M', 'MSDPB3MREST', 'MSDPT3MREST') GROUP BY A.COB_DATE