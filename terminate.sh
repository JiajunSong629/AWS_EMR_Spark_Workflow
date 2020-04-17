#!/bin/bash
clusterid=j-369B43V4PS2A

aws emr modify-cluster-attributes --cluster-id $clusterid --no-termination-protected
aws emr terminate-clusters --cluster-ids $clusterid