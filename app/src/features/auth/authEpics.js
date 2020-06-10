import { of, from, EMPTY } from "rxjs";
import { switchMap, tap } from "rxjs/operators";
import { ofType } from "redux-observable";
import { signUp } from "./authSlice";
import Auth from "@aws-amplify/auth";

export const authEpic = (action$, state$) =>
  action$.pipe(ofType(signUp.type), tap(console.log.bind(null, "before")));
