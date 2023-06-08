SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN cn.cntr_cd||'-NONSTANDARD'
        ELSE cn.cntr_cd||'-STANDARD'
       END as "Concept Code",
       cn.cntr_desc as "Concept Name",
       cn.pat_flg as "PAT Flag Y or N",
       cn.effctve_strt_dtm as "Effective Start Datetime",
       cn.effctve_end_dtm as "Effective End Datetime",
       cn.dscntnd_flg as "Discontinued Flag Y or N",
       cn.comments as "Comments",
       cn.last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_cntr cn,
cmx_ors.c_lkp_stndrd st
WHERE
cn.rowid_stndrd_cd =st.rowid_object