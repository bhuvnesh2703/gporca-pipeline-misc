select sum(a.USD_PV10_BENCH) as PV10, a.ISSUER_COUNTRY_CODE,COB_DATE,reference_entity_name,sum(USD_NET_EXPOSURE) as Exposure,CCC_BUSINESS_AREA,position_ult_issuer_party_darwin_name,

case when a.PRODUCT_TYPE_CODE in ('BOND','GVTBOND','GVTBONDIL','FRN','BANKDEBT','AGN','CD', 'BONDIL') then 'Cash' when a.PRODUCT_TYPE_CODE = 'DEFSWAP' then 'CDS' else 'Other' end as Credit_Product,

CASE 
when a.ISSUER_COUNTRY_CODE in ('RUS') then 'RUSSIA' 
when a.ISSUER_COUNTRY_CODE in ('ZAF') then 'SOUTH-AFRICA'
when a.ISSUER_COUNTRY_CODE in ('TUR') then 'TURKEY'
when a.ISSUER_COUNTRY_CODE in ('ARE','IRQ','QAT','SAU','LBN','ISR','EGY','ISR','KWT','BHR','JOR','OMN') then 'MID-EAST' 
WHEN a.ISSUER_COUNTRY_CODE IN ('EGY','MAR','GAB','GHA','AGO','MNE','MOZ','TZA','ETH','ETH','CIV','KEN','SEN','NGA','TUN','ZMB','NAM','RWA') then 'AFRICA'
WHEN a.ISSUER_COUNTRY_CODE IN ('BGR','HRV','BIH','CZE','EST','HUN','ISL','LVA','POL','ROM','SRB','SVK','SVN','LBR','LTU','ROU','KAZ','AZE','BLR','GEO','SLV','ARM','UKR') THEN 'EAST-EUROPE'
WHEN a.ISSUER_COUNTRY_CODE IN ('ARG','BRA','CHL','COL','DOM','ECU','JAM','MEX','PAN','PER','URY') THEN 'LATAM'
else 'Other' end as country_group


from CDWUSER.U_DM_CC a where a.COB_DATE in ('2018-02-28') AND a.ISSUER_COUNTRY_CODE in ('CHN','HKG','IND','IDN','KOR','MYS','PHL','SGP','TWN','THA','VNM','PAK','LKA','MNG','BGD','MAC')
AND a.CCC_TAPS_COMPANY ='0302'
AND a.CCC_DIVISION IN ('FIXED INCOME DIVISION')
AND a.CCC_BUSINESS_AREA NOT IN ('NON CORE','CPM','LENDING')
AND a.CCC_BANKING_TRADING = 'TRADING'
AND (a.CCC_PRODUCT_LINE NOT IN ('DISTRESSED TRADING') OR a.PRODUCT_TYPE_CODE IN ('CDSOPTIDX','CRDINDEX','LOANINDEX'))
AND ((a.FID1_SENIORITY NOT IN ('AT1','SUBT1','SUBUT2') OR a.ISSUER_COUNTRY_CODE NOT IN ('DNK','BMU','CYM','AUS','AUT','BEL','CAN','CHE','DEU','ESP','FIN','FRA','GBR','GRC','IRL','ITA','JPN','LUX','NLD','NOR','NZL','PRT','SWE','USA','JEY','GGY','SUP','XS','XCI','VGB','CYP')) OR a.PRODUCT_TYPE_CODE NOT IN ('BOND','BONDFUT','BONDFUTOPT','BONDIL','BONDOPT','FRN','PREF'))
AND a.VERTICAL_SYSTEM NOT LIKE '%SPG%'
AND a.USD_PV10_BENCH <> 0

 AND book not in ('OBTRS')
AND (a.FID1_INDUSTRY_NAME_LEVEL1 NOT IN ('SOVEREIGN', 'GOVERNMENT SPONSORED') 
OR a.ISSUER_COUNTRY_CODE NOT IN ('DNK','BMU','CYM','AUS','AUT','BEL','CAN','CHE','DEU','ESP','FIN','FRA','GBR','GRC','IRL','ITA','JPN','LUX','NLD','NOR','NZL','PRT','SWE','USA','JEY','GGY','SUP','XS','XCI','VGB','CYP')) group by a.ISSUER_COUNTRY_CODE,COB_DATE,PRODUCT_TYPE_CODE,reference_entity_name,CCC_BUSINESS_AREA,position_ult_issuer_party_darwin_name