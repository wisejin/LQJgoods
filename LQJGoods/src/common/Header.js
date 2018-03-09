/**
 * Created by liaoqijin on 17/3/14.
 */

import {Platform,} from 'react-native';

const Dimensions = require('Dimensions');
export let SCREEN_WIDTH = Dimensions.get('window').width;
export let SCREEN_HEIGHT = Dimensions.get('window').height;
//导航条高度
export let navHeight = Platform.OS === 'ios'?(SCREEN_HEIGHT===812?90:64):70;

//iOS版本号
export let IOSAPP_VERSION = '1.0';
//下载地址
//export let KDownloadEIHApp_URL = 'http://www.jzypvip.com/prod/jzypvip/alpha/page/download.htm';

//主色调
export let KMainColor = 'rgba(51,103,213,1)';
export let KGrayColor = 'rgba(187,187,187,1)';
export let KLightGrayColor = 'rgba(244,244,244,1)';
export let KLightBlueColor = 'rgba(244,247,249,1)';
export let KBlackColor = 'rgba(62,58,57,1)';

//随机颜色
let KColorArray = [
    'aquamarine','bisque','blueviolet','burlywood', 'cadetblue','coral','cornflowerblue','darkseagreen',
    'darkturquoise', 'dodgerblue','goldenrod','hotpink','khaki','lightblue','lightpink','lightseagreen',
    'mediumvioletred','peachpuff','yellowgreen','teal','tomato','skyblue','sandybrown','saddlebrown'];
export let KRandomColor = KColorArray[Math.floor(Math.random()*KColorArray.length)];
export function KRandomColorFuc(alpha) {
  var r = Math.floor(Math.random()*256);
  var g = Math.floor(Math.random()*256);
  var b = Math.floor(Math.random()*256);
  return "rgba("+r+','+g+','+b+','+alpha+")";//所有方法的拼接都可以用ES6新特性`其他字符串{$变量名}`替换
}