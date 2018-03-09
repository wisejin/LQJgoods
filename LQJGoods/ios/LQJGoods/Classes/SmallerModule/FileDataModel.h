//
//  FileDataModel.h
//  LQJGoods
//
//  Created by 廖其进 on 2018/3/5.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDataModel : NSObject
//后缀名 word文档：.docx  PPT文档：.pptx  Excel文档：.xlsx  PDF文档：.pdf  TXT文档：.txt  RTF文档：.rtf  其它文档
@property (nonatomic, strong) NSString *suffixName;
////分类：WORD  PPT  EXCEL  PDF  TXT  RTF  OTHER
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) long long fileSize;
@property (nonatomic, strong) NSString *fileSizeStr;
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) BOOL isSelect;


@end

























