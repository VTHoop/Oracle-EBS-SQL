select  fds.name
        ,fds.initial_value
        ,fat.application_name
        ,rct.name rec_trx_typ
        ,rct.description,
        rct.type,
        gcc.segment1 || '.' || gcc.segment2 || '.' || gcc.segment3 code_comb
from    apps.ra_cust_trx_types_all rct
        ,apps.gl_code_combinations gcc
        ,apps.FND_DOC_SEQUENCE_ASSIGNMENTS fdsa
        ,apps.FND_DOCUMENT_SEQUENCES fds
        ,apps.fnd_application_tl fat
where rct.gl_id_rev = gcc.code_combination_id
and gcc.segment1 in ('007','014','015','016')
and     fdsa.doc_sequence_id = fds.doc_sequence_id
and     fat.application_id = fds.application_id
and     fat.application_name = 'Order Management'
and     fdsa.category_code = rct.cust_trx_type_id
and     fdsa.end_date is null;


select * from all_tables where table_name like '%APPLICATION%';
select * from apps.fnd_application_tl;
select * from apps.ra_cust_trx_types_all;
select * from apps.oe_transaction_types_all;
