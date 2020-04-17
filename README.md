# ECE590.24 Data Analysis at Scale in the Cloud

Previous projects:

[NEWS api on Google Cloud Platform](https://github.com/JiajunSong629/NEWS_API_on_Google_Cloud_Platform)

[Jupyter workflows using Docker Container](https://github.com/JiajunSong629/jupyter-workflows-using-docker-container)

Next project:

[Quick implementation of OCR application with AWS Lambda (in build)](https://www.google.com)

## Cloud Map Reduce and Distributed Jobs

This is individual project 3 for my course, [Data Analysis At Scale in Cloud](https://noahgift.github.io/cloud-data-analysis-at-scale/). In this project, I implement a spark workflow on AWS EMR which is similar to real-world applictions: create the cluster, submit a job, add another step and terminate the cluster. In addition to the descriptions below, you can refer to the [screencast demo](https://www.youtube.com/watch?v=c4p97h5LjDQ&t=2s).


### How to build

- Create a S3 bucket. In the bucket upload `pyspark_job.py` and `emr_bootstrap.sh`.
- (Optional) Create a Key pair on EC2 instances.
- In the terminal run the following. These commands create the cluster on AWS EMR and submit a Spark job to the cluster. You can check the cluster status on [AWS EMR](https://console.aws.amazon.com/elasticmapreduce/home?region=us-east-1#). It generally takes 5 minutes for the cluster be ready and run the job. After the job is completed, you can go to the S3 bucket and check the output.

```shell
#!/bin/bash
aws emr create-cluster --name "your-cluster-name" \
    --release-label emr-5.29.0 \
    --applications Name=Spark \
    --log-uri s3://your-bucket/logs/ \
    --ec2-attributes KeyName=emr-key \
    --instance-type m5.xlarge \
    --instance-count 3 \
    --bootstrap-actions Path=s3://your-bucket-name/emr_bootstrap.sh \
    --steps Type=Spark,Name="Your-Spark-job-name",ActionOnFailure=CONTINUE,Args=[--deploy-mode,cluster,--master,yarn,s3://your-bucket-name/pyspark_job.py] \
    --use-default-roles ##--auto-terminate
```

- Open `addstep.sh` and change the variable `clusterid` with your cluster id. In the terminal run the following. This command submits the job again to the running cluster.


```shell
#!/bin/bash
clusterid=j-1AXXXXXXPSXX

aws emr add-steps --cluster-id $clusterid \
    --steps Type=Spark,Name="Spark job",ActionOnFailure=CONTINUE,Args=[--deploy-mode,cluster,--master,yarn,s3://your-bucket-name/pyspark_job.py]

```

- Again open `terminate.sh`, change the variable `clusterid` with your cluster id. In the terminal run the following. This step terminates the cluster to stop being charged for the cluster.

```shell
#!/bin/bash
clusterid=j-1AXXXXXXPSXX

aws emr modify-cluster-attributes --cluster-id $clusterid --no-termination-protected
aws emr terminate-clusters --cluster-ids $clusterid
```

### About the repo

- [`pyspark_job.py`](https://github.com/JiajunSong629/AWS_EMR_Spark_Workflow/blob/master/pyspark_job.py): The main Spark job you submitted to the cluster. Here in the demo this job reads the Amazon book review data, apply filtering and wrangling and output the results to S3 bucket.
- [`emr_bootstrap.sh`](https://github.com/JiajunSong629/AWS_EMR_Spark_Workflow/blob/master/emr_bootstrap.sh): Dependecies you would the cluster environment to be preinstalled. It would be useful if you want to use the notebook instances.
- [`submit_job.sh`](https://github.com/JiajunSong629/AWS_EMR_Spark_Workflow/blob/master/submit_job.sh): Create the cluster and submit a job to it.
- [`addstep.sh`](https://github.com/JiajunSong629/AWS_EMR_Spark_Workflow/blob/master/addstep.sh): Add another step(job) to the running cluster.
- [`terminate.sh`](https://github.com/JiajunSong629/AWS_EMR_Spark_Workflow/blob/master/terminate.sh): Terminate the cluster.


## Resources:
1. [Get started with pyspark on Amazon EMR](https://towardsdatascience.com/getting-started-with-pyspark-on-amazon-emr-c85154b6b921)
2. [AWS Command Line references](https://aws.amazon.com/cli/)
3. [Big Data on Amazon EMR (Elastic MapReduce), run a spark job (GUI and CLI)](https://medium.com/big-data-on-amazon-elastic-mapreduce/run-a-spark-job-within-amazon-emr-in-15-minutes-68b02af1ae16)
4. [Production data processing with Apache Spark](https://towardsdatascience.com/production-data-processing-with-apache-spark-96a58dfd3fe7)