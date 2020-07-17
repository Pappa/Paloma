import logging
import os
import sys
import json

from src.functions.lib.paloma_graph import PalomaGraph


logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    db = os.getenv('NEPTUNE_CLUSTER_ADDRESS')
    logging.info(f"NEPTUNE_CLUSTER_ADDRESS: {db}")

    try:
        paloma = PalomaGraph(db)

        if (event["httpMethod"] == "POST"):
            if (event["resource"] == "/graph/users"):
                body = json.loads(event["body"])
                email = body["email"]
                username = body["username"]

                paloma.add_user(email, username)

                graph = paloma.get_user(email)

        logging.info(f"graph: {json.dumps(graph, sort_keys=True, indent=4)}")

        response_body = {
            "event": event,
            "graph": graph
        }
        response = {
            "statusCode": 200,
            "body": json.dumps(response_body)
        }
        return response

    except Exception as e:
        logging.error(e, exc_info=True)
        response_body = {
            "event": event,
            "error": str(e)
        }
        response = {
            "statusCode": 500,
            "body": json.dumps(response_body)
        }
        return response
