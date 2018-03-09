//
//  BaseRichTextController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/26.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "BaseRichTextController.h"
#import "BNPictureBrowseView.h"

@interface BaseRichTextController ()<UITableViewDataSource,UITableViewDelegate,RichTextCellDelegate,RichTextReplyInputViewDelegate>{
  UITableView *_mainTable;
  UIButton *_replyBtn;
  RichTextReplyInputView *_replyView ;
  BOOL _hideReply;
}

@end

@implementation BaseRichTextController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  [self initTableview];
}

- (void) initTableview{
  _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, KNavHeight, self.view.frame.size.width, self.view.frame.size.height-KNavHeight) style:UITableViewStyleGrouped];
  if (@available(iOS 11.0, *)) {
    _mainTable.estimatedRowHeight = 0;
    _mainTable.estimatedSectionFooterHeight = 0;
    _mainTable.estimatedSectionHeaderHeight = 0;
    _mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  }
  _mainTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
  _mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  _mainTable.delegate = self;
  _mainTable.dataSource = self;
  
  [_mainTable registerClass:[RichTextCell class] forCellReuseIdentifier:@"RichTextCellIdentifier"];
  [self.view addSubview:_mainTable];
}

#pragma mark - 计算高度
- (RichTextDataModel*)calculateHeights:(RichTextDataModel *)ymData{
  ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
  ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
  ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
  return ymData;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return  [[self dataSource] numberOfRowsInRichText];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  RichTextDataModel *ym = [[self dataSource] dataForRowAtIndex:[indexPath section]];
  BOOL unfold = ym.foldOrNot;
  CGFloat height = TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance;
  if ([self.delegate respondsToSelector:NSSelectorFromString(@"hideReplyButtonForIndex:")]) {
    if ([[self delegate] hideReplyButtonForIndex:indexPath.section]) {
      height -= 40;
    }
  }
  return  height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  //    static NSString *CellIdentifier = @"ILTableViewCell";
    RichTextCell*cell = (RichTextCell *)[tableView dequeueReusableCellWithIdentifier:@"RichTextCellIdentifier"];
  //    if (cell == nil) {
  //        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  //    }
//  for (UIView *view in [cell.contentView subviews]) {
//    [view removeFromSuperview];
//  }
  
//  [cell initView];
  
  cell.stamp = indexPath.section;
  cell.replyBtn.tag = indexPath.section;
  cell.replyBtn.appendIndexPath = indexPath;
  [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
  cell.delegate = self;
  if ([self.delegate respondsToSelector:NSSelectorFromString(@"hideReplyButtonForIndex:")]) {
    if ([[self delegate] hideReplyButtonForIndex:indexPath.section]) {
      cell.hideReply = YES;
    }
  }
  RichTextDataModel *data = [[self dataSource] dataForRowAtIndex:[indexPath section]];
  //    NSLog(@"")
  //这里是为了解决
  if(!data.shuoshuoHeight){
    data = [self calculateHeights:[[self dataSource] dataForRowAtIndex:[indexPath section]]];
  }
  //这句话让头像 支持异步加载
  [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:data.headPicUrl] placeholderImage:[UIImage imageNamed:@"nilPic.png"]];
  //    cell.headerImage.image = data.headPic;
  cell.nameLbl.text = data.name;
  cell.introLbl.text = data.intro;
  [cell setRichTextViewWith:data];
  return cell;
}

#pragma mark - 按钮动画
- (void)replyAction:(UIButton *)sender{
//  CGRect rectInTableView = [_mainTable rectForRowAtIndexPath:sender.appendIndexPath];
  CGRect rectInTableView = [_mainTable rectForSection:sender.appendIndexPath.section];
  NSLog(@"%@",sender.appendIndexPath);
  float origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
  if (_replyBtn) {
    [UIView animateWithDuration:0.25f animations:^{
      _replyBtn.frame = CGRectMake(sender.frame.origin.x, origin_Y - 10 , 0, 38);
    } completion:^(BOOL finished) {
      NSLog(@"销毁");
      [_replyBtn removeFromSuperview];
      _replyBtn = nil;
    }];
  }else{
    _replyBtn = [UIButton buttonWithType:0];
    _replyBtn.layer.cornerRadius = 5;
    _replyBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:37/255.0 blue:38/255.0 alpha:0.8];
    _replyBtn.frame = CGRectMake(sender.frame.origin.x , origin_Y - 10 , 0, 38);
    [_replyBtn setTitleColor:[UIColor whiteColor] forState:0];
    _replyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _replyBtn.tag = sender.tag;
    [_mainTable addSubview:_replyBtn];
    [_replyBtn addTarget:self action:@selector(replyMessage:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.25f animations:^{
      _replyBtn.frame = CGRectMake(sender.frame.origin.x - 60, origin_Y  - 10 , 60, 38);
    } completion:^(BOOL finished) {
      [_replyBtn setTitle:@"评论" forState:0];
    }];
  }
}

