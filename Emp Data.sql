select upper(papf.last_name || '/' || substr(papf.first_name, 1, 4)) lookup
        ,papf.full_name
        ,papf.employee_number
        ,hou.attribute2 cost_center
        ,papf.email_address
from    apps.per_all_people_f papf
        ,apps.per_all_assignments_f paaf
        ,apps.hr_organization_units hou
where   trunc(sysdate) between papf.effective_start_date and papf.effective_end_date
and     trunc(sysdate) between paaf.effective_start_date and paaf.effective_end_date
and     papf.person_id = paaf.person_id
and     paaf.organization_id = hou.organization_id
and (current_employee_flag = 'Y' or current_npw_flag = 'Y')
and person_type_id = 6
;




select * from apps.per_all_people_f where full_name = 'Robbins, Tom';
select * from apps.per_all_people_f where person_type_id = 13;
select * from apps.per_person_types;