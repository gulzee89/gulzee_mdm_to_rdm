SELECT CASE
        WHEN st.stndrd_cd = 'N'
        THEN s.state_cd||'-NONSTANDARD'
        ELSE s.state_cd||'-STANDARD'
       END as "Concept Code",
       s.state_desc as "Concept Name",
       s.effctve_strt_dtm as "Effective Start Datetime",
       s.effctve_end_dtm as "Effective End Datetime",
       s.dscntnd_flg as "Discontinued Flag Y or N",
       s.comments as "Comments",
       s.last_rowid_system as "System"
FROM
cmx_ors.c_lkp_state s,
cmx_ors.c_lkp_stndrd st
WHERE
s.rowid_stndrd_cd = st.rowid_object