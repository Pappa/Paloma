import { signInSuccess, signOutSuccess } from "../features/auth/authSlice";

export const onAuthStateChange = (dispatch, state, data) => {
  switch (state) {
    case "signedin":
      dispatch(
        signInSuccess({ username: data.username, email: data.attributes.email })
      );
  }
};
