import {NativeModules} from 'react-native';

// 下一句中的ToastExample即对应上文
// public String getName()中返回的字符串

export let SplashScreen = NativeModules.SplashScreen;
export let MyIntentModule = NativeModules.MyIntentModule;
export let DialogModule = NativeModules.DialogModule;
export let ImagePickerModule = NativeModules.ImagePickerModule;
