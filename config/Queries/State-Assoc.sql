SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN s.state_cd||'-NONSTANDARD'
        ELSE s.state_cd||'-STANDARD'
       END as "Concept Code",
       c.cntry_shrt_desc || ' (' || c.cntry_cd || ')' as "Country",
       l.lang_cd as "Language",
       st.stndrd_cd as "Standard",
       s.last_rowid_system as "System"
FROM
cmx_ors.c_lkp_state s,
cmx_ors.c_lkp_cntry c,
cmx_ors.c_lkp_lang l,
cmx_ors.c_lkp_stndrd st 
WHERE
s.rowid_cntry_cd = c.rowid_object
and s.rowid_lang_cd = l.rowid_object
and s.rowid_stndrd_cd = st.rowid_object