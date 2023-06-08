SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN u.uom_cd||'-NONSTANDARD'
        ELSE u.uom_cd||'-STANDARD'
       END as "Concept Code",
       u.uom_desc as "Concept Name",
       cast(u.uom_alt_cd as varchar(100)) as "Unit Of Measure Alternate Code N3",
       u.uom_alt_desc as "Unit Of Measure Alternate Description",
       u.effctve_strt_dtm as "Effective Start Datetime",
       u.effctve_end_dtm as "Effective End Datetime",
       u.dscntnd_flg as "Discontinued Flag Y or N",
       u.comments as "Comments",
       u.last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_uom u,
cmx_ors.c_lkp_stndrd st
WHERE
u.rowid_stndrd_cd = st.rowid_object