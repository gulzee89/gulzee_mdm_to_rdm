SELECT d.disease_st_nm || '-' || i.preferred_term_cd as "Concept Code",
       d.disease_st_nm  as "Disease State",
       i.preferred_term_cd as "Indication",
       di.last_rowid_system as "System"
FROM 
cmx_ors.c_rel_disease_indctn di,
cmx_ors.c_lkp_disease d,
cmx_ors.c_lkp_indctn i
WHERE
di.rowid_disease = d.rowid_object
and di.rowid_indctn = i.rowid_object