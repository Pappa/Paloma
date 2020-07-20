from gremlin_python import statics
from gremlin_python.structure.graph import Graph
from gremlin_python.process.graph_traversal import __
from gremlin_python.process.strategies import *
from gremlin_python.process.traversal import T, P, Operator, WithOptions
from gremlin_python.driver.driver_remote_connection import DriverRemoteConnection
from gremlin_python.driver.tornado.transport import (TornadoTransport)
import logging
import os
import sys
import json

map_user = __.project("id", "label", "email", "username").by(
    T.id).by(T.label).by("email").by("username")


class PalomaGraph:

    def __init__(self, addr):
        graph = Graph()
        self.g = graph.traversal().withRemote(
            DriverRemoteConnection(f"wss://{addr}:8182/gremlin", "g"))

    def add_user(self, sub: str, email: str, username: str):
        if (sub and email and username):
            self.g.V().hasLabel("user").has("email", email).fold().coalesce(
                __.unfold(),
                __.addV("user").property(
                    T.id, sub).property(
                    "email", email).property("username", username)
            ).next()
        else:
            raise Exception(
                f"Missing user details. sub: {sub} | Email: {email} | Username: {username}")

    def get_user_by_sub(self, sub: str):
        return self.g.V().hasLabel("user").has(T.id, sub).limit(1).flatMap(map_user).toList()[0]

    def get_user_by_email(self, email: str):
        return self.g.V().hasLabel("user").has("email", email).limit(1).flatMap(map_user).toList()[0]

    def get_graph(self):
        return self.g.V().valueMap().with_(WithOptions.tokens).toList()

    def drop_graph(self):
        return self.g.V().drop().iterate()
