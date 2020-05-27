import { of } from "rxjs";
import { switchMap } from "rxjs/operators";
import { ofType } from "redux-observable";
import { increment, incrementAsync } from "./counterSlice";

export const incrementEpic = (action$, state$) =>
  action$.pipe(
    ofType(incrementAsync.type),
    switchMap(() => of(increment()))
  );
