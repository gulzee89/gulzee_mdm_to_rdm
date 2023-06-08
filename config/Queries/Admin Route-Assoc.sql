SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN au.admn_rt_cd||'-NONSTANDARD'
        ELSE au.admn_rt_cd||'-STANDARD'
       END as "Concept Code",
       l.lang_cd as "Language",
       st.stndrd_cd as "Standard",
       au.last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_admn_route au,
cmx_ors.c_lkp_lang l,
cmx_ors.c_lkp_stndrd st
WHERE
au.rowid_lang_cd = l.rowid_object
and au.rowid_stndrd_cd =st.rowid_object