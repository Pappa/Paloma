import { of, from, EMPTY } from "rxjs";
import { switchMap, tap } from "rxjs/operators";
import { ofType } from "redux-observable";
import { signUp } from "./authSlice";
import Auth from "@aws-amplify/auth";

export const incrementEpic = (action$, state$) =>
  action$.pipe(
    ofType(signUp.type),
    tap(console.log.bind(null, "before")),
    switchMap(({ payload: { username, password, email } }) => {
      return from(
        Auth.signUp({
          username,
          password,
          attributes: {
            email,
          },
        })
      ).pipe(tap(console.log.bind(null, "after 1")), of(EMPTY));
    }),
    tap(console.log.bind(null, "after 2"))
  );
