//
//  WebBrowserController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/3/2.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "WebBrowserController.h"
#import <WebKit/WebKit.h>

static NSString *homeURL = @"https://github.com/";

@interface WebBrowserController ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITextField *navTextField;
@property (nonatomic, assign) BOOL debug;

@property (nonatomic, strong) UIBarButtonItem *navBackBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *navCloseBarButtonItem;

@end
/*
 说明
 >白屏时间，白屏时间无论安卓还是iOS在加载网页的时候都会存在的问题，也是目前无法解决的；
 >页面耗时，页面耗时指的是开始加载这个网页到整个页面load完成即渲染完成的时间；
 >加载链接的一些性能数据，重定向时间，DNS解析时间，TCP链接时间，request请求时间，response响应时间，dom节点解析时间，page渲染时间，同时我们还需要抓取资源时序数据，
 */

@implementation WebBrowserController

//取消监听
- (void)dealloc{
  [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  [self createWeView];
  self.navigationItem.leftBarButtonItems = @[self.navBackBarButtonItem];
}

#pragma mark - UI
- (void)createWeView{
  WKWebViewConfiguration *config = [self getWkWebViewConfiguration];
  _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
  _webView.navigationDelegate = self;
  _webView.scrollView.delegate = self;
  //允许左右划手势导航，默认NO
  _webView.allowsBackForwardNavigationGestures = YES;
  //监听进度
  [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
  NSMutableURLRequest *muRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_info?_info:homeURL]];
  [muRequest setTimeoutInterval:10];
  [_webView loadRequest:muRequest];
  
  [self.view addSubview:_webView];
  [self.view addSubview:[self progressView]];
}

- (UIProgressView *)progressView{
  if(!_progressView){
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, KNavHeight, SCREEN_WIDTH, 12)];
    _progressView.tintColor = [UIColor redColor];
    _progressView.trackTintColor = [UIColor whiteColor];
  }
  return _progressView;
}

- (UIBarButtonItem *)navBackBarButtonItem{
  if(!_navBackBarButtonItem){
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 30, 30);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [button setImageEdgeInsets: UIEdgeInsetsMake(4, -10, 4, 5)];
    [button addTarget:self action:@selector(navLeftBackBtClick:) forControlEvents:UIControlEventTouchUpInside];
    _navBackBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
  }
  return _navBackBarButtonItem;
}

- (UIBarButtonItem *)navCloseBarButtonItem{
  if(!_navCloseBarButtonItem){
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.frame = CGRectMake(0, 0, 30, 30);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
//    [button setImageEdgeInsets: UIEdgeInsetsMake(3, -11, 3, 0)];
    [button addTarget:self action:@selector(navLeftBtCloseClick:) forControlEvents:UIControlEventTouchUpInside];
    _navCloseBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
  }
  return _navCloseBarButtonItem;
}

#pragma mark - 配置WKWebViewConfiguration
- (WKWebViewConfiguration *)getWkWebViewConfiguration{
  
  WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
  config.preferences = [WKPreferences new];
  //设置最小的字体大小，默认是0
  config.preferences.minimumFontSize = 10;
  //是否支持JavaScript
  config.preferences.javaScriptEnabled = YES;
  //不通过用户交互，是否可以打开窗口
  config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
  return config;
}

//计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
  if(object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]){
    CGFloat newProgress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
    if(newProgress == 1){
      self.progressView.hidden = YES;
      [self.progressView setProgress:0 animated:NO];
    }else{
      self.progressView.hidden = NO;
      [self.progressView setProgress:newProgress animated:YES];
    }
    
  }
}

#pragma mark - WKNavigationDelegate 页面加载过程
//开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
  self.title = @"加载中...";
  NSLog(@"%@",_webView.backForwardList);
}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
  
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
  NSLog(@"加载完成");
  self.title = webView.title;
  if(webView.backForwardList.backList.count){
    self.navigationItem.leftBarButtonItems = @[self.navBackBarButtonItem,self.navCloseBarButtonItem];
  }else{
    self.navigationItem.leftBarButtonItems = @[self.navBackBarButtonItem];
  }
}

//页面加载失败时调用（经过测试，不会执行）
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
  if(error){
    /*
     error.userInfo
     
     NSErrorFailingURLKey = "https://www.jianshu.com/";
     NSErrorFailingURLStringKey = "https://www.jianshu.com/";
     NSLocalizedDescription = "The Internet connection appears to be offline.";
     NSUnderlyingError = "Error Domain=kCFErrorDomainCFNetwork Code=-1009 \"(null)\" UserInfo={_kCFStreamErrorCodeKey=50, _kCFStreamErrorDomainKey=1}";
     "_WKRecoveryAttempterErrorKey" = "<WKReloadFrameErrorRecoveryAttempter: 0x170225d40>";
     "_kCFStreamErrorCodeKey" = 50;
     "_kCFStreamErrorDomainKey" = 1;
     */
    
    NSLog(@"%@",error.userInfo);
    if(error.userInfo[@"_kCFStreamErrorCodeKey"]){
      if([error.userInfo[@"_kCFStreamErrorCodeKey"] integerValue] == 50){
        self.title = @"无网络";
      }else if ([error.userInfo[@"_kCFStreamErrorCodeKey"] integerValue] ==-2102){
        self.title = @"超时";
      }
    }else{
      self.title = webView.title;
      //注意这里返回的是个 NSURL类型的 千万别以为是NSString的
      NSURL *Url = error.userInfo[@"NSErrorFailingURLKey"];
      if(Url) [[UIApplication sharedApplication] openURL:Url];
      else NSLog(@"无法跳转");
    }
    
    /*
     NSString *url = error.userInfo[@"NSErrorFailingURLKey"];
     
     //Note: 在iOS9中,如果你要想使用canOpenURL, 你必须添加URL schemes到Info.plist中的白名单, 否则一样跳转不了...
     BOOL didOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
     if (didOpen) {
     DLog(@"打开成功");
     }
     else
     {
     
     }
     */
    
  }else{
    self.title = @"加载失败！";
  }
}

