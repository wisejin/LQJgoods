//
//  RNBaseController.h
//  BNBravat
//
//  Created by 廖其进 on 2018/1/5.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "BaseController.h"
#import <CodePush/CodePush.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "ReactNativeHandler.h"
#import "BNPictureBrowseView.h"
#import "TZImagePickerController.h" //图片选择和查看
#import "FileManagerTool.h"
#import "UIImage+Extension.h"

@interface RNBaseController : BaseController
@property (nonatomic, strong) NSString *rnModule;
- (void)setRNNoti;
@end