#pragma mark - 真の评论  回复发送评论
- (void)replyMessage:(UIButton *)sender{
  //NSLog(@"TAG === %d",sender.tag);
  if (_replyBtn){
    [_replyBtn removeFromSuperview];
    _replyBtn = nil;
  }
  // NSLog(@"alloc reply");
  
  _replyView = [[RichTextReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, SCREEN_WIDTH,44) andAboveView:self.view];
  _replyView.delegate = self;
  _replyView.replyTag = sender.tag;
  [self.view addSubview:_replyView];
}

#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
  if (_replyBtn) {
    [_replyBtn removeFromSuperview];
    _replyBtn = nil;
  }
}

#pragma mark - RichTextCellDelegate
- (void)changeFoldState:(RichTextDataModel *)ymD onCellRow:(NSInteger)cellStamp{
  RichTextCell *cell = (RichTextCell*)[_mainTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:cellStamp]];
  [cell setRichTextViewWith:ymD];
  [_mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:cellStamp]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)didHeadPicPressForIndex:(NSInteger)index{
  if ([self.delegate respondsToSelector:NSSelectorFromString(@"didPromulgatorPressForIndex:name:")]) {
    [self.delegate didPromulgatorPressForIndex:index name:@""];
  }
}

-(void)didPromulgatorNameOrHeadPicPressedForIndex:(NSInteger)index name:(NSString *)name{
  if ([self.delegate respondsToSelector:NSSelectorFromString(@"didPromulgatorPressForIndex:name:")]) {
    [self.delegate didPromulgatorPressForIndex:index name:name];
  }
}

-(void)didRichTextPress:(NSString *)text index:(NSInteger)index{
  if ([self.delegate respondsToSelector:NSSelectorFromString(@"didRichTextPressedFromText:index:")]) {
    [self.delegate didRichTextPressedFromText:text index:index];
  }
}

-(void)didRichTextPress:(NSString *)text index:(NSInteger)index replyIndex:(NSInteger)replyIndex{
  if ([self.delegate respondsToSelector:NSSelectorFromString(@"didRichTextPressedFromText:index:replyIndex:")]) {
    [self.delegate didRichTextPressedFromText:text index:index replyIndex:replyIndex];
  }
}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
  NSLog(@"%ld",clickTag);
  if(imageViews.count){
    NSMutableArray *muImageUrlArray = [NSMutableArray array];
    for (NSString *url in imageViews) {
      [muImageUrlArray addObject:[NSURL URLWithString:url]];
    }
    BNPictureBrowseView *pictureBrowseView = [[BNPictureBrowseView alloc] initWithImgArray:muImageUrlArray andBNPictureBrowseViewDelegate:nil andPlaceholderImageArray:@[@"logo-1024"] andIndex:clickTag-9999+1];
    [pictureBrowseView show];
  }
}

#pragma mark - 评论说说回调
- (void)replyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
  NSLog(@"评论说说回调");
  
  NSString *newString = [NSString stringWithFormat:@"@%@:%@",[[self delegate] senderName],replyText];//此处可扩展。已写死，包括内部逻辑也写死 在YMTextData里 自行添加部分
  //    YMTableViewCell *cell = (YMTableViewCell*)[mainTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:inputTag]];
  RichTextDataModel *ymData = [self.muDataArray objectAtIndex:inputTag];
  [ymData.muReplyDataSourceArray addObject:newString];
  //清空属性数组。否则会重复添加
  [ymData.muCompletionReplySourceArray removeAllObjects];
  [ymData.muAttributeDataArray removeAllObjects];
  
  NSString *rangeStr = NSStringFromRange(NSMakeRange(0, [[self delegate] senderName].length));
  NSMutableArray *rangeArr = [[NSMutableArray alloc] init];
  [rangeArr addObject:rangeStr];
  [ymData.muDefineAttrDataArray addObject:rangeArr];
  ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
//  ymData.replyHeight += [ymData addNewReplycalculateReplyHeightWithWidth:self.view.frame.size.width replyDataStr:newString];

  //    [cell setYMViewWith:ymData];
  //    if(self.muYmDataArray.count && self.muYmDataArray[inputTag]){
  //        [self.muYmDataArray replaceObjectAtIndex:inputTag withObject:ymData];
  //    }
  //    [mainTable reloadData];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:inputTag];
  [_mainTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  //    if ([self.delegate respondsToSelector:NSSelectorFromString(@"replyForIndex:replyText:")]) {
  //        [self.delegate replyForIndex:inputTag replyText:replyText];
  //    }
  
}

- (void)destorySelf{
  //  NSLog(@"dealloc reply");
  [_replyView removeFromSuperview];
  _replyView = nil;
}

@end











































