SELECT
    A.COB_DATE,
    SUM (a.USD_NET_EXPOSURE) AS netexp
FROM cdwuser.U_DM_CC A
WHERE
    a.COB_DATE IN (
'2018-01-24', 
'2018-01-31', 
'2018-02-07', 
'2018-02-14', 
'2018-02-21', 
'2018-02-27', 
'2018-02-28'
) AND
    A.PARENT_LEGAL_ENTITY IN ('0302(S)', '0342', '0517(G)', '0302(G)', '0517(S)', '0621(S)') AND 

    A.CCC_BUSINESS_AREA = 'CREDIT-CORPORATES' AND
    A.CREDIT_TRADING_FLAG = 'Junior Subs'
GROUP BY
    A.COB_DATE