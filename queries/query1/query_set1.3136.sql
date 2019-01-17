SELECT f.COB_DATE, case when f.BOOK like '%JUMBO%' then 'FRM' when f.BOOK like '%YRARM%' then 'ARM' else '1mARM' end as Type, book, case when f.FACILITY_TYPE = 'RATELOCK' then 'rateLock' else 'long' end as FACILITY_TYPE, SUM (CASE WHEN f.COUPON > 0 THEN f.USD_NOTIONAL * f.COUPON / 1200 * (1 / (1 - POWER (1 + f.COUPON / 1200, - CASE WHEN f.BOOK LIKE '%15Y%' THEN 15 * 12 ELSE 30 * 12 END)) - 1) ELSE 0.0 END) ::numeric(15,5) AS Sched, CASE WHEN x.COB_DATE IS NULL THEN 'New' ELSE 'Old' END AS Status, '20' || substring(f.VINTAGE,1,2) as VINTAGE2, sum(COALESCE(f.usd_notional, 0)) ::numeric(15,5) as usd_notional FROM CDWUSER.U_OT_MSR f LEFT OUTER JOIN ( SELECT f.COB_DATE, extract(YEAR from f.COB_DATE) * 100 + extract(MONTH from f.COB_DATE) AS Curr_Month, f.TAPSCUSIP, f.Product_DESCRIPTION, sum(COALESCE(f.usd_notional, 0)) ::numeric(15,5) as usd_notional FROM CDWUSER.U_OT_MSR f WHERE f.cob_date in ( '2018-02-28', '2018-02-27', '2018-02-21', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31', '2017-09-29' ) AND f.CCC_DIVISION IN ('PRIVATE BANKING GROUP', 'RETAIL BANKING GROUP', 'PWM US BRANCH', 'HELD FOR INVESTMENT - (HFI)') AND ( f.CCC_STRATEGY IN ('HELD FOR INVESTMENT - (HFI)', 'MSPBNA - VH MORTGAGE') OR f.CCC_PRODUCT_LINE IN ('HELD FOR INVESTMENT - (HFI)')) AND f.PRODUCT_TYPE_CODE LIKE 'LOAN%' AND f.FACILITY_TYPE IN ('LONG') AND f.BOOK NOT LIKE '%ORIG%' and VAR_EXCL_FL<> 'Y' AND PARENT_LEGAL_ENTITY In ('6635(G)') GROUP BY f.COB_DATE, f.TAPSCUSIP, f.Product_DESCRIPTION ) x ON (extract(YEAR from(f.COB_DATE - interval '1 month'))* 100 + extract(MONTH from(f.COB_DATE - interval '1 month')), f.TAPSCUSIP, f.Product_DESCRIPTION) = (x.Curr_Month, x.TAPSCUSIP, x. Product_DESCRIPTION) WHERE f.cob_date in ( '2018-02-28', '2018-02-27', '2018-02-21', '2018-01-31', '2017-12-29', '2017-11-30', '2017-10-31', '2017-09-29' ) AND f.CCC_DIVISION IN ('PRIVATE BANKING GROUP', 'RETAIL BANKING GROUP', 'PWM US BRANCH', 'HELD FOR INVESTMENT - (HFI)') AND ( f.CCC_STRATEGY IN ('HELD FOR INVESTMENT - (HFI)', 'MSPBNA - VH MORTGAGE') OR f.CCC_PRODUCT_LINE IN ('HELD FOR INVESTMENT - (HFI)')) AND f.PRODUCT_TYPE_CODE LIKE 'LOAN%' AND f.BOOK NOT LIKE '%ORIG%' and VAR_EXCL_FL<> 'Y' AND PARENT_LEGAL_ENTITY In ('6635(G)') group by f.COB_DATE, f.BOOK, case when BOOK like '%JUMBO%' then 'FRM' when BOOK like '%YRARM%' then 'ARM' else '1mARM' end, f.FACILITY_TYPE, f.VINTAGE, f.COUPON, CASE WHEN x.COB_DATE IS NULL THEN 'New' ELSE 'Old' END