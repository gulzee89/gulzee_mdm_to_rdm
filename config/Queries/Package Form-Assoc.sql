SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN pf.pkg_frm_cd||'-NONSTANDARD'
        ELSE pf.pkg_frm_cd||'-STANDARD'
       END as "Concept Code",
       l.lang_cd as "Language",
       st.stndrd_cd as "Standard",
       pf.last_rowid_system as "System"
FROM cmx_ors.c_lkp_pkg_frm pf,
     cmx_ors.c_lkp_lang l,
     cmx_ors.c_lkp_stndrd st
WHERE
pf.rowid_lang_cd = l.rowid_object
and pf.rowid_stndrd_cd = st.rowid_object