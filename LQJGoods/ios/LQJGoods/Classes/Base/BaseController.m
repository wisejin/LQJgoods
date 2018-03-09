//
//  BaseController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/2.
//  Copyright © 2018年 LQJ. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.navigationController.navigationBar setBarTintColor:KThemeColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = KLightBlueColor;
}

#pragma mark - gestureRecognizer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  
  return YES;
}
@end
























