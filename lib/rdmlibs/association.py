from loguru import logger

def generate_json(df, vocabulary, system, mdmsysnameflag,):
    try:
        alst = []

        for row in df.collect():
            for col in df.columns:

                if mdmsysnameflag.lower() == "y":
                    if str(row["System"]).strip() != "" and row["System"] != None:
                        sys = row["System"].strip()
                    else:
                        sys = system
                else:
                    sys = system

                if col.lower() not in ("concept_code", "concept_name", "system") and row[col] != None and str(row[col]).strip() != "" and str(row["Concept_Code"]).strip() != "" and row["Concept_Code"] != None:
                    alst.append({
                        "conceptCodeFrom": row["Concept_Code"],
                        "conceptCodeTo": row[col],
                        "relationName": col.replace("_"," "),
                        "vocabularyNameFrom": vocabulary,
                        "vocabularyNameTo": col.replace("_"," "),
                        "systemName": sys
                    })

        return {"data": alst, "status": 0, "error": None}
    except Exception as error:
        logger.info("execution failed!")
        logger.info("below exception encountered in association.generate_json...")
        logger.info(error)
        
        return {"data": None, "status": -1, "error": str(error)}