SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN sp.spclst_cd||'-NONSTANDARD'
        ELSE sp.spclst_cd||'-STANDARD'
       END as "Concept Code",
       l.lang_cd as "Language",
       st.stndrd_cd as "Standard",
       sp.last_rowid_system as "System"
FROM cmx_ors.c_lkp_spclst sp,
     cmx_ors.c_lkp_lang l,
     cmx_ors.c_lkp_stndrd st
WHERE
sp.rowid_lang_cd = l.rowid_object
and sp.rowid_stndrd_cd = st.rowid_object