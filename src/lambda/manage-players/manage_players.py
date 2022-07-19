import os
import dynamoDB

contacts_table_name = os.environ['contacts_table']

def handle_manage_players(body_json):
    player_states = dynamoDB.get_attribute_from_all(contacts_table_name, 'playing')
