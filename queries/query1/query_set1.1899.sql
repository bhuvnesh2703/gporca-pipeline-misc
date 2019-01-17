SELECT a.COB_DATE, A.ACCOUNT, A.BOOK, A.CCC_TAPS_COMPANY, a.CCC_PRODUCT_LINE, A.CCC_STRATEGY, A.SECTYPE2, A.CCC_HIERARCHY_LEVEL0, A.POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME, a.POSITION_CHILD_ISSUER_PARTY_DARWIN_ID, CASE WHEN A.POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME IN ( 'THE HUNTINGTON INVESTMENT COMPANY', 'UNIVERSITY OPPORTUNITY FUND LLC', 'CORE INNOVATION CAPITAL I LP', 'CORE INNOVATION CAPITAL II, L.P.', 'AVANTE MEZZANINE PARTNERS SBIC II, LP', 'BRIDGES VENTURES U.S. SUSTAINABLE GROWTH FUND, L.P.', 'BRIGHTWOOD CAPITAL SBIC II, LP', 'EPIC VENTURE FUND IV LLC', 'LFE GROWTH FUND III, L.P.', 'PATRIOT CAPITAL TRUST I.', 'THE CENTRAL VALLEY FUND III (SBIC), LP', 'STONEHENGE CAPITAL CORPORATION', 'PELION VENTURES V FINANCIAL INSTITUTIONS FUND, LP', 'UTFC FUND II LLC', 'UV PARTNERS IV FINANCIAL INSTITUTIONS FUND LP', 'TECUM CAPITAL PARTNERS II, L.P.', 'SMALL BUSINESS COMMUNITY CAPITAL II, L.P.', 'WASATCH VENTURE FUND II LLC', 'SEACOAST CAPITAL PARTNERS IV, L.P.', 'RESIDENTIAL HEALTHCARE HOLDINGS, LLC', 'PATRIOT CAPITAL IV (A), L.P.', '"UNIVERSITY OPPORTUNITY FUND, LLC"', 'WASATCH VENTURE FUND II', 'HCAP PARTNERS III, L.P.') or a.CCC_TAPS_COMPANY in ('7637') THEN 'SBIC' WHEN A.POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME IN ('THE COMMUNITY DEVELOPMENT TRUST, LP', 'THE COMMUNITY DEVELOPMENT TRUST, INC.', 'HOUSING PARTNERSHIP EQUITY TRUST REIT I, LLC') THEN 'AHREIT' WHEN A.POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME IN ( 'NEF PRESERVATION FUND I LP', 'NEF PRESERVATION MORTGAGE LOAN FUND I LP', 'NEF PRESERVATION FUND II LP', 'NYC DISTRESSED MULTIFAMILY HOUSING FUND II LP', 'NEF FRIENDSHIP VILLAGE FUND LLC', 'NYC DISTRESSED MULTIFAMILY HOUSING FUND I LP') THEN 'AHREALESTATE' WHEN (A.CCC_TAPS_COMPANY IN ('5036', '4945') or a.book in ('BKTCB')) THEN 'TAXEQUITY' ELSE 'OTHER' END AS PRODUCT_TYPE, SUM (CAST(A.USD_PV01SPRD as numeric(15,5))) AS SPRD_PV01, SUM (CAST(A.USD_IR_UNIFIED_PV01 as numeric(15,5))) AS PV01, SUM (COALESCE (CAST(A.USD_NOTIONAL as numeric(15,5)), 0)) AS usd_notional, SUM (COALESCE (CAST(A.USD_MARKET_VALUE as numeric(15,5)), 0)) AS usd_market_value, SUM (CAST(A.USD_DELTA as numeric(15,5))) AS EQUITY_DELTA, SUM (COALESCE (CAST(USD_IR_UNIFIED_PV01 as numeric(15,5)), 0)) AS USD_PV01, SUM (COALESCE (CAST(a.USD_EXPOSURE as numeric(15,5)), 0)) AS usd_net_expousre, SUM (COALESCE (CAST(a.USD_UNFUNDED_COMMIT as numeric(15,5)), 0)) AS USD_UNFUNDED_COMMIT, SUM (COALESCE (CAST(a.USD_FUNDED_COMMIT as numeric(15,5)), 0)) AS USD_FUNDED_COMMIT, SUM (COALESCE (CAST(a.USD_COMMITTMENT as numeric(15,5)), 0)) AS USD_COMMIt FROM cdwuser.u_EXP_msr a WHERE A.COB_DATE IN ( '2018-02-28', '2018-02-27', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31', '2017-09-29', '2017-08-31' ) AND (a.book LIKE ('%CRA%') OR a.CCC_STRATEGY LIKE ('%CRA%')) AND BOOK IN ('BKGSP', 'BKCRA','BKBIC', 'BKTCB') GROUP BY a.COB_DATE, A.ACCOUNT, A.BOOK, A.CCC_TAPS_COMPANY, a.CCC_PRODUCT_LINE, A.CCC_STRATEGY, A.SECTYPE2, A.CCC_HIERARCHY_LEVEL0, A.POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME, a.POSITION_CHILD_ISSUER_PARTY_DARWIN_ID, CASE WHEN A.POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME IN ( 'THE HUNTINGTON INVESTMENT COMPANY', 'UNIVERSITY OPPORTUNITY FUND LLC', 'CORE INNOVATION CAPITAL I LP', 'CORE INNOVATION CAPITAL II, L.P.', 'AVANTE MEZZANINE PARTNERS SBIC II, LP', 'BRIDGES VENTURES U.S. SUSTAINABLE GROWTH FUND, L.P.', 'BRIGHTWOOD CAPITAL SBIC II, LP', 'EPIC VENTURE FUND IV LLC', 'LFE GROWTH FUND III, L.P.', 'PATRIOT CAPITAL TRUST I.', 'THE CENTRAL VALLEY FUND III (SBIC), LP', 'STONEHENGE CAPITAL CORPORATION', 'PELION VENTURES V FINANCIAL INSTITUTIONS FUND, LP', 'UTFC FUND II LLC', 'UV PARTNERS IV FINANCIAL INSTITUTIONS FUND LP', 'TECUM CAPITAL PARTNERS II, L.P.', 'SMALL BUSINESS COMMUNITY CAPITAL II, L.P.', 'WASATCH VENTURE FUND II LLC', 'SEACOAST CAPITAL PARTNERS IV, L.P.', 'RESIDENTIAL HEALTHCARE HOLDINGS, LLC', 'PATRIOT CAPITAL IV (A), L.P.', '"UNIVERSITY OPPORTUNITY FUND, LLC"', 'WASATCH VENTURE FUND II', 'HCAP PARTNERS III, L.P.') or a.CCC_TAPS_COMPANY in ('7637') THEN 'SBIC' WHEN A.POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME IN ('THE COMMUNITY DEVELOPMENT TRUST, LP', 'THE COMMUNITY DEVELOPMENT TRUST, INC.', 'HOUSING PARTNERSHIP EQUITY TRUST REIT I, LLC') THEN 'AHREIT' WHEN A.POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME IN ( 'NEF PRESERVATION FUND I LP', 'NEF PRESERVATION MORTGAGE LOAN FUND I LP', 'NEF PRESERVATION FUND II LP', 'NYC DISTRESSED MULTIFAMILY HOUSING FUND II LP', 'NEF FRIENDSHIP VILLAGE FUND LLC', 'NYC DISTRESSED MULTIFAMILY HOUSING FUND I LP') THEN 'AHREALESTATE' WHEN (A.CCC_TAPS_COMPANY IN ('5036', '4945') or a.book in ('BKTCB')) THEN 'TAXEQUITY' ELSE 'OTHER' END