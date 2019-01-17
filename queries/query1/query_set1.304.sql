With x as ( 
Select COB_DATE, 
Case When CCC_STRATEGY in ('NON CORE WORKOUT') Then 'PROP WORKOUT' 
When CCC_PRODUCT_LINE = 'GLOBAL STRUCT PRODUCTS' Then 'GLOBAL STRUCT PRODUCTS' 
When CCC_PRODUCT_LINE = 'MSPI INVESTING' Then 'MSPI INVESTING' 
When CCC_PRODUCT_LINE = 'PROP WORKOUT' Then 'PROP WORKOUT' 
Else CCC_BUSINESS_AREA end as CCC_BUSINESS_AREA, 
Case When FEED_SOURCE_NAME = 'ER1' THEN PRODUCT_DESCRIPTION ELSE POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME END as CHILD_ISSUER , GICS_LEVEL_1_NAME 
, sum(case when a.PRODUCT_TYPE_CODE in ('ADR','STOCK','SWAP','WARRNT','ETF','OPTION','FUTURE') then Coalesce(USD_DELTA,0) else Coalesce(USD_EXPOSURE,0) end)/1000 as INVENTORY 
from cdwuser.U_EXP_MSR a 
where COB_DATE in ('2018-02-28','2018-02-27') 
and (CCC_BUSINESS_AREA in ('GLOBAL STRUCT PRODUCTS','MSPI INVESTING','PROP WORKOUT') 
or (CCC_BUSINESS_AREA = 'NON CORE' and CCC_PRODUCT_LINE in ('GLOBAL STRUCT PRODUCTS','MSPI INVESTING','PROP WORKOUT'))) 
Group by COB_DATE, 
Case When CCC_STRATEGY in ('NON CORE WORKOUT') Then 'PROP WORKOUT' 
When CCC_PRODUCT_LINE = 'GLOBAL STRUCT PRODUCTS' Then 'GLOBAL STRUCT PRODUCTS' 
When CCC_PRODUCT_LINE = 'MSPI INVESTING' Then 'MSPI INVESTING' 
When CCC_PRODUCT_LINE = 'PROP WORKOUT' Then 'PROP WORKOUT' 
Else CCC_BUSINESS_AREA end, 
Case When FEED_SOURCE_NAME = 'ER1' THEN PRODUCT_DESCRIPTION ELSE POSITION_CHILD_ISSUER_PARTY_DARWIN_NAME END, GICS_LEVEL_1_NAME) 
, Industry as (Select distinct CCC_BUSINESS_AREA, CHILD_ISSUER, GICS_LEVEL_1_NAME 
from (Select CCC_BUSINESS_AREA, CHILD_ISSUER, GICS_LEVEL_1_NAME 
, Rank() Over (Partition by CCC_BUSINESS_AREA, CHILD_ISSUER order By Abs(sum(INVENTORY)) DESC) as SECTOR_RANK 
, sum(INVENTORY) as INVENTORY 
from x 
where COB_DATE = '2018-02-28' 
group by CCC_BUSINESS_AREA, CHILD_ISSUER, GICS_LEVEL_1_NAME) sub_qry 
 Where SECTOR_RANK = 1) 
Select Rank() Over 
(Partition by x.CCC_BUSINESS_AREA Order by Abs(Sum(Case When COB_DATE = '2018-02-28' THEN INVENTORY Else 0 END)) DESC)||'_'||x.CCC_BUSINESS_AREA as RANK_BUSINESS 
, x.CHILD_ISSUER, b.GICS_LEVEL_1_NAME 
, Sum(Case When COB_DATE = '2018-02-28' THEN INVENTORY Else 0 END) as INVENTORY_COB 
, Sum(Case When COB_DATE = '2018-02-27' THEN INVENTORY Else 0 END) as INVENTORY_PREV 
, Sum(Case When COB_DATE = '2018-02-28' THEN INVENTORY Else -INVENTORY END) as INVENTORY_DOD 
from x inner join Industry b on (x.CCC_BUSINESS_AREA, x.CHILD_ISSUER) = (b.CCC_BUSINESS_AREA, b.CHILD_ISSUER) 
Group by x.CCC_BUSINESS_AREA, x.CHILD_ISSUER, b.GICS_LEVEL_1_NAME 
Union All 
Select Rank() Over 
(Partition by x.CCC_BUSINESS_AREA Order by Abs(Sum(Case When COB_DATE = '2018-02-28' THEN INVENTORY Else -INVENTORY END)) DESC)||'_Change_'||x.CCC_BUSINESS_AREA as RANK_BUSINESS 
, x.CHILD_ISSUER, b.GICS_LEVEL_1_NAME 
, Sum(Case When COB_DATE = '2018-02-28' THEN INVENTORY Else 0 END) as INVENTORY_COB 
, Sum(Case When COB_DATE = '2018-02-27' THEN INVENTORY Else 0 END) as INVENTORY_PREV 
, Sum(Case When COB_DATE = '2018-02-28' THEN INVENTORY Else -INVENTORY END) as INVENTORY_DOD 
from x inner join Industry b on (x.CCC_BUSINESS_AREA, x.CHILD_ISSUER) = (b.CCC_BUSINESS_AREA, b.CHILD_ISSUER) 
Group by x.CCC_BUSINESS_AREA, x.CHILD_ISSUER, b.GICS_LEVEL_1_NAME