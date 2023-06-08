SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN g.gndr_cd||'-NONSTANDARD'
        ELSE g.gndr_cd||'-STANDARD'
       END as "Concept Code",
       g.gndr_desc as "Concept Name",
       g.gndr_alt_cd as "Gender Alternate Code N1",
       g.gndr_alt_desc as "Gender Alternate Description",
       g.effctve_strt_dtm as "Effective Start Datetime",
       g.effctve_end_dtm as "Effective End Datetime",
       g.dscntnd_flg as "Discontinued Flag Y or N",
       g.comments as "Comments",
       g.last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_gndr g,
cmx_ors.c_lkp_stndrd st
WHERE
g.rowid_stndrd_cd = st.rowid_object