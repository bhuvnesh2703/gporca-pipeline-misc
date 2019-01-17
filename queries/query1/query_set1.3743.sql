SELECT
    a.COB_DATE, a.PRODUCT_TYPE_CODE, a.LE_GROUP, a.CURRENCY_OF_MEASURE ,
    a.CCC_PL_REPORTING_REGION,
    a.COUNTRY_CD_OF_RISK,
    a.CCC_BUSINESS_AREA,     a.TERM_BUCKET, A.TERM_NEW,
    a.CURVE_NAME,
    CASE WHEN a.PRODUCT_TYPE_CODE in ('AGN', 'BOND', 'BONDFUT', 'BONDFUTOPT', 'GOVTBONDOPT', 'GOVTBONDOPTIL', 'GVTBOND','GVTBONDIL', 'GVTFRN', 'TRRSWAP', 
'TRS - GVTBOND', 'TRS - GVTBONDIL') then 'BONDS' else 'SWAPS' end as BOND_SWAP_FL,
    CASE WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)','CPM', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD','COMMODS FINANCING') 
OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES')) 
AND a.CCC_PRODUCT_LINE NOT IN ('CREDIT LOAN PORTFOLIO', 'CMD STRUCTURED FINANCE') then 'CVA_IR'
when a.CCC_BUSINESS_AREA = 'LENDING' OR a.CCC_PRODUCT_LINE = 'PRIMARY - LOANS' then 'LENDING' 
ELSE 'IR' end as CVA_FL, 
   SUM(coalesce(a.USD_IR_UNIFIED_PV01,0)) AS PV01,                            /* pv01 for bonds and swaps */
   SUM (coalesce(a.USD_IR_KAPPA,0))/10 as USD_KAPPA                                               /* 10% relative increase in Vol as we divided by 10 */
FROM cdwuser.U_IR_MSR_INTRPLT a

WHERE
    cob_date IN ('2018-02-28','2018-02-21') 
    AND a.CURRENCY_OF_MEASURE in ('ZAR') 
    AND CCC_DIVISION NOT IN ('FID DVA', 'FIC DVA')  AND CCC_STRATEGY NOT IN ('MS DVA STR NOTES IED') 

GROUP BY
   a.COB_DATE, a.PRODUCT_TYPE_CODE, a.LE_GROUP, a.CURRENCY_OF_MEASURE ,
    a.CCC_PL_REPORTING_REGION,
    a.COUNTRY_CD_OF_RISK,
    a.CCC_BUSINESS_AREA,     a.TERM_BUCKET,  A.TERM_NEW,
    a.CURVE_NAME,
    CASE WHEN a.PRODUCT_TYPE_CODE in ('AGN', 'BOND', 'BONDFUT', 'BONDFUTOPT', 'GOVTBONDOPT', 'GOVTBONDOPTIL', 'GVTBOND','GVTBONDIL', 'GVTFRN', 'TRRSWAP', 
'TRS - GVTBOND', 'TRS - GVTBONDIL') then 'BONDS' else 'SWAPS' end,
    CASE WHEN (a.CCC_BUSINESS_AREA IN ('CPM TRADING (MPE)','CPM', 'CREDIT', 'MS CVA MNE - FID', 'MS CVA MNE - COMMOD','COMMODS FINANCING') 
OR a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES')) 
AND a.CCC_PRODUCT_LINE NOT IN ('CREDIT LOAN PORTFOLIO', 'CMD STRUCTURED FINANCE') then 'CVA_IR'
when a.CCC_BUSINESS_AREA = 'LENDING' OR a.CCC_PRODUCT_LINE = 'PRIMARY - LOANS' then 'LENDING' 
ELSE 'IR' end