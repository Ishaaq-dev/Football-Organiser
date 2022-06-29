import boto3 as aws

pinpoint = aws.client('pinpoint')

MESSAGE_TYPE = ('TRANSACTIONAL', 'PROMOTIONAL')
MESSAGES = {
    'initial': 'Would you like to play football this Saturday: \n\n-> Accrington Stanley \n-> Thorneyholme Rd BB5 6BD \n\n-> 14:00-15:00 \n\n-> £3.50 \n\nPlease reply: \nyes \nno'
}

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
                    'Body': MESSAGES.get(message),
                    'MessageType': MESSAGE_TYPE[1]
                }
            }
        }
    )
