import os
import json

import dynamoDB
contacts_table_name = os.environ['contacts_table']

GAME_INVITE = {
    'accepted': 'yes',
    'rejected': 'no'
}

def handle_incoming_responses(body_json):
    message = json.loads(body_json['Message'])
    phone_number = message['originationNumber']
    player_response = message['messageBody']
    message_keyword = message['messageKeyword']

    print("Phone number: %s \nPlayerResponse: %s \nMessageKeyword: %s" %
          (phone_number, player_response, message_keyword))

    player_info = dynamoDB.get_item(contacts_table_name, 'phone_number', phone_number)
    print('player_info: {}'.format(player_info))

    if not player_info:
        print('Player does not exist. Phone number: {}'.format(phone_number))
        return False

    player_state = False
    if GAME_INVITE['accepted'] in player_response.lower():
        player_state = True
    
    player_info['playing'] = player_state

    dynamoDB.put_item(contacts_table_name, player_info)
