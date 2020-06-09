import React from "react";
import { useDispatch } from "react-redux";
import { signUp } from "./authSlice";

const Signup = () => {
  const dispatch = useDispatch();

  return (
    <main>
      <div>Count: {count}</div>
      <button onClick={() => dispatch(signUp())}>Add to count</button>
    </main>
  );
};
