//
//  BNRefreshView.h
//  BNAnimation
//
//  Created by benniuMAC on 16/5/5.
//  Copyright © 2016年 BN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRefreshView;
@protocol BNRefreshViewDelegate <NSObject>

@optional
- (void)refreshViewStartRefresh:(BNRefreshView *)refreshView;

@end

/**
 *  仿QQ下拉刷新控件
 */
@interface BNRefreshView : UIView

//监听的滚动视图
@property (nonatomic, weak) UIScrollView *scrollView;
//代理
@property (nonatomic, weak) id<BNRefreshViewDelegate> delegate;

//使用滚动视图创建下拉刷新控件
+ (instancetype)refreshViewWithScrollView:(UIScrollView *)scrollView;

//释放监听
- (void)free;

//开始刷新
- (void)startRefresh;

//停止刷新
- (void)endRefreshing;

@end








































