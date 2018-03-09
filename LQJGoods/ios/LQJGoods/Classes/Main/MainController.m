//
//  MainController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/2.
//  Copyright © 2018年 LQJ. All rights reserved.
//

#import "MainController.h"

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KLightBlueColor;
    self.title = @"首页";
    
    self.dataSoureArray = @[
  @{@"iconName":@"list_0",@"title":@"项目小模块",@"className":@"SmallerModuleController",@"info":@""},
  @{@"iconName":@"list_1",@"title":@"动画",@"className":@"AnimationController",@"info":@""},
  @{@"iconName":@"list_2",@"title":@"三方库的使用",@"className":@"OtherLibrariesController",@"info":@""},
  @{@"iconName":@"list_3",@"title":@"RN模块",@"className":@"RNBaseController",@"info":@""},
  @{@"iconName":@"list_4",@"title":@"自定义控件",@"className":@"CustomTableViewController",@"info":@""}];
}
@end















































