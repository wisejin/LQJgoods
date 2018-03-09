//
//  RichTextDataModel.h
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/7.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RichTextDataModel : NSObject
//以下的数据需要初始化
//图片数组  可以为nil
@property (nonatomic, strong) NSMutableArray *muShowImageArray;
//是否折叠
@property (nonatomic, assign) BOOL foldOrNot;
//说说部分  不能为nil
@property (nonatomic, strong) NSString *showShuoShuoStr;
//自行添加 元素为每条回复中的自行添加的range组成的数组 如：第一条回复有(0，2)
@property (nonatomic, strong) NSMutableArray *muDefineAttrDataArray;
//回复内容数据源（未处理）可以为nil
@property (nonatomic, strong) NSMutableArray *muReplyDataSourceArray;
//发布说说人的姓名，可以为nil
@property (nonatomic, strong) NSString *name;
//发布说说人的头像 可以为nil 支持网络异步加载
@property (nonatomic, strong) NSString *headPicUrl;
//可以用来显示简介或者时间 可以为nil
@property (nonatomic, strong) NSString *intro;

//以下数值不需要初始化
//回复高度
@property (nonatomic, assign) float replyHeight;
//折叠说说高度
@property (nonatomic, assign) float shuoshuoHeight;
//展开说说高度
@property (nonatomic, assign) float unFoldShuoHeight;
//回复内容数据源（处理）
@property (nonatomic, strong) NSMutableArray *muCompletionReplySourceArray;
//TextView 附带的点击区域数组（这里是为了特定的字符串添加点击事件的） 回复发表言论的
@property (nonatomic, strong) NSMutableArray *muAttributeDataArray;
//TextView附带的点击区域数组（这里是为了特定的字符串添加点击事件的）  也就是上边发布的说说内容
@property (nonatomic, strong) NSMutableArray *muAttributedDataWFArray;
//展示图片的高度
@property (nonatomic, assign) float showImageHeight;
//说说部分（处理后） 也就是下边回复发表的言论
@property (nonatomic, strong) NSString *completionShuoshuo;
//是否小于最低限制 宏定义最低限制是 limitline
@property (nonatomic, assign) BOOL islessLimit;

/**
 *  计算高度
 *
 *  @param sizeWidth view 宽度
 *
 *  @return 返回高度
 */
- (float)calculateReplyHeightWithWidth:(float)sizeWidth;

/**
 *  计算折叠还是展开的说说的高度
 *
 *  @param sizeWidth 宽度
 *  @param isUnfold  展开与否
 *
 *  @return 高度
 */
- (float)calculateShuoshuoHeightWithWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold;

/**
 *  添加新评论回复重新计算高度，并completionReplySource数组添加新的处理后的评论
 *
 *  @param sizeWidth 宽度
 *  @param replyDataStr  回复的评论字符串
 *
 *  @return 高度
 */
- (float)addNewReplycalculateReplyHeightWithWidth:(float)sizeWidth replyDataStr:(NSString *)replyDataStr;
@end

































