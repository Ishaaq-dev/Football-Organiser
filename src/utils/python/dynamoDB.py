import boto3 as aws
dynamoDB = aws.client('dynamodb')

def get_attribute_from_all(table_name, attribute, data_type='S'):
    result = dynamoDB.scan(
        TableName=table_name,
        Select='SPECIFIC_ATTRIBUTES',
        ProjectionExpression=attribute
    )
    response = [ player.get(attribute).get(data_type) for player in result.get('Items') ]
    return response