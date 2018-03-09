//
//  RichTextView.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/24.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "RichTextView.h"
#import <CoreText/CoreText.h>
#import "RegularExpressionManager.h"
#import "NSArray+Extension.h"
#import "NSString+Extention.h"

#define FontHeight                15.0
#define ImageLeftPadding            2.0
#define ImageTopPadding           3.0
#define FontSize                  FontHeight
#define LineSpacing               10.0
#define EmotionImageWidth         FontSize

@implementation RichTextView{
  NSString *_oldString;
  NSString *_newString;
  
  NSMutableArray *_muSelectionsViewArray;
  
  CTTypesetterRef _typesetter;
  CTFontRef _helvetica;
}

@synthesize isDraw = _isDraw;

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//  if(self = [super initWithCoder:aDecoder]){
//
//  }
//  return self;
//}

- (instancetype)initWithFrame:(CGRect)frame{
  if(self = [super initWithFrame:frame]){
    _muSelectionsViewArray = [NSMutableArray arrayWithCapacity:0];
    _isFold = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyself:)];
    [self addGestureRecognizer:tap];
    
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)dealloc{
  if(_typesetter != NULL){
    CFRelease(_typesetter);
  }
}

- (void)setOldString:(NSString *)oldString andNewString:(NSString *)newString{
  _oldString = oldString;
  _newString = newString;
  [self cookEmotionString];
}

#pragma mark - Cook the emotion string
//遍历查找表情字符串，并替换成表情
- (void)cookEmotionString{
  //使用正则表达式查找特殊字符的位置
  NSArray *itemIndexesArray = [RegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:_oldString];
  
  NSArray *nameArray = nil;
  NSArray *newRangeArray = nil;
  
  //分割表情拿到图片名字字符串数组，比如[em:02:]  获取 02
  nameArray = [_oldString itemsForPattern:EmotionItemPattern captureGroupIndex:1];
  
  //计算特殊字符替换为空字符串后的新位置，比如[em:02:] 先变成为" "
  //因为表情是本地图片，加载之前是不知道图片的尺寸的，所以就先替换成为一个空格
  newRangeArray = [itemIndexesArray offsetRangesInArrayBy:[PlaceHolder length]];
  _emotionNames = nameArray;
  if(_newString){
    _attrEmotionString = [self createAttributedEmotionStringWithRanges:newRangeArray forString:_newString];
  }
  
  if(_attrEmotionString){
    _typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)_attrEmotionString);
  }
  
  if(_isDraw == NO){
    return ;
  }
  
  //重新绘制
  [self setNeedsDisplay];
}

#pragma mark - Utility for emotions relative operations
// 根据调整后的字符串，生成绘图时使用的 attribute string
- (NSAttributedString *)createAttributedEmotionStringWithRanges:(NSArray *)ranges forString:(NSString *)aString{
  NSMutableAttributedString *attrString =
  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",aString]];
  _helvetica = CTFontCreateWithName(CFSTR("Helvetica"),FontSize, NULL);
  [attrString addAttribute:(id)kCTFontAttributeName value: (id)CFBridgingRelease(_helvetica) range:NSMakeRange(0,[attrString.string length])];
  [attrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)([UIColor blackColor].CGColor) range:NSMakeRange(0,[attrString length])];
  
  
  for (int i = 0; i < _muAttributeDataArray.count; i ++) {
    NSDictionary *attributedDic = [_muAttributeDataArray objectAtIndex:i];
    NSString *str = [[attributedDic allKeys] firstObject];
    
    [attrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)([UIColor blueColor].CGColor) range:NSRangeFromString(str)];
    
  }
  
  for(NSInteger i = 0; i < [ranges count]; i++)
  {
    NSRange range = NSRangeFromString([ranges objectAtIndex:i]);
    NSString *emotionName = [self.emotionNames objectAtIndex:i];
    [attrString addAttribute:AttributedImageNameKey value:emotionName range:range];
    [attrString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)newEmotionRunDelegate() range:range];
  }
  
  return attrString;
}

