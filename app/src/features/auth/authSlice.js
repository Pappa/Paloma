import { createSlice, createAction } from "@reduxjs/toolkit";

export const authSlice = createSlice({
  name: "auth",
  initialState: {
    authenticated: false,
    user: {},
  },
  reducers: {
    signInSuccess: (state, { payload }) => {
      // Not mutating - using Immer library
      state.authenticated = true;
      state.user = payload;
    },
    signOut: (state) => {
      state.authenticated = false;
      state.user = {};
    },
  },
});

export const { signInSuccess, signOut } = authSlice.actions;

// Additional actions
export const signUp = createAction("auth/signUp");
export const signIn = createAction("auth/signIn");

// Selectors
export const selectIsAuthed = (state) => state.auth.authenticated;

export default authSlice.reducer;
