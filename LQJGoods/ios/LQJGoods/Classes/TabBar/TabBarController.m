//
//  TabBarController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/5.
//  Copyright © 2018年 LQJ. All rights reserved.
//

#import "TabBarController.h"
#import "MainController.h"
#import "LearnController.h"
#import "FindController.h"
#import "MineController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.viewControllers = @[
                             [self creat_NVCcontroller:[MainController new] title:@"首页" norImage:[UIImage imageNamed:@"bottom_index_normal"] selImage:[UIImage imageNamed:@"bottom_index_select"]],
                             [self creat_NVCcontroller:[LearnController new] title:@"学习" norImage:[UIImage imageNamed:@"bottom_learn_normal"] selImage:[UIImage imageNamed:@"bottom_learn_select"]],
                             [self creat_NVCcontroller:[FindController new] title:@"发现" norImage:[UIImage imageNamed:@"bottom_find_normal"] selImage:[UIImage imageNamed:@"bottom_find_select"]],
                             [self creat_NVCcontroller:[MineController new] title:@"我的" norImage:[UIImage imageNamed:@"bottom_mine_normal"] selImage:[UIImage imageNamed:@"bottom_mine_select"]],
                             ];
}
- (UINavigationController *)creat_NVCcontroller:(UIViewController *)vc title:(NSString *)title norImage:(UIImage *)norImg selImage:(UIImage *)selImg{
    
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[norImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KThemeColor} forState:UIControlStateSelected];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kRGBColor(191, 203, 217)} forState:UIControlStateNormal];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    return navc;
}

@end



















