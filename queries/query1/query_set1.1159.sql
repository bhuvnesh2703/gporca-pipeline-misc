SELECT a.COB_DATE, a.CCC_DIVISION, a.CCC_PL_REPORTING_REGION, a.financial_element, sum(a.ytd_PL) as pnl FROM CDWUSER.U_PCT_PNL_CURRENT a WHERE a.COB_DATE > '2017-02-28' AND a.COB_DATE <= '2018-02-28' and (a.CCC_DIVISION='FID DVA' OR a.CCC_DIVISION='FIC DVA' OR A.CCC_STRATEGY='MS DVA STR NOTES IED') group by a.COB_DATE, a.CCC_DIVISION, a.CCC_PL_REPORTING_REGION, a.financial_element