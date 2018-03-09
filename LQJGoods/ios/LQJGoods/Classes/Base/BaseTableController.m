//
//  BaseTableController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/5.
//  Copyright © 2018年 LQJ. All rights reserved.
//

#import "BaseTableController.h"
#import "ArrayDataSource.h"
#import "BaseTableCell.h"

const NSInteger cellH = 60;

static NSString *cellIdentifier = @"identifier";

@interface BaseTableController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) ArrayDataSource *arrayDataSource;
@end

@implementation BaseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.navigationController.navigationBar setBarTintColor:KThemeColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
   [self.tableView registerNib:[UINib nibWithNibName:@"BaseTableCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)setDataSoureArray:(NSArray *)dataSoureArray{
    _muDataArray = [BaseTableDataModel mj_objectArrayWithKeyValuesArray:dataSoureArray];
    void (^configureCell)(BaseTableCell *, BaseTableDataModel *) = ^(BaseTableCell *cell, BaseTableDataModel *model){
        cell.iconImgView.image = [UIImage imageNamed:model.iconName];
        cell.titleLabel.text = model.title;
        cell.contentView.backgroundColor = KRandomColor;
    };
    _arrayDataSource = [[ArrayDataSource alloc] initWithItems:_muDataArray cellIdentifier:cellIdentifier configureCellBlock:configureCell];
    self.tableView.dataSource = _arrayDataSource;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseTableDataModel *model = [_muDataArray objectAtIndex:indexPath.row];
    
    UIViewController *vc = [[NSClassFromString(model.className) alloc] init];
    if(vc){
      if(model.info){
        [self setInfoToVcWithVc:vc info:model.info];
      }
      vc.title = model.title;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        if(self.navigationController.viewControllers.count == 1){
            vc.hidesBottomBarWhenPushed = NO;
        }
    }
}

#pragma mark - gestureRecognizer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  return YES;
}

//判断Controller是否含有info属性
- (void)setInfoToVcWithVc:(UIViewController *)vc info:(NSString *)info{
  unsigned int count;
  objc_property_t *properties = class_copyPropertyList([vc class], &count);
  for(int i = 0; i < count; i++)
  {
    objc_property_t property = properties[i];
    NSLog(@"name:%s",property_getName(property));
    NSLog(@"attributes:%s",property_getAttributes(property));
    // 取得属性名
    NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                      encoding:NSUTF8StringEncoding];
    if([propertyName isEqualToString:@"info"]){
      [vc setValue:info forKey:propertyName];
      break ;
    }
  }
  free(properties);
}

@end
































