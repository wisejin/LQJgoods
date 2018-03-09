//
//  BNPictureBrowseCell.m
//  BNPictureBrowseTest
//
//  Created by benniuMAC on 16/4/7.
//  Copyright © 2016年 BN. All rights reserved.
//

#import "BNPictureBrowseCell.h"
#import "SDWebImage/UIImageView+WebCache.h"     //图片异步加载
#import "SVProgressHUD.h"
#import "BNImgProgressHUD.h"

@interface BNPictureBrowseCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate> {
    CGFloat _aspectRatio;
}
/**图片加载动画**/
@property (nonatomic, strong) BNImgProgressHUD *imgHUD;

@end

@implementation BNPictureBrowseCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeRedraw;
        _imageView.clipsToBounds = YES;
        _imageContainerView.userInteractionEnabled = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
    }
    return self;
}

- (void)setImg:(UIImage *)img
{
    _img = img;
    [_scrollView setZoomScale:1.0 animated:NO];
    self.imageView.image = img;
    [self resizeSubviews];
}

- (void)setImgURL:(NSURL *)imgURL
{
  _imgURL = imgURL;
  [self.imageView sd_setImageWithURL:_imgURL placeholderImage:[UIImage imageNamed:_placeholderImageStr] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    NSLog(@"receivedSize=%ld,expectedSize=%ld,receivedSize/expectedSize=%@",receivedSize,expectedSize,[NSString stringWithFormat:@"%.f%@",((float)receivedSize/(float)expectedSize)*100,@"%"]);
    if(_imgHUD == nil)
    {
      _imgHUD = [BNImgProgressHUD showHUDto:self animated:YES];
    }
    if(expectedSize >= 0)
    {
      _imgHUD.ratioLabel.text = [NSString stringWithFormat:@"%.f%@",((float)receivedSize/(float)expectedSize)*100,@"%"];
    }
  } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    [_imgHUD hide:YES];
    if(!image && error)
    {
      [SVProgressHUD setFont:[UIFont systemFontOfSize:12]];
      [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
      [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
      [SVProgressHUD setErrorImage:[UIImage imageNamed:@"iconfont-shibai.png"]];
      [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }
    else
    {
      _img = image;
      [_scrollView setZoomScale:1.0 animated:NO];
      [self resizeSubviews];
    }
  }];
}

- (void)resizeSubviews {
    
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.center_y = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    _scrollView.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    //显示状态条
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    if(_initRect.size.width)
    {
        [_imgHUD hide:YES];
        __weak typeof(self)weakSelf = self;
        //添加动画
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.backgroundColor = [UIColor clearColor];
            weakSelf.superview.backgroundColor = [UIColor clearColor];
            //先把放大的滚动视图缩小先
            _scrollView.zoomScale = 1;
            self.imageContainerView.frame = _initRect;
            self.imageView.frame = self.imageContainerView.bounds;
        } completion:^(BOOL finished) {
            if (weakSelf.singleTapGestureBlock) {
                weakSelf.singleTapGestureBlock();
            }
        }];
    }
    else
    {
        if (self.singleTapGestureBlock) {
            self.singleTapGestureBlock();
        }
    }
    NSLog(@"单击");
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width) ? (scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height) ? (scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


@end



