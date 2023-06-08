SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN g.gndr_cd||'-NONSTANDARD'
        ELSE g.gndr_cd||'-STANDARD'
       END as "Concept Code",
       l.lang_cd as "Language",
       st.stndrd_cd as "Standard",
       g.last_rowid_system as "System"
FROM cmx_ors.c_lkp_gndr g,
     cmx_ors.c_lkp_lang l,
     cmx_ors.c_lkp_stndrd st
WHERE g.rowid_lang_cd = l.rowid_object
AND   g.rowid_stndrd_cd = st.rowid_object