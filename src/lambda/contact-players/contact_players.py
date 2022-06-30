import os
import dynamoDB
import pinpoint

contacts_table_name = os.environ['contacts_table']

def handle_contacting_players(body_json):
    phone_numbers = dynamoDB.get_attribute_from_all(contacts_table_name, 'phone_number')
    print('phone numbers: {}'.format(phone_numbers))

    pinpoint.send_messages(phone_numbers, 'initial')