// 通过表情名获得表情的图片
- (UIImage *)getEmotionForKey:(NSString *)key{
  NSString *nameStr = [NSString stringWithFormat:@"%@.gif",key];
  return [UIImage imageNamed:nameStr];
}

//　（自定义表情）图片宽高在工程中都需要加载后才知道，而在文本绘制中需要直接留出其位置再进行绘制，所以图片的宽高都是在数据中保存好的，此处笔者用固定值来表示其宽高。为了留出其位置我们需要用空白的字符来做占位符使用。为了知道其图片绘制的位置(即空白占位符位置)我们需要设置代理才能够得知图片绘制位置。具体步骤如下:
//设置CTRunDeleagte：通过代理来找到该字符串，并确定图片绘制的原点
CTRunDelegateRef newEmotionRunDelegate(){
  static NSString *emotionRunName = @"com.cocoabit.CNEmotionView.emotionRunName";
  
  CTRunDelegateCallbacks imageCallbacks;
  imageCallbacks.version = kCTRunDelegateVersion1;
  imageCallbacks.dealloc = RunDelegateDeallocCallback;
  imageCallbacks.getAscent = RunDelegateGetAscentCallback;
  imageCallbacks.getDescent = RunDelegateGetDescentCallback;
  imageCallbacks.getWidth = RunDelegateGetWidthCallback;
  CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)emotionRunName);
  
  return runDelegate;
}

#pragma mark - Run delegate
void RunDelegateDeallocCallback(void* refCon){
//  CFRelease(refCon);
}

CGFloat RunDelegateGetAscentCallback(void *refCon){
  return FontHeight;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
  return 0.0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon){
  // EmotionImageWidth + 2 * ImageLeftPadding
  return 19.0;
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect{
  //没有内容时取消本次绘制
  if(!_typesetter) return;
  
  CGFloat w = CGRectGetWidth(self.frame);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  UIGraphicsPushContext(context);
  
  //翻转坐标系
  Flip_Context(context, FontHeight);
  
  CGFloat y = 0;
  CFIndex start = 0;
  NSInteger length = [_attrEmotionString length];
  int tempK = 0;
  while (start < length) {
    CFIndex count = CTTypesetterSuggestClusterBreak(_typesetter, start, w);
    CTLineRef line = CTTypesetterCreateLine(_typesetter, CFRangeMake(start, count));
    CGContextSetTextPosition(context, 0, y);
    
    //画字
    CTLineDraw(line, context);
    
    //画表情
    Draw_Emoji_For_Line(context, line, self, CGPointMake(0, y));
    
    start += count;
    y -= FontSize + LineSpacing;
    CFRelease(line);
    
    tempK ++;
    if(tempK == limitline){
      _limitCharIndex = start;
    }
  }
  
  UIGraphicsPopContext();
}

//翻转坐标系 普通视图坐标系原点在左上方，而Quart绘图的坐标系原点在左下方，所以我们先要调整坐标系
//内联函数 inline  相当于宏了，但是底层与宏有一点区别
static inline
void Flip_Context(CGContextRef context,CGFloat offset){//offset为字体的高度
  CGContextScaleCTM(context, 1, -1);//坐标系X,Y缩放
  CGContextTranslateCTM(context, 0, -offset);//坐标系平移
}

//生成每个表情的frame坐标
static inline
CGPoint Emoji_Origin_For_Line(CTLineRef line, CGPoint lineOrigin, CTRunRef run){
  CGFloat x = lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL) + ImageLeftPadding;
  CGFloat y = lineOrigin.y - ImageTopPadding;
  return CGPointMake(x, y);
}

