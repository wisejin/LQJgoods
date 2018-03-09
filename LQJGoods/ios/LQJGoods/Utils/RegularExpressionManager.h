//
//  RegularExpressionManager.h
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/7.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularExpressionManager : NSObject
//使用正则表达式查找特殊字符的位置
+ (NSArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString;

//查找是否有电话号码数字，并生成一个字典{range:string}存储到数组，以便于到时响应对应的点击事件，和不同字体颜色
+ (NSMutableArray *)matchMobileLink:(NSString *)pattern;

//查找是否有网址链接，并生成一个字典{range:string}存储到数组，以便于到时响应对应的点击事件，和不同字体颜色
+ (NSMutableArray *)matchWebLink:(NSString *)pattern;

//查找匹配名字字符串，并生成一个字典{range:string}存储到数组，以便于到时响应对应的点击事件，和不同字体颜色
+ (NSMutableArray *)matchName:(NSString *)pattern;


@end
