select sum(a.USD_NET_EXPOSURE) as EXPOSURE, a.issuer_country_em_flag, a.COB_DATE, ISSUER_COUNTRY_CODE,ccc_business_area, CASE when a.ISSUER_COUNTRY_CODE in ('RUS') then 'RUSSIA' when a.ISSUER_COUNTRY_CODE in ('ZAF') then 'SOUTH-AFRICA' when a.ISSUER_COUNTRY_CODE in ('TUR') then 'TURKEY' when a.ISSUER_COUNTRY_CODE in ('ARE','IRQ','QAT','SAU','LBN','ISR','EGY','ISR','KWT','BHR','OMN','JOR') then 'MID-EAST' WHEN a.ISSUER_COUNTRY_CODE IN ('EGY','MAR','GAB','GHA','AGO','MNE','MOZ','TZA','ETH','ETH','CIV','KEN','SEN','NGA','TUN','ZMB','NAM','RWA') then 'AFRICA' WHEN a.ISSUER_COUNTRY_CODE IN ('BGR','HRV','BIH','CZE','EST','HUN','ISL','LVA','POL','ROM','SRB','SVK','SVN','LBR','LTU','ROU','KAZ','AZE','BLR','GEO','SLV','ARM','UKR') THEN 'EAST-EUROPE' WHEN a.ISSUER_COUNTRY_CODE IN ('BRA','CHL','COL','DOM','ECU','JAM','MEX','PAN','PER','URY','ARG','VEN') THEN 'LATAM' else 'Other' end as country_group from cdwuser.U_DM_CC a where a.COB_DATE >= '2017-12-30' AND USD_NET_EXPOSURE is not NULL AND USD_NET_EXPOSURE <>0 AND ccc_business_area IN ('FXEM MACRO TRADING','EM CREDIT TRADING') AND CCC_PL_REPORTING_REGION in ('EMEA') group by a.issuer_country_em_flag,a.COB_DATE, ISSUER_COUNTRY_CODE,ccc_business_area