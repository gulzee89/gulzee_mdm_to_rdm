SELECT 
       CASE
        WHEN st.stndrd_cd = 'N'
        THEN f.fclty_cd||'-NONSTANDARD'
        ELSE f.fclty_cd||'-STANDARD'
       END as "Concept Code",
       c.cntry_shrt_desc || ' (' || c.cntry_cd || ')' as "Country",
       l.lang_cd as "Language",
       st.stndrd_cd as "Standard",
       f.last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_fclty f,
cmx_ors.c_lkp_cntry c,
cmx_ors.c_lkp_lang l,
cmx_ors.c_lkp_stndrd st
WHERE
f.rowid_cntry = c.rowid_object
and f.rowid_lang_cd = l.rowid_object
and f.rowid_stndrd_cd =st.rowid_object