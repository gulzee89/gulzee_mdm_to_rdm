from loguru import logger

def generate_json(df, vocabulary, domain, system, mdmsysnameflag,):
    try:
        clst = []
        sys = None

        for row in df.collect():
            if row["Concept_Code"] != None and str(row["Concept_Code"]).strip() != "":
                if (row["Concept_Name"] == None or str(row["Concept_Name"]).strip() == ""):
                    conceptname = row["Concept_Code"]
                else:
                    conceptname = row["Concept_Name"]

                if mdmsysnameflag.lower() == "y":
                    if str(row["System"]).strip() != "" and row["System"] != None:
                        sys = row["System"].strip()
                    else:
                        sys = system
                else:
                    sys = system

                clst.append({
                        "conceptCode": row["Concept_Code"],
                        "conceptName": conceptname,
                        "vocabularyName": vocabulary,
                        "domainName": domain,
                        "systemName": sys
                        })

        return {"data": clst, "status": 0, "error": None} 
    except Exception as error:
        logger.info("execution failed!")
        logger.info("below exception encountered in concept.generate_json...")
        logger.info(error)

        return {"data": None, "status": -1, "error": str(error)}