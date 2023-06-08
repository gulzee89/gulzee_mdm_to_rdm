SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN cg.cntry_grp_cd||'-NONSTANDARD'
        ELSE cg.cntry_grp_cd||'-STANDARD'
       END as "Concept Code",
       l.lang_cd as "Language",
       st.stndrd_cd as "Standard",
       cg.last_rowid_system as "System"
FROM cmx_ors.c_lkp_cntry_grp cg,
     cmx_ors.c_lkp_lang l,
     cmx_ors.c_lkp_stndrd st
WHERE cg.rowid_lang_cd = l.rowid_object
and cg.rowid_stndrd_cd =st.rowid_object