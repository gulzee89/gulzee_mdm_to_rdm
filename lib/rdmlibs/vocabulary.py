import pandas as pd
from loguru import logger

def generate_json(vocabulariesfilepath, propertiesfilepath, vocabulary, system,):
    try:
        plist = []
        vlst = []
        vocversion = None
        conceptcodelength = None
        clengthfixed = None
        mandatoryrelationships = None

        df_pmeta = pd.read_csv(propertiesfilepath)
        df_vmeta = pd.read_csv(vocabulariesfilepath)

        df_prop = df_pmeta[(df_pmeta["Vocabulary Name"] == vocabulary) & (df_pmeta["Nullable"] == "N")]
        df_voc = df_vmeta[df_vmeta["Vocabulary Name"] == vocabulary]

        for index, vrow in df_voc.iterrows():
            vocversion = vrow["Vocabulary Version"]
            conceptcodelength = vrow["Concept Code Length"]
            clengthfixed = vrow["Concept Code Fixed Length"]
            mandatoryrelationships = vrow["Mandatory Relationships"]
            vocdesc = vrow["Vocabulary Description"]

        for index, row in df_prop.iterrows():
            if row["Property Name"].lower().strip() not in ("concept name", "concept code"):
                plist.append(row["Property Name"].strip())

        vlst.append({
                "vocabularyName":vocabulary,
                "vocabularyDesc":vocdesc,
                "vocabularyVersion": str(vocversion),
                "mandatoryProperties":str(plist).strip("[").strip("]").replace(",",";").replace("'",""),
                "mandatoryRelationships": mandatoryrelationships,
                "conceptCodeLength":str(conceptcodelength),
                "isCodeLengthFixed":clengthfixed,
                "systemName":system
            })

        return {"data": vlst, "status": 0, "error": None} 
    except Exception as error:
        logger.info("execution failed!")
        logger.info("below exception encountered in vocabulary.generate_json...")
        logger.info(error)
        
        return {"data": None, "status": -1, "error": str(error)} 