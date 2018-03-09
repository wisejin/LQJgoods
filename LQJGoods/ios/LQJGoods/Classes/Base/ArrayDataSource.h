//
//  ArrayDataSource.h
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/5.
//  Copyright © 2018年 LQJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^configureCell)(id cell, id item);

@interface ArrayDataSource : NSObject<UITableViewDataSource>

- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)identifier configureCellBlock:(configureCell)configureCellBlock;
- (void)setDataSourceArray:(NSArray *)array;

@end































