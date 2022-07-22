import os
import dynamoDB

players_table_name = os.environ['players_db']

def handle_manage_players(body_json):
    player_states = dynamoDB.get_attribute_from_all(players_table_name, 'playing')
    