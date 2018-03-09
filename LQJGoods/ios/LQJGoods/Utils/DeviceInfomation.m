//
//  DeviceInfomation.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "DeviceInfomation.h"
#import "KeyChainStore.h"
#import "sys/utsname.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation DeviceInfomation

#define DEFAULT_RETURN_STRING @"Unable to determine"

//获取手机UUID
+ (NSString *)getUUID{
  
  static NSString *strId = @"com.iBenew.BNBravat";
  NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
  NSString *strUUID = (NSString *)[KeyChainStore load:identifier != nil ? identifier:strId];
  if ([strUUID isEqualToString:@""] || !strUUID){
    
    //生成UUID
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
    //UUID保存到keychain
    [KeyChainStore save:identifier != nil ? identifier:strId data:strUUID];
  }
  if(strUUID == nil || [strUUID isEqualToString:@"(null)"])
    strUUID = DEFAULT_RETURN_STRING;
  return strUUID;
}

//获取运营商名字 例如：电信
+ (NSString *)getCarrierName{
  
  CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
  CTCarrier *carrier = [info subscriberCellularProvider];
  NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
  if(mCarrier == nil || [mCarrier isEqualToString:@"(null)"])
    mCarrier = DEFAULT_RETURN_STRING;
  return mCarrier;
}

//获取手机机型
+ (NSString *)getDeviceType{
  
  struct utsname systemInfo;
  uname(&systemInfo);
  NSString *correspondVersion = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
  /*
   char  sysname[_SYS_NAMELEN];  [XSI] Name of OS
   char  nodename[_SYS_NAMELEN]; [XSI] Name of this network node
   char  release[_SYS_NAMELEN];  [XSI] Release level
   char  version[_SYS_NAMELEN];  [XSI] Version level
   char  machine[_SYS_NAMELEN];  [XSI] Hardware type
   */
  
//  DBLog(@"设备信息: sysname=%@,nodename=%@,release=%@,version=%@,machine=%@",
//        [NSString stringWithCString:systemInfo.sysname encoding:NSUTF8StringEncoding],
//        [NSString stringWithCString:systemInfo.nodename encoding:NSUTF8StringEncoding],
//        [NSString stringWithCString:systemInfo.release encoding:NSUTF8StringEncoding],
//        [NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding],
//        [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]);
  
  //Simulator
  if ([correspondVersion isEqualToString:@"i386"])        return @"Simulator";
  if ([correspondVersion isEqualToString:@"x86_64"])      return @"Simulator";
  //iPhone
  if ([correspondVersion isEqualToString:@"iPhone1,1"])   return @"iPhone 1";
  if ([correspondVersion isEqualToString:@"iPhone1,2"])   return @"iPhone 3";
  if ([correspondVersion isEqualToString:@"iPhone2,1"])   return @"iPhone 3S";
  if ([correspondVersion isEqualToString:@"iPhone3,1"] || [correspondVersion isEqualToString:@"iPhone3,2"])   return @"iPhone 4";
  if ([correspondVersion isEqualToString:@"iPhone4,1"])   return @"iPhone 4S";
  if ([correspondVersion isEqualToString:@"iPhone5,1"] || [correspondVersion isEqualToString:@"iPhone5,2"])   return @"iPhone 5";
  if ([correspondVersion isEqualToString:@"iPhone5,3"] || [correspondVersion isEqualToString:@"iPhone5,4"])   return @"iPhone 5c";
  if ([correspondVersion isEqualToString:@"iPhone6,1"] || [correspondVersion isEqualToString:@"iPhone6,2"])   return @"iPhone 5s";
  if([correspondVersion rangeOfString:@"iPhone7"].length){
    
    if(IPhone6_Later)  return @"iPhone 6";
    else               return @"iPhone 6Plus";
  }
  if([correspondVersion rangeOfString:@"iPhone8"].length){
    
    if(IPhone6P_Later)  return @"iPhone 6sPlus";
    else                return @"iPhone 6s";
  }
  //iPod
  if ([correspondVersion isEqualToString:@"iPod1,1"])   return @"iPod Touch 1";
  if ([correspondVersion isEqualToString:@"iPod2,1"])   return @"iPod Touch 2";
  if ([correspondVersion isEqualToString:@"iPod3,1"])   return @"iPod Touch 3";
  if ([correspondVersion isEqualToString:@"iPod4,1"])   return @"iPod Touch 4";
  if ([correspondVersion isEqualToString:@"iPod5,1"])   return @"iPod Touch 5";
  //iPad
  if ([correspondVersion isEqualToString:@"iPad1,1"])   return @"iPad 1";
  if ([correspondVersion isEqualToString:@"iPad2,1"] || [correspondVersion isEqualToString:@"iPad2,2"] || [correspondVersion isEqualToString:@"iPad2,3"] || [correspondVersion isEqualToString:@"iPad2,4"])     return@"iPad 2";
  if ([correspondVersion isEqualToString:@"iPad2,5"] || [correspondVersion isEqualToString:@"iPad2,6"] || [correspondVersion isEqualToString:@"iPad2,7"] )  return @"iPad Mini";
  if ([correspondVersion isEqualToString:@"iPad3,1"] || [correspondVersion isEqualToString:@"iPad3,2"] || [correspondVersion isEqualToString:@"iPad3,3"] || [correspondVersion isEqualToString:@"iPad3,4"] || [correspondVersion isEqualToString:@"iPad3,5"] || [correspondVersion isEqualToString:@"iPad3,6"])      return @"iPad 3";
  
//    DBLog(@"设备类型: %@",correspondVersion);
  if(correspondVersion == nil || [correspondVersion isEqualToString:@"(null)"])
    correspondVersion = DEFAULT_RETURN_STRING;
  return correspondVersion;
}

