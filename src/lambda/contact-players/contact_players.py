import os
import dynamoDB
import pinpoint
import rds

players_table_name = os.environ['players_db']

def handle_contacting_players(body_json):
    phone_numbers = dynamoDB.get_attribute_from_all(players_table_name, 'phone_number')
    print('phone numbers: {}'.format(phone_numbers))

    columns = ('first_name', 'surname', 'phone_number')
    player = ('Maryam', 'Iqbal', '+447806684810')

    rds.insert_row('players', columns, player)

    # pinpoint.send_messages(phone_numbers, 'initial')
