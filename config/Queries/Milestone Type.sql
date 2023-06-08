SELECT mlstn_typ_desc as "Concept Code",
       mlstn_typ_desc as "Concept Name",
       dscntnd_flg as "Discontinued Flag Y or N",
       dscntnd_rsn as "Discontinued Reason",
       effctve_strt_dtm as "Effective Start Datetime",
       effctve_end_dtm as "Effective End Datetime",
       last_rowid_system as "System"
FROM cmx_ors.c_lkp_mlstn_typ