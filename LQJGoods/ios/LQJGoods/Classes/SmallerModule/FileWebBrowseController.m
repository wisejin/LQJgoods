//
//  FileWebBrowseController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/3/6.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "FileWebBrowseController.h"

@interface FileWebBrowseController (){
  UIWebView *_webView;
}

@end

@implementation FileWebBrowseController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = _model.name;
  
  _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:_webView];
  _webView.scalesPageToFit = YES;
  if([_model.type isEqualToString:@"TXT"]){
    ///编码可以解决 .txt 中文显示乱码问题
    NSStringEncoding *useEncodeing = nil;
    
    //带编码头的如utf-8等，这里会识别出来
    NSString *body = [NSString stringWithContentsOfFile:_model.filePath usedEncoding:useEncodeing error:nil];
    
    //识别不到，按GBK编码再解码一次.这里不能先按GB18030解码，否则会出现整个文档无换行bug。
    if (!body) {
      body = [NSString stringWithContentsOfFile:_model.filePath encoding:0x80000632 error:nil];
    }
    
    //还是识别不到，按GB18030编码再解码一次.
    if (!body) {
      body = [NSString stringWithContentsOfFile:_model.filePath encoding:0x80000631 error:nil];
    }
    
    //展现
    if (body) {
      [_webView loadHTMLString:body baseURL: nil];
      
    }else {
      NSURL *url = [NSURL fileURLWithPath:_model.filePath];
      NSURLRequest *request = [NSURLRequest requestWithURL:url];
      [_webView loadRequest:request];
    }
    
  }else{
    NSURL *url = [NSURL fileURLWithPath:_model.filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
  }
  
}

@end






















