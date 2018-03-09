//
//  RichTextDataModel.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/7.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "RichTextDataModel.h"
#import "RegularExpressionManager.h"
#import "NSString+Extention.h"
#import "RichTextView.h"

@implementation RichTextDataModel{
  BOOL _isReplyView;
  int _tempInt;
}

- (instancetype)init{
  if(self = [super init]){
    _muCompletionReplySourceArray = [[NSMutableArray alloc] init];
    _muAttributeDataArray = [[NSMutableArray alloc] init];
    _muAttributedDataWFArray = [[NSMutableArray alloc] init];
    _muShowImageArray = [NSMutableArray array];
    _muReplyDataSourceArray = [NSMutableArray array];
    _foldOrNot = YES;
    _islessLimit = NO;
    _name = [NSString string];
    _headPicUrl = [NSString string];
    _intro = [NSString string];
  }
  return self;
}

//计算评论回复replyView高度
- (float)calculateReplyHeightWithWidth:(float)sizeWidth{
  _isReplyView = YES;
  float height = 0.0f;
  
  for(int i = 0;i < _muReplyDataSourceArray.count;i ++){
    _tempInt = i;
    
    NSString *matchString = [_muReplyDataSourceArray objectAtIndex:i];
    
    //正则表达式查找表情字符串的位置
    NSArray *itemIndexs = [RegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
    
    //替换表情字符串为新的字符串，并返回新的内容
    //遍历替换新字符串 比如：[em:03:]  替换成 " "
    NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs AndString:PlaceHolder];
    
    //处理新的字符串内容后 存储新的内容
    [_muCompletionReplySourceArray addObject:newString];
    
    //过滤网址、电话号码、自行发表的评论并添加到对应的数组（点击区域数组）
    [self matchString:newString fromView:_isReplyView];
    
    RichTextView *richTextView = [[RichTextView alloc] initWithFrame:CGRectMake(offSet_X, 10, sizeWidth - offSet_X * 2, 0)];
    richTextView.isDraw = NO;
    [richTextView setOldString:[self.muReplyDataSourceArray objectAtIndex:i] andNewString:newString];
    height = height + [richTextView getTextHeight] + 5;
    
  }
  
  [self calculateShowImageHeight];
  
  return height;
}

//添加新评论回复重新计算高度，并completionReplySource数组添加新的处理后的评论
- (float)addNewReplycalculateReplyHeightWithWidth:(float)sizeWidth replyDataStr:(NSString *)replyDataStr{
  float height = .0f;
  _tempInt += 1;
  
  NSArray *itemIndexs = [RegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:replyDataStr];
  
  
  NSString *newString = [replyDataStr replaceCharactersAtIndexes:itemIndexs AndString:PlaceHolder];
  //存新的
  [self.muCompletionReplySourceArray addObject:newString];
  
  
  
  [self matchString:newString fromView:_isReplyView];
  
  RichTextView *richTextView = [[RichTextView alloc] initWithFrame:CGRectMake(offSet_X,10, sizeWidth - offSet_X * 2, 0)];
  
  richTextView.isDraw = NO;
  
  [richTextView setOldString:replyDataStr andNewString:newString];
  
  height = [richTextView getTextHeight] + 5;
  
  return height;
}

//图片高度
- (void)calculateShowImageHeight{
  
  if (self.muShowImageArray.count == 0) {
    self.muShowImageArray = 0;
  }else{
    self.showImageHeight = (ShowImage_H + 10) * ((self.muShowImageArray.count - 1)/3 + 1);
  }
  
}

//过滤网址、电话号码、自行发表的评论并添加到对应的数组（点击区域数组）
//是否是折叠状态
- (void)matchString:(NSString *)dataSourceString fromView:(BOOL)isYMOrNot{
  
  //下边有回复评论内容的
  if(isYMOrNot == YES){
    NSMutableArray *muTotalArray = [NSMutableArray arrayWithCapacity:0];
    
    /******匹配电话号码**********/
    NSMutableArray *muMobileLinkArray = [RegularExpressionManager matchMobileLink:dataSourceString];
    for(int i = 0;i < muMobileLinkArray.count;i ++){
      [muTotalArray addObject:[muMobileLinkArray objectAtIndex:i]];
    }
    
    /**********匹配网址************/
    NSMutableArray *muWebLinkArray = [RegularExpressionManager matchWebLink:dataSourceString];
    for(int i = 0;i < muWebLinkArray.count;i ++){
      [muTotalArray addObject:[muWebLinkArray objectAtIndex:i]];
    }
    
    /***********匹配姓名******************/
    NSMutableArray *muNameArray = [RegularExpressionManager matchName:dataSourceString];
    for(int i = 0;i < muNameArray.count;i ++){
      [muTotalArray addObject:[muNameArray objectAtIndex:i]];
    }
    
    /***********自行添加（也就是自己回复评论内容）************************/
    if(_muDefineAttrDataArray.count != 0){
      NSArray *tArr = [_muDefineAttrDataArray objectAtIndex:_tempInt];
      for(int i = 0;i < tArr.count;i ++){
        NSString *string = [dataSourceString substringWithRange:NSRangeFromString([tArr objectAtIndex:i])];
        [muTotalArray addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSRangeFromString([tArr objectAtIndex:i]))]];
      }
    }
    
    /*************************/
    _muAttributeDataArray = muTotalArray;
  }else{
    
    /******匹配电话号码**********/
    NSMutableArray *muMobileLinkArray = [RegularExpressionManager matchMobileLink:dataSourceString];
    for(int i = 0;i < muMobileLinkArray.count;i ++){
      [self.muAttributedDataWFArray addObject:[muMobileLinkArray objectAtIndex:i]];
    }
    
    /**********匹配网址**************/
    NSMutableArray *muWebLinkArray = [RegularExpressionManager matchWebLink:dataSourceString];
    for(int i = 0;i < muWebLinkArray.count;i ++){
      [self.muAttributedDataWFArray addObject:[muWebLinkArray objectAtIndex:i]];
    }
    
    /**********匹配名字**************/
    NSMutableArray *muNameArray = [RegularExpressionManager matchName:dataSourceString];
    for(int i = 0;i < muNameArray.count;i ++){
      [self.muAttributedDataWFArray addObject:[muNameArray objectAtIndex:i]];
    }
  }
}

//计算说说是高度（也就是上边内容高度）
- (float)calculateShuoshuoHeightWithWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold{
  _isReplyView = NO;
  
  NSString *matchString =  _showShuoShuoStr;
  
  NSArray *itemIndexs = [RegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
  
  NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                     AndString:PlaceHolder];
  //存新的
  self.completionShuoshuo = newString;
  
  [self matchString:newString fromView:_isReplyView];
  
  RichTextView *_wfcoreText = [[RichTextView alloc] initWithFrame:CGRectMake(20,10, sizeWidth - 2*20, 0)];
  
  _wfcoreText.isDraw = NO;
  
  [_wfcoreText setOldString:_showShuoShuoStr andNewString:newString];
  
  if ([_wfcoreText getTextLines] <= limitline) {
    self.islessLimit = YES;
  }else{
    self.islessLimit = NO;
  }
  
  if (!isUnfold) {
    
    _wfcoreText.isFold = YES;
    
  }else{
    
    _wfcoreText.isFold = NO;
    
    
  }
  return [_wfcoreText getTextHeight];
}

@end




































