SELECT cob_date, limit_id, LIMIT_NAME, LIMIT_VALUE, RISK_VALUE_ORIGINAL, RISK_VALUE_OVERRIDE FROM CDWUSER.U_FLOW_LIMITS WHERE cob_date >= ('2017-11-27') AND LIMIT_ID in ('10974','10972','10971','10973','10969','10970')