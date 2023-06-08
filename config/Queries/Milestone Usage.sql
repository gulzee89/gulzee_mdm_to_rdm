SELECT 
       mlstn_usg_cd as "Concept Code",
       mlstn_desc as "Concept Name",
       mlstn_usg_desc as "Milestone Usage Description",
       dscntnd_rsn as "Discontinued Reason",
       CAST(mlstn_strt_fnsh AS VARCHAR(100)) as "Milestone Start Finish",
       dscntnd_flg as "Discontinued Flag Y or N",
       effctve_strt_dtm as "Effective Start Datetime",
       effctve_end_dtm as "Effective End Datetime",
       last_rowid_system as "System"
FROM 
cmx_ors.c_lkp_mlstn