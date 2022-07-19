from manage_players import handle_manage_players

def process_event(event, context):
    response = handle_manage_players(event)
    return {
        'statusCode': 200,
        'body': response
    }
