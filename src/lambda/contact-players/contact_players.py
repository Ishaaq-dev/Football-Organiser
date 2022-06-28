import os
import json
import boto3 as aws

dynamoDB = aws.client('dynamodb')
contact_table_name = os.environ['contacts_table']

def handle_contacting_players(body_json):
    phone_numbers = dynamoDB.scan(
        TableName=contact_table_name,
        Select='SPECIFIC_ATTRIBUTES',
        ProjectionExpression='phone_number'
    ).get('Items')
    # phone_numbers = [ player.get('phone_number') for player in players ]
    print('phone numbers: {}'.format(phone_numbers))