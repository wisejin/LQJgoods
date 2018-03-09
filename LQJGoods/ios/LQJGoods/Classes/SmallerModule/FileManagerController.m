//
//  FileManagerController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/3/5.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "FileManagerController.h"
#import "FileDataModel.h"
#import "FileManagerCell.h"
#import "UITapGestureRecognizer+Extension.h"
#import "FileManagerTool.h"
#import "FileWebBrowseController.h"
#import "BNRefreshView.h"

@interface FileManagerController ()<UITableViewDelegate,UITableViewDataSource,BNRefreshViewDelegate>{
  //后缀名 word文档：.docx  PPT文档：.pptx  Excel文档：.xlsx  PDF文档：.pdf  TXT文档：.txt  RTF文档：.rtf  其它文档
  NSMutableArray *_muDataArray;
  NSMutableArray *_muFileDataArray;
  UITableView *_tableView;
  UIView *_scrollLineView;
  
  //底部
  UILabel *_selectSizeLabel;
  UIButton *_submitButton;
  NSMutableArray *_muSelectFileModelArray;
  
  BNRefreshView *_refreshHeader;
}

@end

@implementation FileManagerController

- (void)dealloc{
  [_refreshHeader free];
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  //记得回调RN的block方法，不然会造成内存泄漏
  if(_muInfoDataArray.count){
    RCTResponseSenderBlock RNCallBackBlock = [_muInfoDataArray lastObject];
    RNCallBackBlock(@[]);
  }
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = KLightBlueColor;
  _muDataArray = [NSMutableArray array];
  _muFileDataArray = [NSMutableArray array];
  _muSelectFileModelArray = [NSMutableArray array];
  [self createData];
  [self createUI];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navRightAddClick)];
  
  _refreshHeader = [BNRefreshView refreshViewWithScrollView:_tableView];
  _refreshHeader.delegate = self;
}

- (void)createUI{
  NSArray *titleArray = @[@"文档",@"视频",@"相册",@"音乐",@"其他"];
  UIView *toView = [[UIView alloc] initWithFrame:CGRectMake(0, KNavHeight, SCREEN_WIDTH, 40)];
  toView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:toView];
  for(int i = 0;i < 5;i ++){
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((SCREEN_WIDTH/5.0)*i, 0, (SCREEN_WIDTH/5.0), 40);
    button.tag = 190+i;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(topBtClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:titleArray[i] forState:UIControlStateNormal];
    [toView addSubview:button];
  }
  
  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
  lineView.backgroundColor = KLightGrayColor;
  [toView addSubview:lineView];
  _scrollLineView = [[UIView alloc] initWithFrame:CGRectMake(((SCREEN_WIDTH/5.0)-40)/2.0, 38, 40, 2)];
  _scrollLineView.backgroundColor = KThemeColor;
  [toView addSubview:_scrollLineView];
  
  //表格
  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNavHeight+40, SCREEN_WIDTH, SCREEN_HEIGHT-(KNavHeight+40+40)) style:UITableViewStyleGrouped];
  _tableView.backgroundColor = KLightBlueColor;
  _tableView.dataSource = self;
  _tableView.delegate = self;
  if (@available(iOS 11.0, *)) {
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  }
  _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
  _tableView.scrollIndicatorInsets = _tableView.contentInset;
  _tableView.rowHeight = 150;
  _tableView.sectionHeaderHeight = 0.1f;
  _tableView.sectionFooterHeight = 0.1f;
//  _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  [self.view addSubview:_tableView];
  [_tableView registerNib:[UINib nibWithNibName:@"FileManagerCell" bundle:nil] forCellReuseIdentifier:@"identifier"];
  
  [self createBottonView];
}

- (void)createBottonView{
  UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40)];
  bottomView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:bottomView];
  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
  lineView.backgroundColor = KLightGrayColor;
  [bottomView addSubview:lineView];
  
  _selectSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
  _selectSizeLabel.textColor = [UIColor lightGrayColor];
  _selectSizeLabel.font = [UIFont systemFontOfSize:13];
  [bottomView addSubview:_selectSizeLabel];
  
  _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _submitButton.frame =CGRectMake(SCREEN_WIDTH-80, 5, 70, 30);
  _submitButton.backgroundColor = KThemeColor;
  _submitButton.layer.cornerRadius = 3;
  [_submitButton setTitle:@"发送" forState:UIControlStateNormal];
  _submitButton.titleLabel.font = [UIFont systemFontOfSize:14];
  _submitButton.tag = 180;
  [_submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  [_submitButton addTarget:self action:@selector(submitBtClick:) forControlEvents:UIControlEventTouchUpInside];
  _submitButton.enabled = NO;
  [bottomView addSubview:_submitButton];
}

