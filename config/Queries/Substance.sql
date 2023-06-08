SELECT sbstnce_cd as "Concept Code",
       sbstnce_cd as "Concept Name",
       effctve_strt_dt as "Effective Start Datetime",
       effctve_end_dt as "Effective End Datetime",
       prtflio_sts_chnge_rsn as "Portfolio Status Change Reason",
       comments as "Comments",
       last_rowid_system as "System"
FROM cmx_ors.c_bo_sbstnce sb