//获取手机名称
+ (NSString *)getPnoneName{
  
  struct utsname systemInfo;
  uname(&systemInfo);
  NSString *phoneNameStr = [NSString stringWithCString:systemInfo.nodename encoding:NSUTF8StringEncoding];
  if(phoneNameStr == nil || [phoneNameStr isEqualToString:@"(null)"])
    phoneNameStr = DEFAULT_RETURN_STRING;
  return phoneNameStr;
}

//获取网络类型
+ (NSString *)getNetworkType{
  
  NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
  NSNumber *dataNetworkItemView = nil;
  for (id subview in subviews) {
    if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
      dataNetworkItemView = subview;
      break;
    }
  }
  NSString *networkTypeStr = nil;
  switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"] integerValue]) {
    case 0:
      networkTypeStr = @"No wifi or cellular";
      break;
    case 1:
      networkTypeStr = @"2G";
      break;
    case 2:
      networkTypeStr = @"3G";
      break;
    case 3:
      networkTypeStr = @"4G";
      break;
    case 4:
      networkTypeStr = @"LTE";
      break;
    case 5:
      networkTypeStr = @"Wifi";
      break;
    default:
      break;
  }
  if(networkTypeStr == nil || [networkTypeStr isEqualToString:@"(null)"])
    networkTypeStr = DEFAULT_RETURN_STRING;
  return networkTypeStr;
}

//获取手机IP
+ (NSString *)getDeviceNetworkIP{
  
  NSString *address = @"0.0.0.0";
  struct ifaddrs *interfaces = NULL;
  struct ifaddrs *temp_addr = NULL;
  int success = 0;
  success = getifaddrs(&interfaces);
  if (success == 0) {
    temp_addr = interfaces;
    while (temp_addr != NULL) {
      if( temp_addr->ifa_addr->sa_family == AF_INET) {
        if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]){
          address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in  *)temp_addr->ifa_addr)->sin_addr)];
        }
      }
      temp_addr = temp_addr->ifa_next;
    }
  }
  freeifaddrs(interfaces);
  return address;
}

@end
