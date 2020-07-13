
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

    try:
        g = setup_graph(f"wss://{db}:8182/gremlin")
        response = {
            "statusCode": 200,
            "body": ""
        }
        return response
    except Exception as e:
        logging.error(e, exc_info=True)
        response = {
            "statusCode": 500,
            "body": str(e)
        }
        return response


def setup_graph(addr):
    graph = Graph()
    logging.info('Trying To Login')
    g = graph.traversal().withRemote(DriverRemoteConnection(addr, 'g'))
    logging.info('Successfully Logged In')
    return g
