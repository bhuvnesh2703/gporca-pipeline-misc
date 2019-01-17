SELECT
    a.CCC_STRATEGY,
    A.MUNI_TYPE_CODE,
    a.COB_DATE,
    SUM (A.USD_PV01SPRD) AS USD_PV01SPRD,
    SUM (A.USD_IR_UNIFIED_PV01) AS USD_IR_UNIFIED_PV01,
    SUM (A.USD_NET_EXPOSURE) AS USD_NET_EXPOSURE,
    SUM (ABS (A.USD_NET_EXPOSURE)) AS USD_GROSS_EXPOSURE
FROM cdwuser.U_DM_CC A
WHERE
    a.COB_DATE IN ('2018-02-28', '2018-01-31') AND 
    A.MUNI_TYPE_CODE IS NOT NULL AND
    ((a.CCC_BUSINESS_AREA = 'MUNICIPAL SECURITIES' AND
      a.PRODUCT_TYPE_CODE IN ('BONDFUT', 'RATEFUT', 'GVTBOND', 'MUNI', 'MUNI_TAXABLE', 'SWAPTION',  'SWAP', 'BOND', 'BONDFUTOPT')))
GROUP BY
    a.MUNI_TYPE_CODE,
    a.COB_DATE,
    a.CCC_STRATEGY