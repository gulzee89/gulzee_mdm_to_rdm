select
blndng_typ as "Concept Code",
blndng_typ_shrt_desc as "Concept Name",
blndng_cdisc_cd as "Blinding Type CDISC Code",
defn as "Defenition",
blndng_typ_lng_desc as "Blinding Type Long Description",
effctv_strt_dt as "Effective Start Datetime",
effctv_end_dt as "Effective End Datetime",
usr_cmmnt as "Comments",
last_rowid_system as "System"
from
cmx_ors.c_lkp_blndng_typ