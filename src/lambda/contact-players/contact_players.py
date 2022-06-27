import os
import json
import boto3 as aws

dynamoDB = aws.client('dynamodb')
contact_table_name = os.environ['contacts_table']

def handle_contacting_players(body_json):
    items = dynamoDB.scan(
        TableName=contact_table_name
    )
    print('items: {}'.format(items))