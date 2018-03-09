//
//  BNPictureBrowseView.m
//  BNPictureBrowseTest
//
//  Created by benniuMAC on 16/4/7.
//  Copyright © 2016年 BN. All rights reserved.
//

#import "BNPictureBrowseView.h"
#import "BNPictureBrowseCell.h"
#import "UIView+Extension.h"

@interface BNPictureBrowseView (){
  //系统动画停止是刷新当前偏移量_offer是我定义的全局变量
  CGFloat _offer;
}
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *muDataArray;
/**
 *  表格
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  Index of the photo user click / 用户点击的图片的索引
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  加载底图数组
 */
@property (nonatomic, strong) NSArray *placeholderImageArray;
/**
 *  父视图（这里是keyWindow）
 */
@property (nonatomic, strong) UIView *superView;
/**
 *  记录自己的位置
 */
@property (nonatomic, assign) CGRect scaleOriginRect;
/**
 *  底部显示图片的张数
 */
@property (nonatomic, strong) UILabel *signalLabel;
/**
 *  默认显示第几张
 */
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) id<BNPictureBrowseViewDelegate>delegate;
@end

@implementation BNPictureBrowseView
- (instancetype)initWithImgArray:(NSMutableArray *)muImgArray andBNPictureBrowseViewDelegate:(id)delegate andPlaceholderImageArray:(NSArray *)placeholderImageArray andIndex:(NSInteger)index
{
    if(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]){
        _delegate = delegate;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window endEditing:YES];
        _superView = window;
        //数据源
        _muDataArray = [muImgArray copy];
//        _initRect = CGRectMake(100, 100, 100, 100);
        //记录自己的位置
        _scaleOriginRect = window.bounds;
        _index = index;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.alpha = 0.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 30;
  layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 30);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width , self.bounds.size.height) collectionViewLayout:layout];
   _collectionView.contentSize = CGSizeMake(self.bounds.size.width * _muDataArray.count, self.bounds.size.height);
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
//    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(SCREEN_WIDTH*(_index>0?_index-1:0)+(_index-1)*30, 0);
  //写完这些你可能发现效果不好，原因是系统的减速点太大了我们改小点就好了
  _collectionView.decelerationRate = 10;//我改的是10
  
    [self addSubview:_collectionView];
    //单元格注册
    [_collectionView registerClass:[BNPictureBrowseCell class] forCellWithReuseIdentifier:@"BNPictureBrowseCell"];
    
    //底部显示图片的张数
    _signalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-30, SCREEN_WIDTH, 20)];
    _signalLabel.textColor = [UIColor whiteColor];
    _signalLabel.font = [UIFont systemFontOfSize:17];
    _signalLabel.backgroundColor = [UIColor clearColor];
    _signalLabel.textAlignment = NSTextAlignmentCenter;
    _signalLabel.text = [NSString stringWithFormat:@"%ld/%ld",_index>0?_index:1,_muDataArray.count];
//    [_collectionView addSubview:_signalLabel];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGPoint offSet = scrollView.contentOffset;
  _currentIndex = offSet.x / (self.width+((_muDataArray.count-1)*30)/_muDataArray.count);
  _signalLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,_muDataArray.count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self refreshNaviBarAndBottomBarState];

  _signalLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,_muDataArray.count];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

  _offer = scrollView.contentOffset.x;
  NSLog(@"end========%f",_offer);
}

