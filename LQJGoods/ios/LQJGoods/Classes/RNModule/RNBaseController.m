//
//  RNBaseController.m
//  BNBravat
//
//  Created by 廖其进 on 2018/1/5.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "RNBaseController.h"
#import "FileDataModel.h"

@interface RNBaseController ()<UINavigationControllerDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>{
  
  //获取相册、相机图片回调给JS的block
  RCTResponseSenderBlock _launchImageLibraryCallback;
  RCTResponseSenderBlock _launchCameraCallback;
  
  //清除缓存回调给JS的block
  RCTResponseSenderBlock _cleanDocumentCacheCallback;
  
  //当前屏幕是否是向右的横屏
  BOOL _isOrientationLandscapeRight;
  
  //是否要打开当前界面左边返回手势
  BOOL _isOpenGespanBack;
}

@end

@implementation RNBaseController

#pragma mark ================== 各种进入界面触发方法 =============
- (void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  _launchImageLibraryCallback = nil;
  _launchCameraCallback = nil;
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  //    [self.navigationController.navigationBar setBarTintColor:KMainColor];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _isOpenGespanBack = true;
  NSURL *jsCodeLocation;
  
#ifdef DEBUG
  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  jsCodeLocation = [CodePush bundleURL];
#endif
  //  jsCodeLocation = [CodePush bundleURL];
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"LQJGoods"
                                               initialProperties:@{@"entrance":_rnModule?_rnModule:@"index"}
                                                   launchOptions:nil];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  self.view = rootView;
  
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.bezelView.backgroundColor = [UIColor blackColor];
  [hud setContentColor:[UIColor whiteColor]];
  rootView.loadingView = hud;
  
  [self setRNNoti];
  
  
}

- (void)setRNNoti{
  //监听JS回调OC原生push到指定界面通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToNextVcNotifi:) name:@"pushToNextVc" object:nil];
  
  //监听JS回调OC原生pop返回界面通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popBackNotifi:) name:@"popBack" object:nil];
  
  //监听JS告知OC RN界面已经回到了根视图了，然后OC开启手势POP返回开关
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rnGotoRootViewNotifi:) name:@"rnGotoRootView" object:nil];
  
  //监听JS告知OC RN点击放大图片通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rnPictureBrowseNotifi:) name:@"pictureBrowse" object:nil];
  
  //监听JS告知OC  RN打开相册获取图片通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchImageLibraryNotifi:) name:@"launchImageLibrary" object:nil];
  
  //监听JS告知OC  RN打开相机获取图片通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchCameraNotifi:) name:@"launchCamera" object:nil];
  
  //监听JS告知OC  清除沙盒缓存通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanDocumentCacheNotifi:) name:@"cleanDocumentCache" object:nil];

  //监听JS回调OC 旋转屏幕通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotatingDeviceScreenDirectionNotifi:) name:@"rotatingDeviceScreenDirection" object:nil];
}

#pragma mark ===================== 各种RN监听通知执行方法 ==========
//监听JS回调OC原生打开相册获取图片通知执行事件
- (void)launchImageLibraryNotifi:(NSNotification *)noti{
  NSMutableDictionary *muDic = noti.object;
  NSInteger count = [[NSString stringWithFormat:@"%@",[muDic objectForKey:@"count"]] integerValue];
  _launchImageLibraryCallback = [muDic objectForKey:@"callback"];
  TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
  [self presentViewController:imagePickerVc animated:YES completion:nil];
}

//监听JS回调OC原生打开相机获取图片通知执行事件
- (void)launchCameraNotifi:(NSNotification *)noti{
  _launchCameraCallback = noti.object;
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    UIImagePickerController *imgPickerVc = [UIImagePickerController new];
    imgPickerVc.delegate = self;
    imgPickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imgPickerVc animated:YES completion:nil];
  }
}

//监听JS回调OC 清除沙盒缓存执行事件
- (void)cleanDocumentCacheNotifi:(NSNotification *)noti{
  NSMutableDictionary *muDic = noti.object;
  NSString *path = [muDic objectForKey:@"path"];
  _cleanDocumentCacheCallback = [muDic objectForKey:@"callback"];
  [FileManagerTool cleanDocumentCacheWithPath:path andCompleteBlock:^(BOOL b) {
    if(_cleanDocumentCacheCallback){
      _cleanDocumentCacheCallback(@[@(b)]);
    }
  }];
}

