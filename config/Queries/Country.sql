SELECT effctv_strt_dt  as "Effective Start Datetime",
       effctv_end_dt as "Effective End Datetime",
       cntry_shrt_desc || ' (' || cntry_cd || ')'  as "Concept Code",
       cntry_shrt_desc as "Concept Name",
       cntry_lng_desc as "Country Long Description",
       cntry_alt_cd as "Country Alternate Code",
       cntry_cdisc_cd as "Country CDISC Code",
       cntry_alt_desc as "Country Alternate Description",
       last_rowid_system as "System"
FROM cmx_ors.c_lkp_cntry