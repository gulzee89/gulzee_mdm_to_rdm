select
stdy_phse_cd as "Concept Code",
stdy_phse_shrt_desc as "Concept Name",
stdy_phse_cdisc_cd as "Study Phase CDISC Code",
stdy_phse_lng_desc as "Study Phase Long Description",
defn as "Defenition",
effctv_strt_dt as "Effective Start Datetime",
effctv_end_dt as "Effective End Datetime",
usr_cmmnt as "Comments",
last_rowid_system as "System"
from cmx_ors.c_lkp_stdy_phse