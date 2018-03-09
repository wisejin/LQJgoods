//
//  NSDate+Extension.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

// [YYYY-MM-dd HH:mm:ss]
+ (NSString *)getCurrentTimeString;
// [YYYY-MM-dd HH:mm:ss:SSS]
+ (NSString *)getCurrentTimeMillisecondString;
// 根据格式返回时间字符串
+ (NSString *)getCurrentTimeStringWithFormatter:(NSString *)formatter;
// 时间戳13位[1234567891234]
+ (NSString *)getCurrentTimestampStr;

// 时间戳转时间字符串
+ (NSString *)getTimeFromTimestamp:(NSString *)timestamp formatter:(NSString *)formatter;
// 时间字符串转时间戳
+ (NSString *)getTimestampFromTimeStr:(NSString *)time formatter:(NSString *)formatter;
// 计算两个时间间隔
+ (NSString *)changeTimeString1:(NSString *)str1 timeString2:(NSString *)str2 formatter:(NSString *)formatter;

@end
