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


class PalomaGraph:

    def __init__(self, addr):
        graph = Graph()
        self.g = graph.traversal().withRemote(
            DriverRemoteConnection(f"wss://{addr}:8182/gremlin", "g"))

    def add_user(self, email: str, username: str):
        self.g.V().hasLabel("user").has("email", email).fold().coalesce(
            __.unfold(),
            __.addV("user").property(
                "email", email).property("username", username)
        ).next()

    def get_user(self, email: str):
        return self.g.V().hasLabel("user").has("email", email).values(
            "email", "username").limit(1).next()

    def get_graph(self):
        return self.g.V().values("id", "email", "username").toList()
