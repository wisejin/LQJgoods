//
//  UILabel+Extension.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (CGFloat)calculateLableHeight{

    NSDictionary *dict = @{NSFontAttributeName:self.font};
    CGRect bounds = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return bounds.size.height;
}
- (CGFloat)calculateLableWidth{
  
    NSDictionary *dict = @{NSFontAttributeName:self.font};
    CGRect bounds = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return bounds.size.width;
}

// 创建Label
+ (UILabel *)creatLabelRect:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color{
  
  UILabel *lab = [[UILabel alloc] initWithFrame:frame];
  lab.textColor = color;
  lab.font = font;
  return lab;
}

@end