//滑动减速是触发的代理，当用户用力滑动或者清扫时触发
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
  if (fabs(scrollView.contentOffset.x -_offer) > 10) {
    if (scrollView.contentOffset.x > _offer && _currentIndex != _muDataArray.count-1) {
      int i = scrollView.contentOffset.x/(self.width + 30)+1;
      NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
      [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }else if(scrollView.contentOffset.x < _offer){
      int i = scrollView.contentOffset.x/(self.width + 30)+1;
      if(i != 0){
        NSIndexPath * index =  [NSIndexPath indexPathForRow:i-1 inSection:0];
        [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
      }
    }
    else if (scrollView.contentOffset.x > _offer && _currentIndex == _muDataArray.count-1){
      NSIndexPath * index =  [NSIndexPath indexPathForRow:_currentIndex inSection:0];
      [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
  }
}

//用户拖拽是调用
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
  if (fabs(scrollView.contentOffset.x -_offer) > 20) {
    int i = scrollView.contentOffset.x/(self.width + 30)+1;
    if(i != 0){
      if (scrollView.contentOffset.x > _offer && _currentIndex != _muDataArray.count-1){
        NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
        [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
      }else if(scrollView.contentOffset.x < _offer){
        NSIndexPath * index =  [NSIndexPath indexPathForRow:i-1 inSection:0];
        [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
      }else if (scrollView.contentOffset.x > _offer && _currentIndex == _muDataArray.count-1){
        NSIndexPath * index =  [NSIndexPath indexPathForRow:_currentIndex inSection:0];
        [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
      }
      
    }
  }
}

#pragma mark - UICollectionViewDataSource && Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _muDataArray.count;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//  return _muDataArray.count;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BNPictureBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BNPictureBrowseCell" forIndexPath:indexPath];
    //NSURL 对象
    if([[_muDataArray objectAtIndex:indexPath.row] isKindOfClass:NSClassFromString(@"NSURL")])
    {
        cell.imgURL = [_muDataArray objectAtIndex:indexPath.row];
        if(_placeholderImageArray.count > indexPath.row)
        {
            cell.placeholderImageStr = [_placeholderImageArray objectAtIndex:indexPath.row];
        }
        else
        {
             cell.placeholderImageStr = [_placeholderImageArray objectAtIndex:0];
        }
    }
    //UIImage对象
    else if([[_muDataArray objectAtIndex:indexPath.row] isKindOfClass:NSClassFromString(@"UIImage")])
    {
        cell.img = _muDataArray[indexPath.row];
    }
    //本地相册目录路径
    else{
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:_muDataArray[indexPath.row]]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_muDataArray[indexPath.row]] options:NSDataReadingMappedAlways error:nil];
        NSLog(@"爱多多：%ld",indexPath.row);
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
          dispatch_async(dispatch_get_main_queue(), ^{
            //在这里做UI操作(UI操作都要放在主线程中执行)
            cell.img = image;
          });
        }
        
      });
    }
    //如果要返回原来的位置
    if(_initRect.size.width)
    {
//      CGRect rect1 = [view convertRect:view.frame fromView:cell.contentView];//获取button在contentView的位置
//
//      CGRect rect2 = [view convertRect:rect1 toView:[UIApplication sharedApplication].keyWindow];
      cell.superview.frame = [UIApplication sharedApplication].keyWindow.frame;
        cell.initRect = _initRect;
    }
    //单击隐藏完成block
    cell.singleTapGestureBlock = ^(void)
    {
        [UIView animateWithDuration:.6f animations:^
         {
             self.alpha = 0;
         }completion:^(BOOL finished)
         {
             //移除该视图
             [self removeFromSuperview];
//             [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
         }];
    };
    return cell;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//
//  return UIEdgeInsetsMake(0, 40, 0, 30);//第一个cell居中的效果,调用一次   上 左 下 右 的偏移量
//
//}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//
//  CGFloat offSetX = targetContentOffset->x; //偏移量
//
//  CGFloat itemWidth = SCREEN_WIDTH-100;   //itemSizem 的宽
//
//  //itemSizem的宽度+行间距 = 页码的宽度
//
//  NSInteger pageWidth = itemWidth + 30;
//
//  //根据偏移量计算 第几页
//
//  NSInteger pageNum = (offSetX+pageWidth/2)/pageWidth;
//
//  //根据显示的第几页,从而改变偏移量
//
//  targetContentOffset->x += 100;
//
//  NSLog(@"%.1f",targetContentOffset->x);
//
//}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//  if(indexPath.row+1 != _muDataArray.count){
//    if(collectionView.contentScaleFactor)
//    BNPictureBrowseCell *cell1 = (BNPictureBrowseCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
//    //  _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//    cell1.scrollView.frame = CGRectMake(10, 0, self.bounds.size.width, self.bounds.size.height);
//  }
//
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//  BNPictureBrowseCell *cell1 = (BNPictureBrowseCell *)cell;
//  cell1.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//}

#pragma mark 显示
- (void)show
{
    //添加动画显示到父视图上
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = _scaleOriginRect;
        self.alpha = 1.0;
        [_superView addSubview:self];
        [self addSubview:_signalLabel];
    } completion:^(BOOL finished) {
        //状态条隐藏
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }];
}

@end















































