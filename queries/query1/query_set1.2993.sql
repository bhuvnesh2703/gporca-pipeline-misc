SELECT NE.COB_DATE, NE.POSITION_ISSUER_PARTY_DARWIN_NAME, NE.BOOK, NE.INSURER_RATING, NOTIONAL.PRE_USD_EXPOSURE, NOTIONAL.PRE_USD_NOTIONAL, NE.CUR_USD_EXPOSURE, NE.CUR_USD_NOTIONAL FROM ( SELECT a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME, a.BOOK, a.INSURER_RATING, SUM ((a.USD_EXPOSURE) :: numeric(15,5)) AS CUR_USD_EXPOSURE, SUM ((a.USD_NOTIONAL) :: numeric(15,5)) AS CUR_USD_NOTIONAL FROM cdwuser.U_DM_WM a WHERE a.COB_DATE IN ( '2018-02-28' ) AND a.CCC_PRODUCT_LINE IN ('CRE LENDING', 'CREL BANK HFI', 'CRE LENDING SEC/HFS') AND a.SPG_DESC IN ('CMBS LOAN', 'CMBS LOAN IO', 'CMBS MEZZANINE LOAN') AND a.CCC_TAPS_COMPANY = '1633' AND a.BOOK NOT IN ('CRE_LENDING_EU_HFI', 'CRE_LENDING_HFI') GROUP BY a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME, a.BOOK, a.INSURER_RATING ) NE LEFT JOIN ( SELECT a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME, SUM ((a.USD_EXPOSURE) :: numeric(15,5)) AS PRE_USD_EXPOSURE, SUM ((a.USD_NOTIONAL) :: numeric(15,5)) AS PRE_USD_NOTIONAL FROM cdwuser.U_DM_WM a WHERE a.COB_DATE IN ( '2018-02-27' ) AND a.CCC_PRODUCT_LINE IN ('CRE LENDING', 'CREL BANK HFI', 'CRE LENDING SEC/HFS') AND a.SPG_DESC IN ('CMBS LOAN', 'CMBS LOAN IO', 'CMBS MEZZANINE LOAN') AND a.CCC_TAPS_COMPANY = '1633' AND a.BOOK NOT IN ('CRE_LENDING_EU_HFI', 'CRE_LENDING_HFI') GROUP BY a.COB_DATE, a.POSITION_ISSUER_PARTY_DARWIN_NAME, a.BOOK, a.INSURER_RATING ) notional ON NE.POSITION_ISSUER_PARTY_DARWIN_NAME = notional.POSITION_ISSUER_PARTY_DARWIN_NAME ORDER BY NE.CUR_USD_EXPOSURE DESC FETCH FIRST 20 ROWS ONLY