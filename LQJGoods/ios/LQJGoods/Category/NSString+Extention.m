//
//  NSString+Extention.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "NSString+Extention.h"

@implementation NSString (Extention)

/*字符串是否为空*/
- (BOOL)isEmpty{
  if (self.length == 0 || self == nil) {
    return YES;
  }
  return NO;
}

//字符串文字的宽
- (CGFloat)widthOfStringFont:(UIFont *)font height:(CGFloat)height{
  
  CGRect bounds;
  NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
  bounds = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
  return bounds.size.width;
}
//字符串文字的高
- (CGFloat)heightOfStringFont:(UIFont *)font width:(CGFloat)width{
  
  CGRect bounds;
  NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
  bounds = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
  return bounds.size.height;
}

//富文本
- (NSMutableAttributedString *)attributeTextWithFirstColor:(UIColor *)fColor nextColor:(UIColor *)nColor divideIndex:(NSInteger)index{
  
  NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:fColor, NSForegroundColorAttributeName,nil];
  NSDictionary *attributeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:nColor, NSForegroundColorAttributeName,nil];
  NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:self];
  [contentStr setAttributes:attributeDict1 range:NSMakeRange(0, index)];
  [contentStr setAttributes:attributeDict2 range:NSMakeRange(index, contentStr.length-index)];
  return contentStr;
}
//富文本[全]
- (NSMutableAttributedString *)attributeTextWithFirstColor:(UIColor *)fColor nextColor:(UIColor *)nColor firstFont:(CGFloat)fSize nextFont:(CGFloat)nSize divideIndex:(NSInteger)index{
  
  NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:fColor, NSForegroundColorAttributeName,[UIFont systemFontOfSize:fSize],NSFontAttributeName,nil];
  NSDictionary *attributeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:nColor, NSForegroundColorAttributeName,[UIFont systemFontOfSize:nSize],NSFontAttributeName,nil];
  NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:self];
  [contentStr setAttributes:attributeDict1 range:NSMakeRange(0, index)];
  [contentStr setAttributes:attributeDict2 range:NSMakeRange(index, contentStr.length-index)];
  return contentStr;
}
//富文本[最全]
- (NSMutableAttributedString *)attributeTextWithColor1:(UIColor *)color1 color2:(UIColor *)color2 color3:(UIColor *)color3 font1:(CGFloat)font1 font2:(CGFloat)font2 font3:(CGFloat)font3 index1:(NSInteger)index1 index2:(NSInteger)index2{
  
  NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:color1, NSForegroundColorAttributeName,[UIFont systemFontOfSize:font1],NSFontAttributeName,nil];
  NSDictionary *attributeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:color2, NSForegroundColorAttributeName,[UIFont systemFontOfSize:font2],NSFontAttributeName,nil];
  NSDictionary *attributeDict3 = [NSDictionary dictionaryWithObjectsAndKeys:color3, NSForegroundColorAttributeName,[UIFont systemFontOfSize:font3],NSFontAttributeName,nil];
  NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:self];
  [contentStr setAttributes:attributeDict1 range:NSMakeRange(0, index1)];
  [contentStr setAttributes:attributeDict2 range:NSMakeRange(index1, index2-index1)];
  [contentStr setAttributes:attributeDict3 range:NSMakeRange(index2, contentStr.length-index2)];
  return contentStr;
}

//遍历替换新字符串 比如：[em:03:]  替换成 " "
- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes AndString:(NSString *)aString{
  //断言
  NSAssert(indexes != nil, @"%s: indexes 不可以为nil", __PRETTY_FUNCTION__);
  NSAssert(aString != nil, @"%s: aString 不可以为nil", __PRETTY_FUNCTION__);
  
  NSUInteger offset = 0;
  NSMutableString *raw = [self mutableCopy];
  
  NSInteger prevLength = 0;
  for(NSInteger i = 0;i < [indexes count];i ++){
    //自动释放池，释放临时变量，减少内存消耗
    @autoreleasepool{
      NSRange range = [[indexes objectAtIndex:i] rangeValue];
      prevLength = range.length;
      
      range.location -= offset;
      [raw replaceCharactersInRange:range withString:aString];
      offset = offset + prevLength - [aString length];
    }
  }
  
  return raw;
}

//分割表情拿到图片名字字符串数组，比如[em:02:]    获取 02
- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index{
  if(!pattern){
    return nil;
  }
  
  NSError *error = nil;
  NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
  
  if(error){
    
  }else{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSRange searchRange = NSMakeRange(0, [self length]);
    [regx enumerateMatchesInString:self options:0 range:searchRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
      NSRange groupRange = [result rangeAtIndex:index];
      NSString *match = [self substringWithRange:groupRange];
      [results addObject:match];
    }];
    
    return results;
  }
  
  return nil;
}

@end

























