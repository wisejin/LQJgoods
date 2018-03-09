/**
 * Created by liaoqijin on 17/3/20.
 */
import {AsyncStorage} from 'react-native';

export default class Storage{

  /*
  //通过key取值
  static getValuesForKey(key){
    AsyncStorage.multiGet(key, (err, stores) => {
      try {
        stores.map((result, i, store) => {
          // get at each store's key/value so you can work with it
          let key = store[i][0];
          let value = store[i][1];
          if (value)items.push(JSON.parse(value));
        });
        resolve(items);
      } catch (e) {
        reject(e);
      }
    });
  }

  //增
  static saveWithKeyValue(key, value){
    try {
      return AsyncStorage.setItem(key, value, (error)=>{
        if (error){
          alert('存值失败:',error);
          console.log("保存失败 key:value =>", key, value);
        }else{
          alert('存值成功:',key+':'+value);
          console.log("保存成功 key:value =>", key, value);
        }
      });
    }catch(error){
      console.log('保存失败:'+error);
    }
  }

  //查
  static getValueForKey(key) {
    try {
      return AsyncStorage.getItem(key, (error,result)=>{
        if (error){
          alert('取值失败:'+error);
          console.log("取值成功: =>", result);
        }else{
          alert('取值成功:'+result);
          console.log("取值成功: =>", result);
        }
      })
    }catch(error){
      console.log("取值失败: =>", error);
    }
  }

  //删
  static removeValueForKey(key){
    try{
      return AsyncStorage.removeItem(key, (error)=>{
        console.log("删除值 key:", key);
        if(!error){
          alert('移除成功');
          console.log("删除成功: =>", key);
        }else{
          console.log("删除失败: =>", error);
        }
      });
    }catch(error) {
      console.log("删除失败: =>", error);
    }
  }

  ////合并更新 merge
  //static mergeArrayWithKeyValue(key,value) {
  //  try {
  //    return Storage.getValueForKey(key).then((val)=>{
  //      if (typeof val === 'undefined' || val === null) {
  //        Storage.saveWithKeyValue(key,[value]);
  //        console.log(`key: ${key} is undefined, save array`);
  //      } else {
  //        val.unshift(value);
  //        Storage.saveWithKeyValue(key,val);
  //      }
  //    })
  //  } catch(e) {
  //    console.log(e);
  //  }
  //}
  */

  // 增
  static saveWithKeyValue(key,value) {
    try {
      return AsyncStorage.setItem(key, JSON.stringify(value), (error)=>{
        console.log("save success with key:value => ",key, value,error);
        if(error){
          return false;
        }else{
          return true;
        }
      });
    } catch(e) {
      console.log(e);
    }
  }


  // 查
  static getValueForKey(key) {
    try {
      return AsyncStorage.getItem(key, (value)=>{
        console.log("trying to get value with key :", key);
        //return JSON.parse(value);
      }).then((value)=>{
        // console.log("渠道值 :", value);
        return JSON.parse(value);
        //return value;
      },
      (e) => {
        console.log("------eeeeeeeee",e);
      });
    } catch(e) {
      console.log(e);
    }
  }

  //static getValueForKey(key) {
  //  try {
  //    return new Promise(function(resolve,reject) {
  //      AsyncStorage.getItem(key, ()=>{
  //        console.log("trying to get value with key :", key);
  //      }).then((value)=>{
  //        resolve(JSON.parse(value))
  //      })
  //    })
  //  } catch(e) {
  //    console.log(e);
  //  }
  //}

  // 删
  static removeValueForKey(key) {
    try {
      return AsyncStorage.removeItem(key, ()=>{
        console.log("remove value for key: ",key);
      });
    } catch(e) {
      console.log(e);
    }
  }

  // merge
  static mergeArrayWithKeyValue(key,value) {
    try {
      return Storage.getValueForKey(key).then((val)=>{
        if (typeof val === 'undefined' || val === null) {
          Storage.saveWithKeyValue(key,[value]);
          console.log(`key: ${key} is undefined, save array`);
        } else {
          val.unshift(value);
          Storage.saveWithKeyValue(key,val);
        }
      })
    } catch(e) {
      console.log(e);
    }
  }
}


