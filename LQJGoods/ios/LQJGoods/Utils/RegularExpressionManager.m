//
//  RegularExpressionManager.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/7.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "RegularExpressionManager.h"

@implementation RegularExpressionManager

//使用正则表达式查找特殊字符的位置
+ (NSArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString{
  //断言
  NSAssert(pattern != nil, @"%s: pattern 不可以为 nil", __PRETTY_FUNCTION__);
  NSAssert(findingString != nil, @"%s: findingString 不可以为 nil", __PRETTY_FUNCTION__);
  
  NSError *error = nil;
  //正则表达式查找
  NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
  //查找匹配的字符串
  NSArray *result = [regExp matchesInString:findingString options:NSMatchingReportCompletion range:NSMakeRange(0, [findingString length])];
  
  if(error){
    return nil;
  }
  
  NSUInteger count = [result count];
  //没有查找到结果，返回空数组
  if(0 == count){
    return [NSArray array];
  }
  
  //将返回数组中的NSTextCheckingResult的实例range取出生成新的range数组
  NSMutableArray *ranges = [[NSMutableArray alloc] init];
  for(NSInteger i = 0;i < count;i ++){
    @autoreleasepool{
      NSRange aRange = [[result objectAtIndex:i] range];
      [ranges addObject:[NSValue valueWithRange:aRange]];
    }
  }
  
  return ranges;
}

//查找是否有电话号码数字，并生成一个字典{range:string}存储到数组，以便于到时响应对应的点击事件，和不同字体颜色
+ (NSMutableArray *)matchMobileLink:(NSString *)pattern{
  NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];
  NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:KPhoneNumPattern options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
  
  NSArray *array = [regular matchesInString:pattern options:0 range:NSMakeRange(0, [pattern length])];
  for (NSTextCheckingResult *result in array) {
    NSString *string = [pattern substringWithRange:result.range];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
    [linkArr addObject:muDic];
  }
  
  return linkArr;
}

//查找是否有网址链接，并生成一个字典{range:string}存储到数组，以便于到时响应对应的点击事件，和不同字体颜色
+ (NSMutableArray *)matchWebLink:(NSString *)pattern{
  NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];
  NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:KWebLinkPattern options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
  
  NSArray *array = [regular matchesInString:pattern options:0 range:NSMakeRange(0, [pattern length])];
  for (NSTextCheckingResult *result in array) {
    NSString *string = [pattern substringWithRange:result.range];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
    [linkArr addObject:muDic];
  }
  return linkArr;
}

//查找匹配名字字符串，并生成一个字典{range:string}存储到数组，以便于到时响应对应的点击事件，和不同字体颜色
+ (NSMutableArray *)matchName:(NSString *)pattern{
  NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];
  NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:KNamePattern options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
  
  NSArray *array = [regular matchesInString:pattern options:0 range:NSMakeRange(0, [pattern length])];
  
  for (NSTextCheckingResult *result in array) {
    NSString *string = [pattern substringWithRange:result.range];
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
    [linkArr addObject:muDic];
  }
  
  return linkArr;
}

@end



























