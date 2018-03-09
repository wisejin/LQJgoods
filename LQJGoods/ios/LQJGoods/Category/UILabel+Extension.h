//
//  UILabel+Extension.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

// 获得label文本的计算宽高
- (CGFloat)calculateLableHeight;
- (CGFloat)calculateLableWidth;

// 创建Label
+ (UILabel *)creatLabelRect:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color;

@end
