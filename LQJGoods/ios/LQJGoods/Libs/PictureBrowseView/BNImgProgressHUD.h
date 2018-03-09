//
//  BNImgProgressHUD.h
//  BNPictureBrowsingProject
//
//  Created by benniuMAC on 16/3/11.
//  Copyright © 2016年 BN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNImgProgressHUD : UIView

/**显示加载比例**/
@property (nonatomic, strong) UILabel *ratioLabel;

- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;

+ (instancetype)showHUDto:(UIView *)view animated:(BOOL)animated;

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;

@end
