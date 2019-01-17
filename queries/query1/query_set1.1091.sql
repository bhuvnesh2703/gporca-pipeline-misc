SELECT * FROM     (         SELECT             a.COB_DATE,             CASE WHEN COALESCE (a.CURVE_TYPE,                                 '') = 'CPCRMNE' THEN 'MS CVA' WHEN COALESCE (a.CURVE_TYPE,                                                                              '') = 'MS_SECCPM' THEN 'MS FVA' WHEN COALESCE (a.CURVE_TYPE                                                                                                                                 ,                                                                                                                             '') IN (                                                                                                                                         'CPCRFUND'                 , 'CPCR_MPEFUND') THEN 'CTP FVA' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('MPE', 'MPE_CVA', 'MNE', 'MNE_CVA', 'MNE_CP',                                                                                        'MPE_PROXY', 'MPE_FVA_PROXY', 'MPE_FVA',                                                                                        'MPE_FVA_RAW', 'MNE_FVA_NET', 'MNE_FVA') THEN                  'CTP CVA'             ELSE 'HEDGE' END AS CVA_Type_Flag,             CASE WHEN a.COUNTERPARTY_ACCOUNT IN ('85071', '84611', '94925', '93836', '90565', '326497', '84640', '84914', '84976',                                                       '90010', '94010', '91310', '90254', '435380', '138472', '647581', '86903', '94489',                                                       '92869', '87478', '287554', '90730', '294825', '89520', '89654', '86121', '90520',                                                       '443005', '89667', '383409', '84872', '92215', '84852', '94531', '84528', '86219',                                                       '92694', '87490', '91768', '90226', '92780', '87141', '476804', '86234', '250072',                                                       '84084', '84809', '94319', '94397', '89661', '93024', '84980', '85075', '84916',                                                       '85689', '93102', '92627', '86314', '87178', '475293', '89665', '84526', '94105',                                                       '90749', '84373', '318822', '93026', '300382', '90009', '90480', '94395', '91288',                                                       '94658', '360742', '329171', '89543', '87387', '94116', '167746', '90093', '399759'                 , '92779', '94068', '87205', '95048', '85036', '90131', '635345', '85305', '321017', '90779', '89718', '328570',                                                       '377148', '482116', '91094', '251968', '95064', '299062', '456281', '87483',                                                       '87319', '92500', '94370', '85239', '395995', '91318', '93144', '91982', '86246',                                                       '359343', '91913', '87360', '94985', '461914', '91652', '90753', '295552', '89684',                                                       '94061', '90013', '86600', '87318', '86206', '90960', '316886', '95671', '352812',                                                       '92017', '89323', '87633', '91983', '348370', '324397', '306844', '377726', '89674'                 , '86092', '83925', '95728', '86006', '355677', '306605', '326047', '306606', '93966', '87359', '92383', '90794',                                                       '94396', '87541', '92509', '94921', '90920', '84643', '84911', '91600', '86004',                                                       '92138', '93100', '86082', '87537', '436334', '92937', '89717', '94726', '85112',                                                       '91540', '85009', '91319', '90377', '89669', '87529', '87150', '91772', '92126',                                                       '318831', '92123', '343669', '87464', '328569', '92448', '167208', '437069',                                                       '336982', '90760', '94798', '91912', '94106', '87500', '85115', '356143', '436335',                                                       '435885', '249411', '306406', '321016', '438599', '352561', '89663', '401366',                                                       '250277', '439966', '435381', '87358', '85301', '93989', '436806', '92416',                                                       '231081', '435382', '84874', '91174', '93682', '90129', '93208', '87251', '91315',                                                       '404621', '91309', '87307', '87373', '318152', '676118', '84088', '461474',                                                       '443565', '167749', '91984', '446892', '85303', '423540', '437068', '90246',                                                       '92928', '359673', '397988', '91316', '593133', '357966', '84688', '327342',                                                       '89670', '92140', '89650', '401367', '87357', '95019', '86789', '405393', '87410',                                                       '374535', '86191', '405404', '406194', '405413', '478776', '83829', '436481',                                                       '405441', '405858', '405390', '405391', '435503', '89262', '89516', '306834',                                                       '94038', '84499', '402244', '93162', '86845', '92071', '87393', '92848', '571245',                                                       '94297', '90225', '93268', '85219', '86959', '405386', '406196', '91452', '576079',                                                       '295497', '94200', '705323', '578407', '448487', '90032', '92831') THEN 'MUNI' WHEN             a.COUNTERPARTY_ACCOUNT IN ('0617taki7', '709414', '90063', '1040178', '92305', '481274', '1274690', '541669', '87351',                                             '359333', '91095', '595465', '93744', '452896', '709414', '90063') OR             a.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME IN ('ASTER SECURITIES (US) LP', 'BRITISH BROADCASTING CORPORATION',                                                              'EQUITY RELEASE FUNDING (NO. 1) PLC', 'EQUITY RELEASE FUNDING (NO. 4) PLC',                                                              'EQUITY RELEASE FUNDING (NO. 5) PLC', 'HEATHROW (SP) LIMITED',                                                              'J SAINSBURY PLC', 'KEMBLE WATER STRUCTURE LIMITED', 'LONGSTONE FINANCE PLC'                 , 'NORTH WEST ELECTRICITY NETWORKS LIMITED', 'OSPREY ACQUISITIONS LIMITED', 'WALES & WEST UTILITIES LIMITED',                                                              'YORKSHIRE WATER SERVICES LIMITED')             THEN 'INFLATION' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE '%SOVEREIGNS%' THEN 'SOV' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE                  '%FINANCIAL%' THEN 'FINANCIAL' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE '%ENERGY%' THEN 'ENERGY' WHEN a.                 FID1_INDUSTRY_NAME_LEVEL2 LIKE '%UTILITIES%' THEN 'UTILITIES' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE                  '%CONSUMER DISCRETIONARY%' THEN 'CONSUMER DISCRETIONARY' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE '%CONSUMER STAPLES%' THEN                  'CONSUMER STAPLES' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE '%HEALTH CARE%' THEN 'HEALTH CARE' WHEN a.                 FID1_INDUSTRY_NAME_LEVEL2 LIKE '%INDUSTRIALS%' THEN 'INDUSTRIALS' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE                  '%INFORMATION TECHNOLOGY%' THEN 'INFORMATION TECHNOLOGY' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE '%MATERIALS%' THEN                  'MATERIALS' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE '%REAL ESTATE%' THEN 'REAL ESTATE' WHEN a.FID1_INDUSTRY_NAME_LEVEL2                  LIKE '%TELECOMMUNICATION SERVICES%' THEN 'TELECOMMUNICATION SERVICES'             ELSE 'OTHER' END AS BUCKET,             SUM (a.USD_PV10_BENCH / 1000) AS PV10         FROM cdwuser.U_CR_MSR a         WHERE a.COB_DATE IN ('2018-02-28', '2018-01-31', '2017-12-29', '2017-11-30') and CCC_PL_REPORTING_REGION in ('EMEA') AND              (a.CCC_BUSINESS_AREA IN ('CPM', 'COMMODS FINANCING', 'CPM TRADING (MPE)', 'CREDIT', 'MS CVA MNE - FID',                                           'MS CVA MNE - COMMOD') OR              a.CCC_STRATEGY IN ('MS CVA MPE - DERIVATIVES', 'MS CVA MNE - DERIVATIVES','EQ XVA HEDGING')) AND             a.USD_PV10_BENCH IS NOT NULL AND             a.ccc_product_line NOT IN ('CREDIT LOAN PORTFOLIO', 'CMD STRUCTURED FINANCE') AND             A.CURVE_TYPE NOT IN ('CPCR_CLEAR')         GROUP BY             a.COB_DATE,             A.FID1_INDUSTRY_NAME_LEVEL2,             CASE WHEN COALESCE (a.CURVE_TYPE,                                 '') = 'CPCRMNE' THEN 'MS CVA' WHEN COALESCE (a.CURVE_TYPE,                                                                              '') = 'MS_SECCPM' THEN 'MS FVA' WHEN COALESCE (a.CURVE_TYPE                                                                                                                                 ,                                                                                                                             '') IN (                                                                                                                                         'CPCRFUND'                 , 'CPCR_MPEFUND') THEN 'CTP FVA' WHEN a.PRODUCT_SUB_TYPE_CODE IN ('MPE', 'MPE_CVA', 'MNE', 'MNE_CVA', 'MNE_CP',                                                                                        'MPE_PROXY', 'MPE_FVA_PROXY', 'MPE_FVA',                                                                                        'MPE_FVA_RAW', 'MNE_FVA_NET', 'MNE_FVA') THEN                  'CTP CVA'             ELSE 'HEDGE' END,             CASE WHEN a.COUNTERPARTY_ACCOUNT IN ('85071', '84611', '94925', '93836', '90565', '326497', '84640', '84914', '84976',                                                       '90010', '94010', '91310', '90254', '435380', '138472', '647581', '86903', '94489',                                                       '92869', '87478', '287554', '90730', '294825', '89520', '89654', '86121', '90520',                                                       '443005', '89667', '383409', '84872', '92215', '84852', '94531', '84528', '86219',                                                       '92694', '87490', '91768', '90226', '92780', '87141', '476804', '86234', '250072',                                                       '84084', '84809', '94319', '94397', '89661', '93024', '84980', '85075', '84916',                                                       '85689', '93102', '92627', '86314', '87178', '475293', '89665', '84526', '94105',                                                       '90749', '84373', '318822', '93026', '300382', '90009', '90480', '94395', '91288',                                                       '94658', '360742', '329171', '89543', '87387', '94116', '167746', '90093', '399759'                 , '92779', '94068', '87205', '95048', '85036', '90131', '635345', '85305', '321017', '90779', '89718', '328570',                                                       '377148', '482116', '91094', '251968', '95064', '299062', '456281', '87483',                                                       '87319', '92500', '94370', '85239', '395995', '91318', '93144', '91982', '86246',                                                       '359343', '91913', '87360', '94985', '461914', '91652', '90753', '295552', '89684',                                                       '94061', '90013', '86600', '87318', '86206', '90960', '316886', '95671', '352812',                                                       '92017', '89323', '87633', '91983', '348370', '324397', '306844', '377726', '89674'                 , '86092', '83925', '95728', '86006', '355677', '306605', '326047', '306606', '93966', '87359', '92383', '90794',                                                       '94396', '87541', '92509', '94921', '90920', '84643', '84911', '91600', '86004',                                                       '92138', '93100', '86082', '87537', '436334', '92937', '89717', '94726', '85112',                                                       '91540', '85009', '91319', '90377', '89669', '87529', '87150', '91772', '92126',                                                       '318831', '92123', '343669', '87464', '328569', '92448', '167208', '437069',                                                       '336982', '90760', '94798', '91912', '94106', '87500', '85115', '356143', '436335',                                                       '435885', '249411', '306406', '321016', '438599', '352561', '89663', '401366',                                                       '250277', '439966', '435381', '87358', '85301', '93989', '436806', '92416',                                                       '231081', '435382', '84874', '91174', '93682', '90129', '93208', '87251', '91315',                                                       '404621', '91309', '87307', '87373', '318152', '676118', '84088', '461474',                                                       '443565', '167749', '91984', '446892', '85303', '423540', '437068', '90246',                                                       '92928', '359673', '397988', '91316', '593133', '357966', '84688', '327342',                                                       '89670', '92140', '89650', '401367', '87357', '95019', '86789', '405393', '87410',                                                       '374535', '86191', '405404', '406194', '405413', '478776', '83829', '436481',                                                       '405441', '405858', '405390', '405391', '435503', '89262', '89516', '306834',                                                       '94038', '84499', '402244', '93162', '86845', '92071', '87393', '92848', '571245',                                                       '94297', '90225', '93268', '85219', '86959', '405386', '406196', '91452', '576079',                                                       '295497', '94200', '705323', '578407', '448487', '90032', '92831') THEN 'MUNI' WHEN             a.COUNTERPARTY_ACCOUNT IN ('0617taki7', '709414', '90063', '1040178', '92305', '481274', '1274690', '541669', '87351',                                             '359333', '91095', '595465', '93744', '452896', '709414', '90063') OR             a.POSITION_ULT_ISSUER_PARTY_DARWIN_NAME IN ('ASTER SECURITIES (US) LP', 'BRITISH BROADCASTING CORPORATION',                                                              'EQUITY RELEASE FUNDING (NO. 1) PLC', 'EQUITY RELEASE FUNDING (NO. 4) PLC',                                                              'EQUITY RELEASE FUNDING (NO. 5) PLC', 'HEATHROW (SP) LIMITED',                                                              'J SAINSBURY PLC', 'KEMBLE WATER STRUCTURE LIMITED', 'LONGSTONE FINANCE PLC'                 , 'NORTH WEST ELECTRICITY NETWORKS LIMITED', 'OSPREY ACQUISITIONS LIMITED', 'WALES & WEST UTILITIES LIMITED',                                                              'YORKSHIRE WATER SERVICES LIMITED')             THEN 'INFLATION' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE '%SOVEREIGNS%' THEN 'SOV' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE                  '%FINANCIAL%' THEN 'FINANCIAL' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE '%ENERGY%' THEN 'ENERGY' WHEN a.                 FID1_INDUSTRY_NAME_LEVEL2 LIKE '%UTILITIES%' THEN 'UTILITIES' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE                  '%CONSUMER DISCRETIONARY%' THEN 'CONSUMER DISCRETIONARY' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE '%CONSUMER STAPLES%' THEN                  'CONSUMER STAPLES' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE '%HEALTH CARE%' THEN 'HEALTH CARE' WHEN a.                 FID1_INDUSTRY_NAME_LEVEL2 LIKE '%INDUSTRIALS%' THEN 'INDUSTRIALS' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE                  '%INFORMATION TECHNOLOGY%' THEN 'INFORMATION TECHNOLOGY' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE '%MATERIALS%' THEN                  'MATERIALS' WHEN a.FID1_INDUSTRY_NAME_LEVEL2 LIKE '%REAL ESTATE%' THEN 'REAL ESTATE' WHEN a.FID1_INDUSTRY_NAME_LEVEL2                  LIKE '%TELECOMMUNICATION SERVICES%' THEN 'TELECOMMUNICATION SERVICES'             ELSE 'OTHER' END     )     B WHERE b.CVA_Type_Flag IN ('CTP FVA', 'CTP CVA', 'HEDGE')