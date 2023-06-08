"""Glue job to run MDM to RDM data migration"""
import sys
import json
import csv
import datetime
from dateutil import tz
import boto3
import pandas as pd
from loguru import logger
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame
from pyspark.context import SparkContext
from pyspark.sql.functions import *
from pyspark.sql.types import *

from rdmlibs import (
    concept,
    concept_attribute,
    property,
    vocabulary,
    association,
    relation,
)

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)

# Initializing boto clients
lc = boto3.client("lambda")
sm = boto3.client("secretsmanager")
s3r = boto3.resource("s3")
s3 = boto3.client("s3")

# Capturing timestamp in EST
now = datetime.datetime.now()
to_zone = tz.gettz("America/Indiana/Indianapolis")
est = now.astimezone(to_zone)
esty = est.strftime("%Y")
estm = est.strftime("%m")
estd = est.strftime("%d")
esth = est.strftime("%H")

clst = []
calst = []
plst = []
vlst = []
alst = []
rlst = []
_rlst = []

def raise_incident(event):
    """Function to raise incident in case of an exception"""
    try:

        args = getResolvedOptions(
            sys.argv,
            [
                "JOB_NAME",
                "snowconfigbucket",
                "snowconfigkey",
                "snowlambdaname",
            ],
        )

        job_run_id = args["JOB_RUN_ID"]

        # Reading the content of service-now config file
        content_object = s3r.Object(args["snowconfigbucket"], args["snowconfigkey"])
        snow_parms = json.loads(content_object.get()["Body"].read().decode("utf-8"))

        # Adding othere required key-vales to the snow config json
        error_message = ("MDIDS Glue job execution failed.\nGlue Job Name: "
            + args["JOB_NAME"]
            + "\nJob Run Id: "
            + job_run_id
            + "\nError Details: "
            + "\n"
            + str(event)
            + "\nPlease see the CloudWatch logs for more details.")

        snow_parms["job_name"] = args["JOB_NAME"]
        snow_parms["error_message"] = error_message
        snow_parms["error_obj_name"] = args["JOB_NAME"]

        logger.info("SNOW Config: " + str(snow_parms))

        # Raising incident
        invoke_response = lc.invoke(
            FunctionName=args["snowlambdaname"],
            InvocationType="RequestResponse",
            Payload=json.dumps(snow_parms).encode("utf-8"),
        )
        inc = str(invoke_response["Payload"].read().decode())
        logger.info("Incident#: " + inc)
        logger.info("Service-Now Incident Raised!")

    except Exception as error:
        logger.info("execution failed!")
        logger.info("below exception encountered in raise_incident...")
        logger.info(error)
        sys.exit()

