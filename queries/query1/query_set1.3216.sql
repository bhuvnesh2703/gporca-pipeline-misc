SELECT
    COB_DATE,
    CCC_PRODUCT_LINE,
    CCC_STRATEGY,
    BOOK,
    SUM(USD_EXPOSURE) AS USD_EXPOSURE,
    CASE
    WHEN CCC_PRODUCT_LINE in ('RESIDENTIAL') THEN  'Resi Non Core'
    WHEN CCC_PRODUCT_LINE  in ('COMMERCIAL RE (PTG)') THEN  'CRE Non Core'
    ELSE 'Other Limit' END AS Limit_Name
    
    FROM CDWUSER.U_EXP_MSR a
    where CCC_BUSINESS_AREA in ('RESIDENTIAL','COMMERCIAL RE (PTG)','NON CORE') 
    AND COB_DATE IN ('2018-02-28', '2018-01-31')
    GROUP BY
    COB_DATE,
    CCC_PRODUCT_LINE,
    CCC_STRATEGY,
    BOOK,
    CASE
    WHEN CCC_PRODUCT_LINE in ('RESIDENTIAL') THEN  'Resi Non Core'
    WHEN CCC_PRODUCT_LINE  in ('COMMERCIAL RE (PTG)') THEN  'CRE Non Core'
    ELSE 'Other Limit' END