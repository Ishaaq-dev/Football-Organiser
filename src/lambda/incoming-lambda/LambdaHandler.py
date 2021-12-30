import os
import json
import boto3 as aws


def process_event(event, context):
    body = event['Records'][0]['body']
    message = json.loads(body)
    print(message['Message'])
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
