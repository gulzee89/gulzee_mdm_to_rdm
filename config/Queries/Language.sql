SELECT lang_cd as "Concept Code",
       lang_desc as "Concept Name",
       lang_alt_cd as "Language Alternate Code",
       effctve_strt_dtm as "Effective Start Datetime",
       effctve_end_dtm as "Effective End Datetime",
       dscntnd_flg as "Discontinued Flag Y or N",
       last_rowid_system as "System"
FROM cmx_ors.c_lkp_lang