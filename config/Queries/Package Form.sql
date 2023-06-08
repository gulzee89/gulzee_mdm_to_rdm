SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN pf.pkg_frm_cd||'-NONSTANDARD'
        ELSE pf.pkg_frm_cd||'-STANDARD'
       END as "Concept Code",
       pf.pkg_frm_desc as "Concept Name",
       pf.pkg_frm_alt_cd as "Package Form Alternate Code A10",
       pf.pkg_frm_alt_desc as "Package Form Alternate Description",
       pf.effctve_strt_dtm as "Effective Start Datetime",
       pf.effctve_end_dtm as "Effective End Datetime",
       pf.dscntnd_flg as "Discontinued Flag Y or N",
       pf.comments as "Comments",
       pf.last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_pkg_frm pf,
cmx_ors.c_lkp_stndrd st
WHERE
pf.rowid_stndrd_cd = st.rowid_object