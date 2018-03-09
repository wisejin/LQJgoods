//
//  RichTextReplyInputView.h
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/26.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RichTextReplyInputViewDelegate <NSObject>

- (void)replyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag;
- (void)destorySelf;

@end

@interface RichTextReplyInputView : UIView<UITextViewDelegate>{
  CGFloat topGap;
  CGFloat keyboardAnimationDuration;
  UIViewAnimationCurve keyboardAnimationCurve;
  CGFloat keyboardHeight;
  int inputHeight;
  int inputHeightWithShadow;
  BOOL autoResizeOnKeyboardVisibilityChanged;
  UIView *tapView;
}

@property (strong, nonatomic) UIButton* sendButton;
@property (strong, nonatomic) UITextView* textView;
@property (strong, nonatomic) UILabel* lblPlaceholder;
@property (strong, nonatomic) UIImageView* inputBackgroundView;
@property (strong, nonatomic) UITextField *textViewBackgroundView;
@property (assign, nonatomic) BOOL autoResizeOnKeyboardVisibilityChanged;
@property (readwrite, nonatomic) CGFloat keyboardHeight;
@property (assign, nonatomic) id<RichTextReplyInputViewDelegate>delegate;
@property (assign, nonatomic) NSInteger replyTag;

- (NSString*)text;
- (void)setText:(NSString*)text;
- (void)setPlaceholder:(NSString*)text;
- (void)showCommentView;
- (id) initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView;
- (void)disappear;

@end




























