from loguru import logger

def generate_json(df, vocabulary, system, mdmsysnameflag,):
    try:
        calst = []
        
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
                    
                    calst.append({
                    "conceptCode": row["Concept_Code"],
                    "propertyName": col.replace("_"," "),
                    "conceptAttributeName": row[col],
                    "vocabularyName": vocabulary,
                    "systemName": sys
                    })

        return {"data": calst, "status": 0, "error": None} 
    except Exception as error:
        logger.info("execution failed!")
        logger.info("below exception encountered in concept_attribute.generate_json...")
        logger.info(error)
        
        return {"data": None, "status": -1, "error": str(error)} 