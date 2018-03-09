//
//  UITapGestureRecognizer+Extension.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/26.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "UITapGestureRecognizer+Extension.h"
#import <objc/runtime.h>

@implementation UITapGestureRecognizer (Extension)
#pragma mark 使用runtime为该类别添加appendIndexPath属性
//即实现setter/getter方法
static NSString *appendArrayKey = @"appendArrayKey";
- (void)setMuAppendArray:(NSMutableArray *)muAppendArray{
  objc_setAssociatedObject(self, &appendArrayKey, muAppendArray, OBJC_ASSOCIATION_COPY);
}

- (NSMutableArray *)muAppendArray{
  return objc_getAssociatedObject(self, &appendArrayKey);
}

@end
