import os
import json
import boto3 as aws
from incoming import handle_incoming_message


def process_event(event, context):
    body = event['Records'][0]['body']
    body_json = json.loads(body)
    handle_incoming_message(body_json)
    return {
        'statusCode': 200,
        'body': body_json
    }
