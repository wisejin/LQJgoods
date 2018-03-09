//
//  NSString+Extention.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extention)

/*字符串是否为空*/
- (BOOL)isEmpty;


// 字符串文字的宽
- (CGFloat)widthOfStringFont:(UIFont *)font height:(CGFloat)height;
// 字符串文字的高
- (CGFloat)heightOfStringFont:(UIFont *)font width:(CGFloat)width;

// 富文本
- (NSMutableAttributedString *)attributeTextWithFirstColor:(UIColor *)fColor nextColor:(UIColor *)nColor divideIndex:(NSInteger)index;
- (NSMutableAttributedString *)attributeTextWithFirstColor:(UIColor *)fColor nextColor:(UIColor *)nColor firstFont:(CGFloat)fSize nextFont:(CGFloat)nSize divideIndex:(NSInteger)index;
- (NSMutableAttributedString *)attributeTextWithColor1:(UIColor *)color1 color2:(UIColor *)color2 color3:(UIColor *)color3 font1:(CGFloat)font1 font2:(CGFloat)font2 font3:(CGFloat)font3 index1:(NSInteger)index1 index2:(NSInteger)index2;

//遍历替换新字符串 比如：[em:03:]  替换成 " "
- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes AndString:(NSString *)aString;

//分割表情拿到图片名字字符串数组，比如[em:02:]    获取 02
- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index;
@end
