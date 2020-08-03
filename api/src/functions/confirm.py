
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
        addr = f"wss://{db}:8182/gremlin"
        paloma = PalomaGraph(addr)
        uid = event["request"]["userAttributes"]["sub"]
        email = event["request"]["userAttributes"]["email"]
        username = event["userName"]

        paloma.add_user(uid, email, username)
    except Exception as e:
        logging.error(e)
        return e

    return event
