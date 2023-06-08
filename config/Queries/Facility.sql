SELECT 
       CASE
        WHEN st.stndrd_cd = 'N'
        THEN f.fclty_cd||'-NONSTANDARD'
        ELSE f.fclty_cd||'-STANDARD'
       END as "Concept Code",
       f.fclty_desc as "Concept Name",
       f.effctve_strt_dtm as "Effective Start Datetime",
       f.effctve_end_dtm as "Effective End Datetime",
       f.dscntnd_flg as "Discontinued Flag Y or N",
       f.comments as "Comments",
       f.last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_fclty f,
cmx_ors.c_lkp_stndrd st
WHERE 
f.rowid_stndrd_cd =st.rowid_object