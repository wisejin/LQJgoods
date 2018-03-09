//
//  FileManagerTool.h
//  BNBravat
//
//  Created by 廖其进 on 2018/1/4.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileDataModel.h"

@interface FileManagerTool : NSObject
//将图片写入沙盒目录
+ (void)writeImgToDocumentWith:(NSArray<UIImage *> *)imgArray andCompleteBlock:(void(^)(NSArray *))completeBlock;

//清除沙盒写入的缓存（文件或者目录）
+ (void)cleanDocumentCacheWithPath:(NSString *)path andCompleteBlock:(void(^)(BOOL))completeBlock;

//写文档文件到沙盒，并返回文件路径数组
+ (void)writeFileToDocumentWithDataArray:(NSArray<NSData *> *)dataArray andFileNameArray:(NSArray *)fileNameArray andCompleteBlock:(void(^)(NSArray *))completeBlock;

//查看沙盒某个路径的文件，并返回文件枚举对象
+ (void)examineDocumentFileWithFoldName:(NSString *)foldName andCompleteBlock:(void(^)(NSArray<FileDataModel *> *))completeBlock;

//移动某个目录下的所有文件到另外一个目录 movePath如果是nil的话就默认是沙盒路径Documents路径   dictPath：目标目录，比如：localFile
+ (void)moveFoldFilePath:(NSString *)dictPath toPath:(NSString *)movePath andCompleteBlock:(void(^)(BOOL))completeBlock;
@end
