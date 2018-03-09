//
//  BNPictureBrowseCell.h
//  BNPictureBrowseTest
//
//  Created by benniuMAC on 16/4/7.
//  Copyright © 2016年 BN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@interface BNPictureBrowseCell : UICollectionViewCell
/**
 *  要展示的图片
 */
@property (nonatomic, strong) UIImage *img;
/**
 *  要加载的底图
 */
@property (nonatomic, strong) NSString *placeholderImageStr;
/**
 *  要加载的URL
 */
@property (nonatomic, strong) NSURL *imgURL;
/**
 *  单击block
 */
@property (nonatomic, copy) void (^singleTapGestureBlock)();
/**转换后的rect（找到我触碰的位置，即点击图片面板的父视图的frame）**/
@property (nonatomic, assign) CGRect initRect;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *imageContainerView;

@end
