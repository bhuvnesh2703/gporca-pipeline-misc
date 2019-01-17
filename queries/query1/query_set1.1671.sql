with FDSF_SCENARIOS_DATA as ( select COB_DATE AS "Cob Date", ATTRIBUTE1 AS "Asset", ATTRIBUTE2 AS "Legal Entity", ATTRIBUTE3 AS "Business Unit", case when ATTRIBUTE4 
in ('CREDIT-CORPORATES', 'SECURITIZED PRODUCTS GRP','FXEM MACRO TRADING','EM CREDIT TRADING','LIQUID FLOW RATES','STRUCTURED RATES','DSP - CREDIT') then ATTRIBUTE4 when ATTRIBUTE3 in ('INSTITUTIONAL EQUITY DIVISION') then 'IED' else 'OTHER' end AS "Sub Business Unit", ATTRIBUTE5 AS "Desk", ATTRIBUTE6 AS "Book", ATTRIBUTE7 AS "Counterparty", ATTRIBUTE8 AS "Currency of Exposure", ATTRIBUTE9 AS "Scenario Shock", ATTRIBUTE9 AS "Risk Metric", ATTRIBUTE10 AS "Severity", case when ATTRIBUTE4 = 'STRUCTURED RATES' and ATTRIBUTE11 in ('CYP', 'GRC', 'IRL', 'ITA', 'PRT', 'SVN', 'ESP') then 'Peripherals' when ATTRIBUTE4 = 'STRUCTURED RATES' and ATTRIBUTE11 not in ('CYP', 'GRC', 'IRL', 'ITA', 'PRT', 'SVN', 'ESP') then 'Other' else ATTRIBUTE11 end AS "Country of Issuer", ATTRIBUTE12 AS "Product Type", ATTRIBUTE13 AS "Reference", ATTRIBUTE14 AS "FX Pair Currency", VALUE1 AS "Scenario Shock Result Value", substr(ATTRIBUTE10,1,strpos(ATTRIBUTE10,'/')-1) as "Severity_Spot", replace(substr(ATTRIBUTE10,strpos(ATTRIBUTE10,'/')+1,100),' ','') as "Severity_Vol", case when COB_DATE = '2018-02-16' then 'CURRENT' when COB_DATE = '2018-01-19' then 'PRIOR' else 'OTHER' end as COB from CDWUSER.U_GENERIC_DATA where cob_date in ('2018-02-16','2018-01-19','2017-12-29','2017-11-17','2017-10-20') and analytic_group = 'FDSF' and analytics = 'SCENARIOS' and ATTRIBUTE1 = 'CR' and ATTRIBUTE10 like '%/None'), CONSOLIDATED as ( select coalesce(F1."Business Unit", F2."Business Unit") as "Business Unit", coalesce(F1."Sub Business Unit", F2."Sub Business Unit") as "Sub Business Unit", coalesce(F1."Country of Issuer", F2."Country of Issuer") as "Country of Issuer", coalesce(F1."Severity_Spot", F2."Severity_Spot") as "Severity_Spot", coalesce(F1."Severity_Vol", F2."Severity_Vol") as "Severity_Vol", coalesce(F1."Scenario Shock Result Value",0) as "Current PnL", coalesce(F2."Scenario Shock Result Value",0) as "Prior PnL", coalesce(F1."Scenario Shock Result Value",0) - coalesce(F2."Scenario Shock Result Value",0) as "PnL Diff" from (select "Business Unit", "Sub Business Unit", "Country of Issuer", "Severity_Spot", "Severity_Vol", sum(coalesce("Scenario Shock Result Value",0)) as "Scenario Shock Result Value" from FDSF_SCENARIOS_DATA where COB = 'CURRENT' group by "Business Unit", "Sub Business Unit", "Country of Issuer", "Severity_Spot", "Severity_Vol") F1 full outer join (select "Business Unit", "Sub Business Unit", "Country of Issuer", "Severity_Spot", "Severity_Vol", sum(coalesce("Scenario Shock Result Value",0)) as "Scenario Shock Result Value" from FDSF_SCENARIOS_DATA where COB = 'PRIOR' group by "Business Unit", "Sub Business Unit", "Country of Issuer", "Severity_Spot", "Severity_Vol") F2 on F1."Business Unit" = F2."Business Unit" and F1."Sub Business Unit" = F2."Sub Business Unit" and F1."Country of Issuer" = F2."Country of Issuer" and F1."Severity_Spot" = F2."Severity_Spot" and F1."Severity_Vol" = F2."Severity_Vol" ) select 'Sub Business Unit' as "Level", "Business Unit", "Sub Business Unit", "Country of Issuer", "Severity_Spot", "Severity_Vol", "Current PnL", "Prior PnL", "PnL Diff", ROW_NUMBER() over (partition by "Business Unit", "Sub Business Unit", "Severity_Vol" order by max_curr_pnl desc) as "Current Country Rank", ROW_NUMBER() over (partition by "Business Unit", "Sub Business Unit", "Severity_Vol" order by max_prior_pnl desc) as "Prior Country Rank", ROW_NUMBER() over (partition by "Business Unit", "Sub Business Unit", "Severity_Vol" order by max_pnl_diff desc) as "Variance Country Rank", "Current PnL"/(sum("Current PnL") over (partition by "Business Unit", "Sub Business Unit", "Severity_Spot", "Severity_Vol") + 1) as "Current Country Contribution", "Prior PnL"/(sum("Prior PnL") over (partition by "Business Unit", "Sub Business Unit", "Severity_Spot", "Severity_Vol") + 1) as "Prior Country Contribution", "PnL Diff"/(sum("PnL Diff") over (partition by "Business Unit", "Sub Business Unit", "Severity_Spot", "Severity_Vol") + 1) as "Variance Country Contribution" from ( select "Business Unit", "Sub Business Unit", "Country of Issuer", "Severity_Spot", "Severity_Vol", "Current PnL", "Prior PnL", "PnL Diff", max(abs("Current PnL")) over (partition by "Business Unit", "Sub Business Unit", "Severity_Vol", "Country of Issuer") as max_curr_pnl, max(abs("Prior PnL")) over (partition by "Business Unit", "Sub Business Unit", "Severity_Vol", "Country of Issuer") as max_prior_pnl, max(abs("PnL Diff")) over (partition by "Business Unit", "Sub Business Unit", "Severity_Vol", "Country of Issuer") as max_pnl_diff from CONSOLIDATED F ) as F union all select 'Business Unit' as "Level", "Business Unit", NULL as "Sub Business Unit", "Country of Issuer", "Severity_Spot", "Severity_Vol", "Current PnL", "Prior PnL", "PnL Diff", ROW_NUMBER() over (partition by "Business Unit", "Severity_Vol" order by max_curr_pnl desc) as "Current Country Rank", ROW_NUMBER() over (partition by "Business Unit", "Severity_Vol" order by max_prior_pnl desc) as "Prior Country Rank", ROW_NUMBER() over (partition by "Business Unit", "Severity_Vol" order by max_pnl_diff desc) as "Variance Country Rank", "Current PnL"/(sum("Current PnL") over (partition by "Business Unit", "Severity_Spot", "Severity_Vol") + 1) as "Current Country Contribution", "Prior PnL"/(sum("Prior PnL") over (partition by "Business Unit", "Severity_Spot", "Severity_Vol") + 1) as "Prior Country Contribution", "PnL Diff"/(sum("PnL Diff") over (partition by "Business Unit", "Severity_Spot", "Severity_Vol") + 1) as "Variance Country Contribution" from (select "Business Unit","Country of Issuer", "Severity_Spot", "Severity_Vol", "Current PnL", "Prior PnL", "PnL Diff", max(abs("Current PnL")) over (partition by "Business Unit", "Severity_Vol", "Country of Issuer") as max_curr_pnl, max(abs("Prior PnL")) over (partition by "Business Unit", "Severity_Vol", "Country of Issuer") as max_prior_pnl, max(abs("PnL Diff")) over (partition by "Business Unit", "Severity_Vol", "Country of Issuer") as max_pnl_diff from ( select "Business Unit", "Country of Issuer", "Severity_Spot", "Severity_Vol", sum("Current PnL") as "Current PnL", sum("Prior PnL") as "Prior PnL", sum("PnL Diff") as "PnL Diff" from CONSOLIDATED group by "Business Unit", "Country of Issuer", "Severity_Spot", "Severity_Vol") F )F