SELECT
    sb.sbstnce_cd     AS "Concept Code",
    st.sbstnce_cd_typ AS "Substance Code Type",
    ps.prtflio_sts    AS "Portfolio Status",
    sb.last_rowid_system as "System"
FROM
    cmx_ors.c_bo_sbstnce sb
    INNER JOIN cmx_ors.c_lkp_sbstnce_cd_typ st ON sb.rowid_sbstnce_cd_typ = st.rowid_object
    LEFT JOIN cmx_ors.c_lkp_prtflio_sts    ps ON sb.rowid_prtflio_sts = ps.rowid_object