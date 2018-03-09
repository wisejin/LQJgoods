/**
 * Created by liaoqijin on 2017/11/16.
 */
import * as ActionTypes from '../actions/ActionTypes.js';
const initialState = {
  type:0,   //1：普通成员   2：上级领导  3：最高权限（董事长或者财务）
};

//permissionStatus


let UserInfoReducer = (state = initialState, action) => {
  var newState = state;
  switch (action.type) {
    case ActionTypes.CHANGE_USER_TYPE:
      newState = Object.assign({}, state, {
        type: action.value,
      });
      return newState;

    default:
      return state
  }
};

export default UserInfoReducer;