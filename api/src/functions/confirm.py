
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
        email = event["request"]["userAttributes"]["email"]
        username = event["userName"]
        if (email and username):
            paloma.add_user(email, username)
        else:
            raise Exception(
                f"Missing user details. Email: {email} Username: {username}")
    except Exception as e:
        logging.error(str(e))
        return e

    return event
