SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN ds.dsg_frm_cd||'-NONSTANDARD'
        ELSE ds.dsg_frm_cd||'-STANDARD'
       END as "Concept Code",
       l.lang_cd as "Language",
       st.stndrd_cd as "Standard",
       ds.last_rowid_system as "System"
FROM cmx_ors.c_lkp_dsg_frm ds,
     cmx_ors.c_lkp_lang l,
     cmx_ors.c_lkp_stndrd st
WHERE
ds.rowid_lang_cd = l.rowid_object
and ds.rowid_stndrd_cd =st.rowid_object