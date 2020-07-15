
import logging
import os
import sys
import json

from paloma_graph import PalomaGraph


def handler(event, context):
    db = os.getenv('NEPTUNE_CLUSTER_ADDRESS')
    logging.info(f"NEPTUNE_CLUSTER_ADDRESS: {db}")

    event_string = json.dumps(event, sort_keys=True, indent=4)
    logging.info(f"event: {event_string}")
    print(f"event: {event_string}")

    try:
        paloma = PalomaGraph(f"wss://{db}:8182/gremlin")
    except Exception as e:
        return e

    return event
