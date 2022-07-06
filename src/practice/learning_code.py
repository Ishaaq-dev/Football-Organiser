import boto3 as aws
import json

function = aws.client('lambda')

players = []

ibraheem = {
    'name': 'ibraheem',
    'age': 19
}

yushua = {
    'name': 'yushua',
    'age': 18
}

bilal = {
    "name": "bilal",
    "age": 17
}

yaaseen = {
    'name': 'yaaseen',
    'age': 21
}

ishaaq = {
    'name': 'Ishaaq',
    'age': 25
}

response = function.invoke(
    FunctionName='print_details',
    Payload=json.dumps(bilal)
)



players.append(ibraheem)
players.append(yushua)
players.append(yaaseen)
players.append(bilal)

# print(players)


def print_details(player):
    print('My name is {}'.format(player.get('name')))
    print('I am {} years old'.format(player.get('age')))


print(response.get('Payload').read().decode("utf-8"))

results = [
    {'name': 'ibraheem', 'age': 19},
    {'name': 'yushua', 'age': 18},
    {'name': 'yaaseen', 'age': 21},
    {'name': 'bilal', 'age': 17},
    {'name': 'Ishaaq', 'age': 25}
]
