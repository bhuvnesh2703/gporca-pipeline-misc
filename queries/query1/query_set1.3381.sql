select a.COB_DATE, book, a.PRODUCT_DESCRIPTION, A.PRODUCT_TYPE_CODE, a.CCC_GL_COMPANY_CODE, sum(a.USD_NOTIONAL::numeric(15,5)) as notional from cdwuser.U_DM_TREASURY a where a.COB_DATE in ( '2018-02-28', '2018-02-21', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31', '2017-09-29', '2017-08-31' ) and a.book in ('TAPOZ') AND A.CCC_GL_COMPANY_CODE IN ('7713', '7714', '7715', '0870', '0876') GROUP BY a.COB_DATE, book, a.PRODUCT_DESCRIPTION, a.CCC_GL_COMPANY_CODE, A.PRODUCT_TYPE_CODE