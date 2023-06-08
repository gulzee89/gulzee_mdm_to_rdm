SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN cast(ig.indctn_grp_cd as varchar(100))||'-NONSTANDARD'
        ELSE cast(ig.indctn_grp_cd as varchar(100))||'-STANDARD'
       END as "Concept Code",
       ig.indctn_grp_desc as "Concept Name",
       ig.effctve_strt_dtm as "Effective Start Datetime",
       ig.effctve_end_dtm as "Effective End Datetime",
       ig.dscntnd_flg as "Discontinued Flag Y or N",
       ig.comments as "Comments",
       ig.last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_indctn_grp ig,
cmx_ors.c_lkp_stndrd st
WHERE
ig.rowid_stndrd_cd = st.rowid_object
union
SELECT CASE
        WHEN igs.stndrd_cd = 'N'
        THEN cast(ig.indctn_grp_cd as varchar(100))||'-NONSTANDARD'
        ELSE cast(ig.indctn_grp_cd as varchar(100))||'-STANDARD'
       END as "Concept Code",
       ig.indctn_grp_desc as "Concept Name",
       ig.effctve_strt_dtm as "Effective Start Datetime",
       ig.effctve_end_dtm as "Effective End Datetime",
       ig.dscntnd_flg as "Discontinued Flag Y or N",
       ig.comments as "Comments",
       ig.last_rowid_system as "System"
FROM cmx_ors.c_lkp_indctn_ref ir,
     cmx_ors.c_lkp_indctn_grp ig,
     cmx_ors.c_lkp_stndrd igs
WHERE ir.rowid_indctn_grp_cd = ig.rowid_object
AND   ir.rowid_indctn_grp_stndrd_cd = igs.rowid_object