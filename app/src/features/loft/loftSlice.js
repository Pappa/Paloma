import { createSlice, createAction } from "@reduxjs/toolkit";

export const authSlice = createSlice({
  name: "loft",
  initialState: {
    pigeons: [],
  },
  reducers: {
    fetchPigeonsSuccess: (state, { payload }) => {
      state.pigeons = payload;
    },
  },
});

export const { fetchPigeonsSuccess } = authSlice.actions;

// Additional actions
export const fetchPigeons = createAction("auth/fetchPigeons");

// Selectors
export const selectPigeons = (state) => state.pigeons;

export default authSlice.reducer;
