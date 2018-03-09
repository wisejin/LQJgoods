//
//  BaseTableCell.h
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/5.
//  Copyright © 2018年 LQJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
