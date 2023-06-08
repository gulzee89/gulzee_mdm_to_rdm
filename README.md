# mdids-ihub-mdm-to-rdm-migration

## Getting Started

mdids-ihub-mdm-to-rdm-migration repository is used to install MDIDS InfoHub MDM to RDM Data Migration Components in EDB Environments

## Dependencies

```
mdids-ihub-mdm-to-rdm-migration is dependent on the below repositories:
- mdids-ihub-core-iam
```

## Overview of the stacks created

```
edb_mdids_infohub_mdm_to_rdm_migration                 <-- Glue Job
edb_mdids_infohub_mdm_to_rdm_ondemand                  <-- Glue Job Trigger
edb-mdids-ihub-mdm-to-rdm-connection                   <-- Glue Job Connection
awsedb-md-mdm-database                                 <-- MDM Database Secret
```

## Directory Structure

```
.
├── .github                                            <-- Directory for CODEOWNERS, CODEQL and Dependabot Setup
code
│   └── mdids_ihub_mdm_to_rdm_migration.py             <-- Glue job code
├── config                                             <-- Directory for Glue job python packages and configurations
├── design                                             <-- Directory with design flow details
├── lib                                                <-- Directory with RDM File Format conversion python package
├── README.MD                                          <-- This instructions file
├── buildspec.yml                                      <-- SAM BuildSpec file
├── params.dev.json                                    <-- CodePipeline Parameter File
├── params.qa.json                                     <-- CodePipeline Parameter File
├── params.prod.json                                   <-- CodePipeline Parameter File
├── post-deploy-buildspec.yml                          <-- SAM PostBuildSpec file
└── template.yaml                                      <-- SAM CloudFormation template
```
