#!/bin/bash
aws emr create-cluster --name "FromCloud9-demo" \
    --release-label emr-5.29.0 \
    --applications Name=Spark \
    --log-uri s3://your-bucket/logs/ \
    --ec2-attributes KeyName=emr-key \
    --instance-type m5.xlarge \
    --instance-count 3 \
    --bootstrap-actions Path=s3://emr-workflow-apr16/emr_bootstrap.sh \
    --steps Type=Spark,Name="Spark job",ActionOnFailure=CONTINUE,Args=[--deploy-mode,cluster,--master,yarn,s3://emr-workflow-apr16/pyspark_job.py] \
    --use-default-roles ##--auto-terminate
