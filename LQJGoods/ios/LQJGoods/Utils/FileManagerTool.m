//
//  FileManagerTool.m
//  BNBravat
//
//  Created by 廖其进 on 2018/1/4.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "FileManagerTool.h"

//文件管理目录名
static NSString *fileFoldName = @"localFile";

@implementation FileManagerTool

//写图片到沙盒目录，并返回路径
+ (void)writeImgToDocumentWith:(NSArray<UIImage *> *)imgArray andCompleteBlock:(void(^)(NSArray *))completeBlock{
  if(imgArray.count){
    // 获取Documents目录路径
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSMutableArray *muImgPathArray = [NSMutableArray array];
    NSString *createPath = [NSString stringWithFormat:@"%@/image", docDir];
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
      [[NSFileManager defaultManager] createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (UIImage *image in imgArray) {
      CFUUIDRef uuidRef =CFUUIDCreate(NULL);
      
      CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
      
      CFRelease(uuidRef);
      
      NSString *uniqueId = (__bridge NSString *)uuidStringRef;
      
      NSString *filePath = [createPath stringByAppendingPathComponent:
                            [NSString stringWithFormat:@"%@.jpg",uniqueId]];  // 保存文件的名称
      NSLog(@"渣渣：%@",filePath);
      //高保真压缩图片，此方法可将图片压缩，但是图片质量基本不变，第二个参数为质量参数
      NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
      //是否保存成功
      BOOL result=[imageData writeToFile:filePath atomically:YES];
      if(result){
        if([filePath rangeOfString:@"file:"].location == NSNotFound){
          [muImgPathArray addObject:[NSString stringWithFormat:@"file://%@",filePath]];
        }else{
          [muImgPathArray addObject:filePath];

        }
      }
    }
    
    if(completeBlock){
      completeBlock(muImgPathArray);
    }
  }
}

//清除沙盒写入的缓存（文件或者目录）
+ (void)cleanDocumentCacheWithPath:(NSString *)path andCompleteBlock:(void(^)(BOOL))completeBlock{
  if(path){
    // 获取Documents目录路径
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePathh = [NSString stringWithFormat:@"%@%@",docDir,path];
    NSLog(@"清除：%@",filePathh);
    //删除
    if([[NSFileManager defaultManager] fileExistsAtPath:filePathh]){
      BOOL b = [[NSFileManager defaultManager] removeItemAtPath:filePathh error:nil];
      if(b){
        if(completeBlock){
          completeBlock(YES);
        }
      }else{
        if(completeBlock){
          completeBlock(NO);
        }
      }
    }else{
      if(completeBlock){
        completeBlock(NO);
      }
    }
    
  }
  
}

//写文档文件到沙盒，并返回文件路径数组
+ (void)writeFileToDocumentWithDataArray:(NSArray<NSData *> *)dataArray andFileNameArray:(NSArray *)fileNameArray andCompleteBlock:(void(^)(NSArray *))completeBlock{
  if(dataArray.count){
    // 获取Documents目录路径
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSMutableArray *muImgPathArray = [NSMutableArray array];
    NSString *createPath = [NSString stringWithFormat:@"%@/%@", docDir,fileFoldName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
      [[NSFileManager defaultManager] createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    for (int i = 0;i < dataArray.count;i ++) {
      NSData *data = dataArray[i];
      NSString *filePath = [createPath stringByAppendingPathComponent:
                            [NSString stringWithFormat:@"%@",fileNameArray[i]]];  // 保存文件的名称
      NSLog(@"渣渣啦啦啦啦：%@",filePath);
      //是否保存成功
      BOOL result=[data writeToFile:filePath atomically:YES];
      if(result){
        [muImgPathArray addObject:filePath];
      }
    }
    
    if(completeBlock){
      completeBlock(muImgPathArray);
    }
  }
  
}

//移动某个目录下的所有文件到另外一个目录 movePath如果是nil的话就默认是沙盒路径Documents路径   dictPath：目标目录，比如：localFile
+ (void)moveFoldFilePath:(NSString *)movePath toPath:(NSString *)dictPath andCompleteBlock:(void(^)(BOOL))completeBlock{
  // 获取Documents目录路径
  NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  if(movePath){
    movePath = [NSString stringWithFormat:@"%@/%@",docDir,movePath];
  }else{
    movePath = docDir;
  }
  NSString *ddictPath = [NSString stringWithFormat:@"%@/%@",docDir,dictPath];
  
  //判断新的目录是否存在，不存在则创建目标目录
  if (![[NSFileManager defaultManager] fileExistsAtPath:ddictPath]) {
    [[NSFileManager defaultManager] createDirectoryAtPath:ddictPath withIntermediateDirectories:YES attributes:nil error:nil];
  }
  
  NSFileManager *fm = [NSFileManager defaultManager];
  NSDirectoryEnumerator *dirEnumerater = [fm enumeratorAtPath:movePath];
  NSString *filePath = nil;
  while (nil != (filePath = [dirEnumerater nextObject])) {
    NSString *msgdir = [NSString stringWithFormat:@"%@/%@",movePath,filePath];
    
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:msgdir isDirectory:&isDir]) {
      if (!isDir) {
        //过滤掉不相关文件
        if ([[filePath lastPathComponent] isEqualToString:@".DS_Store"]) {
          
          continue;
          
        }
        
        if([filePath rangeOfString:@"image/"].location != NSNotFound || [filePath rangeOfString:[NSString stringWithFormat:@"%@/",fileFoldName]].location != NSNotFound){
          
          continue;
        }
        
        NSError *error = nil;
        
        //先判断目标目录下是否有相同的文件，如果有则先删除
        NSString *delePath = [NSString stringWithFormat:@"/%@/%@",dictPath,filePath];
        [FileManagerTool cleanDocumentCacheWithPath:delePath andCompleteBlock:nil];
        
        BOOL isMove = [fm moveItemAtPath:msgdir toPath:[NSString stringWithFormat:@"%@/%@",ddictPath,filePath] error:&error];
//        BOOL isMove = [fm copyItemAtPath:dictPath toPath:msgdir error:&error];
        if (isMove) {
          NSLog(@"移动成功");
          
        } else {
          NSLog(@"移动失败");
          
        }
        
      }
      
    }
    
  }
  
  if(completeBlock){
    completeBlock(YES);
  }
}

//查看沙盒某个路径的文件，并返回文件枚举对象
+ (void)examineDocumentFileWithFoldName:(NSString *)foldName andCompleteBlock:(void(^)(NSArray<FileDataModel *> *))completeBlock{
  // 获取Documents目录路径
  NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  NSMutableArray *muFileDataArray = [NSMutableArray array];
  NSString *dir = [NSString stringWithFormat:@"%@/%@", docDir,fileFoldName];
  NSFileManager *fm = [NSFileManager defaultManager];
  NSDirectoryEnumerator *dirEnumerater = [fm enumeratorAtPath:dir];
  
  NSLog(@"哔哔：%@",docDir);
  
  NSString *filePath = nil;
  while (nil != (filePath = [dirEnumerater nextObject])) {
    NSString *msgdir = [NSString stringWithFormat:@"%@/%@/%@",docDir,fileFoldName,filePath];
    
    BOOL isDir;
    
    if ([fm fileExistsAtPath:msgdir isDirectory:&isDir]) {
      if (!isDir) {
        
        //过滤掉不相关文件
        if ([[filePath lastPathComponent] isEqualToString:@".DS_Store"]) {
          
          continue;
          
        }
        
        FileDataModel *model = [[FileDataModel alloc] init];
        //文件名
        NSString *fileNameStr = [filePath lastPathComponent];
        model.name = fileNameStr;
        
        //文件后缀
        model.suffixName = [NSString stringWithFormat:@".%@",[[fileNameStr componentsSeparatedByString:@"."]lastObject]];
        
        //分类：WORD  PPT  EXCEL  PDF  TXT  RTF  OTHER
        if([model.suffixName isEqualToString:@".docx"] || [model.suffixName isEqualToString:@".doc"]){
          model.type = @"WORD";
        }else if ([model.suffixName isEqualToString:@".pptx"] || [model.suffixName isEqualToString:@".ppt"]){
          model.type = @"PPT";
        }else if ([model.suffixName isEqualToString:@".xlsx"] || [model.suffixName isEqualToString:@".xls"]){
          model.type = @"EXCEL";
        }else if ([model.suffixName isEqualToString:@".pdf"]){
          model.type = @"PDF";
        }else if ([model.suffixName isEqualToString:@".txt"]){
          model.type = @"TXT";
        }else if ([model.suffixName isEqualToString:@".rtf"] || [model.suffixName isEqualToString:@".rtfd"]){
          model.type = @"RTF";
        }else{
          model.type = @"OTHER";
        }
        
        //文件路径
        NSString *filePath = msgdir;
        model.filePath = filePath;
        
        //文件的修改时间
        NSDictionary *attributes = [fm attributesOfItemAtPath:msgdir error:nil];
        NSDate *theModifiDate;
        if ((theModifiDate = [attributes objectForKey:NSFileModificationDate])){
          NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
          
          [formatter setDateFormat:@"yyyy-MM-dd"];
          
          NSString *dateStr = [formatter stringFromDate:theModifiDate];
          model.dateStr = dateStr;
        }
        
        //文件大小
        long long fileSize;
        fileSize = [[fm attributesOfItemAtPath:filePath error:nil] fileSize];
        model.fileSize = fileSize;
        
        float fileSizef = fileSize/(1024.0*1024.0);
        if(fileSizef < 1){
          fileSizef = fileSize/1024.0;
          model.fileSizeStr = [NSString stringWithFormat:@"%.2fKB",fileSizef];
        }else{
          model.fileSizeStr = [NSString stringWithFormat:@"%.2fMB",fileSizef];
        }
        
        [muFileDataArray addObject:model];
      }
    }
  }
  
  if(completeBlock){
    completeBlock(muFileDataArray);
  }
}

@end

































