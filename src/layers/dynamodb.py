import boto3 as aws
dynamoDB = aws.client('dynamodb')

def get_all_with_attribute(table_name, attribute):
    response = dynamoDB.scan(
        TableName=table_name,
        Select='SPECIFIC_ATTRIBUTES',
        ProjectionExpression=attribute
    )
    return response