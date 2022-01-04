import os
import json


def handle_incoming_message(body_json):
    message = json.loads(body_json['Message'])
    origin_number = message['originationNumber']
    message_body = message['messageBody']
    message_keyword = message['messageKeyword']

    print("Origin number: %s \nMessageBody: %s \nMessageKeyword: %s" %
          (origin_number, message_body, message_keyword))

    print("Ibraheem, Bilal, Yushua")
    # from the `message` variable
    # create a json object to put into dynamoDB

    object_to_put_into_dynamo = {
        "name": "saaqy"
    }

    print(object_to_put_into_dynamo)

    object2 = {
        "name": "bilal"
    }

    print(object2)

    object3 = {
        "name": "Ibraheem"
    }

    print(object3)

    object4 = {
        "name": "Yushua"
    }

    print(object4)

    object5 = {
        "name": "Yushua2"
    }

    print(object5)

    object6 = {
        "name": "Yushua3"
    }

    print(object6)
