SELECT a.COB_DATE,curve_name,a.CURVE_TYPE,a.CURRENCY_OF_MEASURE,a.PRODUCT_SUB_TYPE_CODE, 'XGAMMA_CR_FX' as XGAMMA_TYPE, SUM (USD_XGAMMA_CR_FX) AS xgamma FROM cdwuser.U_exp_msr a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') AND  LE_GROUP = ('UK') AND  UPPER(bu_risk_system) like ('%PERSIST%') and USD_XGAMMA_CR_FX is not null group by  a.COB_DATE,curve_name,a.CURVE_TYPE,a.CURRENCY_OF_MEASURE,a.PRODUCT_SUB_TYPE_CODE  union all  SELECT a.COB_DATE,curve_name,a.CURVE_TYPE,a.CURRENCY_OF_MEASURE,a.PRODUCT_SUB_TYPE_CODE, 'XGAMMA_IR_FX' as XGAMMA_TYPE, sum (usd_xgamma_ir_fx) as xgamma FROM cdwuser.U_exp_msr a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') AND  LE_GROUP = ('UK') AND  UPPER(bu_risk_system) like ('%PERSIST%') and usd_xgamma_ir_fx is not null group by  a.COB_DATE,curve_name,a.CURVE_TYPE,a.CURRENCY_OF_MEASURE,a.PRODUCT_SUB_TYPE_CODE  union all  SELECT a.COB_DATE,curve_name,a.CURVE_TYPE,a.CURRENCY_OF_MEASURE,a.PRODUCT_SUB_TYPE_CODE, 'XGAMMA_CR_IR_FXBASIS' as XGAMMA_TYPE, SUM (USD_XGAMMA_IR_CR) AS xgamma FROM cdwuser.U_exp_msr a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') AND  LE_GROUP = ('UK') AND  UPPER(bu_risk_system) like ('%PERSIST%') and USD_XGAMMA_IR_CR is not null and a.CURVE_TYPE = 'FXBASISYIELDCURVE'  group by  a.COB_DATE,curve_name,a.CURVE_TYPE,a.CURRENCY_OF_MEASURE,a.PRODUCT_SUB_TYPE_CODE  union all  SELECT a.COB_DATE,curve_name,a.CURVE_TYPE,a.CURRENCY_OF_MEASURE,a.PRODUCT_SUB_TYPE_CODE, 'XGAMMA_CR_IR_Inflation' as XGAMMA_TYPE, SUM (USD_XGAMMA_IR_CR) AS xgamma FROM cdwuser.U_exp_msr a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') AND  LE_GROUP = ('UK') AND  UPPER(bu_risk_system) like ('%PERSIST%') and USD_XGAMMA_IR_CR is not null and (a.CURVE_TYPE ='LIBORYIELDCURVE' and a.CURVE_NAME like '%_inf') group by  a.COB_DATE,curve_name,a.CURVE_TYPE,a.CURRENCY_OF_MEASURE,a.PRODUCT_SUB_TYPE_CODE  union all  SELECT a.COB_DATE, case when a.CCC_PL_REPORTING_REGION = 'JAPAN' and a.CURVE_NAME in ('gbpnw_disc','gbpnw_3m') then 'gbpnw_3m - gbpnw_disc' when a.CCC_PL_REPORTING_REGION = 'EMEA' and a.CURVE_NAME in ('usdn_3m','usdn_disc') then 'usdn_3m - usdn_disc' when a.CCC_PL_REPORTING_REGION = 'EMEA' and a.CURVE_NAME in ('jpynw_disc','jpynw_3m') then 'jpynw_3m - jpynw_disc' else curve_name end as curve_name, 'IRBASISYIELDCURVE' as CURVE_TYPE, a.CURRENCY_OF_MEASURE, a.PRODUCT_SUB_TYPE_CODE, 'XGAMMA_CR_IR_TENORBASIS' as XGAMMA_TYPE, sum(case when a.CCC_PL_REPORTING_REGION = 'JAPAN' and a.CURVE_NAME = 'gbpnw_disc' then -USD_XGAMMA_IR_CR when a.CCC_PL_REPORTING_REGION = 'EMEA' and a.CURVE_NAME = 'usdn_disc' then -USD_XGAMMA_IR_CR when a.CCC_PL_REPORTING_REGION = 'EMEA' and a.CURVE_NAME = 'jpynw_disc' then -USD_XGAMMA_IR_CR else USD_XGAMMA_IR_CR end) as USD_XGAMMA_IR_CR  FROM cdwuser.U_exp_msr a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') AND  LE_GROUP = ('UK') AND  UPPER(bu_risk_system) like ('%PERSIST%') and USD_XGAMMA_IR_CR is not null and a.CURVE_TYPE <> 'FXBASISYIELDCURVE' and not (a.CURVE_TYPE ='LIBORYIELDCURVE' and a.CURVE_NAME like '%_inf') and (a.CCC_PL_REPORTING_REGION = 'JAPAN' and a.CURVE_NAME in ('gbpnw_disc','gbpnw_3m') or a.CCC_PL_REPORTING_REGION = 'EMEA' and a.CURVE_NAME in ('usdn_3m','usdn_disc') or a.CCC_PL_REPORTING_REGION = 'EMEA' and a.CURVE_NAME in ('jpynw_disc','jpynw_3m') ) Group By  a.COB_DATE, case when a.CCC_PL_REPORTING_REGION = 'JAPAN' and a.CURVE_NAME in ('gbpnw_disc','gbpnw_3m') then 'gbpnw_3m - gbpnw_disc' when a.CCC_PL_REPORTING_REGION = 'EMEA' and a.CURVE_NAME in ('usdn_3m','usdn_disc') then 'usdn_3m - usdn_disc' when a.CCC_PL_REPORTING_REGION = 'EMEA' and a.CURVE_NAME in ('jpynw_disc','jpynw_3m') then 'jpynw_3m - jpynw_disc' else curve_name end, a.CURRENCY_OF_MEASURE, a.PRODUCT_SUB_TYPE_CODE  Union all  SELECT a.COB_DATE, curve_name, 'LIBORYIELDCURVE' as CURVE_TYPE, a.CURRENCY_OF_MEASURE, a.PRODUCT_SUB_TYPE_CODE, 'XGAMMA_CR_IR_OUTRIGHT' as XGAMMA_TYPE, sum(USD_XGAMMA_IR_CR) as USD_XGAMMA_IR_CR FROM cdwuser.U_exp_msr a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') AND  LE_GROUP = ('UK') AND  UPPER(bu_risk_system) like ('%PERSIST%') and USD_XGAMMA_IR_CR is not null and a.CURVE_TYPE <> 'FXBASISYIELDCURVE' and not (a.CURVE_TYPE ='LIBORYIELDCURVE' and a.CURVE_NAME like '%_inf') and (a.CCC_PL_REPORTING_REGION = 'JAPAN' and a.CURVE_NAME in ('gbpnw_disc') or a.CCC_PL_REPORTING_REGION = 'EMEA' and a.CURVE_NAME in ('usdn_disc') or a.CCC_PL_REPORTING_REGION = 'EMEA' and a.CURVE_NAME in ('jpynw_disc') ) GROUP BY a.COB_DATE, curve_name, a.CURRENCY_OF_MEASURE, a.PRODUCT_SUB_TYPE_CODE  union all  SELECT a.COB_DATE,curve_name,a.CURVE_TYPE,a.CURRENCY_OF_MEASURE,a.PRODUCT_SUB_TYPE_CODE, CASE      WHEN a.CURVE_TYPE ='IRBASISYIELDCURVE' THEN 'XGAMMA_CR_IR_TENORBASIS'     ELSE 'XGAMMA_CR_IR_OUTRIGHT'  END as XGAMMA_TYPE, SUM (USD_XGAMMA_IR_CR) AS xgamma FROM cdwuser.U_exp_msr a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-27') AND  LE_GROUP = ('UK') AND  UPPER(bu_risk_system) like ('%PERSIST%') and USD_XGAMMA_IR_CR is not null and a.CURVE_TYPE <> 'FXBASISYIELDCURVE' and not (a.CURVE_TYPE ='LIBORYIELDCURVE' and a.CURVE_NAME like '%_inf') and not (a.CCC_PL_REPORTING_REGION = 'JAPAN' and a.CURVE_NAME in ('gbpnw_disc','gbpnw_3m') or a.CCC_PL_REPORTING_REGION = 'EMEA' and a.CURVE_NAME in ('usdn_3m','usdn_disc') or a.CCC_PL_REPORTING_REGION = 'EMEA' and a.CURVE_NAME in ('jpynw_disc','jpynw_3m') ) group by a.COB_DATE,curve_name,a.CURVE_TYPE,a.CURRENCY_OF_MEASURE,a.PRODUCT_SUB_TYPE_CODE, CASE      WHEN a.CURVE_TYPE ='IRBASISYIELDCURVE' THEN 'XGAMMA_CR_IR_TENORBASIS'     ELSE 'XGAMMA_CR_IR_OUTRIGHT'  END