SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN ir.indctn_cd||'-NONSTANDARD'
        ELSE ir.indctn_cd||'-STANDARD'
       END as "Concept Code",
       ir.indctn_desc as "Concept Name",
       ir.effctve_strt_dtm as "Effective Start Datetime",
       ir.effctve_end_dtm as "Effective End Datetime",
       ir.dscntnd_flg as "Discontinued Flag Y or N",
       ir.comments as "Comments",
       ir.last_rowid_system as "System"
FROM cmx_ors.c_lkp_indctn_ref ir,
     cmx_ors.c_lkp_stndrd st
WHERE ir.rowid_stndrd_cd = st.rowid_object