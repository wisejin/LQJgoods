//
//  BNPictureBrowseView.h
//  BNPictureBrowseTest
//
//  Created by benniuMAC on 16/4/7.
//  Copyright © 2016年 BN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNPictureBrowseView;
@protocol BNPictureBrowseViewDelegate <NSObject>

- (void)didShowImgIndex:(NSInteger)imgIndex andDidShowImg:(UIImage *)didShowImg andImgArray:(NSArray *)imgArray andPictureBrowseView:(BNPictureBrowseView *)pictureBrowseView;
@end

@interface BNPictureBrowseView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
/**转换后的rect（找到我触碰的位置，即点击图片面板的父视图的frame）**/

@property (nonatomic, assign) CGRect initRect;

/**
 *  构造函数
 *
 *  @param imgArray              要显示的图片数组（可以为UIImage对象，也可以为NSURL对象）。
 *  @param delegate              设置代理
 *  @param placeholderImageArray 加载底图（NSString类型）。如果值为空，则没有底图；如果底图数量不够要加载图片数组的数量（比如只有一个元素），则总是取第一个元素作为加载的底图
 *
 *  @return 返回控件对象
 */
- (instancetype)initWithImgArray:(NSMutableArray *)muImgArray andBNPictureBrowseViewDelegate:(id)delegate andPlaceholderImageArray:(NSArray *)placeholderImageArray andIndex:(NSInteger)index;

/**
 *  显示
 */
- (void)show;
@end































