SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN cn.cntr_cd||'-NONSTANDARD'
        ELSE cn.cntr_cd||'-STANDARD'
       END as "Concept Code",
       l.lang_cd as "Language",
       st.stndrd_cd as "Standard",
       cn.last_rowid_system as "System"
FROM cmx_ors.c_lkp_cntr cn,
     cmx_ors.c_lkp_lang l,
     cmx_ors.c_lkp_stndrd st
WHERE
cn.rowid_lang_cd = l.rowid_object
and cn.rowid_stndrd_cd =st.rowid_object