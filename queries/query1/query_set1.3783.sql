select a.ISSUER_COUNTRY_CODE_DECOMP, a.COB_DATE, LE_GROUP,CCC_PL_REPORTING_REGION, sum(a.USD_EQ_DELTA_DECOMP)/1000 as Delta from CDWUSER.u_Decomp_msr a where cob_date IN ('2018-02-28','2018-02-21') and a.DIVISION = 'IED' and a.CCC_BANKING_TRADING = 'TRADING' and a.ISSUER_COUNTRY_CODE_DECOMP = 'TUR' group by a.ISSUER_COUNTRY_CODE_DECOMP, a.COB_DATE, LE_GROUP,CCC_PL_REPORTING_REGION order by abs(sum(a.USD_EQ_DELTA_DECOMP)) desc