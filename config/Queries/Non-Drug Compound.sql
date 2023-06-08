select
non_drg_cmpnd_cd as "Concept Code",
non_drg_cmpnd_desc as "Concept Name",
non_drg_src_cd as "Non Drug Source Code",
non_drg_src_desc as "Non Drug Source Description",
non_drg_defn as "Defenition",
lang_cd as "Language Code",
effctv_strt_dt as "Effective Start Datetime",
effctv_end_dt as "Effective End Datetime",
CASE 
 WHEN
  UPPER(sts_flg) = 'A'
 THEN 'N'
 WHEN
  UPPER(sts_flg) = 'I'
 THEN 'Y'
END as "Discontinued Flag Y or N",
replace(sts_chng_rsn,'"','''') as "Discontinued Reason",
std_flg as "STD Flag Y or N",
last_rowid_system as "System"
from cmx_ors.c_lkp_non_drg_cmpnd