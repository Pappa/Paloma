import { of, from, EMPTY } from "rxjs";
import { ajax } from "rxjs/ajax";
import { switchMap, tap, mapTo, ignoreElements } from "rxjs/operators";
import { ofType } from "redux-observable";
import { signInSuccess } from "../auth/authSlice";
import { fetchPigeons } from "./loftSlice";

export const fetchPigeonsEpic = (action$, state$, { config }) =>
  action$.pipe(
    ofType(signInSuccess.type), 
    tap(action => console.log(action, config)),
    switchMap(({ payload }) => ajax({
      url: `${config.API.BASE_URL}/graph/users/${payload.sub}/pigeons`,
      method: 'GET',
      // headers: {
      //   'Authorization': 'application/json',
      // },
      //"g7qwlp78nh.execute-api.eu-west-1.amazonaws.com/dev/graph/users/512ec9c1-6569-4472-b13b-51825d0702e6/pigeons"
    }).pipe(tap(response => console.log("response", response)))),
    ignoreElements()
  );
