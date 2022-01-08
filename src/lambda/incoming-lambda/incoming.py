import os
import json
import boto3 as aws
import uuid

dynamoDB = aws.client('dynamodb')
contact_table_name = os.environ['contacts_table')


def handle_incoming_message(body_json):
    message = json.loads(body_json['Message'])
    origin_number = message['originationNumber']
    message_body = message['messageBody']
    message_keyword = message['messageKeyword']

    print("Origin number: %s \nMessageBody: %s \nMessageKeyword: %s" %
          (origin_number, message_body, message_keyword))

    object_for_dynamo = {
        "id": {
            "S": str(uuid.uuid4())
        },
        "origin_number": {
            "S": origin_number
        },
        "message_body": {
            "S": message_body
        },
        "message_keyword": {
            "S": message_keyword
        }
    }
    print(object_for_dynamo)
    result = dynamoDB.put_item(
        TableName=contact_table_name,
        Item=object_for_dynamo
    )
    print(result)
