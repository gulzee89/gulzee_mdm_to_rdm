from loguru import logger

def generate_json(df, vocabulary, ):
    try:
        _rlst = []
        for row in df.collect():
            for col in df.columns:
                if col.lower() not in ("concept_code", "concept_name", "system") and row[col] != None and str(row[col]).strip() != "" and str(row["Concept_Code"]).strip() != "" and row["Concept_Code"] != None:
                    if {
                        "relationName": col.replace("_"," "),
                        "tiedToVoc": vocabulary
                    } not in _rlst:
                        _rlst.append({
                            "relationName": col.replace("_"," "),
                            "tiedToVoc": vocabulary
                    })

        return {"data": _rlst, "status": 0, "error": None} 
    except Exception as error:
        logger.info("execution failed!")
        logger.info("below exception encountered in relation.generate_json...")
        logger.info(error)
        
        return {"data": None, "status": -1, "error": str(error)} 