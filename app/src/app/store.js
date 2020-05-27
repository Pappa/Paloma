import { configureStore } from "@reduxjs/toolkit";
import { compose, applyMiddleware } from "redux";
import reducer from "./reducers";
import { createEpicMiddleware } from "redux-observable";
import epics, { createEpicSubject, createRootEpic } from "./epics";

export const initStore = (dependencies = {}) => {
  const composeMiddleware = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__
    ? window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__
    : compose;

  const epicMiddleware = createEpicMiddleware(/*{ dependencies }*/);
  const epic$ = createEpicSubject(epics);
  const rootEpic = createRootEpic(epic$);

  const store = configureStore({
    reducer,
    middleware: [epicMiddleware], //composeMiddleware(applyMiddleware(epicMiddleware)),
  });

  epicMiddleware.run(rootEpic);

  return store;
};
