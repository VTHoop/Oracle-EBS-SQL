--CUSTOMER CLEANUP STATUS--

select  rc.customer_number,
        rc.customer_name,
        rc.creation_date,
        rc.status,
        decode((select count(*) from apps.ra_customer_trx_all rcta where rcta.bill_to_customer_id = rc.customer_id and rcta.trx_date > '01-DEC-2012'), 0, 'No Billing', 'Billing Activity') Billing_Activity,
        decode((select count(*) from apps.ra_customer_trx_all rcta where rcta.ship_to_customer_id = rc.customer_id and rcta.trx_date > '01-DEC-2012'), 0, 'No Shipping', 'Shipping Activity') Shipping_Activity,
        decode((select customer_id from apps.ar_payment_schedules_all apsa where apsa.customer_id = rc.customer_id and apsa.amount_due_remaining > 0 group by customer_id), null, 'No Aging', 'Aging Activity') Aging_Activity,
        decode((select rc2.creation_date from apps.ra_customers rc2 where rc2.customer_id = rc.customer_id and rc2.creation_date > '01-DEC-2013'), null, 'Not New', 'New') New_Status
from apps.ra_customers rc;

select distinct ship_to_customer_id from apps.ra_customer_trx_all where trx_date > '01-DEC-2012'; 

---CUSTOMER HEADER CREATION ANALYSIS--
select fu.user_name, papf.full_name, hou.name, ppt.system_person_type, count(rc.customer_id)
from    apps.ra_customers rc
        ,apps.fnd_user fu
        ,apps.per_all_people_f papf
        ,apps.per_person_types ppt
        ,apps.per_all_assignments_f paaf
        ,apps.hr_organization_units hou
where rc.creation_date > '01-JUL-2013'
and     rc.created_by = fu.user_id
and     papf.person_type_id = ppt.person_type_id
and     fu.employee_id = papf.person_id
and     papf.person_id = paaf.person_id
and     paaf.organization_id = hou.organization_id
and     trunc(sysdate) between papf.effective_start_date and nvl(papf.effective_end_date, '31-DEC-4712')
and     trunc(sysdate) between paaf.effective_start_date and nvl(paaf.effective_end_date, '31-DEC-4712')
group by fu.user_name, papf.full_name, hou.name, ppt.system_person_type
order by papf.full_name
;
--CUSTOMER SITE CREATION ANALYSIS--
select fu.user_name
    , papf.full_name EMPLOYEE_NAME
    , hou.name COST_CENTER
    , ppt.system_person_type STATUS
    , hpsu.site_use_type SITE_USE
    , count(hpsu.party_site_use_id) "# Of Sites Created"
from    apps.hz_party_site_uses hpsu
        ,apps.fnd_user fu
        ,apps.per_all_people_f papf
        ,apps.per_person_types ppt
        ,apps.per_all_assignments_f paaf
        ,apps.hr_organization_units hou
where    fu.user_id = hpsu.created_by
and     hpsu.creation_date > '01-JUL-2013'
and     papf.person_type_id = ppt.person_type_id
and     fu.employee_id = papf.person_id
and     papf.person_id = paaf.person_id
and     paaf.organization_id = hou.organization_id
and     trunc(sysdate) between papf.effective_start_date and nvl(papf.effective_end_date, '31-DEC-4712')
and     trunc(sysdate) between paaf.effective_start_date and nvl(paaf.effective_end_date, '31-DEC-4712')
--and     fu.end_date is null
group by fu.user_name, papf.full_name, hou.name, ppt.system_person_type, hpsu.site_use_type
order by papf.full_name
;

select *
from    apps.hz_party_sites;


select * from apps.ra_customer_trx_all;
select * from apps.RA_CUSTOMER_TRX_PARTIAL_V;
select * from apps.ar_receipts_all;
select * from all_tables where table_name like '%SITE%' and owner = 'AR';
select * from apps.ar_payment_schedules_all where amount_due_remaining > 0 and customer_id = 1022;--group by customer_id;

select * from apps.ra_customers where customer_number = '1000';

begin
dbms_application_info.set_client_info('47');
end;