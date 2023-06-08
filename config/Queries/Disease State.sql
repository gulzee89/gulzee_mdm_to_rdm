SELECT ds.disease_st_nm as "Concept Code",
       ds.disease_st_nm as "Concept Name",
       ds.dscntnd_flg as "Discontinued Flag Y or N",
       ds.dscntnd_rsn as "Discontinued Reason",
       ds.effctve_strt_dtm as "Effective Start Datetime",
       ds.effctve_end_dtm as "Effective End Datetime",
       CAST(da.cstoftd AS VARCHAR(100)) as "Cand Sel To First Tox Dose",
       CAST(da.pre_clncl_dev AS VARCHAR(100)) as "Pre Clinical Development",
       CAST(da.rgstrn AS VARCHAR(100)) as "Registration",
       CAST(da.launch AS VARCHAR(100)) as "Launch",
       CAST(da.phasei AS VARCHAR(100)) as "Phase I",
       CAST(da.phaseii AS VARCHAR(100)) as "Phase II",
       CAST(da.phaseiii AS VARCHAR(100)) as "Phase III",
       ds.last_rowid_system as "System"
FROM cmx_ors.c_lkp_disease ds
LEFT JOIN cmx_ors.c_lkp_dsst_archtyp da 
ON ds.rowid_object = da.rowid_disease