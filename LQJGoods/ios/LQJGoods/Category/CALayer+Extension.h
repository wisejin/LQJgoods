//
//  CALayer+Extension.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Extension)

//虚线框
+ (CALayer *)drawDashRect:(CGRect)rect lineColor:(UIColor *)color cornerRadius:(CGFloat)radius dash:(NSArray<NSNumber *>*)dash;

//虚线
+ (CALayer *)drawDashLine:(CGRect)rect lineColor:(UIColor *)color horizonal:(BOOL)isHorizonal dash:(NSArray<NSNumber *>*)dash;

//添加分割线
+ (CALayer *)addLine:(CGRect)rect lineColor:(UIColor *)color;

@end
