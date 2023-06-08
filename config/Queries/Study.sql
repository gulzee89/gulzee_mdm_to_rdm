SELECT
    cs.stdy_alias_cd                        AS "Concept Code",
    CASE 
        WHEN
        CAST(cs.clncl_stdy_nbr AS VARCHAR(100)) IS NULL
        THEN
        cs.stdy_alias_cd
        ELSE
        CAST(cs.clncl_stdy_nbr AS VARCHAR(100))
    END                                     AS "Concept Name",
    cs.stdy_desc                            AS "Study Description",
    cs.dscntnd_flg                          AS "Discontinued Flag Y or N",
    cs.comments                             AS "Comments",
    cs.last_rowid_system                    AS "System"
FROM
    cmx_ors.c_bo_clncl_stdy cs
WHERE
    cs.stdy_alias_cd  IS NOT NULL