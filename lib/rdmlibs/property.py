import pandas as pd
from loguru import logger

def generate_json(propertiesfilepath, system,):
    try:
        plst = []

        df_meta = pd.read_csv(propertiesfilepath)
        df_meta = df_meta.fillna("<>")

        df_dist_meta = df_meta[["Property Name","Data Type","Precision","Fixed Length","Values From"]]
        df_dist_meta = df_dist_meta.drop_duplicates()

        for index, drow in df_dist_meta.iterrows():
            df_prop = df_meta[(df_meta["Property Name"] == drow["Property Name"]) &
                            (df_meta["Data Type"] == drow["Data Type"]) &
                            (df_meta["Precision"] == drow["Precision"]) &
                            (df_meta["Fixed Length"] == drow["Fixed Length"]) &
                            (df_meta["Values From"] == drow["Values From"])]

            vlist = []
            for index, row in df_prop.iterrows():
                if row["Property Name"].lower().strip() not in ("concept name", "concept code"):
                    if row["Vocabulary Name"].strip() not in vlist:
                        vlist.append(row["Vocabulary Name"].strip())

            plst.append({
                "propertyName":drow["Property Name"],
                "propertyDesc":drow["Property Name"],
                "propertyType":drow["Data Type"],
                "propertyLength":str(drow["Precision"]).replace("-1",""),
                "isFixedLength":drow["Fixed Length"],
                "tiedToVoc":str(vlist).strip("[").strip("]").replace(",",";").replace("'","").replace("<>",""),
                "valuesFromVoc":drow["Values From"].replace("<>",""),
                "systemName":system
            })

        return {"data": plst, "status": 0, "error": None} 
    except Exception as error:
        logger.info("execution failed!")
        logger.info("below exception encountered in property.generate_json...")
        logger.info(error)
        
        return {"data": None, "status": -1, "error": str(error)} 