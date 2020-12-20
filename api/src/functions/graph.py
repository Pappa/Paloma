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

    logging.info(f"httpMethod: {event['httpMethod']}")
    logging.info(f"resource: {event['resource']}")

    try:
        addr = f"wss://{db}:8182/gremlin"
        paloma = PalomaGraph(addr)

        if (event["httpMethod"] == "POST"):
            if (event["resource"] == "/graph/users"):
                body = json.loads(event["body"])
                email = body["email"]
                username = body["username"]
                uid = body["uid"]

                paloma.add_user(uid, email, username)

                graph = paloma.get_user_by_email(email)
                print(graph)

        if (event["httpMethod"] == "POST"):
            if (event["resource"] == "/graph/users/{id}/pigeons"):
                body = json.loads(event["body"])
                uid = body["uid"]
                pigeon = body["pigeon"]

                graph = paloma.add_pigeon(uid, pigeon)
                print(graph)

        if (event["httpMethod"] == "GET"):
            if (event["resource"] == "/graph/users/{id}"):
                uid = event["pathParameters"]["id"]

                graph = paloma.get_user_by_uid(uid)

        if (event["httpMethod"] == "GET"):
            if (event["resource"] == "/graph/users/{id}/pigeons"):
                uid = event["pathParameters"]["id"]

                graph = paloma.get_pigeons_by_uid(uid)

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
