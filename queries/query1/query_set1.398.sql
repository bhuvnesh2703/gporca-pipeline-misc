Select A.COB_DATE, sum(A.DOLLAR_GREEK) as DOLLAR_GREEK, A.ELEC_HIERARCHY, A.PEAK, A.prod_consum FROM (Select prod_pos_name_description,COB_DATE,ccc_business_area, product_type_code,time_bucket_calendar, product_sub_type_code,EXPIRATION_DATE,time_bucket_quarter, sum(cast(USD_CM_Delta as numeric(15,5))) as dollar_greek, sum(cast(RAW_CM_Delta as numeric(15,5))) as raw_greek, case when EXPIRATION_DATE < ('2019-09-01') then time_bucket_quarter end as quarters, case when product_type_code in ('EAST OFF', 'MIDWEST OFF','TEXAS OFF', 'WEST OFF','EAST INTERCONNECT OF','TEXAS INTERCONNECT O','WEST INTERCONNECT OF') then 'Off-Peak' when product_type_code in ('EAST PEAK', 'MIDWEST PEAK', 'TEXAS PEAK','WEST PEAK','EAST INTERCONNECT PE', 'TEXAS INTERCONNECT P','ERCOT', 'WEST INTERCONNECT PE') then 'Peak' when product_type_code ='Natgas' then product_type_code end as PEAK, case when product_type_code in ('TEXAS OFF', 'TEXAS PEAK','TEXAS INTERCONNECT O', 'TEXAS INTERCONNECT P', 'ERCOT') then 'Texas' when product_type_code in('WEST OFF', 'WEST PEAK','WEST INTERCONNECT OF', 'WEST INTERCONNECT PE') then 'West' when product_type_code in ('EAST OFF', 'EAST PEAK') OR PRODUCT_SUB_TYPE_CODE in ('NE_ISO_O', 'NY_ISO_O', 'PJM_O', 'SERC_O', 'SPP_O','NE_ISO_P', 'NY_ISO_P', 'PJM_P', 'SERC_P', 'SPP_P', 'NEPOOL O','SOUTHEAST O','PJMW O','PJME O','NY O','NY P','PJMW P','NEPOOL P','PJME P','SOUTHEAST P') then 'East' when product_type_code in('MIDWEST OFF', 'MIDWEST PEAK') OR PRODUCT_SUB_TYPE_CODE in ('MIDWEST_P','MIDWEST_O','MISO OFF', 'PJM-MIDCONT OFF','MISO PEAK','PJM-MIDCONT PEAK') then 'Midwest' end as ELEC_HIERARCHY, case when product_sub_type_code in ('NY P','NY O','PJME P','PJME O','SOUTHEAST P','SOUTHEAST O', 'NY_ISO_P','NY_ISO_O','PJM_P','PJM_O','SERC_P','SPP_P','SERC_O','SPP_O') then 'Consuming' when product_sub_type_code in ('CALIFORNIA OFF', 'CALIFORNIA PEAK', 'CAISO_O', 'CASIO_P') then 'California' when product_sub_type_code in ('ERCOT S P', 'ERCOT S O') OR PROD_POS_NAME_DESCRIPTION in ('ERCOT S-O','ERCOT S-P','ERCOT S 345KV-P') then 'South Texas' else 'Other' end as prod_consum FROM cdwuser.U_CM_MSR Where COB_DATE IN ('2018-02-28','2018-02-27') AND product_type_code in ('EAST OFF', 'EAST PEAK', 'MIDWEST OFF', 'MIDWEST PEAK', 'TEXAS OFF', 'TEXAS PEAK', 'WEST OFF', 'WEST PEAK','EAST INTERCONNECT OF','EAST INTERCONNECT PE','TEXAS INTERCONNECT O', 'TEXAS INTERCONNECT P', 'ERCOT', 'WEST INTERCONNECT OF', 'WEST INTERCONNECT PE') AND CCC_BUSINESS_AREA not in ('CREDIT','MS CVA MNE - COMMOD', 'COMMODS FINANCING') AND ((CCC_DIVISION='COMMODITIES' and CCC_BUSINESS_AREA in ('NA ELECTRICITYNATURAL GAS')) /*OLD LOGIC*/ OR (CCC_DIVISION = 'FIXED INCOME DIVISION' AND CCC_BUSINESS_AREA = 'COMMODITIES' and CCC_PRODUCT_LINE IN ('NA POWER & GAS'))) /* NEW LOGIC*/ AND (CCC_PL_REPORTING_REGION IN ('EUROPE','EMEA')) Group By prod_pos_name_description,COB_DATE,ccc_business_area,product_type_code,time_bucket_calendar, EXPIRATION_DATE,time_bucket_quarter, product_sub_type_code)A Group by A.COB_DATE, A.ELEC_HIERARCHY, A.PEAK, A.prod_consum