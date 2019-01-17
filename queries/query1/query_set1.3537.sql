select distinct a.LIMIT_NAME, case when a.TEMP_LIMIT_EXPIRATION_DATE >= a.COB_DATE then a.TEMP_LIMIT_VALUE else a.LIMIT_VALUE end as LIMIT_VALUE, a.LIMIT_APPLIED_TO from Cdwuser.U_FLOW_LIMITS a where a.COB_DATE = '2/27/2018' and a.LIMIT_ID in ( '6149', '6150') and a.PARENT_DESCRIPTION = 'FIRM TREASURY'