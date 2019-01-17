SELECT
A.COB_DATE,
 CASE WHEN a.SPG_DESC IN ('CORPORATE INDEX', 'CORPORATE DEFAULT SWAP') AND a.CCC_PRODUCT_LINE NOT IN ('CRE LENDING', 'CREL BANK HFI', 'CRE LENDING SEC/HFS') THEN 'Corporates' 
    WHEN a.CCC_PRODUCT_LINE NOT IN ('AGENCY MBS','AGENCY TRADING') AND (a.SPG_DESC = 'GOVERNMENT' OR PRODUCT_TYPE_CODE in ('BERMUDAN_SWAPTION_VA','BONDFUTOPT','MISC'))  THEN 'IR Hedges - Treasury' 
    WHEN a.CCC_PRODUCT_LINE NOT IN ('AGENCY MBS', 'AGENCY TRADING') AND (spg_desc like 'RATE %' or spg_desc in ('SWAP','SWAPS')) THEN 'IR Hedges - Swap'    
    WHEN a.SPG_DESC = 'CMBS INDEX' AND a.CCC_PRODUCT_LINE IN ('SPG MANAGEMENT') THEN 'CMBX Hedge'
    ELSE 'EQUITY' END AS GROUPED_PRODUCT_TYPE,
sum(a.SLIDE_EQ_MIN_30_USD) as PV_MIN30,
sum(a.SLIDE_EQ_MIN_20_USD) as PV_MIN20,
sum(a.SLIDE_EQ_MIN_10_USD) as PV_MIN10,
sum(a.USD_DELTA) as USD_DELTA,
sum(a.SLIDE_EQ_PLS_10_USD) as PV_PLS10
FROM cdwuser.U_EQ_MSR a
WHERE
    a.COB_DATE IN 
    ('2018-02-28', '2018-02-21')
    AND a.CCC_BUSINESS_AREA = 'SECURITIZED PRODUCTS GRP'
group by
A.COB_DATE,
 CASE WHEN a.SPG_DESC IN ('CORPORATE INDEX', 'CORPORATE DEFAULT SWAP') AND a.CCC_PRODUCT_LINE NOT IN ('CRE LENDING', 'CREL BANK HFI', 'CRE LENDING SEC/HFS') THEN 'Corporates' 
    WHEN a.CCC_PRODUCT_LINE NOT IN ('AGENCY MBS', 'AGENCY TRADING') AND (a.SPG_DESC = 'GOVERNMENT' OR PRODUCT_TYPE_CODE in ('BERMUDAN_SWAPTION_VA','BONDFUTOPT','MISC'))  THEN 'IR Hedges - Treasury' 
    WHEN a.CCC_PRODUCT_LINE NOT IN ('AGENCY MBS', 'AGENCY TRADING') AND (spg_desc like 'RATE %' or spg_desc in ('SWAP','SWAPS')) THEN 'IR Hedges - Swap'    
    WHEN a.SPG_DESC = 'CMBS INDEX' AND a.CCC_PRODUCT_LINE IN ('SPG MANAGEMENT') THEN 'CMBX Hedge'
    ELSE 'EQUITY' END