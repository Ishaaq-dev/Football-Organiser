def process_event(event, context):
    return {
        'statusCode': 200,
        'body': event
    }