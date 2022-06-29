import boto3 as aws

pinpoint = aws.client('pinpoint')

MESSAGE_TYPE = ('TRANSACTIONAL', 'PROMOTIONAL')

def send_messages(phone_numbers, message):
    addresses = {}
    for phone_number in phone_numbers:
        addresses[phone_number] = {'ChannelType': 'SMS'}
    
    pinpoint.send_messages(
        ApplicationId='9006a065fb264a43940edb6b872deace',
        MessageRequest={
            'Addresses': addresses,
            'MessageConfiguration': {
                'SMSMessage': {
                    'Body': message,
                    'MessageType': MESSAGE_TYPE[1]
                }
            }
        }
    )