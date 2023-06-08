SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN ds.dsg_frm_cd||'-NONSTANDARD'
        ELSE ds.dsg_frm_cd||'-STANDARD'
       END as "Concept Code",
       ds.dsg_frm_desc as "Concept Name",
       ds.dsg_frm_alt_cd as "Dosage Form Alternate Code A5",
       ds.dsg_frm_alt_desc as "Dosage Form Alternate Description",
       ds.effctve_strt_dtm as "Effective Start Datetime",
       ds.effctve_end_dtm as "Effective End Datetime",
       ds.dscntnd_flg as "Discontinued Flag Y or N",
       ds.comments as "Comments",
       ds.last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_dsg_frm ds,
cmx_ors.c_lkp_stndrd st
WHERE
ds.rowid_stndrd_cd =st.rowid_object