- (void)createData{
  [_muDataArray removeAllObjects];
  [_muSelectFileModelArray removeAllObjects];
  [_muFileDataArray removeAllObjects];
  for(int i = 0;i < 7;i ++){
    NSMutableArray *muFileDataArray = [NSMutableArray array];
    [_muDataArray addObject:muFileDataArray];
  }
  
  //先把沙盒路径的文件移动到localFile目录
  [FileManagerTool moveFoldFilePath:nil toPath:@"localFile" andCompleteBlock:^(BOOL b) {
    if(b){
      [FileManagerTool examineDocumentFileWithFoldName:@"localFile" andCompleteBlock:^(NSArray<FileDataModel *> *fileDataModelArray) {
        if(fileDataModelArray.count){
          for (FileDataModel *model in fileDataModelArray) {
            [_muFileDataArray addObject:model];
          }
          
        }
        [_refreshHeader endRefreshing];
      }];
    }
  }];
}

#pragma mark - BNRefreshViewDelegate
//下拉刷新
- (void)refreshViewStartRefresh:(BNRefreshView *)refreshView{
  [self createData];
  [_tableView reloadData];
  [self calculateSelectFile];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return _muDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if(_muDataArray[section]){
    NSMutableArray *muArray =_muDataArray[section];
    return muArray.count;
  }
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.01f;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  FileManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
  NSMutableArray *muArray = [_muDataArray objectAtIndex:indexPath.section];
  cell.backgroundColor = [UIColor whiteColor];
  FileDataModel *model = [muArray objectAtIndex:indexPath.row];
//  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.fileDataModel = model;
  
  cell.fileLogoImgView.userInteractionEnabled = YES;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fileLogoImgTapClick:)];
  NSMutableArray *muAppendArray = [NSMutableArray array];
  [muAppendArray addObject:model];
  tap.muAppendArray = muAppendArray;
  [cell.fileLogoImgView addGestureRecognizer:tap];
  
  return cell;
}

//创建组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
  sectionView.backgroundColor = [UIColor whiteColor];
  UIImageView *arrowImgView = [[UIImageView alloc] init];
  NSMutableArray *muFileDataArray = [_muDataArray objectAtIndex:section];
  if(muFileDataArray.count){
    arrowImgView.image = [UIImage imageNamed:@"arrow_down"];
    arrowImgView.frame = CGRectMake(10, 16, 13, 8);
  }else{
    arrowImgView.image = [UIImage imageNamed:@"right-arrow"];
    arrowImgView.frame = CGRectMake(10, 16, 8, 13);
  }
  [sectionView addSubview:arrowImgView];
  sectionView.userInteractionEnabled = YES;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableSectionClick:andSection:)];
  NSMutableArray *muAppendArray = [NSMutableArray array];
  [muAppendArray addObject:@(section)];
  tap.muAppendArray = muAppendArray;
  [sectionView addGestureRecognizer:tap];
  UILabel *sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 10, 150, 20)];
  sectionTitleLabel.textColor = [UIColor blackColor];
  [sectionView addSubview:sectionTitleLabel];
  sectionTitleLabel.text = [self sectionTypeWithSection:section];
  sectionTitleLabel.font = [UIFont boldSystemFontOfSize:16];
  return sectionView;
}

#pragma mark - UITableViewDelegate
//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSMutableArray *muArray = [_muDataArray objectAtIndex:indexPath.section];
  FileDataModel *model = [muArray objectAtIndex:indexPath.row];
  model.isSelect = !model.isSelect;
  [tableView reloadData];
  [self calculateSelectFile];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
  NSMutableArray *muFileDataArray = [_muDataArray objectAtIndex:indexPath.section];
  if(muFileDataArray.count){
    FileDataModel *model = muFileDataArray[indexPath.row];
    [FileManagerTool cleanDocumentCacheWithPath:[NSString stringWithFormat:@"/localFile/%@",model.name] andCompleteBlock:^(BOOL b) {
      if(b){
        [_muFileDataArray removeObject:model];
        [muFileDataArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [self calculateSelectFile];
      }
      
    }];
  }
}

//组头点击事件
- (void)tableSectionClick:(UITapGestureRecognizer *)tap andSection:(NSInteger)section{
  NSNumber *number = [tap.muAppendArray firstObject];
  NSMutableArray *muArray = [_muDataArray objectAtIndex:[number integerValue]];
  if(muArray.count){
    [muArray removeAllObjects];
  }else{
    for (FileDataModel *model in _muFileDataArray) {
      if([model.type isEqualToString:[self sectionTypeWithSection:[number integerValue]]]){
        [muArray addObject:model];
      }
    }
  }
  [_tableView reloadData];
  
}

