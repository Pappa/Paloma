import { configureStore, getDefaultMiddleware } from "@reduxjs/toolkit";
import reducer from "./reducers";
import { createEpicMiddleware } from "redux-observable";
import { createEpicSubject, createRootEpic } from "./utils";
import * as epics from "./epics";

export const initStore = (dependencies = {}) => {
  const epicMiddleware = createEpicMiddleware({ dependencies });
  const epic$ = createEpicSubject(epics);
  const rootEpic = createRootEpic(epic$);

  const store = configureStore({
    reducer,
    middleware: [
      ...getDefaultMiddleware({
        thunk: false,
      }),
      epicMiddleware,
    ],
    devTools: true,
  });

  epicMiddleware.run(rootEpic);

  return store;
};
