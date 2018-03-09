//
//  RichTextCell.h
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/26.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextDataModel.h"
#import "RichTextView.h"
#import "UIButton+Extension.h"

@protocol RichTextCellDelegate <NSObject>

- (void)changeFoldState:(RichTextDataModel *)ymD onCellRow:(NSInteger) cellStamp;
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;
-(void)didPromulgatorNameOrHeadPicPressedForIndex:(NSInteger)index name:(NSString*)name;
-(void)didRichTextPress:(NSString*)text index:(NSInteger)index;
-(void)didRichTextPress:(NSString*)text index:(NSInteger)index replyIndex:(NSInteger)index;

@end

@interface RichTextCell : UITableViewCell<RichCoreTextViewDelegate>

@property BOOL hideReply;


//界面
@property (nonatomic,strong) UIImageView * headerImage;
@property(nonatomic , strong)UILabel *nameLbl;
@property(nonatomic,strong)UILabel *introLbl;
@property(nonatomic,strong)UIButton *foldBtn;
@property(nonatomic,strong)UIImageView *replyImageView;

//数据
@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,strong) NSMutableArray * ymTextArray;
@property (nonatomic,strong) NSMutableArray * ymShuoshuoArray;
@property (nonatomic,assign) id<RichTextCellDelegate> delegate;
@property (nonatomic,assign) NSInteger stamp;
@property (nonatomic,strong) UIButton *replyBtn;

//- (void)initView;

- (RichTextDataModel*)getRichTextData;

- (void)setRichTextViewWith:(RichTextDataModel *)ymData;

@end
