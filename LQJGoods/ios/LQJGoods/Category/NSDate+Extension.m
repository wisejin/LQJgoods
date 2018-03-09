//
//  NSDate+Extension.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

// [YYYY-MM-dd HH:mm:ss]
+ (NSString *)getCurrentTimeString{
  
  NSDate *date = [NSDate date];
  NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}
// [YYYY-MM-dd HH:mm:ss:SSS]
+ (NSString *)getCurrentTimeMillisecondString{
  
  NSDate *date = [NSDate date];
  NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss:SSS"];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}
// 根据格式返回时间字符串
+ (NSString *)getCurrentTimeStringWithFormatter:(NSString *)formatter{
  
  NSDate *date = [NSDate date];
  NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:formatter];
  NSString *time = [dateFormatter stringFromDate:date];
  return time;
}
// 时间戳13位[1234567891234]
+ (NSString *)getCurrentTimestampStr{
  
  NSDate *date = [NSDate date];
  NSTimeInterval timeInt = [date timeIntervalSince1970]*1000;
  NSString *timeString = [NSString stringWithFormat:@"%f",timeInt];
  NSString *endStr = [timeString componentsSeparatedByString:@"."][0];
  return endStr;
}
// 时间戳转时间字符串
+ (NSString *)getTimeFromTimestamp:(NSString *)timestamp formatter:(NSString *)formatter{
  
  NSAssert(timestamp == nil, @"timestamp is nil");
  NSAssert(timestamp.length == 13, @"timestamp‘s length is not 13");
  NSTimeInterval timeInt = [timestamp doubleValue];
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInt*0.001];
  NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:formatter];
  NSString *endStr = [dateFormatter stringFromDate:date];
  return endStr;
}
// 时间字符串转时间戳
+ (NSString *)getTimestampFromTimeStr:(NSString *)time formatter:(NSString *)formatter{
  
  NSAssert(time == nil, @"time is nil");
  NSAssert(time.length == formatter.length, @"formatter is wrong");
  NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:formatter];
  NSDate *date = [dateFormatter dateFromString:time];
  NSTimeInterval timeInt = [date timeIntervalSince1970]*1000;
  NSString *timeString = [NSString stringWithFormat:@"%f",timeInt];
  NSString *endStr = [timeString componentsSeparatedByString:@"."][0];
  return endStr;
}
// 计算两个时间间隔
+ (NSString *)changeTimeString1:(NSString *)str1 timeString2:(NSString *)str2 formatter:(NSString *)formatter{
  
  NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:formatter];
  NSDate *date1 = [dateFormatter dateFromString:str1];
  NSDate *date2 = [dateFormatter dateFromString:str2];
  NSTimeInterval pv = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
  NSString *endStr = [NSString stringWithFormat:@"%.1f",pv+0.05];
  return endStr;
}


@end
