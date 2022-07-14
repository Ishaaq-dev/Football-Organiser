import os
import dynamoDB
import pinpoint

players_table_name = os.environ['players_db']

def handle_contacting_players(body_json):
    phone_numbers = dynamoDB.get_attribute_from_all(players_table_name, 'phone_number')
    print('phone numbers: {}'.format(phone_numbers))

    pinpoint.send_messages(phone_numbers, 'initial')
