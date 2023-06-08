select
dsgn_typ as "Concept Code",
dsgn_typ_shrt_desc as "Concept Name",
dsgn_typ_cdisc_cd as "Design Type CDISC Code",
dsgn_typ_lng_desc as "Design Type Long Description",
defn as "Defenition",
effctv_strt_dt as "Effective Start Datetime",
effctv_end_dt as "Effective End Datetime",
usr_cmmnt as "Comments",
last_rowid_system as "System"
from cmx_ors.c_lkp_dsgn_typ