#!/bin/bash

sudo apt update
sudo apt install postgresql-client -y

RDS_END_POINT=$(aws rds describe-db-instances --region ap-south-1 | jq -r '.DBInstances.[0].Endpoint.Address')
RDS_PORT=$(aws rds describe-db-instances --region ap-south-1 | jq -r '.DBInstances.[0].Endpoint.Port')
RDS_DB_NAME=$(aws rds describe-db-instances --region ap-south-1 | jq -r '.DBInstances.[0].DBName')
RDS_USER_NAME=$(aws rds describe-db-instances --region ap-south-1 | jq -r '.DBInstances.[0].MasterUsername')

export PGPASSWORD=dbpassword

psql -h $RDS_END_POINT -p $RDS_PORT -U $RDS_USER_NAME -d $RDS_DB_NAME -f ./schemas.sql