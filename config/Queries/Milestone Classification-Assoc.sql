select
mu.mlstn_usg_cd || '-' || mt.mlstn_typ_desc as "Concept Code",
mu.mlstn_usg_cd as "Milestone Usage",
mt.mlstn_typ_desc as "Milestone Type",
mlc.last_rowid_system as "System"
from
cmx_ors.c_rel_mlstn_clsfctn mlc,
cmx_ors.c_lkp_mlstn mu,
cmx_ors.c_lkp_mlstn_typ mt
where
mlc.rowid_mlstn_typ = mt.rowid_object
and mlc.rowid_mlstn_usg = mu.rowid_object