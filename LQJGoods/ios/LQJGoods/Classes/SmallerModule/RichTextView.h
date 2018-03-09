//
//  RichTextView.h
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/24.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RichCoreTextViewDelegate <NSObject>
- (void)clickRichCoreText:(NSString *)clickString;
- (void)clickRichCoreText:(NSString *)clickString replyIndex:(NSInteger)index;

@end

//弄一个枚举类型用来更改主题
typedef NS_ENUM(NSUInteger, TextType){
  TextTypeContent = 0,
  TextTypeReply
};

@interface RichTextView : UIView

@property (nonatomic, strong) NSAttributedString *attrEmotionString;
@property (nonatomic, strong) NSArray *emotionNames;
@property (nonatomic, assign) BOOL isDraw;//是否已经画完
@property (nonatomic, assign) BOOL isFold;//是否折叠
@property (nonatomic, strong) NSMutableArray *muAttributeDataArray;
@property (nonatomic, assign) int textLine;
@property (nonatomic, assign) id<RichCoreTextViewDelegate>delegate;
@property (nonatomic, assign) CFIndex limitCharIndex;//限制行的最后一个char的index
@property (nonatomic, assign) TextType type;
@property (nonatomic, assign) NSInteger replyIndex;

- (void)setOldString:(NSString *)oldString andNewString:(NSString *)newString;

- (int)getTextLines;

- (float)getTextHeight;

@end









