//监听JS告知OC RN点击放大图片通知执行事件
- (void)rnPictureBrowseNotifi:(NSNotification *)noti{
  NSMutableDictionary *muDic = noti.object;
  NSLog(@"按时发生：%@",muDic);
  NSMutableArray *imgArry = [muDic objectForKey:@"imgArray"];
  NSInteger index = [[muDic objectForKey:@"index"]integerValue];
  
  if([[imgArry firstObject] rangeOfString:@"http:"].location !=NSNotFound){
    NSMutableArray *muImageUrlArray = [NSMutableArray array];
    for (NSString *url in imgArry) {
      [muImageUrlArray addObject:[NSURL URLWithString:url]];
    }
    BNPictureBrowseView *pictureBrowseView = [[BNPictureBrowseView alloc] initWithImgArray:muImageUrlArray andBNPictureBrowseViewDelegate:nil andPlaceholderImageArray:@[@"dayly_icon"] andIndex:index];
    [pictureBrowseView show];
  }else if ([[imgArry firstObject] rangeOfString:@"file:"].location !=NSNotFound){
    BNPictureBrowseView *pictureBrowseView = [[BNPictureBrowseView alloc] initWithImgArray:imgArry andBNPictureBrowseViewDelegate:nil andPlaceholderImageArray:@[@"dayly_icon"] andIndex:index];
    [pictureBrowseView show];
  }
}

//监听JS回调OC原生push到指定界面通知执行事件
- (void)pushToNextVcNotifi:(NSNotification *)noti{
  self.hidesBottomBarWhenPushed = YES;
  NSMutableDictionary *muDic = noti.object;
  NSLog(@"我我我我%@",muDic);
  NSString *vcName = [muDic objectForKey:@"vcName"];
  Class vcClass = NSClassFromString(vcName);
  UIViewController *vc = [[vcClass alloc] init];
  [self setInfoToVcWithVc:vc andMuInfoDataArray:[muDic objectForKey:@"muInfoDataArray"]];
  [self.navigationController pushViewController:vc animated:YES];
}

//监听JS回调OC pop返回通知执行事件
- (void)popBackNotifi:(NSNotification *)noti{
  [self.navigationController popViewControllerAnimated:YES];
}

//监听JS回调OC 旋转屏幕执行事件
- (void)rotatingDeviceScreenDirectionNotifi:(NSNotification *)noti{
  _isOrientationLandscapeRight = !_isOrientationLandscapeRight;
  CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
  [UIView animateWithDuration:duration animations:^{
    [UIApplication sharedApplication].statusBarHidden = _isOrientationLandscapeRight;
    self.view.transform = _isOrientationLandscapeRight ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformIdentity;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
  }];
}

//监听JS告知OC RN界面已经回到了根视图了，然后OC开启手势POP返回开关执行事件
- (void)rnGotoRootViewNotifi:(NSNotification *)noti{
  NSString *value = noti.object;
  if([value isEqualToString:@"1"]){
    _isOpenGespanBack = YES;
  }else{
    _isOpenGespanBack = NO;
  }
}

//- (BOOL)prefersStatusBarHidden
//{
//  // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//  // 已经不起作用了
//  return _isOrientationLandscapeRight;
//}

#pragma mark ================= 各种代理方法 =================
#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos{
  NSLog(@"啊发撒发：%@",infos);
  if(infos.count){
    NSMutableArray *imgUrlArray = [NSMutableArray array];
    for (NSDictionary *info in infos) {
      NSString *imgUrlStr = [NSString stringWithFormat:@"%@",[info objectForKey:@"PHImageFileURLKey"]];
      [imgUrlArray addObject:imgUrlStr];
    }
    NSLog(@"你大爷：%@,%@",_launchImageLibraryCallback,imgUrlArray);
    
    [FileManagerTool writeImgToDocumentWith:photos andCompleteBlock:^(NSArray *imgArry) {
      if(_launchImageLibraryCallback){
        _launchImageLibraryCallback(@[imgArry]);
      }
    }];
  }
}

//相册/相机选取取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker{
  if(_launchImageLibraryCallback){
    _launchImageLibraryCallback(@[@[]]);
  }
  
  if(_launchCameraCallback){
    _launchCameraCallback(@[@[]]);
  }
  [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
  
  UIImage *imgg = info[UIImagePickerControllerOriginalImage];
  NSMutableArray *imgUrlArray = [NSMutableArray array];
  [imgUrlArray addObject:[UIImage fixOrientation:imgg]];
  
  [FileManagerTool writeImgToDocumentWith:imgUrlArray andCompleteBlock:^(NSArray *imgArry) {
    if(_launchCameraCallback){
      _launchCameraCallback(@[imgArry]);
    }
  }];
  UIImageWriteToSavedPhotosAlbum(imgg, self, nil, nil);
  
  [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  
  //这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
  return _isOpenGespanBack;
}

#pragma mark ================== 其他 ====================
//判断Controller是否含有muInfoDataArray属性，有则传参赋值
- (void)setInfoToVcWithVc:(UIViewController *)vc andMuInfoDataArray:(NSMutableArray *)muInfoDataArray{
  unsigned int count;
  objc_property_t *properties = class_copyPropertyList([vc class], &count);
  for(int i = 0; i < count; i++)
  {
    objc_property_t property = properties[i];
    NSLog(@"name:%s",property_getName(property));
    NSLog(@"attributes:%s",property_getAttributes(property));
    // 取得属性名
    NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    if([propertyName isEqualToString:@"muInfoDataArray"]){
      [vc setValue:muInfoDataArray forKey:propertyName];
      break ;
    }
  }
  free(properties);
}

@end













