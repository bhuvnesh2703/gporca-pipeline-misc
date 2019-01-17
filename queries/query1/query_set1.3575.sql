SELECT MAJOR_EM, CASE WHEN currency_combined in ('OMR','BHD','QAR','KWD','SAR','AED','BGN') THEN 'OTHER_PEGGED' ELSE currency_combined END AS CURRENCY_COMBINED, SUM(a.USD_FX) AS Delta FROM cdwuser.U_DM_FX a WHERE a.cob_date IN ('2018-02-28') AND CURRENCY_OF_MEASURE NOT IN ('USD','UBD') AND USD_FX<>0 AND IS_UK_GROUP = 'Y' AND CCC_DIVISION NOT IN ('FID DVA','FIC DVA') AND CCC_STRATEGY NOT IN ('MS DVA STR NOTES IED') GROUP BY MAJOR_EM, CASE WHEN currency_combined IN ('OMR','BHD','QAR','KWD','SAR','AED','BGN') THEN 'OTHER_PEGGED' ELSE currency_combined END