SELECT     a.COB_date,     a.BU_RISK_SYSTEM,     a.CURVE_NAME,     a.prod_pos_name_description,     a.product_type_code,      CASE When a.CCC_PRODUCT_LINE = 'XVA HEDGING'  Then     'FIC'     ELSE     'EQ'     END AS DIVISION, CASE  WHEN prod_pos_name_description IN ('CHI ETHANOL','ERCOT N-O', 'ERCOT N-P', 'ERCOT RRS-O', 'ERCOT RRS-P', 'ERCOT S-O', 'ERCOT S-P',  'ERCOT URS-O', 'ERCOT URS-P', 'ERCOTW-O', 'ERCOTW-P', 'GITS-O', 'GITS-P', 'MIDCO-O','MIDCO-P', 'NEPOOL-MAHB-O', 'NEPOOL-MAHB-P',  'NOB-O', 'NOB-P', 'NP15-O', 'NP15-P', 'NYZNA-O', 'NYZNA-P', 'NYZND-O', 'NYZND-P', 'NYZNG-O', 'NYZNG-P', 'PALO-P', 'PJMW-O', 'PJMW-P',  'SP15-O', 'SP15-P', 'SPP-O', 'SPP-P', 'AEP-P', 'AEP-O', 'ALTW-O','ALTW-P', 'ARA COAL', 'CARBON','COAL NYMEX','CINERGY-P', 'CINHUB-O', 'EUA P2', 'EUA P3',  'FOB NEWCASTLE', 'NEWCASTLE COAL','FOB RICH COAL', 'GER BASE', 'GER PEAK', 'HOTS-P', 'HOTS-O', 'HOTS-P', 'MICH HUB-P', 'MICHHUB-O', 'MINNHUB-O', 'MINNHUB-P',   'PPA WEST-O', 'PPA WEST-P','SOUTHERN CO-O', 'SOUTHERN CO-P', 'UK BASE-GBP', 'UK PEAK','RGGI') THEN 'POWER'  WHEN prod_pos_name_description IN ('DAWN', 'AECO', 'DOMTRANS', 'HENRY HUB', 'MICHCON', 'NYMEX', 'SOCAL', 'SONAT',  'TETCO2', 'TETCO3', 'TGP6', 'TTF', 'UKNG','NORTH EAST PENN') THEN 'NATGAS'  WHEN prod_pos_name_description IN ('BRENT', 'WTI', 'BRENT', 'CHI ETHANOL', 'DTD BRENT', 'DUBAI', 'GC 3%FO', 'GC 74HO', 'GC C3TET', 'GC C5+XTET', 'GC NC4XTET', 'IPE GO', 'LLS', 'NWE 1%FO', 'NWE 3.5%FO', 'NWE JET', 'NWE NAP', 'NWE ULSD', 'NWE UNL', 'NYM HO', 'NYM RBOB', 'SING 180FO', 'SING 380FO', 'US C2', 'WTI', 'NYM WTI') THEN 'OIL'  WHEN prod_pos_name_description IN ('AH', 'CA', 'NI', 'PB', 'SN', 'ZS') THEN 'BASE METAL'  WHEN prod_pos_name_description IN ('GOLD FORWARD', 'GOLD FUTURE', 'PALLADIUM FOR', 'PALLADIUM FORWARD', 'PALLADIUM FUTURE', 'PLATINUM FORW', 'PLATINUM FORWARD', 'PLATINUM FUTURE', 'SILVER FORWAR', 'SILVER FORWARD', 'XAU') THEN 'PRECIOUS METAL'  WHEN prod_pos_name_description IN ('COCOA', 'COFFEE', 'CORN', 'COTTON', 'KANSASWHEAT', 'LIFFE SUGAR',  'RAST-CHIBA VL', 'RAST-CHIBA VLCC', 'SOYBEANS', 'SUGAR',  'WHEAT', 'AMST-NY 37MM',  'BDI', 'SOYBEAN MEAL', 'SOYBEAN OIL') THEN 'OTHER' ELSE 'NOT IN' END as CM_Category, a.type_flag,     SUM (a.USD_CM_DELTA) AS CM FROM cdwuser.U_DM_CVA a WHERE (a.COB_DATE = '2018-02-28' or a.COB_DATE = '2018-01-01') and CCC_PL_REPORTING_REGION in ('EMEA') AND      a.USD_CM_DELTA IS NOT NULL AND     (a.CCC_BUSINESS_AREA IN ('CPM','CPM TRADING (MPE)', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD') OR      a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES','EQ XVA HEDGING')) and a.ccc_product_line not in ('CREDIT LOAN PORTFOLIO','CMD STRUCTURED FINANCE') GROUP BY     a.COB_date,     a.BU_RISK_SYSTEM,     a.CURVE_NAME,     a.prod_pos_name_description,     a.product_type_code,     a.CCC_PL_REPORTING_REGION,     a.CCC_PRODUCT_LINE ,a.type_flag