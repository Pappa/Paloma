
from gremlin_python import statics
from gremlin_python.structure.graph import Graph
from gremlin_python.process.graph_traversal import __
from gremlin_python.process.strategies import *
from gremlin_python.process.traversal import T, P, Operator
from gremlin_python.driver.driver_remote_connection import DriverRemoteConnection
from gremlin_python.driver.tornado.transport import (TornadoTransport)
import logging
import os
import sys
import json


def handler(event, context):
    db = os.getenv('NEPTUNE_CLUSTER_ADDRESS')
    logging.info(f"NEPTUNE_CLUSTER_ADDRESS: {db}")
    event_string = json.dumps(event, sort_keys=True, indent=4)
    logging.info(f"event: {event_string}")

    try:
        g = setup_graph(f"wss://{db}:8182/gremlin")
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

    if (event["httpMethod"] == "POST"):
        if (event["resource"] == "/gremlin/users"):
            body = json.loads(event["body"])
            email = body["email"]
            g.V().hasLabel("user").has('email', email).fold().coalesce(
                __.unfold(),
                __.addV().property('email', email)
            ).next()

    graph = g.V().values("id", "email", "username").toList()
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


def setup_graph(addr):
    return Graph().traversal().withRemote(DriverRemoteConnection(addr, 'g'))
