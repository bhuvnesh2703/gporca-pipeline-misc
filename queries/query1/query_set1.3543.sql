SELECT     B.*,     CASE WHEN B.PRODUCT_GROUP_DETAIL IN ('Savings', 'Deposits - Spot', 'Deposits - 3M Forward', 'Deposits - Beyond 3M',                                               'GWM BDP Personal Trust', 'Brokered CD - GCM','Brokered CD - PBG', 'Promontory Deposits', 'Structured CD') THEN          'Deposits' WHEN B.PRODUCT_GROUP_DETAIL IN ('AFS Govt Bonds', 'AFS AGN Fixed', 'AFS AGN Float', 'AFS Credit Fixed',                                                         'AFS Credit Float', 'HTM Govt Bonds', 'HTM Agency', 'Repo') THEN          'Investment Portfolio' WHEN B.PRODUCT_GROUP_DETAIL IN ('IR Swap', 'Swaption', 'IR Futures', 'Option on Futures') THEN          'IR Hedges' WHEN B.PRODUCT_GROUP_DETAIL IN ('Mortgages (HFI)', 'Mortgages (HFS)', 'PLA', 'LAL', 'Tailored Lending') THEN          'Lending'     ELSE 'Other' END AS PRODUCT_GROUP FROM     (         SELECT             a.COB_DATE,             a.CURRENCY_OF_MEASURE,             a.ACCOUNT,             a.CCC_PRODUCT_LINE,             a.VERTICAL_SYSTEM,             a.BOOK,             CASE WHEN BOOK IN ('DPSWA', 'DPTSW', 'IPBSW', 'IPTSW', 'PLSWA', 'RPOFO', 'RPOHA', 'RPOHD', 'RPOHK', 'RPOHM', 'RPOHO',                                     'TL2SW', 'RPOHE', 'RPOHB', 'RPOHF', 'RPOHG', 'RPOHH') THEN 'INTERNAL TRANSFER TRADES' WHEN account IN                  ('0720GVB14', '0720GVT15') THEN 'AFS Govt Bonds' WHEN account IN ('0720AF1B4', '07100PT40', '072005E15', '07100PT24',                                                                                        '072004ZA5', '0710PT251', '0710PT3A9') THEN                  'AFS AGN Fixed' WHEN account IN ('0720AS209', '072005E98', '07100PT32', '0720AS605', '07200SM16', '07200SM99',                                                       '0720TST75', '0720BST58', '072004ZC1') THEN 'AFS AGN Float' WHEN account IN (                                                                                                                                       '0720B59U5'                 , '0720B53Z0', '0720CB3C7', '0720B50C4', '0720A43U5', '0720CB2T1', '0720A43N1', '07200DK45') THEN 'AFS Credit Fixed'                  WHEN account IN ('0720CB2S3', '0720B50B6', '0720A40N4', '0720CB2U8', '0720B50A8', '0720A40F1') THEN 'AFS Credit Float'                  WHEN account IN ('072000F72', '07200B6G8') THEN 'HTM Govt Bonds' WHEN account IN ('071000B85', '07100AS69', '072000GC0',                                                                                                        '07200B6M5', '07100ATD3',                                                                                                        '07200B6K9', '07100ATF8',                                                                                                        '07200B6H6', '07200B6J2') THEN                  'HTM Agency' WHEN account IN ('083003ZU0') THEN 'IR Swap' WHEN account IN ('083003ZY2', '083004FN6') THEN 'Swaption'                  WHEN book IN ('TFUTR', 'EFUTR') THEN 'IR Futures' WHEN book IN ('TOPTN', 'EOPTN') THEN 'Option on Futures' WHEN             account IN ('070008AG2', '0700089Z2', '0700ERR44', '070008AG2', '0700089Z2', '0700ERR44', '07000RE50') OR             book IN ('RPOHJ', 'RPOHC')             THEN 'Repo' WHEN book IN ('TTSNY', 'TBSNY') THEN 'Cash' WHEN             account IN ('L26USBAL0', '072006FH7', '07200C4H6', '072006FD6', '07200C4G8', 'LA5MSCIL1', '072006E54', '07200C4D5',                              'L70USBIC7') OR             book IN ('CRA INVESTMENT')             THEN 'NON BANK CRA' WHEN BOOK IN ('ARBITRAGE', 'CSSW2', 'CSSWA', 'NYCW', 'NYDC', 'NYSB', 'PBGSPORT', 'RDTCC', 'RPOOG') THEN                  'Non Bank Assets' WHEN BOOK IN ('MSDPB_SAVINGS', 'MSDPT_SAVINGS') THEN 'Savings' WHEN BOOK IN ('MSDPB', 'MSDPT') THEN                  'Deposits - Spot' WHEN BOOK IN ('MSDPB3M', 'MSDPT3M') THEN 'Deposits - 3M Forward' WHEN BOOK IN ('MSDPB3MREST',                                                                                                                       'MSDPT3MREST') THEN                  'Deposits - Beyond 3M' WHEN book IN ('GWM BDP PERSONAL TRUST') THEN 'GWM BDP Personal Trust' WHEN BOOK IN ('VNCDB',                                                                                                                                 'VNCDP',                                                                                                                                 'BCDUT')                  THEN 'Brokered CD - GCM' WHEN BOOK IN ('PBCDP', 'PBCDB') THEN 'Brokered CD - PBG' WHEN (CCC_PRODUCT_LINE =                                                                                                              'HELD FOR INVESTMENT - (HFI)'                 ) THEN 'Mortgages (HFI)' WHEN (CCC_PRODUCT_LINE = 'HELD FOR SALE - (HFS)' OR                                                BOOK = 'CCISW' OR                                                CCC_STRATEGY = 'RESI WM JV') THEN 'Mortgages (HFS)' WHEN BOOK IN ('PLAFL', 'PLAPV') THEN                  'PLA' WHEN BOOK LIKE 'WM_LAL%' THEN 'LAL' WHEN (CCC_STRATEGY = 'TAILORED LENDING NJV') THEN 'Tailored Lending' WHEN                  CCC_STRATEGY = 'RESI WM JV' THEN 'WLS' WHEN BOOK IN ('GCTAV', 'GCTPC', 'GCTBL') THEN 'Global Currency' WHEN BOOK IN (                                                                                                                                          'LMSCORE'                 , 'PWMUS') THEN 'Margin' WHEN BOOK IN ('ECLLOAN_MSPB') THEN 'ECL' WHEN BOOK = 'MUNI TRUST' THEN 'Muni Trust' WHEN BOOK =                  'MSDEP' THEN 'Promontory Deposits' WHEN BOOK = 'TNYBL' THEN 'Parent Deposits at FRB' WHEN             BOOK IN ('STRUCTURED CD', 'BROKERED CD1 NAM') AND             ACCOUNT IN ('071002UE', '0710011N')             THEN 'Structured CD' WHEN account IN ('072009A37', '072009A60', '072009A78', '072009A86') THEN 'Resi Whole Loans' WHEN                  account IN ('0710089B4', '0710089C2', '075009BJ8', '075009BP4') THEN 'Resi Whole Loan Hedges' WHEN BOOK IN ('RPOCX')                  THEN 'FHLB Program' WHEN BOOK IN ('BCDUT', 'AEOUT', 'UTCDS') THEN 'Other Liabilities' WHEN             CCC_PRODUCT_LINE = 'RELATIONSHIP LENDING' AND             BOOK IN ('BLNUT', 'BNYUT', 'HFIEB', 'HFINB', 'BNYUU')             THEN 'Relationship Hedges' WHEN (CCC_PRODUCT_LINE IN ('RELATIONSHIP LENDING')) THEN 'Relationship Loans' WHEN             CCC_PRODUCT_LINE IN ('CREL BANK HFI', 'CRE LENDING SEC/HFS', 'CRE LENDING') AND             (ACCOUNT NOT LIKE '083004%' AND              ACCOUNT <> '075006SH0')             THEN 'SPG CRE Loans' WHEN             CCC_PRODUCT_LINE IN ('CREL BANK HFI', 'CRE LENDING SEC/HFS', 'CRE LENDING') AND             (ACCOUNT LIKE '083004%' OR              ACCOUNT = '075006SH0')             THEN 'SPG CRE Hedges' WHEN CCC_PRODUCT_LINE = 'WAREHOUSE' THEN 'SPG Warehouse' WHEN CCC_PRODUCT_LINE = 'PRIMARY - LOANS'                  THEN 'Event Loans' WHEN             account IN ('L26USBAL0', '072006FH7', '07200C4H6', '072006FD6', '07200C4G8', 'LA5MSCIL1', '072006E54', '07200C4D5',                              'L70USBIC7') OR             book IN ('CRA INVESTMENT')             THEN 'NON BANK CRA' WHEN (CCC_PRODUCT_LINE IN ('CRA LOANS', 'CRA FUNDING', 'CMD STRUCTURED FINANCE',                                                                 'CORPORATE EQUITY PRODUCTS', 'CPM TRADING', 'NON CORE COMM RE (PTG)',                                                                 'MUNICIPAL SEC TRADING', 'XVA HEDGING', 'CPM EBS FUNDING',                                                                 'FXEM SPOT-FWD-RATES', 'LIQUIDITY', 'COMMOD LENDING', 'CRA INVESTMENTS'))                  THEN 'Other ISG Loans' WHEN BOOK IN ('ARBITRAGE', 'CSSW2', 'CSSWA', 'NYCW', 'NYDC', 'NYSB', 'PBGSPORT', 'RDTCC', 'RPOOG'                 ) THEN 'Non Bank Assets'             ELSE 'Other' END AS PRODUCT_GROUP_DETAIL,             (CASE WHEN A.CCC_TAPS_COMPANY = '1633' THEN 'MSBNA' WHEN A.CCC_TAPS_COMPANY = '6635' THEN 'MSPBNA' END) AS ASSET_TYPE,             a.PRODUCT_TYPE_NAME,             SUM (USD_NOTIONAL) AS USD_NOTIONAL,             SUM (USD_EXPOSURE) AS USD_EXPOSURE,             SUM (MV) AS MV,             SUM (USD_PV01) AS USD_PV01,             SUM (CASE WHEN (Product_Type_Code IN ('REPO') OR                             A.VERTICAL_SYSTEM LIKE '%SPG%' OR                             book IN ('TTSNY', 'TBSNY')) THEN USD_PV01 * - 100                  ELSE COALESCE (SLIDE_IR_MIN_100BP_USD,                                 USD_PV01 * - 100) END) AS SLIDE_IR_MIN_100BP_USD,             SUM (CASE WHEN (Product_Type_Code IN ('REPO') OR                             A.VERTICAL_SYSTEM LIKE '%SPG%' OR                             book IN ('TTSNY', 'TBSNY')) THEN USD_PV01 * 50                  ELSE COALESCE (SLIDE_IR_PLS_50BP_USD,                                 USD_PV01 * 50) END) AS SLIDE_IR_PLS_50BP_USD,             SUM (CASE WHEN (Product_Type_Code IN ('REPO') OR                             A.VERTICAL_SYSTEM LIKE '%SPG%' OR                             book IN ('TTSNY', 'TBSNY')) THEN USD_PV01 * 100                  ELSE COALESCE (SLIDE_IR_PLS_100BP_USD,                                 USD_PV01 * 100) END) AS SLIDE_IR_PLS_100BP_USD,             SUM (CASE WHEN (Product_Type_Code IN ('REPO') OR                             A.VERTICAL_SYSTEM LIKE '%SPG%' OR                             book IN ('TTSNY', 'TBSNY')) THEN USD_PV01 * 200                  ELSE COALESCE (SLIDE_IR_PLS_200BP_USD,                                 USD_PV01 * 200) END) AS SLIDE_IR_PLS_200BP_USD,             SUM (CASE WHEN (Product_Type_Code IN ('REPO') OR                             A.VERTICAL_SYSTEM LIKE '%SPG%' OR                             book IN ('TTSNY', 'TBSNY')) THEN USD_PV01 * 300                  ELSE COALESCE (SLIDE_IR_PLS_300BP_USD,                                 USD_PV01 * 300) END) AS SLIDE_IR_PLS_300BP_USD,             SUM (CASE WHEN (Product_Type_Code IN ('REPO') OR                             A.VERTICAL_SYSTEM LIKE '%SPG%' OR                             book IN ('TTSNY', 'TBSNY')) THEN USD_PV01 * 400                  ELSE COALESCE (SLIDE_IR_PLS_400BP_USD,                                 USD_PV01 * 400) END) AS SLIDE_IR_PLS_400BP_USD         FROM             (                 SELECT                     a.POSITION_ID,                     a.COB_DATE,                     a.ACCOUNT,                     a.CCC_PRODUCT_LINE,                     a.CCC_DIVISION,                     a.CCC_BUSINESS_AREA,                     a.VERTICAL_SYSTEM,                     a.BOOK,                     a.PRODUCT_TYPE_CODE,                     A.CCC_TAPS_COMPANY,                     a.PRODUCT_SUB_TYPE_CODE,                     a.CCC_HIERARCHY_LEVEL9,                     CCC_STRATEGY,                     a.PRODUCT_TYPE_NAME,                     a.CURRENCY_OF_MEASURE,                     SUM (COALESCE (USD_NOTIONAL,                                    0)) / 1000 AS USD_NOTIONAL,                     SUM (COALESCE (USD_EXPOSURE,                                    0)) / 1000 AS USD_EXPOSURE,                     SUM (COALESCE (a.USD_MARKET_VALUE,                                    0)) / 1000 AS MV,                     SUM (COALESCE (USD_IR_UNIFIED_PV01,                                    0)) AS USD_PV01,                     SUM (a.SLIDE_IR_PLS_100BP_USD) AS SLIDE_IR_PLS_100BP_USD,                     SUM (a.SLIDE_IR_PLS_200BP_USD) AS SLIDE_IR_PLS_200BP_USD,                     SUM (a.SLIDE_IR_PLS_300BP_USD) AS SLIDE_IR_PLS_300BP_USD,                     SUM (a.SLIDE_IR_PLS_50BP_USD) AS SLIDE_IR_PLS_50BP_USD,                     SUM (a.SLIDE_IR_MIN_100BP_USD) AS SLIDE_IR_MIN_100BP_USD,                     SUM (a.SLIDE_IR_MIN_200BP_USD) AS SLIDE_IR_MIN_200BP_USD,                     SUM (a.SLIDE_IR_MIN_300BP_USD) AS SLIDE_IR_MIN_300BP_USD,                     SUM (a.SLIDE_IR_PLS_400BP_USD) AS SLIDE_IR_PLS_400BP_USD                 FROM DWUSER.u_exp_msr a                 WHERE COB_DATE in ('2018-02-28', '2018-01-31')  AND                     A.CCC_TAPS_COMPANY IN ('1633', '6635') AND                     (A.VAR_EXCL_FL <> 'Y' OR                      A.BOOK IN ('MSDPB3M', 'MSDPT3M')) AND                     (A.ccc_banking_trading = 'BANKING' OR                      (A.CCC_HIERARCHY_LEVEL2 IN ('WEALTH MANAGEMENT', 'GLOBAL WEALTH MANAGEMENT') OR                       a.CCC_business_area = 'US BANKS-LIQUIDITY') AND                      A.PRODUCT_TYPE_CODE = 'REPO' AND                      A.CCC_BUSINESS_AREA NOT IN ('NON CORE MARKETS', 'CORE MARKETS'))                 GROUP BY                     a.POSITION_ID,                     a.COB_DATE,                     a.ACCOUNT,                     a.CCC_PRODUCT_LINE,                     a.CCC_DIVISION,                     a.CCC_BUSINESS_AREA,                     a.VERTICAL_SYSTEM,                     a.BOOK,                     a.PRODUCT_TYPE_CODE,                     a.PRODUCT_SUB_TYPE_CODE,                     a.CCC_HIERARCHY_LEVEL9,                     CCC_STRATEGY,                     a.PRODUCT_TYPE_NAME,                     a.CURRENCY_OF_MEASURE,                     A.CCC_TAPS_COMPANY             )             A         GROUP BY             a.COB_DATE,             a.CURRENCY_OF_MEASURE,             a.ACCOUNT,             a.CCC_PRODUCT_LINE,             a.CCC_DIVISION,             a.CCC_BUSINESS_AREA,             a.VERTICAL_SYSTEM,             a.BOOK,             a.PRODUCT_TYPE_NAME,             A.CCC_TAPS_COMPANY,             CCC_HIERARCHY_LEVEL9,             CCC_STRATEGY     )     AS B