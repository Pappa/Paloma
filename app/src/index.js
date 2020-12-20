import React from "react";
import ReactDOM from "react-dom";
import App from "./App";
import { initStore } from "./app/store";
import { Provider } from "react-redux";
import * as serviceWorker from "./serviceWorker";
import Auth from "@aws-amplify/auth";
import config from "./app/config"

Auth.configure({
  userPoolId: "eu-west-1_hOKGydBQa",
  userPoolWebClientId: "1gghnis2ujn0kio3ihd740grkd",
  region: "eu-west-1",
});

const store = initStore({ config });

ReactDOM.render(
  <React.StrictMode>
    <Provider store={store}>
      <App />
    </Provider>
  </React.StrictMode>,
  document.getElementById("root")
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
