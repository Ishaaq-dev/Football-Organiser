import json
from incoming_responses import handle_incoming_responses


def process_event(event, context):
    print('event: {}'.format(event))
    body = event['Records'][0]['body']
    print('body: {}'.format(body))
    body_json = json.loads(body)
    print('body json: {}'.format(body_json))
    handle_incoming_responses(body_json)
    return {
        'statusCode': 200,
        'body': body_json
    }
