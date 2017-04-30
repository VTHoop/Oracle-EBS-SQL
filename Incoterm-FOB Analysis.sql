select * from all_tables where table_name like '%OKE%TERMS%';
select * from oke_k_terms where creation_date > sysdate - 120 and term_code = 'OB_FOB';
select * from OKE_K_HEADERS where creation_date > sysdate - 365 and k_header_id = 650295;
select * from oke_k_user_attributes where creation_date > sysdate - 120;

---total contracts in past 6 months---
select count(*) from OKE_K_HEADERS where creation_date > sysdate - 240
;

----total amount with Incoterms on UDA in past 6 months----
select user_attribute27, count(user_attribute27)
from OKE_K_USER_ATTRIBUTES okua
where creation_date > sysdate - 240
and user_attribute27 != 'N/A'
group by user_attribute27
;
----total amount with FOB Terms on UDA in past 6 months----
select count(user_attribute24)
from OKE_K_USER_ATTRIBUTES okua
where creation_date > sysdate - 240
and okua.k_line_id is null
and user_attribute24 != 'N/A'
;

-----total contracts with an FOB term in the past 6 months----
select count(okh.k_header_id)
from    apps.oke_k_terms okt
        ,apps.oke_k_headers okh
where   okt.creation_date > sysdate - 240
and     okt.k_header_id = okh.k_header_id
and term_code = 'OB_FOB';

----users who entered FOB into UDA---
select fu.user_name, count(user_attribute24)
from OKE_K_USER_ATTRIBUTES okua
        ,fnd_user fu
where okua.creation_date > sysdate - 240
and     okua.created_by = fu.user_id
and okua.k_line_id is null
and user_attribute24 != 'N/A'
group by fu.user_name
;

-----users entering contracts with an FOB term in the past 6 months----
select fu.user_name, count(okh.k_header_id)
from    apps.oke_k_terms okt
        ,apps.oke_k_headers okh
        ,apps.fnd_user fu
where   okt.creation_date > sysdate - 240
and     okt.created_by = fu.user_id
and     okt.k_header_id = okh.k_header_id
and term_code = 'OB_FOB'
group by fu.user_name
;

select k_number_disp, user_attribute27
from apps.OKE_K_USER_ATTRIBUTES okua
        ,apps.oke_k_headers_h okh
where okua.creation_date > sysdate - 120
and okua.k_header_id = okh.k_header_id
and user_attribute27 != 'N/A'
--group by user_attribute27
;
---contracts with a UDA Incoterm in the past 3 months----
select k_number_disp, user_attribute27
from apps.OKE_K_USER_ATTRIBUTES okua
        ,apps.oke_k_headers okh
where okua.k_header_id = okh.k_header_id
and   okua.creation_date > sysdate - 120
and user_attribute27 != 'N/A'
;
-----contracts with an FOB term in the past 3 months----
select okh.k_number_disp, okt.*
from    apps.oke_k_terms okt
        ,apps.oke_k_headers okh
where   okt.creation_date > sysdate - 120
and     okt.k_header_id = okh.k_header_id
and term_code = 'OB_FOB';

----users who have entered a contract in the past year----
select distinct fu.user_name
from    OKE_K_HEADERS okh
        ,apps.fnd_user fu
where   okh.creation_date > sysdate - 365
and     okh.created_by = fu.user_id;