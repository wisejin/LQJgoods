//
//  DeviceInfomation.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfomation : NSObject

// 获取手机UUID
+ (NSString *)getUUID;
// 获取运营商名字 例如：电信
+ (NSString *)getCarrierName;
// 获取手机机型
+ (NSString *)getDeviceType;
// 获取手机名称
+ (NSString *)getPnoneName;
// 获取网络类型
+ (NSString *)getNetworkType;
// 获取手机IP
+ (NSString *)getDeviceNetworkIP;

@end
