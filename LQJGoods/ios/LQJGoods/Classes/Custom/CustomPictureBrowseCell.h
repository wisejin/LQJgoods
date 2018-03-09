//
//  CustomPictureBrowseCell.h
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/27.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPictureBrowseCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;

@property (weak, nonatomic) IBOutlet UIImageView *imgView5;

@property (nonatomic, strong) NSArray *imgUrlArray;
@property (nonatomic, strong) NSArray *filePathArray;
@property (nonatomic, strong) NSArray *imgArray;

@end
