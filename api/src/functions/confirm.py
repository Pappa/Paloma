
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
        sub = event["request"]["userAttributes"]["sub"]
        email = event["request"]["userAttributes"]["email"]
        username = event["userName"]

        paloma.add_user(sub, email, username)
    except Exception as e:
        logging.error(e)
        return e

    return event
