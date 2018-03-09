//
//  UIAlertController+Extension.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/12/13.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extension)

//creat ActionSheet
+ (UIAlertController *)creatActionSheetTitle:(NSString *)title message:(NSString *)msg actionArray:(NSArray<NSString *>*)array okOrCancle:(NSString *)name actionBlock:(void(^)(NSInteger index))actionBlock okOrCancleBlock:(void(^)())block;
//creat Alert
+ (UIAlertController *)creatAlertTitle:(NSString *)title message:(NSString *)msg actionArray:(NSArray<NSString *>*)array actionBlock:(void(^)(NSInteger index))actionBlock;

@end
