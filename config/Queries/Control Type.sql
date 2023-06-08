select
cntrl_typ as "Concept Code",
cntrl_typ_shrt_desc as "Concept Name",
cntrl_typ_cdisc_cd as "Control Type CDISC Code",
cntrl_typ_lng_desc as "Control Type Long Description",
defn as "Defenition",
effctv_strt_dt as "Effective Start Datetime",
effctv_end_dt as "Effective End Datetime",
usr_cmmnt as "Comments",
last_rowid_system as "System"
from cmx_ors.c_lkp_cntrl_typ