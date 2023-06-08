SELECT stndrd_cd as "Concept Code",
       stndrd_desc as "Concept Name",
       dscntnd_flg as "Discontinued Flag Y or N",
       effctve_strt_dtm as "Effective Start Datetime",
       effctve_end_dtm as "Effective End Datetime",
       last_rowid_system as "System"
FROM cmx_ors.c_lkp_stndrd