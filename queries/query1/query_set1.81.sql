WITH EQ_DATA AS(     SELECT         a.COB_DATE,         a.ISSUE_ID_DECOMP,         a.issuer_country_code_decomp,         sum(coalesce(a.USD_EQ_DELTA_DECOMP,0)) as USD_DELTA,         abs(sum(coalesce(a.USD_EQ_DELTA_DECOMP,0))) as ABS_USD_DELTA     FROM         CDWUSER.U_DECOMP_MSR a     WHERE  (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-02-21') and A.CCC_PL_REPORTING_REGION in ('ASIA PACIFIC') AND          CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND      (a.ccc_business_area <> 'INTERNATIONAL WEALTH MGMT') AND        CCC_BANKING_TRADING='TRADING' AND         SILO_SRC = 'IED' and         a.USD_EQ_DELTA_DECOMP <> 0     GROUP BY         a.COB_DATE,         a.ISSUE_ID_DECOMP,         a.issuer_country_code_decomp ) SELECT     issuer_country_code_decomp,     sum(USD_DELTA) as USD_DELTA,     sum(ABS_USD_DELTA) as GNURAMV,     COB_DATE FROM      EQ_DATA GROUP BY     issuer_country_code_decomp,     COB_DATE