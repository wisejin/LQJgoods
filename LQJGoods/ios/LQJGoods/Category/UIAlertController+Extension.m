//
//  UIAlertController+Extension.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/12/13.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "UIAlertController+Extension.h"

@implementation UIAlertController (Extension)

//creat ActionSheet
+ (UIAlertController *)creatActionSheetTitle:(NSString *)title message:(NSString *)msg actionArray:(NSArray<NSString *>*)array okOrCancle:(NSString *)name actionBlock:(void(^)(NSInteger index))actionBlock okOrCancleBlock:(void(^)())block{
  
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
  for (int i = 0; i < array.count; i ++) {
    UIAlertAction *action = [UIAlertAction actionWithTitle:array[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      actionBlock(i);
    }];
    [actionSheet addAction:action];
  }
  UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    block();
  }];
  [actionSheet addAction:action];
  return actionSheet;
}

//creat Alert
+ (UIAlertController *)creatAlertTitle:(NSString *)title message:(NSString *)msg actionArray:(NSArray<NSString *>*)array actionBlock:(void(^)(NSInteger index))actionBlock{
  
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
  for (int i = 0; i < array.count; i ++) {
    UIAlertAction *action = [UIAlertAction actionWithTitle:array[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      actionBlock(i);
    }];
    [alert addAction:action];
  }
  return alert;
}

@end
