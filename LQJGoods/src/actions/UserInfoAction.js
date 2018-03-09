/**
 * 用户信息Action
 */
import * as ActionTypes from './ActionTypes';

/************* 状态回调 **********************/
//修改用户类型
export function setUserType(value) {
  return {
    type:ActionTypes.CHANGE_USER_TYPE,
    value:value
  }
}


/*============================= 事件响应 ===========================*/
export function setUserTypeAction(type) {
  return dispatch =>{
    dispatch(setUserType(type));
  }
}

















