//
//  FileManagerCell.h
//  LQJGoods
//
//  Created by 廖其进 on 2018/3/5.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileDataModel.h"

@interface FileManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;
@property (weak, nonatomic) IBOutlet UIImageView *fileLogoImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *storageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) FileDataModel *fileDataModel;

@end
