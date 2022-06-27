import json

from contact_players import handle_contacting_players

def process_event(event, context):
    body = event.get('Records')[0].get('body')
    body_json = json.loads(body)
    handle_contacting_players(body_json)
    return {
        'statusCode': 200,
        'body': body_json
    }