//
//  ReactNativeHandler.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ReactNativeHandler.h"
//RCTConvert类支持的的类型也都可以使用,RCTConvert还提供了一系列辅助函数，用来接收一个JSON值并转换到原生Objective-C类型或类。
#import <React/RCTConvert.h>
//#import <React/RCTBridge.h>
//本地模块也可以给JavaScript发送事件通知。最直接的方式是使用eventDispatcher
#import <React/RCTEventDispatcher.h>

@implementation ReactNativeHandler
ReactNativeHandler *shareInstance = nil;
RCT_EXPORT_MODULE(ReactNativeHandler)

//单例
+ (ReactNativeHandler *)sharedNativeHandler{
  static dispatch_once_t onceToken;
  if(shareInstance == nil){
    dispatch_once(&onceToken, ^{
      shareInstance = [[ReactNativeHandler alloc] init];
    });
  }
  return shareInstance;
}

//JS调用OC原生push到指定页面界面
RCT_EXPORT_METHOD(pushToNextVc:(NSString *)vcName withInfoDataArray:(NSArray *)infoDataArray callback:(RCTResponseSenderBlock)callback){
  NSLog(@"RN传入原生界面的数据为:%@+%@",vcName,infoDataArray);
  NSLog(@"分%@",self.bridge.eventDispatcher);
  //  [self giveUserInfoToJs:@{@"dd":@"订单"}];
  //主要这里必须使用主线程发送,不然有可能失效
  dispatch_async(dispatch_get_main_queue(), ^{
    if(vcName){
      NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
      [muDic setObject:vcName forKey:@"vcName"];
      
      NSMutableArray *muInfoDataArray = [NSMutableArray array];
      if(infoDataArray.count){
        for (int i = 0;i < infoDataArray.count;i ++) {
          [muInfoDataArray addObject:[infoDataArray objectAtIndex:i]];
        }
      }
      if(callback){
        [muInfoDataArray addObject:callback];
      }
      
      [muDic setObject:muInfoDataArray forKey:@"muInfoDataArray"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToNextVc" object:muDic];
    }
  });
}

//JS调用OC原生pop返回界面
RCT_EXPORT_METHOD(popBack){
  NSLog(@"RN调用原生pop返回");
  NSLog(@"分%@",self.bridge.eventDispatcher);
  //  [self giveUserInfoToJs:@{@"dd":@"订单"}];
  //主要这里必须使用主线程发送,不然有可能失效
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popBack" object:nil];
  });
}

//JS调用OC原生方法传参
RCT_EXPORT_METHOD(callOCMethodWithKey:(NSString *) key){
  //告知OC RN界面已经回到了根视图了，然后OC开启手势POP返回开关
  if([key isEqualToString:@"index"]){
    dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"index" object:@"index"];
    });
  }else if ([key isEqualToString:@"noIndex"]){
    dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"index" object:@"noIndex"];
    });
  }
}

//JS调用OC原生方法放大图片传参
RCT_EXPORT_METHOD(pictureBrowse:(NSArray *)imgArray index:(NSString *)index){
  NSLog(@"发打算封：%@,%@",imgArray,index);
  if(imgArray.count && index){
    dispatch_async(dispatch_get_main_queue(), ^{
      NSMutableDictionary *muDic = [[NSMutableDictionary alloc] init];
      [muDic setObject:imgArray forKey:@"imgArray"];
      [muDic setObject:index forKey:@"index"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"pictureBrowse" object:muDic];
    });
  }
}

//打开相册获取图片
RCT_EXPORT_METHOD(launchImageLibrary:(NSString *)maxImagesCountStr callback:(RCTResponseSenderBlock)callback){
  NSLog(@"按时发放%@,%@",maxImagesCountStr,self);
  dispatch_async(dispatch_get_main_queue(), ^{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:callback forKey:@"callback"];
    if(maxImagesCountStr){
      [muDic setObject:maxImagesCountStr forKey:@"count"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"launchImageLibrary" object:muDic];
    }else{
      [muDic setObject:@"9" forKey:@"count"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"launchImageLibrary" object:muDic];
    }
  });
}

//打开相机获取图片
RCT_EXPORT_METHOD(launchCamera:(RCTResponseSenderBlock)callback){
  NSLog(@"按时发放%@",callback);
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"launchCamera" object:callback];
  });
}

//调用OC原生清除沙盒文件夹、文件
RCT_EXPORT_METHOD(cleanDocumentCache:(NSString *)path callback:(RCTResponseSenderBlock)callback){
  if(path){
    dispatch_async(dispatch_get_main_queue(), ^{
      NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
      [muDic setObject:callback forKey:@"callback"];
      [muDic setObject:path forKey:@"path"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanDocumentCache" object:muDic];
    });
  }
}

//JS调用OC原生旋转屏幕
RCT_EXPORT_METHOD(rotatingDeviceScreenDirection:(NSString *)direction){
  if(direction){
    NSLog(@"横竖屏：%@",direction);
    dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"rotatingDeviceScreenDirection" object:direction];
    });
  }
}

//监听JS告知OC RN界面已经回到了根视图了，然后OC开启手势POP返回开关
RCT_EXPORT_METHOD(rnGotoRootView:(NSString *)index){
  if(index){
    NSLog(@"是否打开手势：%@",index);
    dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"rnGotoRootView" object:index];
    });
  }
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"giveUserInfoToJs",@"logout"]; //这里返回的将是你要发送的消息名的数组。
}

@end
