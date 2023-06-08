SELECT
    CAST(cs.clncl_stdy_nbr AS VARCHAR(100)) AS "Concept Code",
    CAST(cs.clncl_stdy_nbr AS VARCHAR(100)) AS "Concept Name",
    cs.dscntnd_flg                          AS "Discontinued Flag Y or N",
    cs.last_rowid_system                    AS "System"
FROM
    cmx_ors.c_bo_clncl_stdy cs
WHERE
    cs.clncl_stdy_nbr IS NOT NULL
UNION
SELECT
    CAST(cnr.clncl_stdy_nbr AS VARCHAR(100)) AS "Concept Code",
    CAST(cnr.clncl_stdy_nbr AS VARCHAR(100)) AS "Concept Name",
    'N'                                      AS "Discontinued Flag Y or N",
    cnr.last_rowid_system                    AS "System"
FROM
    cmx_ors.c_lkp_clncl_stdy_nbr cnr
WHERE
    cnr.clncl_stdy_nbr NOT IN (SELECT clncl_stdy_nbr FROM cmx_ors.c_bo_clncl_stdy WHERE clncl_stdy_nbr IS NOT NULL)