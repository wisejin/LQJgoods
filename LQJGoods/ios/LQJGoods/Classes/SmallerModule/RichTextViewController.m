//
//  RichTextViewController.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/6.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "RichTextViewController.h"

@interface RichTextViewController ()<BaseRichTextViewDelegate,BaseRichTextViewDataSource>

@end

@implementation RichTextViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = KLightBlueColor;
  self.title = @"朋友圈";
  
  //图片支持网络异步加载
  NSMutableArray *_imageDataSource = [NSMutableArray arrayWithCapacity:0];
  [_imageDataSource addObject:@"http://f.hiphotos.baidu.com/image/h%3D300/sign=4a0a3dd10155b31983f9847573ab8286/503d269759ee3d6db032f61b48166d224e4ade6e.jpg"];
  [_imageDataSource addObject:@"http://a.hiphotos.baidu.com/image/pic/item/f31fbe096b63f62493a948d38c44ebf81b4ca36e.jpg"];
  [_imageDataSource addObject:@"http://d.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a2bfe707b083b5bb5c8eab86e.jpg"];
  [_imageDataSource addObject:@"http://f.hiphotos.baidu.com/image/pic/item/c9fcc3cec3fdfc03ef8c9268df3f8794a5c2266d.jpg"];
  [_imageDataSource addObject:@"http://a.hiphotos.baidu.com/image/pic/item/7e3e6709c93d70cf4ba3dbddf3dcd100bba12b80.jpg"];
  [_imageDataSource addObject:@"http://d.hiphotos.baidu.com/image/h%3D300/sign=9af99ce45efbb2fb2b2b5e127f4b2043/a044ad345982b2b713b5ad7d3aadcbef76099b65.jpg"];
  [_imageDataSource addObject:@"http://e.hiphotos.baidu.com/image/pic/item/500fd9f9d72a6059099ccd5a2334349b023bbae5.jpg"];
  
  self.muDataArray =[[NSMutableArray alloc]init];
  
  for(int i = 0;i < 10;i ++){
    NSMutableArray *_replyDataSource = [[NSMutableArray alloc] init];//回复数据来源
    [_replyDataSource addObject:@"@Della:@戴伟来 DDRichText棒棒哒！ @daiweilai： @daiweilai @戴伟来:I am Della，这是一个IOS库[em:01:][em:02:][em:03:]"];
    
    RichTextDataModel *ymData = [[RichTextDataModel alloc] init];
    if(i%2){
      ymData.muShowImageArray = _imageDataSource;
    }
//    ymData.muShowImageArray = _imageDataSource;

    ymData.foldOrNot = YES;
    
    ymData.showShuoShuoStr = @"这是RichText！！支持富文本并且文本能够收缩和伸展，支持图片，支持图片预览，能够回复，使用非常简单！！，这是一个电话号码13800138000，我是@戴伟来 @daiweilai： @daiweilai @戴伟来:支持自定义表情[em:01 [em:02:] [em:03:] 这是一个网址https://github.com/daiweilai 也支持自定义位置的富文本点击！";
    ymData.muReplyDataSourceArray = _replyDataSource;
    if(i == 2){
      ymData.showShuoShuoStr = @"yi'yo'yu'y！！支持富文本并且文本能够收缩和伸展，支持图片，支持图片预览，能够回复，使用非常简单！！，这是一个电话号码13800138000啊飒飒的的发发发发！";
      [ymData.muReplyDataSourceArray addObject:@"@asdadd:g哈哈哈"];
    }
    ymData.name = @"David";
    ymData.intro = @"2015-2-8";
    ymData.headPicUrl = @"https://octodex.github.com/images/mummytocat.gif";
    [self.muDataArray addObject:ymData];
  }
  self.delegate = self;
  self.dataSource = self;
}

-(NSString *)senderName{
  return @"David";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfRowsInRichText{
  return self.muDataArray.count;
}

-(RichTextDataModel *)dataForRowAtIndex:(NSInteger)index{
  NSLog(@"打啊多：%ld",index);
  return [self.muDataArray objectAtIndex:index];
}


-(BOOL)hideReplyButtonForIndex:(NSInteger)index{
  return NO;
}

-(void)didPromulgatorNameOrHeadPicPressedForIndex:(NSInteger)index name:(NSString *)name{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布者回调" message:[NSString stringWithFormat:@"姓名：%@\n index：%d",name,index] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [alert show];
}


-(void)didRichTextPressedFromText:(NSString*)text index:(NSInteger)index{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"正文富文本点击回调" message:[NSString stringWithFormat:@"点击的内容：%@\n index：%d",text,index] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [alert show];
}

-(void)didRichTextPressedFromText:(NSString *)text index:(NSInteger)index replyIndex:(NSInteger)replyIndex{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"评论的富文本点击回调" message:[NSString stringWithFormat:@"点击的内容：%@\n index：%d \n replyIndex:%d",text,index,replyIndex] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [alert show];
}

-(void)replyForIndex:(NSInteger)index replyText:(NSString*)text{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"回复的回调" message:[NSString stringWithFormat:@"回复的内容：%@\n index：%d",text,index] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [alert show];
}
@end



































