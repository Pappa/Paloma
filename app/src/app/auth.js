import { signInSuccess, signOut } from "../features/auth/authSlice";

export const onAuthStateChange = (dispatch, state, data) => {
  switch (state) {
    case "signedin":
      dispatch(
        signInSuccess({ username: data.username, email: data.attributes.email, sub: data.attributes.sub })
      );
      break;
    case "signin":
      !data && dispatch(signOut());
      break;
    default:
      break;
  }
};
