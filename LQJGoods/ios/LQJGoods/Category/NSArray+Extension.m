//
//  NSArray+Extension.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)
//计算特殊字符替换为空字符串后的新位置  比如[em:02:] 先变为" "
//计算偏移量数组
- (NSArray *)offsetRangesInArrayBy:(NSUInteger)offset{
  NSUInteger aOffset = 0;
  NSUInteger prevLength = 0;
  
  NSMutableArray *ranges = [[NSMutableArray alloc] initWithCapacity:[self count]];
  for(NSInteger i = 0;i < [self count];i ++){
    @autoreleasepool{
      NSRange range = [[self objectAtIndex:i] rangeValue];
      prevLength = range.length;
      
      range.location -= aOffset;
      range.length = offset;
      [ranges addObject:NSStringFromRange(range)];
      
      aOffset = aOffset + prevLength - offset;
    }
  }
  
  return ranges;
}
@end




























