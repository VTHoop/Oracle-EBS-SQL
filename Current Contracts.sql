select * from all_tables where table_name like '%CLASIFICATION%'

select * from hr_all_organization_units

select * from pa_project_players

select * from cs_contracts_all;

select * from oke_k_headers_v where start_date  between '01-APR-07' and '30-JUN-07';

select DISTINCT okh.k_number as CONTRACT_NUMBER,
       okh.k_value AS CONTRACT_VALUE,
       okh.start_date,
       ppa.segment1 AS PROJECT,
       ppa.name,
       haou.name,
       ppa.completion_date,
       --ppa.project_status_code,
       papf.full_name,
       ppc.class_code,
       ppc.code_description
from   oke_k_headers_v okh,
       pa_projects_all ppa,
       per_all_people_f papf,
       pa_project_players pap,
       hr_all_organization_units haou,
       pa_project_classes_v ppc
where okh.project_id = ppa.project_id
and   ppa.project_id = pap.project_id
and   ppa.project_id = ppc.project_id
and   pap.person_id = papf.person_id
and   ppa.carrying_out_organization_id = haou.organization_id
and   okh.start_date between '01-APR-07' and '30-JUN-07'
--and   ppa.project_status_code = 'APPROVED'
--and   ppa.completion_date > '18-APR-2007'
and   (k_type_code = 'AWARD' or k_type_code = 'BOA')
and   pap.project_role_type = 'PROJECT MANAGER'
and   ppc.class_category = 'Product Line'
and   ppc.class_code = '0054'
and   ((trunc(sysdate) between pap.start_date_active and pap.end_date_active) OR pap.end_date_active IS NULL);

select * from pa_projects_all where segment1 = '2614961'

select * from pa_project_classes_v where project_id = 47764

begin apps.fnd_client_info.set_org_context('');
end;

