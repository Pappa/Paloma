import { createSlice, createAction } from "@reduxjs/toolkit";

export const counterSlice = createSlice({
  name: "counter",
  initialState: {
    value: 0,
  },
  reducers: {
    increment: (state) => {
      // Not mutating - using Immer library
      state.value += 1;
    },
    decrement: (state) => {
      state.value -= 1;
    },
    incrementByAmount: (state, action) => {
      state.value += action.payload;
    },
  },
});

export const { increment, decrement, incrementByAmount } = counterSlice.actions;

// Additional actions
export const incrementAsync = createAction("counter/incrementAsync");

// Selectors
export const selectCount = (state) => state.counter.value;

export default counterSlice.reducer;
