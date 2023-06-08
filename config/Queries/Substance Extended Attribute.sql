select
sb.sbstnce_cd || '-' ||
st.sbstnce_extnd_attr_typ || '-' ||
sea.sbstnce_extnd_attr_value || '-' ||
case 
  when c.cntry_cd is null
  then '#'
  else c.cntry_cd
end as "Concept Code",
sea.sbstnce_extnd_attr_value as "Concept Name",
case 
  when sea.rowid_sts = '1'
  then 'N'
  else 'Y'
end as "Discontinued Flag Y or N",
sea.sts_chnge_rsn as "Discontinued Reason",
sea.effctve_strt_dt as "Effective Start Datetime",
sea.effctve_end_dt as "Effective End Datetime",
sea.dfult_gnrc_nm_flg as "Default Generic Name Flag Y or N",
sea.ctms_compound as "CTMS Compound Y or N"
from
cmx_ors.c_bo_sbstnce_extnd_attr sea
INNER JOIN cmx_ors.c_bo_sbstnce sb
ON sea.rowid_sbstnce_cd = sb.rowid_object
INNER JOIN cmx_ors.c_lkp_sbstnc_ext_atr_typ st
ON sea.rowid_sbstnce_extnd_typ = st.rowid_object
LEFT JOIN cmx_ors.c_lkp_genrc_nm_app_agncy ga
ON sea.rowid_gnrc_nm_app_agncy = ga.rowid_object
LEFT JOIN cmx_ors.c_lkp_cntry c
ON sea.rowid_cntry = c.rowid_object