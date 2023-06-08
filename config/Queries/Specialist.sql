SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN sp.spclst_cd||'-NONSTANDARD'
        ELSE sp.spclst_cd||'-STANDARD'
       END as "Concept Code",
       sp.spclst_desc as "Concept Name",
       sp.spclst_alt_cd as "Specialist Alternate Code A5",
       sp.spclst_alt_desc as "Specialist Alternate Description",
       sp.effctve_strt_dtm as "Effective Start Datetime",
       sp.effctve_end_dtm as "Effective End Datetime",
       sp.dscntnd_flg as "Discontinued Flag Y or N",
       sp.comments as "Comments",
       sp.last_rowid_system as "System"
FROM cmx_ors.c_lkp_spclst sp,
cmx_ors.c_lkp_stndrd st
WHERE
sp.rowid_stndrd_cd = st.rowid_object