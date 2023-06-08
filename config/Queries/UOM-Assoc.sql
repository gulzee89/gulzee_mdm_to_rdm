SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN u.uom_cd||'-NONSTANDARD'
        ELSE u.uom_cd||'-STANDARD'
       END as "Concept Code",
       l.lang_cd as "Language",
       st.stndrd_cd as "Standard",
       u.last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_uom u,
cmx_ors.c_lkp_lang l,
cmx_ors.c_lkp_stndrd st
WHERE
u.rowid_lang_cd = l.rowid_object
and u.rowid_stndrd_cd = st.rowid_object