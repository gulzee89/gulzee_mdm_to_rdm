select
mu.mlstn_usg_cd || '-' || mt.mlstn_typ_desc as "Concept Code",
mu.mlstn_usg_cd || '-' || mt.mlstn_typ_desc as "Concept Name",
mlc.effctve_strt_dtm as "Effective Start Datetime",
mlc.effctve_end_dtm as "Effective End Datetime",
mlc.dscntnd_flg as "Discontinued Flag Y or N",
mlc.dscntnd_rsn as "Discontinued Reason",
mlc.last_rowid_system as "System"
from
cmx_ors.c_rel_mlstn_clsfctn mlc,
cmx_ors.c_lkp_mlstn mu,
cmx_ors.c_lkp_mlstn_typ mt
where
mlc.rowid_mlstn_typ = mt.rowid_object
and mlc.rowid_mlstn_usg = mu.rowid_object