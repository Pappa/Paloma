import { of } from "rxjs";
import { switchMap, delay } from "rxjs/operators";
import { ofType } from "redux-observable";
import { incrementByAmount, incrementAsync } from "./counterSlice";

export const incrementEpic = (action$, state$) =>
  action$.pipe(
    ofType(incrementAsync.type),
    switchMap(({ payload }) => of(incrementByAmount(payload))),
    delay(1000)
  );
