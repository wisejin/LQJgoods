//
//  UIView+Extension.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

#pragma mark - ===setter===
- (void)setLeft:(CGFloat)left{
  
  CGRect rect = self.frame;
  rect.origin.x = left;
  self.frame = rect;
}
- (void)setTop:(CGFloat)top{
  
  CGRect rect = self.frame;
  rect.origin.y = top;
  self.frame = rect;
}
- (void)setRight:(CGFloat)right{
  
  CGRect rect = self.frame;
  rect.origin.x = right - rect.size.width;
  self.frame = rect;
}
- (void)setBottom:(CGFloat)bottom{
  
  CGRect rect = self.frame;
  rect.origin.y = bottom - rect.size.height;
  self.frame = rect;
}
- (void)setWidth:(CGFloat)width{
  
  CGRect rect = self.frame;
  rect.size.width = width;
  self.frame = rect;
}
- (void)setHeight:(CGFloat)height{
  
  CGRect rect = self.frame;
  rect.size.height = height;
  self.frame = rect;
}
- (void)setCenter_x:(CGFloat)center_x{
  
  CGPoint point = CGPointMake(center_x, self.center.y);
  self.center = point;
}
- (void)setCenter_y:(CGFloat)center_y{
  
  CGPoint point = CGPointMake(self.center.x, center_y);
  self.center = point;
}
- (void)setOrigin:(CGPoint)origin{
  
  CGRect rect = self.frame;
  rect.origin = origin;
  self.frame = rect;
}
- (void)setOrigin_x:(CGFloat)origin_x{
  
  CGRect rect = self.frame;
  rect.origin.x = origin_x;
  self.frame = rect;
}
- (void)setOrigin_y:(CGFloat)origin_y{
  
  CGRect rect = self.frame;
  rect.origin.y = origin_y;
  self.frame = rect;
}
- (void)setSize:(CGSize)size{
  
  CGRect rect = self.frame;
  rect.size = size;
  self.frame = rect;
}

#pragma mark - ===getter===
- (CGFloat)left{
  
  return CGRectGetMinX(self.frame);
}
- (CGFloat)top{
  
  return CGRectGetMinY(self.frame);
}
- (CGFloat)right{
  
  return CGRectGetMaxX(self.frame);
}
- (CGFloat)bottom{
  
  return CGRectGetMaxY(self.frame);
}
- (CGFloat)width{
  
  return CGRectGetWidth(self.frame);
}
- (CGFloat)height{
  
  return CGRectGetHeight(self.frame);
}
- (CGFloat)center_x{
  
  return CGRectGetMidX(self.frame);
}
- (CGFloat)center_y{
  
  return CGRectGetMidY(self.frame);
}
- (CGPoint)origin{
  
  return self.frame.origin;
}
- (CGFloat)origin_x{
  
  return CGRectGetMinX(self.frame);
}
- (CGFloat)origin_y{
  
  return CGRectGetMinY(self.frame);
}
- (CGSize)size{
  
  return self.frame.size;
}

@end
