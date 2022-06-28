import os
import boto3 as aws

dynamoDB = aws.client('dynamodb')
contact_table_name = os.environ['contacts_table']

def handle_contacting_players(body_json):
    # I would like to create a utils layer that handles dynamodb requests
    phone_numbers = dynamoDB.scan(
        TableName=contact_table_name,
        Select='SPECIFIC_ATTRIBUTES',
        ProjectionExpression='phone_number'
    )
    print('phone numbers: {}'.format(phone_numbers))