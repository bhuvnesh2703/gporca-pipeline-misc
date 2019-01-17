WITH
    IED AS (SELECT 
                COB_DATE,
                PROCESS_ID,
                POSITION_ID,

    SUM (CASE WHEN scenario_name ='S-40%SD' THEN POS_TV_MINUS_BASE END) AS D40VSD, 
    SUM (CASE WHEN scenario_name = 'S-30%/V+.05' THEN POS_TV_MINUS_BASE END) AS D30V05, 
    SUM (CASE WHEN scenario_name = 'S-20%/V+.05' THEN POS_TV_MINUS_BASE END) AS D20V05,
    SUM (CASE WHEN scenario_name = 'S-10%/V+.05' THEN POS_TV_MINUS_BASE END) AS D10V05,
    SUM (CASE WHEN scenario_name = 'S-5%/V+.05' THEN POS_TV_MINUS_BASE END) AS D5V05
            FROM cdwuser.U_IED_SURFACE
            WHERE 
               COB_DATE in ('2018-02-28','2018-02-21')
            GROUP BY
                PROCESS_ID,
                POSITION_ID,
                COB_DATE),
    /*Aggregate the weights on country issuer level*/
    CountryWeights AS (SELECT
                           d.COB_DATE,
                           PROCESS_ID,
                           POSITION_ID,
                           ISSUER_COUNTRY_CODE_DECOMP AS COUNTRY,
                           CASE WHEN FID1_INDUSTRY_NAME_LEVEL2 IN ('CONSUMER DISCRETIONARY') THEN 'CONSUMER DISCRETIONARY' WHEN 
                               FID1_INDUSTRY_NAME_LEVEL2 IN ('CONSUMER STAPLES') THEN 'CONSUMER STAPLES' WHEN FID1_INDUSTRY_NAME_LEVEL2 
                               IN ('ENERGY') THEN 'ENERGY' WHEN FID1_INDUSTRY_NAME_LEVEL2 IN ('FINANCIALS') THEN 'FINANCIALS' WHEN 
                               FID1_INDUSTRY_NAME_LEVEL2 IN ('HEALTH CARE') THEN 'HEALTH CARE' WHEN FID1_INDUSTRY_NAME_LEVEL2 IN ('INDUSTRIALS') 
                               THEN 'INDUSTRIALS' WHEN FID1_INDUSTRY_NAME_LEVEL2 IN ('INFORMATION TECHNOLOGY') THEN 
                               'INFORMATION TECHNOLOGY' WHEN FID1_INDUSTRY_NAME_LEVEL2 IN ('MATERIALS') THEN 'MATERIALS' WHEN 
                               FID1_INDUSTRY_NAME_LEVEL2 IN ('TELECOMMUNICATION SERVICES') THEN 'TELECOMMUNICATION SERVICES' WHEN 
                               FID1_INDUSTRY_NAME_LEVEL2 IN ('UTILITIES') THEN 'UTILITIES'
                           ELSE 'OTHERS' END AS INDUSTRY,
                           ABS (SUM (PRODUCT_WEIGHT_DECOMP)) AS WEIGHT
                       FROM cdwuser.U_DECOMP_MSR d
                       WHERE
               COB_DATE in ('2018-02-28','2018-02-21')
                           
                           AND LE_GROUP = 'UK'
                           
                           AND DIVISION = 'IED' 
                           AND d.CCC_BANKING_TRADING <> 'BANKING'
                       GROUP BY
                           d.COB_DATE,
                           PROCESS_ID,
                           POSITION_ID,
                           ISSUER_COUNTRY_CODE_DECOMP,
                           CASE WHEN FID1_INDUSTRY_NAME_LEVEL2 IN ('CONSUMER DISCRETIONARY') THEN 'CONSUMER DISCRETIONARY' WHEN 
                               FID1_INDUSTRY_NAME_LEVEL2 IN ('CONSUMER STAPLES') THEN 'CONSUMER STAPLES' WHEN FID1_INDUSTRY_NAME_LEVEL2 
                               IN ('ENERGY') THEN 'ENERGY' WHEN FID1_INDUSTRY_NAME_LEVEL2 IN ('FINANCIALS') THEN 'FINANCIALS' WHEN 
                               FID1_INDUSTRY_NAME_LEVEL2 IN ('HEALTH CARE') THEN 'HEALTH CARE' WHEN FID1_INDUSTRY_NAME_LEVEL2 IN ('INDUSTRIALS') 
                               THEN 'INDUSTRIALS' WHEN FID1_INDUSTRY_NAME_LEVEL2 IN ('INFORMATION TECHNOLOGY') THEN 
                               'INFORMATION TECHNOLOGY' WHEN FID1_INDUSTRY_NAME_LEVEL2 IN ('MATERIALS') THEN 'MATERIALS' WHEN 
                               FID1_INDUSTRY_NAME_LEVEL2 IN ('TELECOMMUNICATION SERVICES') THEN 'TELECOMMUNICATION SERVICES' WHEN 
                               FID1_INDUSTRY_NAME_LEVEL2 IN ('UTILITIES') THEN 'UTILITIES'
                           ELSE 'OTHERS' END
                       HAVING SUM (PRODUCT_WEIGHT_DECOMP) <> 0),
    /*Total weights*/
    GrossWeights AS (SELECT
                         x.COB_DATE,
                         PROCESS_ID,
                         POSITION_ID,
                         SUM (ABS (WEIGHT)) AS GROSS_WEIGHT
                     FROM CountryWeights x
                     GROUP BY
                         x.COB_DATE,
                         PROCESS_ID,
                         POSITION_ID),
    /*Calculated weights on issuer country code level*/
    Decomp AS (SELECT
                   w.COB_DATE,
                   w.Process_ID,
                   w.Position_id,
                   COUNTRY,
                   INDUSTRY,
                   ABS (WEIGHT / GROSS_WEIGHT) AS WEIGHT
               FROM
                   CountryWeights w
                   INNER JOIN
                   GrossWeights g
                   ON (w.cob_date = g.cob_date AND
                       w.process_id = g.process_id AND
                       w.position_id = g.position_id))
/*Final query with country categorization and join to modular data via rowid, using the calculated weights to split scenario PnL results*/
SELECT
    COB_DATE,
    COUNTRY,
    INDUSTRY,

    SUM (D40VSD) AS D40VSD,
    SUM (D30V05) AS D30V05,
    SUM (D20V05) AS D20V05,
    SUM (D10V05) AS D10V05,
    SUM (D5V05) AS D5V05
FROM
    (
        SELECT
            i.COB_DATE,
            COUNTRY,
            INDUSTRY,

    (D40VSD * WEIGHT) AS D40VSD,
    (D30V05 * WEIGHT) AS D30V05,
    (D20V05 * WEIGHT) AS D20V05,
    (D10V05 * WEIGHT) AS D10V05,
    (D5V05 * WEIGHT) AS D5V05
        FROM
            IED i
            INNER JOIN
            Decomp d
            ON
                i.PROCESS_ID = d.PROCESS_ID AND
                i.POSITION_ID = d.POSITION_ID AND
                i.COB_DATE = d.COB_DATE
  WHERE (COUNTRY in ('CHN','HKG') 
    ))
    M
GROUP BY
    COUNTRY,
    INDUSTRY,
    COB_DATE