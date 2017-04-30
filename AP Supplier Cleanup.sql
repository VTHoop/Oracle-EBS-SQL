---SUMMARY OF SUPPLIERS-------

select --pv.*,
        pv.segment1 supplier_no,
        pv.vendor_name supplier_name,
        pv.pay_group_lookup_code,
        pv.creation_date,
        pv.enabled_flag,
        pv.end_date_active,
        papf.full_name emp_name,
        papf.current_employee_flag,
        decode(pv.enabled_flag, 'N', 'Inactive', decode(pv.end_date_active, NULL, 'Active', 'Inactive')) active,
        (select count(*) from apps.po_headers_all poh where poh.vendor_id = pv.vendor_id and poh.closed_code not in ('CLOSED','FINALLY CLOSED')) Open_POs,
        decode((select count(*) from apps.ap_checks_all apc where apc.vendor_id = pv.vendor_id and check_date > '01-DEC-2012'), 0, 'No Payments', 'Payment Activity') Payment_Activity,
        decode((select creation_date from apps.po_vendors pv2 where pv2.vendor_id = pv.vendor_id and pv2.creation_date > '01-DEC-2013'), null, 'Not New', 'New') New_Status
from    apps.po_vendors pv
        ,apps.per_all_people_f papf
where       pv.employee_id = papf.person_id (+)
and     trunc(sysdate) between papf.effective_start_date (+) and nvl(papf.effective_end_date (+), '31-DEC-4712')
;
select * from apps.po_headers_all where closed_date is null and vendor_id = 99534;
select * from apps.ap_checks_all;
select * from apps.per_all_people_f;


--SITES SETUP TO non 002 Location--


select pv.segment1, pv.vendor_name, pvsa.vendor_site_code, pvsa.purchasing_site_flag, pvsa.pay_site_flag, gcc.segment1, gcc.segment2, gcc.segment3, gcc.segment4
from apps.po_vendor_sites_all pvsa
    ,apps.po_vendors pv
    ,apps.gl_code_combinations gcc
where pvsa.accts_pay_code_Combination_id = gcc.code_combination_id
and     pvsa.vendor_id = pv.vendor_id
and     gcc.segment1 <> '002'
and   pvsa.inactive_date is not null;


--OPEN POs------

select pv.segment1 supplier_no,
        pv.vendor_name supplier_name,
        poh.segment1 PO_Num,
        --poh.cancel_flag,
        poh.* from
     apps.po_headers_all poh,
     apps.po_vendors pv
where poh.vendor_id = pv.vendor_id
and poh.closed_code not in ('CLOSED','FINALLY CLOSED');

