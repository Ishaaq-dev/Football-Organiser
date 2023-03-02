import json

from contact_players import handle_contacting_players

def process_event(event, context):
    detail = event.get('detail')
    handle_contacting_players(detail)
    return {
        'statusCode': 200,
        'body': detail
    }
