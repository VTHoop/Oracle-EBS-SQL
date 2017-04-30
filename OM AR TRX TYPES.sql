--TO FIND OM/PA ORDER TYPES AND AR TRX TYPES --

select ota.transaction_type_id,
       ota.attribute1,
       ott.name order_type,
       rct.name rec_trx_typ,
       rct.description,
       rct.type,
       ota.start_date_active,
       ota.end_date_active,
       rct.credit_memo_type_id,
       hou.name,
       gcc.segment1 || '.' || gcc.segment2 || '.' || gcc.segment3 code_comb
from apps.oe_transaction_types_all ota,
     apps.oe_transaction_types_tl ott,
     apps.ra_cust_trx_types_all rct,
     apps.hr_organization_units hou,
     apps.gl_code_combinations gcc
where ota.transaction_type_id=ott.transaction_type_id
and   ota.warehouse_id = hou.organization_id
and rct.gl_id_rev = gcc.code_combination_id
and ota.cust_trx_type_id=rct.cust_trx_type_id
--and gcc.segment1 in ('007','014','015','016')
and gcc.segment2 in ('0224')
and ota.end_date_active is not null
;