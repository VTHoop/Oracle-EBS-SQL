--Query B1 
--update ending month of the year  
--18 MIN

SELECT                
ppa.segment1,  
--mtl_pa.cost mtl_oh, 
pei.expenditure_item_date, 
pei.transaction_source, 
               pei.expenditure_type, 
               pei.system_linkage_function,
               pirs.ind_rate_sch_id, 
               haou_pea.name,
               sum(pcd.burdened_cost) Amount                 
           FROM apps.pa_expenditure_items_all pei,
                apps.pa_expenditure_categories pec,
                apps.pa_expenditure_types pet,
                apps.pa_projects_all ppa,
             apps.PA_IND_RATE_SCHEDULES_ALL_BG pirs , 
                apps.pa_expenditures_all                    pea,
                apps.hr_all_organization_units          haou_pea,
--                apps.fy_12_mtl_oh_projects mtl_pa,
                (select 
                  project_id, burdened_cost, expenditure_item_id, PROJECT_RAW_COST
                   from apps.pa_cost_distribution_lines_all
                  where 1 = 1  
                      and gl_date between '30-MAR-2013' and '04-APR-2014'  --update ending month of the year
                    and line_type = 'R'
--                    and project_id = 119811
                    --and project_id in (select project_id
                      --                   from pa_projects_all
                        --                where 1=1 
                                        --and segment1 BETWEEN '0001199' AND '0001199')
                                             --)
                                              ) pcd
          WHERE pei.expenditure_type = pet.expenditure_type
            AND pet.expenditure_category = pec.expenditure_category
            AND pcd.expenditure_item_id = pei.expenditure_item_id
            AND pea.expenditure_id                              = pei.expenditure_id
            and NVL(pea.incurred_by_organization_id,pei.OVERRIDE_TO_ORGANIZATION_ID)  = haou_pea.organization_id
  --          and NVL(pet.attribute5, pec.attribute2) = 'ENG DIR LABOR' 
--                      and pei.expenditure_item_date not between '02-APR-11' and '30-MAR-12'  --FY12
--            and ppa.segment1 not like 'S%' 
--            and ppa.segment1 = mtl_pa.project  
           AND pei.expenditure_type in ('Materials','Non Part Nbr Items','Non Recurring','Outside Proc','Subcon','Satellite Space Segment')--,'Mtl Overhead')
--           AND pei.expenditure_type in ('Non Part Nbr Items')--,'Mtl Overhead') 
            and pcd.project_id = ppa.project_id
            and ppa.cost_ind_rate_sch_id=pirs.ind_rate_sch_id 
--and pirs.ind_rate_sch_id in (670,671,672,673,676,679,680,669) --FY12
and pirs.ind_rate_sch_id in (809,810,811,813) --FY13
and pei.system_linkage_function <> 'WIP'
--and ppa.segment1 not like 'S%' 
group by ppa.segment1, 
--mtl_pa.cost , 
pei.expenditure_item_date, 
               pei.expenditure_type, 
               pei.system_linkage_function, 
               pei.transaction_source, 
               haou_pea.name,
               pirs.ind_rate_sch_id 



               