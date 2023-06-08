SELECT
    cs.stdy_alias_cd                        AS "Concept Code",
    fc.facility                             AS "Facility",
    cm.rpc_cd                               AS "Research Project Code",
    CAST(cs.clncl_stdy_nbr AS VARCHAR(100)) AS "Trial Number",
    cs.last_rowid_system AS "System"
FROM
    (SELECT * FROM cmx_ors.c_bo_clncl_stdy
      WHERE stdy_alias_cd  IS NOT NULL) cs
    LEFT JOIN (
        SELECT
            CASE
            WHEN st.stndrd_cd = 'N' THEN
            f.fclty_cd || '-NONSTANDARD'
            ELSE
            f.fclty_cd || '-STANDARD'
            END AS facility,
            f.rowid_object
        FROM
            cmx_ors.c_lkp_fclty f
            INNER JOIN cmx_ors.c_lkp_stndrd st ON f.rowid_stndrd_cd = st.rowid_object) fc 
            ON cs.rowid_fclty = fc.rowid_object
    LEFT JOIN cmx_ors.c_bo_cmpnd cm ON cs.rowid_cmpnd = cm.rowid_object