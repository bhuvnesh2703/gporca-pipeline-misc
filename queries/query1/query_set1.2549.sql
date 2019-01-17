with src as (SELECT currency_of_measure as currency, SUM (case when COB_DATE = '2018-02-28' then coalesce(usd_fx_delta, 0) else 0 end ) AS usd_fx_delta_cob, SUM (case when COB_DATE = '2018-02-28' then coalesce(usd_fx_delta, 0) else -coalesce(usd_fx_delta, 0) end ) AS usd_fx_delta_change, SUM (case when COB_DATE = '2018-02-28' then coalesce(USD_FX_KAPPA, 0) else 0 end ) AS usd_fx_kappa_cob, SUM (case when COB_DATE = '2018-02-28' then coalesce(USD_FX_KAPPA, 0) else -coalesce(USD_FX_KAPPA, 0) end ) AS usd_fx_kappa_change FROM ( SELECT cob_date, case when currency_of_measure = 'CNY' and onshore_fl = 'N' then 'CNH' when currency_of_measure = 'KRW' and onshore_fl = 'N' then 'KRX' when currency_of_measure = 'BRL' and onshore_fl = 'N' then 'BRX' else currency_of_measure end as currency_of_measure, SUM(case when currency_of_measure not in ('UDB','USD') then usd_fx else 0 end) as usd_fx_delta, SUM(case when feed_source_name <> 'CORISK' then coalesce(USD_FX_KAPPA, 0) + coalesce(usd_fx_partial_kappa,0) when feed_source_name = 'CORISK' and PRODUCT_TYPE_CODE = 'CURRENCY' then coalesce(LCY_FX_KAPPA, 0)/1000 else 0 end) as USD_FX_KAPPA FROM CDWUSER.u_exp_msr WHERE COB_DATE IN ('2018-02-28', '2018-01-31') AND PARENT_LEGAL_ENTITY = '0517(G)' AND var_excl_fl <> 'Y' AND ccc_banking_trading = 'TRADING' GROUP BY cob_date, case when currency_of_measure = 'CNY' and onshore_fl = 'N' then 'CNH' when currency_of_measure = 'KRW' and onshore_fl = 'N' then 'KRX' when currency_of_measure = 'BRL' and onshore_fl = 'N' then 'BRX' else currency_of_measure end ) M GROUP BY currency_of_measure ) select coalesce(a.rank, 12) as rank, coalesce(a.currency, 'Other') as currency, sum(src.usd_fx_delta_cob) as usd_fx_delta_cob, sum(src.usd_fx_delta_change) as usd_fx_delta_change, sum(src.usd_fx_kappa_cob) as usd_fx_kappa_cob, sum(src.usd_fx_kappa_change) as usd_fx_kappa_change from( select distinct case when ROW_NUMBER() OVER() < 12 then ROW_NUMBER() OVER() else 12 end as rank, case when ROW_NUMBER() OVER() < 12 then currency else 'Other' end as currency from( select ROW_NUMBER() OVER(), currency from src group by currency order by CASE WHEN currency = 'EUR' THEN 1 WHEN currency = 'GBP' THEN 2 WHEN currency = 'JPY' THEN 3 ELSE 4 END, abs(sum(usd_fx_delta_cob)) desc ) N ) a right join src on a.currency = src.currency group by coalesce(a.rank, 12), coalesce(a.currency, 'Other')