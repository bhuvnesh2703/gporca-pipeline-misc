SELECT COB_DATE, CUT, COUNTRY, SUM(USD_DELTA) USD_DELTA FROM ( SELECT COB_DATE,UNNEST(ARRAY[CUT0,CUT1,CUT2]) AS CUT, COUNTRY, USD_DELTA FROM ( SELECT 'GLOBAL' CUT0, CASE WHEN a.LE_GROUP = 'UK' THEN 'UK Group' END as CUT1, CASE WHEN a.CCC_PL_REPORTING_REGION = 'EMEA' THEN 'EMEA' END as CUT2, a.COB_DATE, CASE WHEN a.ISSUER_COUNTRY_CODE_DECOMP IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR','GBR', 'DZA','AGO','BEN','BWA','BFA','BDI','CMR','CPV','CAF','TCD','COM','COD','CIV','DJI','EGY','GNQ','ERI','ETH','GAB','GMB','GHA','GIB','GIN','GNB','KEN','LSO','LBR','LBY','MDG','MWI','MLI','MRT','MUS','MYT','MAR','MOZ','NAM','NER','NGA','REU','RWA','BLM','SHN','MAF','STP','SEN','SYC','SLE','SOM','ZAF','SSD','SDN','SWZ','TZA','TGO','TUN','UGA','ESH','ZMB','ZWE' ) THEN 'EMEA' WHEN a.ISSUER_COUNTRY_CODE_DECOMP IN ('USA','CAN') THEN 'AMERICAS' WHEN SUBSTRING(a.PRODUCT_DESCRIPTION_DECOMP,LENGTH(a.PRODUCT_DESCRIPTION_DECOMP)-1,2) <> '-H' AND a.ISSUER_COUNTRY_CODE_DECOMP IN ('HKG') THEN 'HONG KONG' WHEN SUBSTRING(a.PRODUCT_DESCRIPTION_DECOMP,LENGTH(a.PRODUCT_DESCRIPTION_DECOMP)-1,2) = '-H' THEN 'CHINA H-SHARES' WHEN SUBSTRING(a.PRODUCT_DESCRIPTION_DECOMP,LENGTH(a.PRODUCT_DESCRIPTION_DECOMP)-1,2) = '-A' AND a.ISSUER_COUNTRY_CODE_DECOMP = 'CHN' THEN 'CHINA A-SHARES' ELSE 'OTHERS' END AS COUNTRY, cast(sum(coalesce(a.USD_EQ_DELTA_DECOMP,0)) as numeric(15,5)) as USD_DELTA FROM CDWUSER.U_DECOMP_MSR a WHERE a.COB_DATE > '2017-03-31' AND a.CCC_DIVISION = 'INSTITUTIONAL EQUITY DIVISION' AND a.CCC_BANKING_TRADING = 'TRADING' GROUP BY CUT1, CUT2, a.COB_DATE, CASE WHEN a.ISSUER_COUNTRY_CODE_DECOMP IN ('ALB','AND','AUT','BLR','BEL','BIH','BGR','CYP','HRV','CZE','DNK','EST','FRO','FIN','FRA','GEO','DEU','GRC','GGY','VAT','HUN','ISL','IRL','IMN','ITA','JEY','LVA','LIE','LTU','LUX','MKD','MLT','MDA','MCO','MNE','NLD','NOR','POL','PRT','ROU','RUS','SMR','SRB','SVK','SVN','ESP','SJM','SWE','CHE','UKR','GBR', 'DZA','AGO','BEN','BWA','BFA','BDI','CMR','CPV','CAF','TCD','COM','COD','CIV','DJI','EGY','GNQ','ERI','ETH','GAB','GMB','GHA','GIB','GIN','GNB','KEN','LSO','LBR','LBY','MDG','MWI','MLI','MRT','MUS','MYT','MAR','MOZ','NAM','NER','NGA','REU','RWA','BLM','SHN','MAF','STP','SEN','SYC','SLE','SOM','ZAF','SSD','SDN','SWZ','TZA','TGO','TUN','UGA','ESH','ZMB','ZWE' ) THEN 'EMEA' WHEN a.ISSUER_COUNTRY_CODE_DECOMP IN ('USA','CAN') THEN 'AMERICAS' WHEN SUBSTRING(a.PRODUCT_DESCRIPTION_DECOMP,LENGTH(a.PRODUCT_DESCRIPTION_DECOMP)-1,2) <> '-H' AND a.ISSUER_COUNTRY_CODE_DECOMP IN ('HKG') THEN 'HONG KONG' WHEN SUBSTRING(a.PRODUCT_DESCRIPTION_DECOMP,LENGTH(a.PRODUCT_DESCRIPTION_DECOMP)-1,2) = '-H' THEN 'CHINA H-SHARES' WHEN SUBSTRING(a.PRODUCT_DESCRIPTION_DECOMP,LENGTH(a.PRODUCT_DESCRIPTION_DECOMP)-1,2) = '-A' AND a.ISSUER_COUNTRY_CODE_DECOMP = 'CHN' THEN 'CHINA A-SHARES' ELSE 'OTHERS' END ) TMP )TMP_01 WHERE CUT IS NOT NULL GROUP BY 1,2,3