//绘制每行中的表情
void Draw_Emoji_For_Line(CGContextRef context, CTLineRef line, id owner, CGPoint lineOrigin){
  CFArrayRef runs = CTLineGetGlyphRuns(line);
  
  // 统计有多少个run
  NSUInteger count = CFArrayGetCount(runs);
  
  // 遍历查找表情run
  for(NSInteger i = 0; i < count; i++)
  {
    CTRunRef aRun = CFArrayGetValueAtIndex(runs, i);
    CFDictionaryRef attributes = CTRunGetAttributes(aRun);
    NSString *emojiName = (NSString *)CFDictionaryGetValue(attributes, AttributedImageNameKey);
    if (emojiName)
    {
      // 画表情
      CGRect imageRect = CGRectZero;
      imageRect.origin = Emoji_Origin_For_Line(line, lineOrigin, aRun);
      imageRect.size = CGSizeMake(EmotionImageWidth, EmotionImageWidth);
      CGImageRef img = [[owner getEmotionForKey:emojiName] CGImage];
      CGContextDrawImage(context, imageRect, img);
    }
  }
}

//返回高度
- (float)getTextHeight{
  CGFloat w = CGRectGetWidth(self.frame);
  CGFloat y = 0;
  CFIndex start = 0;
  NSInteger length = [_attrEmotionString length];
  int tempK = 0;
  while (start < length)
  {
    CFIndex count = CTTypesetterSuggestClusterBreak(_typesetter, start, w);
    CTLineRef line = CTTypesetterCreateLine(_typesetter, CFRangeMake(start, count));
    start += count;
    y -= FontSize + LineSpacing;
    CFRelease(line);
    tempK++;
    if (tempK == limitline  && _isFold == YES) {
      
      break;
    }
  }
  
  return -y;
}

//计算文本行数
- (int)getTextLines{
  int textlines = 0;
  CGFloat w = CGRectGetWidth(self.frame);
  CGFloat y = 0;
  CFIndex start = 0;
  NSInteger length = [_attrEmotionString length];
  
  while (start < length) {
    CFIndex count = CTTypesetterSuggestClusterBreak(_typesetter, start, w);
    CTLineRef line = CTTypesetterCreateLine(_typesetter, CFRangeMake(start, count));
    start += count;
    y -= FontSize + LineSpacing;
    CFRelease(line);
    
    textlines ++;
  }
  
  return textlines;
}

#pragma mark - 处理点击自己事件
- (void)tapMyself:(UITapGestureRecognizer *)gesture{
  CGPoint point = [gesture locationInView:self];
  
  CGFloat w = CGRectGetWidth(self.frame);
  CGFloat y = 0;
  CFIndex start = 0;
  NSInteger length = [_newString length];
  
  //判断是否点到selectedRange内 默认没点到
  BOOL isSelected = NO;
  
  while (start < length)
  {
  
    CFIndex count = CTTypesetterSuggestClusterBreak(_typesetter, start, w);
    CTLineRef line = CTTypesetterCreateLine(_typesetter, CFRangeMake(start, count));
    CGFloat ascent, descent;
    CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
    
    CGRect lineFrame = CGRectMake(0, -y, lineWidth, ascent + descent);
    
    if (CGRectContainsPoint(lineFrame, point)) { //没进此判断 说明没点到文字 ，点到了文字间距处
      
      CFIndex index = CTLineGetStringIndexForPosition(line, point);
      if ([self judgeIndexInSelectedRange:index withWorkLine:line] == YES) {//点到selectedRange内
        
        isSelected = YES;
        
      }else{
        //点在了文字上 但是不在selectedRange内
        
      }
    }
    start += count;
    y -= FontSize + LineSpacing;
    CFRelease(line);
  }
  
  if (isSelected == YES) {
    
  }else{
    [self clickAllContext];
    // NSLog(@"全部");
    return;
    
  }
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    [_muSelectionsViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
  });
  
}

