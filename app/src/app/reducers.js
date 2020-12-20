import { combineReducers } from "redux";

import auth from "../features/auth/authSlice";
import loft from "../features/loft/loftSlice";

export default combineReducers({ auth, loft });
