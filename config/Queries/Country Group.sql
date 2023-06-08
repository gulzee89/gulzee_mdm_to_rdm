SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN cg.cntry_grp_cd||'-NONSTANDARD'
        ELSE cg.cntry_grp_cd||'-STANDARD'
       END as "Concept Code",
       cg.cntry_grp_desc as "Concept Name",
       cg.cntry_grp_alt_cd as "Country Group Alternate Code A3",
       cg.cntry_grp_alt_desc as "Country Group Alternate Description",
       cg.cntry_grp_cdisc_cd as "Country Group CDISC Code N3",
       cg.cntry_grp_cdisc_desc as "Country Group CDISC Description",
       cg.effctve_strt_dtm as "Effective Start Datetime",
       cg.effctve_end_dtm as "Effective End Datetime",
       cg.dscntnd_flg as "Discontinued Flag Y or N",
       cg.comments as "Comments",
       cg.last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_cntry_grp cg,
cmx_ors.c_lkp_stndrd st
WHERE
cg.rowid_stndrd_cd =st.rowid_object