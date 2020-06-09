import React from "react";
import {
  AmplifyAuthenticator,
  AmplifySignUp,
  AmplifySignIn,
  AmplifySignOut,
} from "@aws-amplify/ui-react";
import { useDispatch } from "react-redux";
import { onAuthStateChange } from "./app/auth";
import partial from "lodash/partial";

function App() {
  const dispatch = useDispatch();
  return (
    <AmplifyAuthenticator
      handleAuthStateChange={partial(onAuthStateChange, dispatch)}
    >
      <AmplifySignUp
        slot="sign-up"
        formFields={[
          {
            type: "username",
            required: true,
          },
          {
            type: "email",
            required: true,
          },
          {
            type: "password",
            required: true,
          },
        ]}
      />
      <AmplifySignIn slot="sign-in" />
      <AmplifySignOut />
    </AmplifyAuthenticator>
  );
}

export default App;