//navigation发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
  
}

//web视图需要响应身份证验证时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
  [webView reload];
}

#pragma mark - 用户交互
//是否允许加载网页 在发送请求之前，决定是否跳转（点击跳转的时候，会执行两遍）
/*
 接下里就是交互部分了
 这里主要用到的是用户点击web页面的按钮，App拦截下来，在App端进行处理
 当用户点击页面的按钮，会走
 */

//在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
  NSString *urlString = [[navigationAction.request URL] absoluteString];
  //主要对于url的中文是无法解析的，需要进行url编码（指定编码类型为utf-8）
  //另外注意url解码使用stringByRemovingPercentEncoding方法
  urlString = [urlString stringByRemovingPercentEncoding];
  NSLog(@"%@",urlString);
  //用：//截取字符串
  NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
  if([urlComps count]){
    //获取协议头
    NSString *protocolHead = [urlComps objectAtIndex:0];
    NSLog(@"协议头=%@",protocolHead);
    //拦截执行
    decisionHandler(WKNavigationActionPolicyAllow);
  }
}

//在接到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
  
  //不加回调会 crash
  decisionHandler(WKNavigationResponsePolicyAllow);
  
  /*
   <WKNavigationResponse: 0x100a57010; response = <NSHTTPURLResponse: 0x17003af00> { URL: https://www.baidu.com/ } { status code: 200, headers {
   "Cache-Control" = "no-cache";
   Connection = "keep-alive";
   "Content-Encoding" = gzip;
   "Content-Length" = 73241;
   "Content-Type" = "text/html;charset=utf-8";
   Date = "Fri, 05 May 2017 01:24:04 GMT";
   P3p = "CP=\" OTI DSP COR IVA OUR IND COM \"";
   Server = "bfe/1.0.8.18";
   "Set-Cookie" = "BAIDUID=1005037D8CF719C18634AF26D533377C:FG=1; max-age=31536000; expires=Sat, 05-May-18 01:24:03 GMT; domain=.baidu.com; path=/; version=1, H_WISE_SIDS=110315_108270_100186_114824_115880_102629_108372_107311_115339_115576_115704_115702_115497_114798_115933_115554_115534_115624_115446_114329_115359_115350_114276_115863_110085; path=/; domain=.baidu.com, BDSVRTM=347; path=/, __bsi=14516488606701504009_00_45_N_N_349_0303_C02F_N_N_Y_0; expires=Fri, 05-May-17 01:24:09 GMT; domain=www.baidu.com; path=/";
   "Strict-Transport-Security" = "max-age=172800";
   Traceid = 1493947444061794561010399075394808135205;
   } }>
   
   */
}

//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
  
}

#pragma mark - WKScriptMessageHandler：必须实现的函数，是APP与js交互，提供从网页中收消息的回调方法
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
  
}

#pragma mark - WKUIDelegate UI界面相关，原生控件支持，三种提示框：输入、确认、警告。首先将web提示框拦截然后再做处理。

//与JS的alert、confirm、prompt交互，我们希望用自己的原生界面，而不是JS的，就可以使用这个代理类来实现。

// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
  return nil;
}
/// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:prompt preferredStyle:UIAlertControllerStyleAlert];
  [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField.textColor = [UIColor blackColor];
    textField.placeholder =defaultText;
  }];
  
  [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    completionHandler([[alert.textFields lastObject] text]);
  }]];
  
  [self presentViewController:alert animated:YES completion:NULL];
}
/// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认框" message:message preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    completionHandler(YES);
  }]];
  [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    completionHandler(NO);
  }]];
  [self presentViewController:alert animated:YES completion:NULL];
  
  NSLog(@"confirm message:%@", message);
  
}
/// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:message preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    completionHandler();
  }]];
  [self presentViewController:alert animated:YES completion:nil];
}

//自定义导航条左边按钮点击事件
- (void)navLeftBtCloseClick:(UIButton *)button{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)navLeftBackBtClick:(UIButton *)button{
  if(_webView.backForwardList.backList.count){
    [_webView goBack];
  }else{
    [self.navigationController popViewControllerAnimated:YES];
  }
}

@end




