def main():
    """Function to run MDM to RDM data migration"""
    try:
        ## Job Arguments
        args = getResolvedOptions(
            sys.argv,
            [
                "JOB_NAME",
                "paramsfilebucket",
                "paramsfilekey",
                "rdmconfigbucket",
                "rdmconfigkey",
                "rdmfilesbucket",
                "rdmfileskey",
                "secretid",
            ],
        )

        ## RDM File Path
        rdmfilepath = "year="+str(esty)+"/month="+str(estm)+"/date="+str(estd)+"/hour="+str(esth)+"/input/"
        rdmconfigfilepath = "year="+str(esty)+"/month="+str(estm)+"/date="+str(estd)+"/hour="+str(esth)+"/"

        ## Read parameter file
        logger.info("reading parameter file...")
        param_object = s3r.Object(args["paramsfilebucket"], args["paramsfilekey"])
        params = json.loads(param_object.get()["Body"].read().decode("utf-8"))
        logger.info("parameter file read!")
        
        ## Read DB Secret
        logger.info("retriving target db connection details from secrets...")
        auth_token = sm.get_secret_value(SecretId=args["secretid"]).get("SecretString")
        logger.info("db secret read!")
        
        dbcreds = json.loads(auth_token)
        
        ## DB Cred variable declaration
        host = dbcreds["host"]
        user = dbcreds["username"]
        pwd = dbcreds["password"]
        dbname = dbcreds["dbname"]
        port = dbcreds["port"]
        dbtype = dbcreds["engine"]
        
        ## Variable declaration
        projectname = params["rdm-projectname"]
        language = params["language"]
        languagedesc = params["languagedesc"]
        domain = params["domain"]
        domaindesc = params["domaindesc"]
        system = params["system"]
        emaillist = params["email-notifcation-list"]

        generaterelationfile = params["generaterelationfile"]
        generatepropertyfile = params["generatepropertyfile"]
        generatevocabularyfile = params["generatevocabularyfile"]
        generatedomainfile = params["generatedomainfile"]
        generatelanguagefile = params["generatelanguagefile"]

        logger.info("parameter file read!")
        
        ## Create database connection string
        if dbtype.lower() == "postgresql":
            url = (
                "jdbc:postgresql://"
                + host
                + ":"
                + str(port)
                + "/"
                + dbname
            )
        elif dbtype.lower() == "oracle":
            url = (
                "jdbc:oracle:thin:@"
                + host
                + ":"
                + str(port)
                + "/"
                + dbname
            )
        
        logger.info("connection string set!")
        
        ## Export data
        vocabcount = 0
        for vocabularydata in params["vocabularies"]:
            ## Generate Vocabulary JSON
            if generatevocabularyfile.lower() == "y":
                logger.info("generating vocabulary json for vocab "+ vocabularydata["rdm-vocabularyname"] +"...")

                _vlst = vocabulary.generate_json(params["vocabulariesfilepath"], params["propertiesfilepath"], vocabularydata["rdm-vocabularyname"], system,)
                if _vlst["status"] == -1:
                    raise_incident(_vlst["error"])
                    sys.exit()
                else:
                    vlst.extend(_vlst["data"])
                    logger.info("vocabulary json generated!")

            ## Generate Relation JSON
            if vocabularydata["assocqueryfilepath"] and generaterelationfile.lower() == "y":
                logger.info("generating relation json for vocab "+vocabularydata["rdm-vocabularyname"]+"...")
                    
                ## Read SQL Query
                rqry_object = s3r.Object(args["paramsfilebucket"], vocabularydata["assocqueryfilepath"])
                rquery = rqry_object.get()["Body"].read().decode("utf-8")
                    
                rqry = "(" + rquery + ") qry"

                ## Read data from MDM database into dataframe    
                if dbtype.lower() == "postgresql":
                    rpdf = glueContext.spark_session.read\
                                .format("org.apache.spark.sql.execution.datasources.jdbc.JdbcRelationProvider")\
                                .option("url", url)\
                                .option("user", user)\
                                .option("password", pwd)\
                                .option("dbtable", rqry)\
                                .load()
                elif dbtype.lower() == "oracle":
                    rpdf = glueContext.spark_session.read\
                                .format("jdbc")\
                                .option("driver", "oracle.jdbc.driver.OracleDriver")\
                                .option("url", url)\
                                .option("user", user)\
                                .option("password", pwd)\
                                .option("dbtable", rqry)\
                                .load()
                                
                ## Rename columns in dataframe
                for colm in rpdf.columns:
                    rpdf = rpdf.withColumnRenamed(colm, colm.replace(" ","_"))
                    
                ## Convert dataframe to string
                for colm in rpdf.columns:
                    rule = "rpdf." + colm + ".cast('string')"
                    rpdf = rpdf.withColumn(colm, eval(rule))

                _rslst = relation.generate_json(rpdf, vocabularydata["rdm-vocabularyname"],)

                if _rslst["status"] == -1:
                    raise_incident(_rslst["error"])
                    sys.exit()
                else:
                    _rlst.extend(_rslst["data"])
                    logger.info("relation json generated!")

            if vocabularydata["activeflag"].lower() == "y":
                vocabcount = vocabcount + 1
                logger.info(str(vocabcount)+". processing vocabulary " + vocabularydata["rdm-vocabularyname"] + "...")

                vocab = vocabularydata["rdm-vocabularyname"]
                
                ## Read SQL Query
                qry_object = s3r.Object(args["paramsfilebucket"], vocabularydata["queryfilepath"])
                query = qry_object.get()["Body"].read().decode("utf-8")
                
                pquery = "(" + query + ") qry" 

                logger.info("executing query and reading data into dataframe...")
                
                ## Read data from MDM database into dataframe
                if dbtype.lower() == "postgresql":
                    spdf = glueContext.spark_session.read\
                            .format("org.apache.spark.sql.execution.datasources.jdbc.JdbcRelationProvider")\
                            .option("url", url)\
                            .option("user", user)\
                            .option("password", pwd)\
                            .option("dbtable", pquery)\
                            .load()
                elif dbtype.lower() == "oracle":
                    spdf = glueContext.spark_session.read\
                            .format("jdbc")\
                            .option("driver", "oracle.jdbc.driver.OracleDriver")\
                            .option("url", url)\
                            .option("user", user)\
                            .option("password", pwd)\
                            .option("dbtable", pquery)\
                            .load()
                
                logger.info("data read!")
                
                logger.info("renaming columns to replace space with underscore...")
                # Rename columns in dataframe
                for colm in spdf.columns:
                    spdf = spdf.withColumnRenamed(colm, colm.replace(" ","_"))
                logger.info("columns remaned!")
                
                logger.info("typecasting columns to string...")

                ## Convert dataframe to string
                for colm in spdf.columns:
                    rule = "spdf." + colm + ".cast('string')"
                    spdf = spdf.withColumn(colm, eval(rule))
                logger.info("columns typecasted!")
                    
                ## Generate Concept JSON
                logger.info("generating concept json...")
                
                _clst = concept.generate_json(spdf, vocab, domain, system, vocabularydata["mdmsysnameflag"],)
                if _clst["status"] == -1:
                    raise_incident(_clst["error"])
                    sys.exit()
                else:
                    clst.extend(_clst["data"])
                    logger.info("concept json generated!")
                
                ## Generate Concept Attribute JSON
                logger.info("generating concept attribute json...")
                
                _calst = concept_attribute.generate_json(spdf, vocab, system, vocabularydata["mdmsysnameflag"],)
                if _calst["status"] == -1:
                    raise_incident(_calst["error"])
                    sys.exit()
                else:
                    calst.extend(_calst["data"])
                    logger.info("concept attribute json generated!")

                ## Generate Association JSON
                if vocabularydata["assocqueryfilepath"]:
                    logger.info("generating association json...")
                    
                    ## Read SQL Query
                    aqry_object = s3r.Object(args["paramsfilebucket"], vocabularydata["assocqueryfilepath"])
                    aquery = aqry_object.get()["Body"].read().decode("utf-8")
                    
                    aqry = "(" + aquery + ") qry"
                    
                    ## Read data from MDM database into dataframe
                    if dbtype.lower() == "postgresql":
                        aspdf = glueContext.spark_session.read\
                                .format("org.apache.spark.sql.execution.datasources.jdbc.JdbcRelationProvider")\
                                .option("url", url)\
                                .option("user", user)\
                                .option("password", pwd)\
                                .option("dbtable", aqry)\
                                .load()
                    elif dbtype.lower() == "oracle":
                        aspdf = glueContext.spark_session.read\
                                .format("jdbc")\
                                .option("driver", "oracle.jdbc.driver.OracleDriver")\
                                .option("url", url)\
                                .option("user", user)\
                                .option("password", pwd)\
                                .option("dbtable", aqry)\
                                .load()
                        
                    ## Rename columns in dataframe
                    for colm in aspdf.columns:
                        aspdf = aspdf.withColumnRenamed(colm, colm.replace(" ","_"))
                    
                    ## Convert dataframe to string
                    for colm in aspdf.columns:
                        rule = "aspdf." + colm + ".cast('string')"
                        aspdf = aspdf.withColumn(colm, eval(rule))
                    
                    _alst = association.generate_json(aspdf, vocab, system, vocabularydata["mdmsysnameflag"],)

                    if _alst["status"] == -1:
                        raise_incident(_alst["error"])
                        sys.exit()
                    else:
                        alst.extend(_alst["data"])
                        logger.info("association json generated!")

        ## Write Domain File
        domfilepath = None
        if generatedomainfile.lower() == "y":
            domfilepath = 's3://'+args["rdmfilesbucket"]+'/'+args["rdmfileskey"]+rdmfilepath+'domain.csv'
            logger.info("writing domian file on output location...")

            domain_json = '[{"domainName":"'+domain+'", "domainDesc":"'+domaindesc+'", "systemName":"'+system+'"}]'
            dom_df = pd.read_json(domain_json)
            dom_df.to_csv(domfilepath, index=False, quoting=csv.QUOTE_ALL, sep=',', quotechar='"')
            logger.info("domian file written on output location!")

        ## Write Language File
        langfilepath = None
        if generatelanguagefile.lower() == "y":
            langfilepath = 's3://'+args["rdmfilesbucket"]+'/'+args["rdmfileskey"]+rdmfilepath+'language.csv'
            logger.info("writing language file on output location...")

            lang_json = '[{"languageCode":"'+language+'","languageName":"'+languagedesc+'","systemName":"'+system+'"}]'
            lang_df = pd.read_json(lang_json)
            lang_df.to_csv(langfilepath, index=False, quoting=csv.QUOTE_ALL, sep=',', quotechar='"')
            logger.info("language file written on output location!")

        ## Write Vocabulaty File
        vocfilepath = None
        if len(vlst) > 0 and generatevocabularyfile.lower() == "y":
            vocfilepath = 's3://'+args["rdmfilesbucket"]+'/'+args["rdmfileskey"]+rdmfilepath+'vocabulaty.csv'
            logger.info("writing vocabulaty file on output location...")
            voc_df = pd.read_json(json.dumps(vlst))
            voc_df.to_csv(vocfilepath, index=False, quoting=csv.QUOTE_ALL, sep=',', quotechar='"')
            logger.info("vocabulaty file written on output location!")

        # Write Concept File
        confilepath = None
        if len(clst) > 0:
            confilepath = 's3://'+args["rdmfilesbucket"]+'/'+args["rdmfileskey"]+rdmfilepath+'concept.csv'
            logger.info("writing concept file on output location...")
            con_df = pd.read_json(json.dumps(clst))
            con_df.to_csv(confilepath, index=False, quoting=csv.QUOTE_ALL, sep=',', quotechar='"', doublequote=False, escapechar="\\")
            logger.info("concept file written on output location!")

        ## Write Concept-Attribute File
        conafilepath = None
        if len(calst) > 0:
            conafilepath = 's3://'+args["rdmfilesbucket"]+'/'+args["rdmfileskey"]+rdmfilepath+'concept_attribute.csv'
            logger.info("writing concept attribute file on output location...")
            ca_df = pd.read_json(json.dumps(calst))
            ca_df.to_csv(conafilepath, index=False, quoting=csv.QUOTE_ALL, sep=',', quotechar='"', doublequote=False, escapechar="\\")
            logger.info("concept attribute file written on output location!")

        ## Write Association File
        assocfilepath = None
        if len(alst) > 0:
            assocfilepath = 's3://'+args["rdmfilesbucket"]+'/'+args["rdmfileskey"]+rdmfilepath+'concept_association.csv'
            logger.info("writing association file on output location...")
            a_df = pd.read_json(json.dumps(alst))
            a_df.to_csv(assocfilepath, index=False, quoting=csv.QUOTE_ALL, sep=',', quotechar='"', doublequote=False, escapechar="\\")
            logger.info("association file written on output location!")

        ## Write Relation File
        relfilepath = None
        if len(_rlst) > 0 and generaterelationfile.lower() == "y":
            relname = None
            from_vocab = []
            for data in _rlst:
                to_vocab = []
                relname = data["relationName"]
                if relname not in from_vocab:
                    from_vocab.append(relname)
                    for sdata in _rlst:
                        if relname == sdata["relationName"]:
                            if sdata["tiedToVoc"] not in to_vocab:
                                to_vocab.append(sdata["tiedToVoc"])
                    if {
                        "relationName": relname,
                        "relationDesc": "Relationship to " + relname,
                        "tiedToVoc": str(to_vocab).strip("[").strip("]").replace(",",";").replace("'","").replace("<>",""),
                        "systemName":system
                    } not in rlst:
                        rlst.append(
                            {
                                "relationName": relname,
                                "relationDesc": "Relationship to " + relname,
                                "tiedToVoc": str(to_vocab).strip("[").strip("]").replace(",",";").replace("'","").replace("<>",""),
                                "systemName":system
                            }
                        )


            relfilepath = 's3://'+args["rdmfilesbucket"]+'/'+args["rdmfileskey"]+rdmfilepath+'relation.csv'
            logger.info("writing relation file on output location...")
            r_df = pd.read_json(json.dumps(rlst))
            r_df.to_csv(relfilepath, index=False, quoting=csv.QUOTE_ALL, sep=',', quotechar='"')
            logger.info("relation file written on output location!")

        ## Generate Property JSON
        propfilepath = None
        if generatepropertyfile.lower() == "y":
            logger.info("generating property json...")

            _plst = property.generate_json(params["propertiesfilepath"], system,)

            if _plst["status"] == -1:
                raise_incident(_plst["error"])
                sys.exit()
            else:
                plst.extend(_plst["data"])
                logger.info("property json generated!")
            
            ## Write Property File
            if len(plst) > 0:
                propfilepath = 's3://'+args["rdmfilesbucket"]+'/'+args["rdmfileskey"]+rdmfilepath+'property.csv'
                logger.info("writing property file on output location...")
                prop_df = pd.read_json(json.dumps(plst))
                prop_df.to_csv(propfilepath, index=False, quoting=csv.QUOTE_ALL, sep=',', quotechar='"')
                logger.info("property file written on output location!")
        
        ## Write Config file
        if len(clst) > 0:
            logger.info("writing configuration json on output location...")

            config_json = {}

            if projectname:
                config_json["projectname"]= projectname
            if vocfilepath:
                config_json["vocabulary"]= vocfilepath
            if domfilepath:
                config_json["domain"]= domfilepath
            if langfilepath:
                config_json["language"]= langfilepath
            if propfilepath:
                config_json["property"]= propfilepath
            if relfilepath:
                config_json["relation"]= relfilepath
            if confilepath:
                config_json["concept"]= confilepath
            if conafilepath:
                config_json["concept_attribute"]= conafilepath
            if assocfilepath:
                config_json["concept_association"]= assocfilepath
            if emaillist:
                config_json["email_notification_list"]= emaillist
            
            data = json.dumps(config_json, indent = 4)
            s3.put_object(Bucket=args["rdmconfigbucket"], Key=args["rdmconfigkey"]+rdmconfigfilepath+'file_ingestion_config.json', Body=data)
    
            logger.info("configuration json written on output location!")

        logger.info("process completed!")
    except Exception as error:
        logger.info("execution failed!")
        logger.info("below exception encountered in main...")
        logger.info(error)

        ## Raise incident for failure
        raise_incident(error)
        sys.exit()
        

if __name__ == "__main__":
    main()