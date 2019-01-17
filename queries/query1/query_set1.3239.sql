with
 PRODUCT_LINE_VALUE(ccc_product_line) as ( values ('CRE LEND SECURITIZATION'),('CRE LEND - BANK HFI/HFS'),('CRE LENDING'),('CRE LENDING SEC/HFS'),('CREL BANK HFI')),
 PRODUCT_TYPE_GROUP_VALUE(spg_product_type_group) as (values ('EQUITY'), ('GOVERNMENT'), ('RESI- AGENCY'), ('SWAP'), ('WAREHOUSE')),
 PRODUCT_TYPE_VALUE(spg_product_type) as (values ('AGENCY CMBS'), ('CMBS LOAN'), ('CORPORATE SINGLE NAME')),
 PRODUCT_TYPE_CODE_VALUE(product_type_code) as (values ('BOND'), ('CRDINDEX'), ('LOANINDEX'), ('AGN'), ('BONDFUT'), ('BONDFUTOPT'), ('GVTBOND'))

SELECT
b.COB_DATE,
b.SPG_PRODUCT_TYPE_GROUP,
b.SPG_PRODUCT_TYPE,
b.CATEGORY,
SUM(NET_EXPOSURE) USD_EXPOSURE
FROM
(

SELECT
a.COB_DATE,
a.SPG_PRODUCT_TYPE_GROUP,
a.SPG_PRODUCT_TYPE,
UNNEST(ARRAY[
CLASSIFICATION_0,
CLASSIFICATION_1,
CLASSIFICATION_2,
CLASSIFICATION_3,
CLASSIFICATION_4,
CLASSIFICATION_5,
CLASSIFICATION_6,
CLASSIFICATION_7,
CLASSIFICATION_8,
CLASSIFICATION_9,
CLASSIFICATION_10,
CLASSIFICATION_11,
CLASSIFICATION_12,
CLASSIFICATION_13,
CLASSIFICATION_14,
CLASSIFICATION_15,
CLASSIFICATION_16,
CLASSIFICATION_17,
CLASSIFICATION_18,
CLASSIFICATION_19,
CLASSIFICATION_20,
CLASSIFICATION_21,
CLASSIFICATION_22,
CLASSIFICATION_23,
CLASSIFICATION_24,
CLASSIFICATION_25,
CLASSIFICATION_26,
CLASSIFICATION_27,
CLASSIFICATION_28,
CLASSIFICATION_29,
CLASSIFICATION_30,
CLASSIFICATION_31,
CLASSIFICATION_32,
CLASSIFICATION_33,
CLASSIFICATION_34]) CATEGORY,
NET_EXPOSURE
FROM 
(

SELECT
COB_DATE, 
SPG_PRODUCT_TYPE_GROUP,
SPG_PRODUCT_TYPE,
'Global Credit' CLASSIFICATION_0,
Case when INSURER_RATING not in ('AAA','AM','AS','PENAAA') AND DETACHMENT < 1 AND SPG_PRODUCT_TYPE not in ('RESI- NON AGENCY PRIME LOAN', 'RESI- NON AGENCY SCRATCH & DENT') then 'Global Credit Mezz' end CLASSIFICATION_1,
Case when SPG_PRODUCT_TYPE_GROUP in ('CMBS','CMBS SINGLE NAME') then 'Global CMBS' end CLASSIFICATION_2,
Case when SPG_PRODUCT_TYPE in ('CMBS CDO','SUBPRIME CDO','CMBS HiGRADE CDO') then 'Global CDO' end CLASSIFICATION_3,
Case when INSURER_RATING not in ('AAA','AM','AS','PENAAA') AND SPG_PRODUCT_TYPE_GROUP in ('CMBS','CMBS SINGLE NAME') then 'Global CMBS Mezz' end CLASSIFICATION_4,
Case when SPG_PRODUCT_TYPE_GROUP in ('RPX','RESI- NON AGENCY','SUBPRIME') then 'Global Resi' end CLASSIFICATION_5,
Case when INSURER_RATING not in ('AAA','AM','AS','PENAAA') AND DETACHMENT < 1 AND SPG_PRODUCT_TYPE_GROUP in ('RPX','RESI- NON AGENCY','SUBPRIME') AND SPG_PRODUCT_TYPE not in ('RESI- NON AGENCY SCRATCH & DENT', 'RESI- NON AGENCY PRIME LOAN') then 'Global Resi Mezz' end CLASSIFICATION_6,
Case when SPG_PRODUCT_TYPE in ('CORPORATE CDO') then 'Global CLO' end CLASSIFICATION_7,
Case when INSURER_RATING not in ('AAA','AM','AS','PENAAA') AND SPG_PRODUCT_TYPE in ('CORPORATE CDO') then 'Global CLO Mezz' end CLASSIFICATION_8,
Case when SPG_PRODUCT_TYPE_GROUP in ('ABS','CDO- MULTI ASSET') then 'Global ABS' end CLASSIFICATION_9,
Case when INSURER_RATING not in ('AAA','AM','AS','PENAAA') AND SPG_PRODUCT_TYPE_GROUP in ('ABS','CDO- MULTI ASSET') then 'Global ABS Mezz' end CLASSIFICATION_10,
Case when CCC_PL_REPORTING_REGION = 'EMEA' then 'EU Credit' end CLASSIFICATION_11,
Case when INSURER_RATING not in ('AAA','AM','AS','PENAAA') AND DETACHMENT < 1 AND SPG_PRODUCT_TYPE not in ('RESI- NON AGENCY PRIME LOAN', 'RESI- NON AGENCY SCRATCH & DENT') AND CCC_PL_REPORTING_REGION = 'EMEA' then 'EU Credit Mezz' end CLASSIFICATION_12,
Case when SPG_PRODUCT_TYPE_GROUP in ('RESI- NON AGENCY', 'SUBPRIME') AND SPG_PRODUCT_TYPE in ('RESI- NON AGENCY PRIME SINGLE NAME', 'RESI- NON AGENCY PRIME LOAN') AND CCC_PL_REPORTING_REGION = 'EMEA' then 'EU Resi Prime' end CLASSIFICATION_13,
Case when SPG_PRODUCT_TYPE_GROUP in ('RESI- NON AGENCY', 'SUBPRIME') AND SPG_PRODUCT_TYPE in ('RESI- NON AGENCY PRIME SINGLE NAME', 'RESI- NON AGENCY PRIME LOAN') AND CCC_PL_REPORTING_REGION = 'EMEA' AND INSURER_RATING not in ('AAA','AM','AS','PENAAA') AND DETACHMENT < 1 then 'EU Resi Prime Mezz' end CLASSIFICATION_14,
Case when SPG_PRODUCT_TYPE_GROUP in ('RESI- NON AGENCY', 'SUBPRIME') AND SPG_PRODUCT_TYPE in ('RESI- NON AGENCY ALT A LOAN', 'RESI- NON AGENCY ALT A SINGLE NAME', 'SUBPRIME CDO', 'SUBPRIME SINGLE NAME') AND CCC_PL_REPORTING_REGION = 'EMEA' then 'EU Resi NonConforming' end CLASSIFICATION_15,
Case when SPG_PRODUCT_TYPE_GROUP in ('RESI- NON AGENCY', 'SUBPRIME') AND SPG_PRODUCT_TYPE in ('RESI- NON AGENCY ALT A LOAN', 'RESI- NON AGENCY ALT A SINGLE NAME', 'SUBPRIME CDO', 'SUBPRIME SINGLE NAME') AND CCC_PL_REPORTING_REGION = 'EMEA' AND INSURER_RATING NOT IN ('AAA','AM','AS','PENAAA') AND DETACHMENT < 1 then 'EU Resi NonConforming Mezz' end CLASSIFICATION_16,
Case when CCC_PL_REPORTING_REGION = 'EMEA' AND SPG_PRODUCT_TYPE_GROUP in ('ABS', 'CDO-MULTI ASSET') then 'EU ABS' end CLASSIFICATION_17,
Case when CCC_PL_REPORTING_REGION = 'EMEA' AND SPG_PRODUCT_TYPE_GROUP in ('ABS', 'CDO-MULTI ASSET') AND INSURER_RATING NOT IN ('AAA', 'AM', 'AJ', 'PENAAA') AND detachment <> '1.0' then 'EU ABS Mezz' end CLASSIFICATION_18,
Case when CCC_PL_REPORTING_REGION = 'EMEA' AND SPG_PRODUCT_TYPE in ('CORPORATE CDO') then 'EU CLO' end CLASSIFICATION_19,
Case when CCC_PL_REPORTING_REGION = 'EMEA' AND SPG_PRODUCT_TYPE_GROUP in ('CMBS','CMBS SINGLE NAME') then 'EU CMBS' end CLASSIFICATION_20,
Case when CCC_PL_REPORTING_REGION = 'EMEA' AND SPG_PRODUCT_TYPE_GROUP in ('CMBS','CMBS SINGLE NAME') AND INSURER_RATING NOT IN ('AAA', 'AM', 'AS', 'PENAAA') then 'EU CMBS Mezz' end CLASSIFICATION_21,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' then 'US Credit' end CLASSIFICATION_22,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' AND INSURER_RATING not in ('AAA','AM','AS','PENAAA') AND DETACHMENT < 1 AND SPG_PRODUCT_TYPE NOT in ('RESI- NON AGENCY PRIME LOAN', 'RESI- NON AGENCY SCRATCH & DENT') then 'US Credit Mezz' end CLASSIFICATION_23,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' AND SPG_PRODUCT_TYPE_GROUP in ('RESI- NON AGENCY', 'SUBPRIME') AND SPG_PRODUCT_TYPE in ('RESI- NON AGENCY SCRATCH & DENT') then 'US Resi Distressed Whole Loans' end CLASSIFICATION_24,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' AND SPG_PRODUCT_TYPE_GROUP in ('RESI- NON AGENCY', 'SUBPRIME') AND SPG_PRODUCT_TYPE in ('RESI- NON AGENCY PRIME LOAN') then 'US Resi Prime Whole Loans' end CLASSIFICATION_25,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' AND SPG_PRODUCT_TYPE_GROUP in ('RESI- NON AGENCY', 'SUBPRIME') AND SPG_PRODUCT_TYPE in ('NON AGENCY RESI ALT A CASH', 'RESI- NON AGENCY ALT A REREMIC', 'RESI- NON AGENCY ALT A SINGLE NAME', 'RESI- NON AGENCY OPTION ARM', 'RESI- NON AGENCY PRIME SINGLE NAME', 'RESI- NON AGENCY SECOND', 'SUBPRIME CDO', 'SUBPRIME SINGLE NAME') then 'US Resi Legacy' end CLASSIFICATION_26,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' AND SPG_PRODUCT_TYPE_GROUP in ('RESI- NON AGENCY', 'SUBPRIME') AND SPG_PRODUCT_TYPE in ('RESI- NON AGENCY CRT') then 'US Resi CRT' end CLASSIFICATION_27,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' AND SPG_PRODUCT_TYPE_GROUP in ('RESI- NON AGENCY', 'SUBPRIME') AND SPG_PRODUCT_TYPE in ('RESI- NON AGENCY CRT') AND TRANCHE_NAME in ('1B1','2B1','B1') then 'US Resi CRT First Loss' end CLASSIFICATION_28,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' AND SPG_PRODUCT_TYPE_GROUP in ('ABS', 'CDO-MULTI ASSET') then 'US ABS' end CLASSIFICATION_29,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' AND SPG_PRODUCT_TYPE_GROUP in ('ABS', 'CDO-MULTI ASSET') AND INSURER_RATING NOT IN ('AAA', 'AM', 'AS', 'PENAAA') then 'US ABS Mezz' end CLASSIFICATION_30,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' AND SPG_PRODUCT_TYPE in ('CORPORATE CDO') then 'US CLO' end CLASSIFICATION_31,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' AND SPG_PRODUCT_TYPE_GROUP in ('CMBS','CMBS SINGLE NAME') AND IS_CASH_FL = 'Y' then 'US CMBS Cash' end CLASSIFICATION_32,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' AND SPG_PRODUCT_TYPE_GROUP in ('CMBS','CMBS SINGLE NAME') AND IS_CASH_FL = 'N' then 'US CMBS Synthetic' end CLASSIFICATION_33,
Case when CCC_PL_REPORTING_REGION = 'AMERICAS' AND SPG_PRODUCT_TYPE_GROUP in ('CMBS','CMBS SINGLE NAME') AND PRODUCT_SUB_TYPE_CODE in ('CMBS_IO','IO_REREMIC') then 'US CMBS IO' end CLASSIFICATION_34,
SUM(USD_EXPOSURE) AS NET_EXPOSURE
FROM CDWUSER.U_EXP_MSR

WHERE
COB_DATE IN ('2018-02-28', '2018-01-31')
AND CCC_BUSINESS_AREA in ('SECURITIZED PRODUCTS GRP') 
AND CCC_PRODUCT_LINE NOT in (select ccc_product_line from PRODUCT_LINE_VALUE)
AND SPG_PRODUCT_TYPE_GROUP NOT in (select spg_product_type_group from PRODUCT_TYPE_GROUP_VALUE)
AND SPG_PRODUCT_TYPE NOT in (select spg_product_type from PRODUCT_TYPE_VALUE)
AND PRODUCT_TYPE_CODE NOT in (select product_type_code from PRODUCT_TYPE_CODE_VALUE)
AND VERTICAL_SYSTEM not in ('C1_LN','C1_NY')
AND EXP_ASSET_TYPE in ('CR','OT')
AND CCC_STRATEGY NOT LIKE ('%NEW ISSUE%') 

group by 
COB_DATE, 
SPG_PRODUCT_TYPE_GROUP,
SPG_PRODUCT_TYPE,
CLASSIFICATION_0,
CLASSIFICATION_1,
CLASSIFICATION_2,
CLASSIFICATION_3,
CLASSIFICATION_4,
CLASSIFICATION_5,
CLASSIFICATION_6,
CLASSIFICATION_7,
CLASSIFICATION_8,
CLASSIFICATION_9,
CLASSIFICATION_10,
CLASSIFICATION_11,
CLASSIFICATION_12,
CLASSIFICATION_13,
CLASSIFICATION_14,
CLASSIFICATION_15,
CLASSIFICATION_16,
CLASSIFICATION_17,
CLASSIFICATION_18,
CLASSIFICATION_19,
CLASSIFICATION_20,
CLASSIFICATION_21,
CLASSIFICATION_22,
CLASSIFICATION_23,
CLASSIFICATION_24,
CLASSIFICATION_25,
CLASSIFICATION_26,
CLASSIFICATION_27,
CLASSIFICATION_28,
CLASSIFICATION_29,
CLASSIFICATION_30,
CLASSIFICATION_31,
CLASSIFICATION_32,
CLASSIFICATION_33,
CLASSIFICATION_34
) A
) B  
WHERE
b.CATEGORY IS NOT NULL
GROUP BY
b.COB_DATE, 
b.SPG_PRODUCT_TYPE_GROUP,  
b.SPG_PRODUCT_TYPE,
b.CATEGORY