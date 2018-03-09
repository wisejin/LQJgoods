//
//  UIButton+Extension.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

@implementation UIButton (Extension)

#pragma mark 使用runtime为该类别添加appendIndexPath属性
//即实现setter/getter方法
static NSString *appendIndexPathKey = @"appendIndexPathKey";
- (void)setAppendIndexPath:(NSIndexPath *)appendIndexPath{
  objc_setAssociatedObject(self, &appendIndexPathKey, appendIndexPath, OBJC_ASSOCIATION_COPY);
}

- (NSIndexPath *)appendIndexPath{
  return objc_getAssociatedObject(self, &appendIndexPathKey);
}

// 创建Button
+ (UIButton *)creatButtonRect:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color bgColor:(UIColor *)bgColor{
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  btn.frame = frame;
  btn.backgroundColor = bgColor;
  [btn setTitle:title forState:UIControlStateNormal];
  [btn setTitleColor:color forState:UIControlStateNormal];
  return btn;
}

@end

