- (BOOL)judgeIndexInSelectedRange:(CFIndex)index withWorkLine:(CTLineRef)workctLine{
  for(int i = 0;i < _muAttributeDataArray.count;i ++){
    NSString *key = [[[_muAttributeDataArray objectAtIndex:i] allKeys] objectAtIndex:0];
    NSRange keyRange = NSRangeFromString(key);
    //点击到指定的区域内
    if(index >= keyRange.location && index <= keyRange.location + keyRange.length){
      if(_isFold){
        if((_limitCharIndex > keyRange.location) && (_limitCharIndex < keyRange.location + keyRange.length)){
          keyRange = NSMakeRange(keyRange.location, _limitCharIndex - keyRange.location);
        }
      }else{
        
      }
      
      NSMutableArray *arr = [self getSelectedCGRectWithClickRange:keyRange];
      [self drawViewFromRects:arr withDictValue:[[_muAttributeDataArray objectAtIndex:i] objectForKey:key]];
      
      NSString *feedString = [[_muAttributeDataArray objectAtIndex:i] valueForKey:key];
      if(_type == TextTypeContent){
        [_delegate clickRichCoreText:feedString];
      }else{
        [_delegate clickRichCoreText:feedString replyIndex:_replyIndex];
      }
      
      return YES;
    }
  }
  
  return NO;
}

- (NSMutableArray *)getSelectedCGRectWithClickRange:(NSRange)tempRange{
  NSMutableArray *clickRects = [[NSMutableArray alloc] init];
  CGFloat w = CGRectGetWidth(self.frame);
  CGFloat y = 0;
  CFIndex start = 0;
  NSInteger length = [_attrEmotionString length];
  
  while (start < length) {
    CFIndex count = CTTypesetterSuggestClusterBreak(_typesetter, start, w);
    CTLineRef line = CTTypesetterCreateLine(_typesetter, CFRangeMake(start, count));
    start += count;
    
    CFRange lineRange = CTLineGetStringRange(line);
    NSRange range = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
    NSRange intersection = [self rangeIntersection:range withSecond:tempRange];
    if(intersection.length > 0){
      //获取整段文字中charIndex位置的字符相对line的原点的x值
      CGFloat xStart = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);
      CGFloat xEnd = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
      
      CGFloat ascent, descent;
      CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
      //所画选择之后背景的 大小 和起始坐标
      CGRect selectionRect = CGRectMake(xStart, -y, xEnd - xStart, ascent + descent);
      [clickRects addObject:NSStringFromCGRect(selectionRect)];
    }
    
    y -= FontSize + LineSpacing;
    CFRelease(line);
  }
  
  return clickRects;
}

//超出1行 处理
- (NSRange)rangeIntersection:(NSRange)first withSecond:(NSRange)second
{
  NSRange result = NSMakeRange(NSNotFound, 0);
  if (first.location > second.location)
  {
    NSRange tmp = first;
    first = second;
    second = tmp;
  }
  if (second.location < first.location + first.length)
  {
    result.location = second.location;
    NSUInteger end = MIN(first.location + first.length, second.location + second.length);
    result.length = end - result.location;
  }
  return result;
}

- (void)drawViewFromRects:(NSArray *)array withDictValue:(NSString *)value{
  //用户名可能超过1行的内容，所以记录在数组里，有多少元素就有多少View
  for(int i = 0;i < [array count];i ++){
    UIView *selectedView = [[UIView alloc] init];
    selectedView.frame = CGRectFromString([array objectAtIndex:i]);
    selectedView.backgroundColor = kUserName_SelectedColor;
    
    [self addSubview:selectedView];
    [_muSelectionsViewArray addObject:selectedView];
  }
}

- (void)clickAllContext{
  
  UIView *myselfSelected = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + 2)];
  myselfSelected.tag = 10101;
  [self insertSubview:myselfSelected belowSubview:self];
  myselfSelected.backgroundColor = kSelf_SelectedColor;
  
  if (_type == TextTypeContent) {
    [_delegate clickRichCoreText:@"您点击了内容"];
  }else{
    [_delegate clickRichCoreText:@"您点击了内容" replyIndex:_replyIndex];
  }
  
  
  
  __weak typeof(self) weakSelf = self;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    if ([weakSelf viewWithTag:10101]) {
      
      [[weakSelf viewWithTag:10101] removeFromSuperview];
    }
    
  });
  
}

@end




























































