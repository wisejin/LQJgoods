//
//  CustomViewController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/27.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "CustomPictureBrowseViewController.h"
#import "BNPictureBrowseView.h"
#import "FileManagerTool.h"
#import "CustomPictureBrowseCell.h"
#import "CustomPictureBrowseReusableView.h"
#import "UITapGestureRecognizer+Extension.h"

@interface CustomPictureBrowseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
  UICollectionView *_collectionView;
  
  NSMutableArray *_muFilePathDataArray;
  NSMutableArray *_muUrlDataArray;
  NSMutableArray *_muImgDataArray;
}
@end

@implementation CustomPictureBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  _muFilePathDataArray = [NSMutableArray array];
  _muUrlDataArray = [NSMutableArray array];
  _muImgDataArray = [NSMutableArray array];
  [self createData];
  
  [self createUI];
}

- (void)dealloc{
  //清除写入到沙盒的图片
  [FileManagerTool cleanDocumentCacheWithPath:@"image" andCompleteBlock:nil];
}

- (void)createData{
  for(int i = 0;i < 5;i ++){
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"Guidepage%d",i+1]];
    [_muImgDataArray addObject:img];
  }
  
  //写入到沙盒
  [FileManagerTool writeImgToDocumentWith:_muImgDataArray andCompleteBlock:^(NSArray *imgArray) {
    for (NSString *imgPath in imgArray) {
      [_muFilePathDataArray addObject:imgPath];
    }
  }];
  
  [_muUrlDataArray addObject:@"http://f.hiphotos.baidu.com/image/h%3D300/sign=4a0a3dd10155b31983f9847573ab8286/503d269759ee3d6db032f61b48166d224e4ade6e.jpg"];
  [_muUrlDataArray addObject:@"http://a.hiphotos.baidu.com/image/pic/item/f31fbe096b63f62493a948d38c44ebf81b4ca36e.jpg"];
  [_muUrlDataArray addObject:@"http://d.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a2bfe707b083b5bb5c8eab86e.jpg"];
  [_muUrlDataArray addObject:@"http://f.hiphotos.baidu.com/image/pic/item/c9fcc3cec3fdfc03ef8c9268df3f8794a5c2266d.jpg"];
  [_muUrlDataArray addObject:@"http://a.hiphotos.baidu.com/image/pic/item/7e3e6709c93d70cf4ba3dbddf3dcd100bba12b80.jpg"];
}

- (void)createUI{
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.minimumLineSpacing = 0;
  layout.minimumInteritemSpacing = 10;
  layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
  _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-KNavHeight) collectionViewLayout:layout];
  _collectionView.backgroundColor = KLightBlueColor;
  _collectionView.dataSource = self;
  _collectionView.delegate = self;
  _collectionView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:_collectionView];
  
  [_collectionView registerNib:[UINib nibWithNibName:@"CustomPictureBrowseCell" bundle:nil] forCellWithReuseIdentifier:@"identifier"];
  [_collectionView registerNib:[UINib nibWithNibName:@"CustomPictureBrowseReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
  return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  CustomPictureBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
//  CGRect rc = [cell.imgView1.superview convertRect:cell.imgView1.frame toView:self.view];
  [self addTapClickWithView:cell.imgView1 indexPath:indexPath index:0];
  [self addTapClickWithView:cell.imgView2 indexPath:indexPath index:1];
  [self addTapClickWithView:cell.imgView3 indexPath:indexPath index:2];
  [self addTapClickWithView:cell.imgView4 indexPath:indexPath index:3];
  [self addTapClickWithView:cell.imgView5 indexPath:indexPath index:4];
  //本地沙盒存储图片地址
  if(indexPath.section == 0){
    cell.filePathArray = _muFilePathDataArray;
  }
  //图片URL地址
  else if (indexPath.section == 1){
    cell.imgUrlArray = _muUrlDataArray;
  }
  //UIImage对象
  else{
    cell.imgArray = _muImgDataArray;
  }
  
  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
  if([kind isEqualToString:UICollectionElementKindSectionHeader]){
    CustomPictureBrowseReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    if(indexPath.section == 0){
      reusableView.titleLabel.text = @"file://沙盒路径的图片";
    }else if (indexPath.section == 1){
      reusableView.titleLabel.text = @"NSURL网络图片";
    }else{
      reusableView.titleLabel.text = @"UIImage对象图片";
    }
    
    return reusableView;
  }
  return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  return CGSizeMake(SCREEN_WIDTH, 200);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
  return CGSizeMake(SCREEN_WIDTH, 40);
}

//获取该View的CGRect
- (CGRect)getRectWithView:(UIView *)view{
  CGRect rect1 = [view convertRect:view.frame fromView:view.superview];//获取button在contentView的位置
  
  CGRect rect2 = [view convertRect:rect1 toView:self.view];
//  CGRect rect = [view.superview convertRect:view.frame toView:self.view];
//  rect.origin.y += 64;
  return rect2;
}

//添加手势
- (void)addTapClickWithView:(UIView *)view indexPath:(NSIndexPath *)indexPath index:(NSInteger)index{
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
  view.userInteractionEnabled = YES;
  NSMutableArray *muAppendArray = [NSMutableArray array];
  [muAppendArray addObject: view];
  tap.muAppendArray = muAppendArray;
  view.tag = indexPath.section*100+index+100;
  NSLog(@"啫啫啫啫：%ld",view.tag);
  [view addGestureRecognizer:tap];
}

- (void)tapClick:(UITapGestureRecognizer *)tap{
  NSLog(@"%ld",tap.view.tag);
  //沙盒图片路径
  if(tap.view.tag >= 100 && tap.view.tag < 200){
    NSInteger index = tap.view.tag-100+1;
    BNPictureBrowseView *pictureBrowseView = [[BNPictureBrowseView alloc] initWithImgArray:_muFilePathDataArray andBNPictureBrowseViewDelegate:nil andPlaceholderImageArray:@[@"logo-1024"] andIndex:index];
    pictureBrowseView.initRect = [self getRectWithView:[tap.muAppendArray firstObject]];
    [pictureBrowseView show];
  }
  //网络图片地址
  else if (tap.view.tag >= 200 && tap.view.tag < 300){
    NSMutableArray *muUrlArray = [NSMutableArray array];
    for (NSString *urlStr in _muUrlDataArray) {
      [muUrlArray addObject:[NSURL URLWithString:urlStr]];
    }
    BNPictureBrowseView *pictureBrowseView = [[BNPictureBrowseView alloc] initWithImgArray:muUrlArray andBNPictureBrowseViewDelegate:nil andPlaceholderImageArray:@[@"logo-1024"] andIndex:tap.view.tag-200+1];
    //initRect可以不传，即会其它动画
    pictureBrowseView.initRect = [self getRectWithView:[tap.muAppendArray firstObject]];
    [pictureBrowseView show];
  }
  //UIImage对象
  else{
    BNPictureBrowseView *pictureBrowseView = [[BNPictureBrowseView alloc] initWithImgArray:_muImgDataArray andBNPictureBrowseViewDelegate:nil andPlaceholderImageArray:@[@"logo-1024"] andIndex:tap.view.tag-300+1];
    pictureBrowseView.initRect = [self getRectWithView:[tap.muAppendArray firstObject]];
    [pictureBrowseView show];
  }
}

@end






















