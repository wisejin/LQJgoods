//
//  SmallerModuleController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/6.
//  Copyright © 2018年 LQJ. All rights reserved.
//

#import "SmallerModuleController.h"

@interface SmallerModuleController ()

@end

@implementation SmallerModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KLightBlueColor;
    self.title = @"项目小模块";
  
  self.dataSoureArray = @[
                          @{@"iconName":@"list_19",@"title":@"朋友圈",@"className":@"RichTextViewController",@"info":@""},
                          @{@"iconName":@"list_13",@"title":@"简易网页浏览器",@"className":@"WebBrowserController",@"info":@"https://github.com/"},
                          @{@"iconName":@"list_3",@"title":@"文件管理",@"className":@"FileManagerController",@"info":@"https://github.com/"}
                          ];
  
}

@end










