//
//  RichTextHeader.h
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/7.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#ifndef RichTextHeader_h
#define RichTextHeader_h

#define dataCount 10
#define kLocationToBottom 20

#define TableHeader 50
#define ShowImage_H 80
#define PlaceHolder @" "
#define offSet_X 20
#define EmotionItemPattern    @"\\[em:(\\d+):\\]"

#define KPhoneNumPattern @"(\\(86\\))?(13[0-9]|15[0-35-9]|18[0125-9])\\d{8}" //匹配电话号码用的

#define KWebLinkPattern @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" //匹配网址链接用的

#define KNamePattern @"@\\w*\\s|@\\w*:|@\\w*：" //只能匹配 @姓名 @姓名: @姓名：  姓名只能使用数字、字母、下划线、汉字


#define kDistance 20 //说说和图片的间隔
#define kReplyBtnDistance 30 //回复按钮距离
#define AttributedImageNameKey      @"ImageName"

//最多显示多少行，超出则隐藏，而且文本高度也是按照该限制计算的
#define limitline 4
#define kSelf_SelectedColor [UIColor colorWithWhite:0 alpha:0.4] //点击背景  颜色
#define kUserName_SelectedColor [UIColor colorWithWhite:0 alpha:0.25]//点击姓名颜色

#endif /* RichTextHeader_h */
