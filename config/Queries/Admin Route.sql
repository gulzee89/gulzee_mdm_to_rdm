SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN au.admn_rt_cd||'-NONSTANDARD'
        ELSE au.admn_rt_cd||'-STANDARD'
       END as "Concept Code",
       au.admn_rt_desc as "Concept Name",
       au.effctve_strt_dtm as "Effective Start Datetime",
       au.effctve_end_dtm as "Effective End Datetime",
       au.dscntnd_flg as "Discontinued Flag Y or N",
       au.comments as "Comments",
       au.last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_admn_route au,
cmx_ors.c_lkp_stndrd st
WHERE
au.rowid_stndrd_cd =st.rowid_object