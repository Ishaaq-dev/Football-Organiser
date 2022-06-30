import boto3 as aws
dynamoDB = aws.client('dynamodb')

ACCEPTED_DATATYPES = ['S', 'BOOL']

def get_attribute_from_all(table_name, attribute):
    result = dynamoDB.scan(
        TableName=table_name,
        Select='SPECIFIC_ATTRIBUTES',
        ProjectionExpression=attribute
    )
    players = _remove_datatypes_from_array_of_objects(result.get('Items'))
    response = [player.get(attribute)
                for player in players]
    return response


def get_item(table_name, key, key_value):
    result = dynamoDB.get_item(
        TableName=table_name,
        Key={
            key: {_get_data_type_initial(key_value): key_value}
        }
    )
    return _remove_datatypes_from_object(result.get('Item'))

def put_item(table_name, data):
    object_for_dynamo = _create_object_for_dynamo(data)
    print('object for dynamo: {}'.format(object_for_dynamo))
    result = dynamoDB.put_item(
        TableName=table_name,
        Item=object_for_dynamo
    )
    return result

def _create_object_for_dynamo(object):
    response = {}
    for key in object.keys():
        data = object.get(key)
        response[key] = { _get_data_type_initial(data): data}
    return response

def _get_data_type_initial(data):
    if isinstance(data, bool):
        return 'BOOL'
    else:
        return 'S'

def _remove_datatypes_from_array_of_objects(array_of_objects):
    response = []
    for object in array_of_objects:
        formatted_object = _remove_datatypes_from_object(object)
        if formatted_object:
            response.append(formatted_object)
        
    return response


def _remove_datatypes_from_object(object):
    # A helper function
    # to convert a dynamoDB response from:
    # {
    #   'phone_number': {'S': '+447xxxxxxxxx'}, 
    #   'message_keyword': {'S': 'ENQUIRE'},
    #   'message_body': {'S': 'yes'}, 
    #   'id': {'S': '89b4c956-d07c-4100-a7a5-b5a78221f595'}
    # }
    # to:
    # {
    #   'phone_number': '+447xxxxxxxxx', 
    #   'message_keyword': 'ENQUIRE', 
    #   'message_body': 'yes', 
    #   'id': '89b4c956-d07c-4100-a7a5-b5a78221f595'
    # }
    keys = object.keys()
    response = {}
    
    for key in keys:
        attribute = object.get(key)
        attribute_keys = attribute.keys()
        for attribute_key in attribute_keys:
            if attribute_key in ACCEPTED_DATATYPES:
                response[key] = attribute.get(attribute_key)
    
    return response 
