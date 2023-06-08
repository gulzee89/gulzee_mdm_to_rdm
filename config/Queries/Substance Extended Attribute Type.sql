SELECT sbstnce_extnd_attr_typ as "Concept Code",
       sbstnce_extnd_attr_desc as "Concept Name",
       dscntnd_flg as "Discontinued Flag Y or N",
       dscntnd_dt as "Discontinued Datetime",
       dscntnd_rsn as "Discontinued Reason",
       last_rowid_system as "System"
FROM cmx_ors.c_lkp_sbstnc_ext_atr_typ