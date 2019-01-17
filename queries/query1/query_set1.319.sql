Select A.COB_DATE, CASE WHEN ((A.PRODUCT_TYPE_CODE in ('EURO PWR','EAST PEAK','EAST OFF','MIDWEST PEAK', 'MIDWEST OFF','TEXAS OFF', 'TEXAS PEAK', 'WEST OFF', 'WEST PEAK','AUSTRALIAN POWER') AND A.CCC_BUSINESS_AREA in ('AP EU ELECTRICNATURAL GAS')) /*OLG LOGIC*/ or (a.CCC_STRATEGY IN ('AP EU POWER & GAS') and A.PRODUCT_TYPE_CODE in ('EURO PWR','EAST PEAK','EAST OFF','MIDWEST PEAK', 'MIDWEST OFF','TEXAS OFF', 'TEXAS PEAK', 'WEST OFF', 'WEST PEAK','AUSTRALIAN POWER'))) /*NEW LOGIC*/ then 'EU Power' WHEN ((A.PRODUCT_TYPE_CODE in ('EURO PWR','EAST PEAK','EAST OFF','MIDWEST PEAK', 'MIDWEST OFF','GRNPWR PEAK', 'GRNPWR OFF','TEXAS OFF', 'TEXAS PEAK', 'WEST OFF', 'WEST PEAK','AUSTRALIAN POWER', 'TEXAS INTERCONNECT O','TEXAS INTERCONNECT P', 'ERCOT', 'WEST INTERCONNECT OF','WEST INTERCONNECT PE', 'EAST INTERCONNECT OF', 'EAST INTERCONNECT PE') AND A.CCC_BUSINESS_AREA in ('NA ELECTRICITYNATURAL GAS')) /*OLG LOGIC*/ or (a.CCC_PRODUCT_LINE IN ('NA POWER & GAS') and A.PRODUCT_TYPE_CODE in ('EURO PWR','EAST PEAK','EAST OFF','MIDWEST PEAK', 'MIDWEST OFF','GRNPWR PEAK', 'GRNPWR OFF','TEXAS OFF', 'TEXAS PEAK', 'WEST OFF', 'WEST PEAK','AUSTRALIAN POWER', 'TEXAS INTERCONNECT O','TEXAS INTERCONNECT P', 'ERCOT', 'WEST INTERCONNECT OF','WEST INTERCONNECT PE', 'EAST INTERCONNECT OF', 'EAST INTERCONNECT PE'))) /*NEW LOGIC*/ then 'NA Power' When ((A.PRODUCT_TYPE_CODE in ('EMISSIONS-EU', 'NATGAS', 'LNG', 'COAL', 'EUR NG', 'COAL-US', 'EMISSIONS-US', 'WEATHER') AND A.CCC_BUSINESS_AREA in ('AP EU ELECTRICNATURAL GAS')) /*OLG LOGIC*/ or ( a.CCC_STRATEGY IN ('AP EU POWER & GAS') and A.PRODUCT_TYPE_CODE in ('EMISSIONS-EU', 'NATGAS', 'LNG', 'COAL', 'EUR NG', 'COAL-US', 'EMISSIONS-US', 'WEATHER'))) /*NEW LOGIC*/ then 'EU Fuels' When ((A.PRODUCT_TYPE_CODE in ('EMISSIONS-EU', 'NATGAS', 'LNG', 'COAL', 'EUR NG', 'COAL-US', 'WEATHER','EMISSIONS-US') AND A.CCC_BUSINESS_AREA in ('NA ELECTRICITYNATURAL GAS')) /*OLG LOGIC*/ or (a.CCC_PRODUCT_LINE IN ('NA POWER & GAS') and A.PRODUCT_TYPE_CODE in ('EMISSIONS-EU', 'NATGAS', 'LNG', 'COAL', 'EUR NG', 'COAL-US', 'WEATHER','EMISSIONS-US'))) /*NEW LOGIC*/ then 'NA Fuels' else 'other' end as AssetType, SUM((A.USD_CM_DELTA)) AS DOLLAR_DELTA FROM cdwuser.U_CM_MSR A WHERE ((A.CCC_DIVISION='COMMODITIES' AND A.CCC_BUSINESS_AREA in ( 'AP EU ELECTRICNATURAL GAS','NA ELECTRICITYNATURAL GAS'))/*OLD LOGIC*/ OR (A.CCC_DIVISION = 'FIXED INCOME DIVISION' AND A.CCC_BUSINESS_AREA = 'COMMODITIES' and (a.CCC_STRATEGY IN ('AP EU POWER & GAS') OR A.CCC_PRODUCT_LINE IN ('NA POWER & GAS')))) /*NEW LOGIC*/ AND A.PRODUCT_TYPE_CODE NOT IN ('CURRENCY', 'INTEREST RATE', 'INFLATION', 'TBD', 'MISC','CVA', 'FVA', 'ERROR') AND A.COB_DATE IN ('2018-02-28','2018-02-27','2018-01-31','2017-12-29','2017-09-29','2017-06-30') and NOT(a.INCLUDE_IN_REG_CAAP_FL = 'N' and a.PRODUCT_SUB_TYPE_CODE in ('N EAST CONSUMPTI', 'N EAST CONSUMPTION', 'N EAST APPALACHI', 'N EAST APPALACHIA') and a.BOOK = '18003') GROUP BY A.COB_DATE, A.PRODUCT_TYPE_CODE,A.CCC_BUSINESS_AREA, CCC_STRATEGY, CCC_PRODUCT_LINE