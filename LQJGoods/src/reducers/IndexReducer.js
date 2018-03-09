/**
 * Created by liaoqijin on 2017/11/16.
 */
import * as ActionTypes from '../actions/ActionTypes.js';
const initialState = {
  userInfo:'',
};

//permissionStatus


let IndexReducer = (state = initialState, action) => {
  var newState = state;
  switch (action.type) {
    case ActionTypes.GET_TOKEN_SUCC:
      newState = Object.assign({}, state, {
        userInfo: action.value,
      });
      return newState;

    default:
      return state
  }
}

export default IndexReducer;