import { BehaviorSubject } from "rxjs";
import { mergeMap } from "rxjs/operators";
import { combineEpics } from "redux-observable";

import * as counterEpics from "../features/counter/counterEpics";

export const createEpicSubject = (epics) =>
  new BehaviorSubject(combineEpics(...Object.values(epics)));

export const createRootEpic = (epic$) => (...args) =>
  epic$.pipe(mergeMap((epic) => epic(...args)));

export default combineEpics(counterEpics);
