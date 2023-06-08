select
sb.sbstnce_cd || '-' ||
st.sbstnce_extnd_attr_typ || '-' ||
sea.sbstnce_extnd_attr_value || '-' ||
case 
  when c.cntry_cd is null
  then '#'
  else c.cntry_cd
end as "Concept Code",
sb.sbstnce_cd as "Substance",
st.sbstnce_extnd_attr_typ as "Substance Extended Attribute Type",
ga.genrc_nm_app_agncy as "Generic Name Approving Agency",
case 
  when c.cntry_cd is null
  then null
  else c.cntry_shrt_desc || ' (' || c.cntry_cd || ')'
end as "Country"
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