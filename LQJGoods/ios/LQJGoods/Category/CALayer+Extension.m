//
//  CALayer+Extension.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "CALayer+Extension.h"

@implementation CALayer (Extension)

//虚线框
+ (CALayer *)drawDashRect:(CGRect)rect lineColor:(UIColor *)color cornerRadius:(CGFloat)radius dash:(NSArray<NSNumber *>*)dash{
  
  CAShapeLayer *borderLayer = [CAShapeLayer layer];
  borderLayer.frame = rect;
  borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:radius].CGPath;
  borderLayer.lineWidth = 0.5;
  borderLayer.lineDashPattern = dash;
  borderLayer.fillColor = [UIColor clearColor].CGColor;
  borderLayer.strokeColor = color.CGColor;
  return borderLayer;
}

//虚线
+ (CALayer *)drawDashLine:(CGRect)rect lineColor:(UIColor *)color horizonal:(BOOL)isHorizonal dash:(NSArray<NSNumber *>*)dash{
  
  CAShapeLayer *borderLayer = [CAShapeLayer layer];
  borderLayer.frame = rect;
  borderLayer.lineWidth = 0.5;
  borderLayer.lineDashPattern = dash;
  borderLayer.fillColor = [UIColor clearColor].CGColor;
  borderLayer.strokeColor = color.CGColor;
  borderLayer.lineJoin = kCALineJoinRound;
  
  CGMutablePathRef path = CGPathCreateMutable();
  if (isHorizonal) {
    CGPathMoveToPoint(path, NULL, 0, rect.size.height*0.5);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(rect), rect.size.height*0.5);
  } else {
    CGPathMoveToPoint(path, NULL, rect.size.width*0.5, 0);
    CGPathAddLineToPoint(path, NULL, rect.size.width*0.5, CGRectGetHeight(rect));
  }
  borderLayer.path = path;
  CGPathRelease(path);
  return borderLayer;
}

//添加分割线
+ (CALayer *)addLine:(CGRect)rect lineColor:(UIColor *)color{
  CALayer *layer = [CALayer layer];
  layer.frame = rect;
  layer.backgroundColor = color.CGColor;
  return layer;
}

@end
