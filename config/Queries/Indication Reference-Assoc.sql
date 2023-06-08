SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN ir.indctn_cd||'-NONSTANDARD'
        ELSE ir.indctn_cd||'-STANDARD'
       END as "Concept Code",
       CASE
        WHEN igs.stndrd_cd = 'N'
        THEN cast(ig.indctn_grp_cd as varchar(100))||'-NONSTANDARD'
        ELSE cast(ig.indctn_grp_cd as varchar(100))||'-STANDARD'
       END as "Indication Group",
       l.lang_cd as "Language",
       st.stndrd_cd as "Standard",
       ir.last_rowid_system as "System"
FROM cmx_ors.c_lkp_indctn_ref ir,
     cmx_ors.c_lkp_lang l,
     cmx_ors.c_lkp_stndrd st,
     cmx_ors.c_lkp_indctn_grp ig,
     cmx_ors.c_lkp_stndrd igs
WHERE ir.rowid_lang_cd = l.rowid_object
AND   ir.rowid_stndrd_cd = st.rowid_object
AND   ir.rowid_indctn_grp_cd = ig.rowid_object
AND   ir.rowid_indctn_grp_stndrd_cd = igs.rowid_object