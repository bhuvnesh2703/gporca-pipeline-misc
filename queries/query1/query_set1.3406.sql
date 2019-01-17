SELECT a.COB_DATE, a.SPG_DESC, SUM (usd_exposure) AS net_exposure, (CASE WHEN spg_desc LIKE 'COLONNADE%' THEN 'Colonnade' WHEN book = 'COLONNADE' AND spg_desc NOT LIKE 'COLONNADE%' THEN 'Colonnade Single Names' WHEN spg_desc IN ('RMBS ALTA SECURITY', 'RMBS CDO', 'RMBS NON CONFORMING DEFAULT SWAP', 'RMBS SECOND RESIDUAL', 'RMBS SUB PRIME RESIDUAL', 'RMBS SUB PRIME SECURITY') THEN 'RMBS NC' WHEN spg_desc IN ('RMBS ALTA LOAN') AND CURRENCY_OF_POSITION = 'GBP' THEN 'UK Residential Whole Loans' WHEN ((spg_desc IN ('RMBS ALTA LOAN') AND CURRENCY_OF_POSITION = 'EUR') OR tapscusip IN ('999BLZY44', '999BM03T9', '999BM03V4')) THEN 'Italian Residential Whole Loans' WHEN ccc_business_area LIKE 'COMMERCIAL RE%' AND spg_desc IN ('CMBS SECURITY', 'CMBS IO') THEN 'CMBS Securities' WHEN ccc_business_area LIKE 'COMMERCIAL RE%' AND spg_desc IN ('CMBS DEFAULT SWAP', 'CMBS INDEX') THEN 'CMBS Hedges' WHEN ccc_business_area LIKE 'COMMERCIAL RE%' AND spg_desc IN ('CMBS LOAN', 'CMBS MEZZANINE LOAN', 'OTHER LOANS') THEN 'CMBS Loan' WHEN ccc_product_line LIKE 'CRE LEND%' AND spg_desc IN ('CMBS LOAN', 'CMBS MEZZANINE LOAN') THEN 'CRE Loan' WHEN spg_desc LIKE 'CMBS%' OR PRODUCT_DESCRIPTION LIKE ('TSCOLN%') THEN 'CMBS' WHEN spg_desc IN ('RMBS PRIME DEFAULT SWAP', 'RMBS PRIME RESIDUAL', 'RMBS PRIME SECURITY', 'RMBS ALTA RESIDUAL', 'RMBS DEFAULT SWAP') THEN 'RMBS PRIME' WHEN spg_desc IN ('CORPORATE CDO', 'CORPORATE CDO DEFAULT SWAP', 'CORPORATE CDO EQUITY', 'CORPORATE CLO') THEN 'CLO' WHEN spg_desc IN ('ABS AUTO LOAN & SECURITY', 'ABS CREDIT CARD SECURITY', 'ABS DEFAULT SWAP', 'ABS EQUIPMENT SECURITY', 'ABS OTHER SECURITY', 'ABS STUDENT SECURITY', 'ABS CREDIT BASKET', 'CORPORATE BONDS') OR PRODUCT_DESCRIPTION LIKE ('JUNEAU%') THEN 'ABS' WHEN spg_desc IN ('CORPORATE DEFAULT SWAP', 'CORPORATE INDEX') AND PRODUCT_DESCRIPTION NOT LIKE ('JUNEAU%') THEN 'Other Corp' END) AS European_Exposure, CASE WHEN Insurer_rating IN ('AAA') THEN 'AAA' ELSE 'Non AAA' END AS Insurer_Rating_Revised FROM cdwuser.U_CR_MSR a WHERE CCC_business_area IN ('SECURITIZED PRODUCTS GRP') AND (a.CCC_PL_REPORTING_REGION = 'EMEA' ) AND a.COB_DATE in ('2018-02-28','2018-02-21','2018-01-31','2017-12-29','2017-11-30','2017-09-29') AND a.CCC_PRODUCT_LINE NOT IN ('CRE LENDING SEC/HFS','CREL BANK HFI') AND a.SPG_DESC NOT IN ('WAREHOUSE ABS LOAN') GROUP BY insurer_rating, ccc_business_area, vintage, a.account, a.ccc_product_line, PRODUCT_DESCRIPTION, a.COB_DATE, spg_desc, book, CURRENCY_OF_POSITION, tapscusip