//
//  NSArray+Extension.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extension)
//计算特殊字符替换为空字符串后的新位置  比如[em:02:] 先变为" "
//计算偏移量数组
- (NSArray *)offsetRangesInArrayBy:(NSUInteger)offset;

@end
