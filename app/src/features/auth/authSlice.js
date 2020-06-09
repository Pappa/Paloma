import { createSlice, createAction } from "@reduxjs/toolkit";

export const authSlice = createSlice({
  name: "auth",
  initialState: {
    authenticated: false,
    user: {},
  },
  reducers: {
    signInSuccess: (state, { payload: { username, email } }) => {
      // Not mutating - using Immer library
      state.authenticated = true;
      state.user = {};
    },
    signOutSuccess: (state) => {
      state.authenticated = false;
      state.user = { username, email };
    },
  },
});

export const { signInSuccess, signOutSuccess } = authSlice.actions;

// Additional actions
export const signUp = createAction("auth/signUp");
export const signIn = createAction("auth/signIn");
export const signOut = createAction("auth/signOut");

// Selectors
export const selectIsAuthed = (state) => state.auth.authenticated;

export default authSlice.reducer;
