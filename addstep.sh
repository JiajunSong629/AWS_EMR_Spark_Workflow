#!/bin/bash
clusterid=j-369B43V4PS2A

aws emr add-steps --cluster-id $clusterid \
    --steps Type=Spark,Name="Spark job",ActionOnFailure=CONTINUE,Args=[--deploy-mode,cluster,--master,yarn,s3://emr-workflow-apr16/pyspark_job.py]