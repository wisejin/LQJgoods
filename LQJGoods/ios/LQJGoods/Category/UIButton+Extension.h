//
//  UIButton+Extension.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

@property (nonatomic,strong) NSIndexPath *appendIndexPath;

// 创建Button
+ (UIButton *)creatButtonRect:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color bgColor:(UIColor *)bgColor;

@end
