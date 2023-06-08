SELECT genrc_nm_app_agncy as "Concept Code",
       genrc_nm_app_agncy_desc as "Concept Name",
       dscntnd_flg as "Discontinued Flag Y or N",
       dscntnd_dt as "Discontinued Datetime",
       dscntnd_rsn as "Discontinued Reason",
       last_rowid_system as "System"
FROM cmx_ors.c_lkp_genrc_nm_app_agncy