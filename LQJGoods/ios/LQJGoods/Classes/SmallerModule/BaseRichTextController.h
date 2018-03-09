//
//  BaseRichTextController.h
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/26.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "BaseController.h"
#import "RichTextDataModel.h"
#import "RichTextCell.h"
#import "RichTextReplyInputView.h"
#import "BNPictureBrowseCell.h"

@protocol BaseRichTextViewDelegate <NSObject>
@required
-(NSString*)senderName;//评论的时候自己的名字
@optional
-(BOOL)hideReplyButtonForIndex:(NSInteger)index;//是否隐藏回复按钮
-(void)didPromulgatorPressForIndex:(NSInteger)index name:(NSString*)name;//发布者的头像或者名字被点击
-(void)didRichTextPressedFromText:(NSString*)text index:(NSInteger)index;//正文的富文本被点击的回调
-(void)didRichTextPressedFromText:(NSString*)text index:(NSInteger)index replyIndex:(NSInteger)replyIndex;//评论的富文本被点击的回调
-(void)replyForIndex:(NSInteger)index replyText:(NSString*)text;//回复文字的回调
@end


@protocol BaseRichTextViewDataSource <NSObject>
@required
-(RichTextDataModel*)dataForRowAtIndex:(NSInteger)index;
-(NSInteger)numberOfRowsInRichText;
@end

@interface BaseRichTextController : BaseController
@property (weak, nonatomic) id<BaseRichTextViewDelegate> delegate;
@property (weak, nonatomic) id<BaseRichTextViewDataSource> dataSource;
@property (nonatomic, strong) NSMutableArray *muDataArray;
@end



