- (NSString *)sectionTypeWithSection:(NSInteger)section{
  switch (section) {
    case 0:
      return @"WORD";
      break;
      
    case 1:
      return @"PPT";
      break;
      
    case 2:
      return @"EXCEL";
      break;
      
    case 3:
      return @"PDF";
      break;
      
    case 4:
      return @"TXT";
      break;
      
    case 5:
      return @"RTF";
      break;
      
    case 6:
      return @"OTHER";
      break;
      
    default:
      return @"";
      break;
  }
}

//计算选中的文件
- (void)calculateSelectFile{
  [_muSelectFileModelArray removeAllObjects];
  if(_muFileDataArray.count){
    for (FileDataModel *model in _muFileDataArray) {
      if(model.isSelect){
        [_muSelectFileModelArray addObject:model];
      }
    }
  }
  
  if(_muSelectFileModelArray.count){
    long long fileSize = 0;
    for (FileDataModel *model in _muSelectFileModelArray) {
      fileSize += model.fileSize;
    }
    float fileSizef = fileSize/(1024.0*1024.0);
    if(fileSizef < 1){
      fileSizef = fileSize/1024.0;
      _selectSizeLabel.text = [NSString stringWithFormat:@"已选%.2fKB",fileSizef];
    }else{
      _selectSizeLabel.text = [NSString stringWithFormat:@"已选%.2fMB",fileSizef];
    }
    [_submitButton setTitle:[NSString stringWithFormat:@"确定(%ld)",_muSelectFileModelArray.count] forState:UIControlStateNormal];
    _submitButton.enabled = YES;
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  }else{
    _selectSizeLabel.text = @"";
    [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _submitButton.enabled = NO;
  }
}

#pragma mark - 点击事件
//顶部按钮点击事件
- (void)topBtClick:(UIButton *)button{
  NSLog(@"%ld",button.tag);
  NSInteger index = button.tag - 190;
  [UIView animateWithDuration:0.3 animations:^{
    _scrollLineView.frame = CGRectMake(((SCREEN_WIDTH/5.0)-40)/2.0+(SCREEN_WIDTH/5.0)*index, 38, 40, 2);
  }];
  
}

//导航条添加按钮事件
- (void)navRightAddClick{
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  NSArray *nameArray = @[@"iOS对数据操作的基本流程.pptx",@"rtmp.ppt",@"《一起赛业绩》项目进度【2018-02-26】.docx",@"OA接口_for赛业绩_各接口列表返回结果.xls",@"需要合并接口.rtf",@"交互说明-前途定稿20180108.pdf",@"test.txt"];
  NSMutableArray *muDataArray = [NSMutableArray array];
  
  for(NSString *fileName in nameArray){
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"" ofType:[[fileName componentsSeparatedByString:@"."]lastObject]];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    [muDataArray addObject:data];
  }
  
  if(muDataArray.count){
    __weak typeof(self)weakSelf = self;
    [FileManagerTool writeFileToDocumentWithDataArray:muDataArray andFileNameArray:nameArray andCompleteBlock:^(NSArray *dataPathArray) {
      NSLog(@"发生发顺丰：%@",dataPathArray);
      [MBProgressHUD hideHUDForView:self.view animated:YES];
      [weakSelf createData];
      [_tableView reloadData];
    }];
  }
}

//文件logo点击事件
- (void)fileLogoImgTapClick:(UITapGestureRecognizer *)tap{
  NSMutableArray *muAppendArray = tap.muAppendArray;
  FileDataModel *model = muAppendArray[0];
  FileWebBrowseController *webBrowseVc = [[FileWebBrowseController alloc] init];
  webBrowseVc.model = model;
  [self.navigationController pushViewController:webBrowseVc animated:YES];
}

//确定提交按钮
- (void)submitBtClick:(UIButton *)button{
  NSLog(@"%ld",button.tag);
  if(_muInfoDataArray.count && _muSelectFileModelArray.count){
    RCTResponseSenderBlock RNCallBackBlock = [_muInfoDataArray lastObject];
    NSMutableArray *muSelectFileDataJsonArray = [NSMutableArray array];
    for(FileDataModel *model in _muSelectFileModelArray){
      NSMutableDictionary *muModelDic = model.mj_keyValues;
      [muSelectFileDataJsonArray addObject:muModelDic];
    }
    
    RNCallBackBlock(@[muSelectFileDataJsonArray]);
    [_muInfoDataArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
  }
}
@end































