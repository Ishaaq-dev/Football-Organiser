import boto3 as aws
import secrets_manager
import mysql.connector
rds = aws.client('rds')
secrets = secrets_manager.get_secret("rds_credentials")

def put_item(data, table_name)
