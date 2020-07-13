import json
import sys
import os


def handler(event, context):
    db = os.getenv('NEPTUNE_CLUSTER_ADDRESS')
    print(f"NEPTUNE_CLUSTER_ADDRESS: {db}")
    body = {
        "message": "Python Function executed successfully!"
    }
    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }
    return response
