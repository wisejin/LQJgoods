//
//  Header.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#ifndef Header_h
#define Header_h

//************************************项目头文件************************************//
// 三方库
#import "SVProgressHUD.h"           //风火轮1
#import "MBProgressHUD.h"           //风火轮2
#import "Masonry.h"                 //适配库
#import "AFNetworking.h"            //请求框架
#import "MJRefresh.h"               //MJ刷新
#import "UIImageView+WebCache.h"    //图片加载
#import "SDWebImageDownloader.h"    //图片下载
#import "Reachability.h"            //网络状态
#import "MJExtension.h"

//************************************项目宏定义************************************//
// 获取屏幕宽度与高度
#define SCREEN_SIZE    [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

// 判断iPhone屏幕
#define IPhone4X          [[UIScreen mainScreen] bounds].size.height == 480.0f
#define IPhone5X          [[UIScreen mainScreen] bounds].size.height == 568.0f
#define IPhone6_Later     [[UIScreen mainScreen] bounds].size.height == 667.0f
#define IPhone6P_Later    [[UIScreen mainScreen] bounds].size.height == 736.0f
#define IPhone_X          [[UIScreen mainScreen] bounds].size.height == 812.0f

//主题色
#define KThemeColor [UIColor colorWithRed:51/255.0 green:103/255.0 blue:213/255.0 alpha:1]
//浅灰色
#define KLightGrayColor [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1]
/**浅蓝暖色**/
#define KLightBlueColor [UIColor colorWithRed:244/255.0 green:247/255.0 blue:249/255.0 alpha:1]
//分割线条灰色
#define KDivideLineColor [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]
//导航条高度
#define KNavHeight (IPhone_X ? 90:64)
//TaBar高度
#define KTabBarHeight (IPhone_X ? 83:49)

// RGB颜色转换（16进制->10进制）
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// RGB颜色/RGBA颜色
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kRGBColor(r, g, b)     kRGBAColor(r, g, b, 1.0)
//设置随机颜色
#define KRandomColor  [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:0.3];


#endif /* Header_h */
