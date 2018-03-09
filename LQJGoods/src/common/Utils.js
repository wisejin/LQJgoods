/**
 * Created by liaoqijin on 17/3/14.
 */
//直接对象引入
import {hex_md5} from './MD5.js';
import Storage from './Storage.js';

//默认请求超时时间
let defTimeout = 6000;

const _fetch = (requestPromise, timeout) => {
  let timeoutAction = null;
  const timerPromise = new Promise((resolve, reject) => {
    timeoutAction = () => {
      reject('请求超时');
    }
  });
  setTimeout(()=> {
    timeoutAction()
  }, timeout)
  return Promise.race([requestPromise, timerPromise]);
};

let Util = {
  /*
   * fetch简单封装
   * url:请求接口
   * parameter参数拼接  如:entityName=EIH_MESSAGES&functionType=HOME&pageSize=3&repositoriesType=IMG&status=PUBLISHED&type=BANNER
   * letterUrl简短接口URL   如:/resources/eih/notice/banner/index/search
   * token
   * JSESSIONID
   * functionName功能名
   * successCallback请求回调
   * failCallback请求失败回调
   * \
   *
   * fetch(url ,{method:'GET', credentials:'includes', timeout:10, headers:{
   "sign":signStr,
   "token":token,
   "functionName":functionName,
   "cookie":JSESSIONID
   }})
   .then((response) => response.text())
   .then((responseText) => {
   console.log('response:'+responseText)
   successCallback(JSON.parse((responseText)));
   })
   .catch((err) => {
   alert('错误:'+err);
   failCallback(err);
   });
   * */
  //token请求
  getToken: (url, functionName, successCallback, failCallback, timeout) => {
    console.log('请求来', url, functionName);
    let Fetch = fetch(url, {
      method: 'GET', credentials: 'includes', headers: {
        "functionName": functionName
      }
    });
    //.then((response) => response.text())
    //    .then((responseText) => {
    //        // console.log('response:'+responseText)
    //        successCallback(JSON.parse((responseText)));
    //    })
    //    .catch((err) => {
    //        //alert('错误:'+err);
    //        failCallback(err);
    //    });

    _fetch(Fetch, timeout?timeout:defTimeout)
    .then((response) => response.text())
    .then((responseText) => {
      //console.log('发发发response:'+responseText)
      successCallback(JSON.parse((responseText)));
    })
    .catch((err) => {
      //alert('错误:'+err);
      failCallback(err);
    });
  },

  get: (url, parameter, letterUrl, functionName, successCallback, failCallback, timeout) => {

    //console.log(Storage.getValueForKey("tokenss"));
    //因为这个是存储对象json,所以返回了promise(回调函数),所以要设定一个回调函数给它拿数据 tokenss
    /*
     * 因为这个是存储对象json,所以返回了promise(回调函数),所以要设定一个回调函数给它拿数据 tokenss  而且是异步取出来的
     * 先取到token/JSESSIONID 并生产sign再发送请求
     * */
    //if(token){
    //    var signStr  = getSign(parameter, letterUrl, token)
    //    //url = urlencode(url);
    //    fetch(url ,{method:'GET', credentials:'includes', timeout:10, headers:{
    //        "sign":signStr,
    //        "token":token,
    //        "functionName":functionName
    //    }})
    //        .then((response) => response.text())
    //        .then((responseText) => {
    //            // console.log('response:'+responseText)
    //            successCallback(JSON.parse((responseText)));
    //        })
    //        .catch((err) => {
    //            //alert('错误:'+err);
    //            failCallback(err);
    //        });
    //}else{
    //    Storage.getValueForKey("tokenss").then(function(token){
    //
    //        var signStr = getSign(parameter, letterUrl, token)
    //        //url = urlencode(url);
    //        fetch(url ,{method:'GET', credentials:'includes', timeout:10,headers:{
    //            "sign":signStr,
    //            "token":token,
    //            "functionName":functionName
    //        }})
    //            .then((response) => response.text())
    //            .then((responseText) => {
    //                // console.log('response:'+responseText)
    //                successCallback(JSON.parse((responseText)));
    //            })
    //            .catch((err) => {
    //                //alert('错误:'+err);
    //                failCallback(err);
    //            });
    //
    //    },function(error){
    //
    //    });
    //}

    Storage.getValueForKey("token").then(function (token) {
      //console.log('get请求',url);
      let signStr = getSign(parameter, letterUrl, token);
      //url = urlencode(url);
      let Fetch = fetch(url, {
        method: 'GET', credentials: 'includes', timeout: 10, headers: {
          "sign": signStr,
          "token": token,
          "functionName": functionName
        }
      });
      //.then((response) => response.text())
      //.then((responseText) => {
      //  //console.log('response:'+responseText)
      //  successCallback(JSON.parse((responseText)));
      //})
      //.catch((err) => {
      //  //alert('错误:'+err);
      //  failCallback(err);
      //});

      _fetch(Fetch, timeout?timeout:defTimeout)
      .then((response) => response.text())
      .then((responseText) => {
        //console.log('发发发response:'+responseText)
        successCallback(JSON.parse((responseText)));
      })
      .catch((err) => {
        //alert('错误:'+err);
        failCallback(err);
      });
    }, function (error) {

    });

  },

  post: (url, parameter, letterUrl, functionName, successCallback, failCallback, timeout) => {

    Storage.getValueForKey("token").then(function (token) {
      // console.log('啦啦啦OK:'+token);
      // console.log('登录参数',parameter);
      console.log('post参数:', parameter);
      console.log('post参数token值:', token);
      console.log('post参数url值:', url);
      if ((typeof parameter) !== 'string') {
        parameter = JSON.stringify(parameter);
      }
      var signStr = getSign(parameter, letterUrl, token);
      //url = urlencode(url);
      let Fetch = fetch(url, {
        method: 'POST', credentials: 'includes', timeout: 10, body: parameter, headers: {
          "sign": signStr,
          "token": token,
          "functionName": functionName
        }
      });
      //.then((response) => response.text())
      //.then((responseText) => {
      //  // console.log('response:'+responseText)
      //  successCallback(JSON.parse((responseText)));
      //})
      //.catch((err) => {
      //  //alert('错误:'+err);
      //  failCallback(err);
      //});

      _fetch(Fetch, timeout?timeout:defTimeout)
      .then((response) => response.text())
      .then((responseText) => {
        //console.log('发发发response:'+responseText)
        successCallback(JSON.parse((responseText)));
      })
      .catch((err) => {
        //alert('错误:'+err);
        failCallback(err);
      });
    }, function (error) {

    });
  },
  delete: (url, parameter, letterUrl, functionName, successCallback, failCallback, timeout) => {

    Storage.getValueForKey("token").then(function (token) {
      // console.log('啦啦啦OK:'+token);
      // console.log('登录参数',parameter);
      if ((typeof parameter) !== 'string') {
        parameter = JSON.stringify(parameter);
      }
      var signStr = getSign(parameter, letterUrl, token);
      //url = urlencode(url);
      let Fetch = fetch(url, {
        method: 'DELETE', credentials: 'includes', timeout: 10, body: parameter, headers: {
          "sign": signStr,
          "token": token,
          "functionName": functionName
        }
      });
      //.then((response) => response.text())
      //.then((responseText) => {
      //  // console.log('response:'+responseText)
      //  successCallback(JSON.parse((responseText)));
      //})
      //.catch((err) => {
      //  //alert('错误:'+err);
      //  failCallback(err);
      //});

      _fetch(Fetch,timeout?timeout:defTimeout)
      .then((response) => response.text())
      .then((responseText) => {
        //console.log('发发发response:'+responseText)
        successCallback(JSON.parse((responseText)));
      })
      .catch((err) => {
        //alert('错误:'+err);
        failCallback(err);
      });
    }, function (error) {

    });
  },

  put: (url, parameter, letterUrl, functionName, successCallback, failCallback, timeout) => {

    Storage.getValueForKey("token").then(function (token) {
      // console.log('啦啦啦OK:'+token);
      console.log('put参数:', parameter);
      //console.log(typeof parameter);

      //console.log(typeof parameter);
      if ((typeof parameter) !== 'string') {
        parameter = JSON.stringify(parameter);
      }
      var signStr = getSign(parameter, letterUrl, token);
      //url = urlencode(url);
      let Fetch = fetch(url, {
        method: 'PUT', credentials: 'includes', timeout: 30, body: parameter, headers: {
          "sign": signStr,
          "token": token,
          "functionName": functionName
        }
      })
      //.then((response) => response.text())
      //.then((responseText) => {
      //  console.log('response:' + responseText)
      //  successCallback(JSON.parse((responseText)));
      //})
      //.catch((err) => {
      //  //alert('错误:'+err);
      //  failCallback(err);
      //});

      _fetch(Fetch,timeout?timeout:defTimeout)
      .then((response) => response.text())
      .then((responseText) => {
        //console.log('发发发response:'+responseText)
        successCallback(JSON.parse((responseText)));
      })
      .catch((err) => {
        //alert('错误:'+err);
        failCallback(err);
      });
    }, function (error) {

    });
  }
}


//生成状态码sign
function getSign(parameter, letterUrl, token) {
  var str = parameter + letterUrl + token;
  //MD5加密
  var signStr = hex_md5(urlencode(str));
  return signStr;
}

//urlencode编码
function urlencode(str) {
  str = (str + '').toString();

  return encodeURIComponent(str).replace(/!/g, '%21').replace(/'/g, '%27').replace(/\(/g, '%28').
  replace(/\)/g, '%29').replace(/\*/g, '%2A').replace(/%20/g, '+');
}
export default Util;
