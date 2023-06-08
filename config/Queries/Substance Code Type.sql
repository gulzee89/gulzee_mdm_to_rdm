SELECT sbstnce_cd_typ as "Concept Code",
       sbstnce_cd_desc as "Concept Name",
       dscntnd_flg as "Discontinued Flag Y or N",
       dscntnd_dt as "Discontinued Datetime",
       dscntnd_rsn as "Discontinued Reason",
       last_rowid_system as "System"
FROM cmx_ors.c_lkp_sbstnce_cd_typ