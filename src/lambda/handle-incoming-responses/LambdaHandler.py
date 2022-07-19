import json
from incoming_responses import handle_incoming_responses


def process_event(event, context):
    body = event['Records'][0]['body']
    body_json = json.loads(body)
    handle_incoming_responses(body_json)
    return {
        'statusCode': 200,
        'body': body_json
    }
