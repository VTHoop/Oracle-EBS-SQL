--SUPPLIERS--
Select --*
vendor_name, segment1, match_option, decode(inspection_required_flag, 'Y', '4-Way', decode(receipt_required_flag, 'Y', '3-Way', '2-Way')) match_type,enabled_flag
from apps.po_vendors-- where creation_date < '01-AUG-2014';
;
--CUSTOMERS--
--select count(*)
--from (
select --hzca.*
hzp.party_number, hzp.party_name, decode(hzp.country, 'US', hzp.state, hzp.province) location, hzca.account_number, hzca.status
--hzp.party_name, hzp.party_id, hzp.party_type, hzca.account_number ,hzca.status cust_account_status
from apps.hz_parties hzp
,   apps.hz_cust_accounts hzca
where   hzp.party_id = hzca.party_id
--and     hzca.creation_date < '01-JUL-2014'
--8and     hzp.party_number = '1359'
--) a
--group by cust_account_status
;

--EXPENDITURES--
select count(*) from apps.pa_expenditure_items_all-- where creation_date <'01-JUL-2014'
;
--ASSETS--
select fa.asset_number, fa.description, fb.book_type_code, fb.cost, fb.deprn_method_code, fb.life_in_months from apps.fa_additions fa, apps.fa_books fb where fa.asset_id = fb.asset_id
--and fa.creation_date < '01-JUL-2014' and fb.last_update_date < '01-JUL-2014'
;

--BUDGETS--
select pa_cost_budgets.segment1 proj_num
        ,pa_cost_budgets.burdened_cost cost_budget
        ,pa_rev_budgets.revenue revenue_budget
from    (select pbv.budget_version_id, ppa.segment1, pbv.burdened_cost, ppa.creation_date
        from    apps.pa_budget_versions pbv
                ,apps.pa_projects_all ppa
        where    pbv.project_id = ppa.project_id
        and     pbv.budget_status_code = 'W'
        and     pbv.budget_type_code = 'AC'
         ) pa_cost_budgets   
        ,(select pbv.budget_version_id, ppa.segment1, pbv.revenue
        from    apps.pa_budget_versions pbv
                ,apps.pa_projects_all ppa
        where    pbv.project_id = ppa.project_id
        and     pbv.budget_status_code = 'W'
        and     pbv.budget_type_code = 'AR'
         ) pa_rev_budgets  
where     pa_cost_budgets.segment1 = pa_rev_budgets.segment1
--and       pa_cost_budgets.segment1 = '2601035';
--and     pa_cost_budgets.creation_date < '01-JUL-2014'
order by pa_cost_budgets.segment1 asc;
