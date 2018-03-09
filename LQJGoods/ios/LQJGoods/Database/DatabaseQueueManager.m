//
//  DatabaseQueueManager.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "DatabaseQueueManager.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import <objc/runtime.h>

// 通过实体获取类名
#define KCLASS_NAME(model)      [NSString stringWithUTF8String:object_getClassName(model)]
// 通过实体获取属性数组数目
#define KMODEL_PROPERTYS_COUNT  [[self getAllProperties:model] count]
// 通过实体获取属性数组
#define KMODEL_PROPERTYS        [self getAllProperties:model]


@implementation DatabaseQueueManager {
  
  FMDatabaseQueue *_fmQueue; //数据库
}

// 单例
+ (instancetype)sharedInstace{
  
  static DatabaseQueueManager *manager = nil;
  if (manager == nil) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      manager = [[self allocWithZone:nil]init];
    });
  }
  return manager;
}

// 获取沙盒路径
- (NSString *)databaseFilePath{
  
  NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentPath = [filePath objectAtIndex:0];
  NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"db.sqlite"];
  NSLog(@"数据库路径：%@",documentPath);
  return dbFilePath;
  
}

/**创建数据库**/
- (void)creatDatabase{
  
  _fmQueue = [FMDatabaseQueue databaseQueueWithPath:[self databaseFilePath]];
}

/**创建数据表**/
- (void)creatTable:(id)model andFMDatabase:(FMDatabase *)db{
  
  //先判断数据是否存在，如果不存在，则创建数据库
  if(!_fmQueue){
    [self creatDatabase];
  }
  //判断数据库是否已经打开，如果没有打开，则提示失败
  if(![db open]){
    NSLog(@"数据库打开失败");
    return;
  }
  //为数据库设置缓存，提高查询效率
  [db setShouldCacheStatements:YES];
  //判断数据库中是否已经存在这张表，如果不存在，则创建该数据表
  if(![db tableExists:KCLASS_NAME(model)]){
    // 1.创建表语句头部拼接
    NSString *creatTableStrHeader = [NSString stringWithFormat:@"create table %@(id INTEGER PRIMARY KEY",KCLASS_NAME(model)];
    // 2.创建表语句中部拼接
    NSString *creatTableStrMiddle =[NSString string];
    for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
      //判断是否是字典类型
      if([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSDictionary"].length){
        creatTableStrMiddle = [creatTableStrMiddle stringByAppendingFormat:@",%@ TEXT",[NSString stringWithFormat:@"NSDictionary_%@",[KMODEL_PROPERTYS objectAtIndex:i]]];
      }
      //判断是否是数组类型
      else if ([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSArray"].length){
        creatTableStrMiddle = [creatTableStrMiddle stringByAppendingFormat:@",%@ TEXT",[NSString stringWithFormat:@"NSArray_%@",[KMODEL_PROPERTYS objectAtIndex:i]]];
      }
      else{
        creatTableStrMiddle = [creatTableStrMiddle stringByAppendingFormat:@",%@ TEXT",[KMODEL_PROPERTYS objectAtIndex:i]];
      }
    }
    // 3.创建表语句尾部拼接
    NSString *creatTableStrTail =[NSString stringWithFormat:@")"];
    // 4.整句创建表语句拼接
    NSString *creatTableStr = [NSString string];
    creatTableStr = [creatTableStr stringByAppendingFormat:@"%@%@%@",creatTableStrHeader,creatTableStrMiddle,creatTableStrTail];
    if([db executeUpdate:creatTableStr]){
      NSLog(@"数据表创建完成创建完成");
    }
  }
  //关闭数据库
  //    [db close];
}


/**只插入数据操作**/
- (BOOL)insertDataModel:(id)model{
  // 判断数据库是否存在
  if (!_fmQueue) {
    [self creatDatabase];
  }
  __block BOOL result = NO;
  __block DatabaseQueueManager *manager = self;
  //    __block dispatch_semaphore_t sem = dispatch_semaphore_create(0);
  [_fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    //判断数据库能否打开
    if(![db open]){
      NSLog(@"数据库打开失败");
    }
    //设置数据库缓存
    [db setShouldCacheStatements:YES];
    //判断是否存在对应的数据表
    if(![db tableExists:KCLASS_NAME(model)]){
      [manager creatTable:model andFMDatabase:db];
    }
    // 拼接插入语句的头部
    NSString *insertStrHeader = [NSString stringWithFormat:@"INSERT INTO %@ (",KCLASS_NAME(model)];
    // 拼接插入语句的中部1
    NSString *insertStrMiddleOne = [NSString string];
    for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
      NSLog(@"%@",[manager getAttributeForIndex:i andModel:model]);
      //判断是否是字典类型
      if([[manager getAttributeForIndex:i andModel:model] rangeOfString:@"NSDictionary"].length){
        insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"NSDictionary_%@",[KMODEL_PROPERTYS objectAtIndex:i]]];
      }
      //判断是否是数组类型
      else if ([[manager getAttributeForIndex:i andModel:model] rangeOfString:@"NSArray"].length){
        insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"NSArray_%@",[KMODEL_PROPERTYS objectAtIndex:i]]];
      }
      else{
        insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@"%@",[KMODEL_PROPERTYS objectAtIndex:i]];
      }
      if (i != KMODEL_PROPERTYS_COUNT -1) {
        insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@","];
      }
    }
    // 拼接插入语句的中部2
    NSString *insertStrMiddleTwo = [NSString stringWithFormat:@") VALUES ("];
    // 拼接插入语句的中部3
    NSString *insertStrMiddleThree = [NSString string];
    for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
      insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@"?"];
      if (i != KMODEL_PROPERTYS_COUNT-1) {
        insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@","];
      }
    }
    // 拼接插入语句的尾部
    NSString *insertStrTail = [NSString stringWithFormat:@")"];
    // 整句插入语句拼接
    NSString *insertStr = [NSString string];
    insertStr = [insertStr stringByAppendingFormat:@"%@%@%@%@%@",insertStrHeader,insertStrMiddleOne,insertStrMiddleTwo,insertStrMiddleThree,insertStrTail];
    NSMutableArray *modelPropertyArray = [NSMutableArray array];
    for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
      NSString *str = [NSString string];
      //判断是否是字典类型
      if([[manager getAttributeForIndex:i andModel:model] rangeOfString:@"NSDictionary"].length){
        NSDictionary *dic = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
        if(dic.count){
          NSData *dicData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
          str = [[NSString alloc] initWithData:dicData encoding:NSUTF8StringEncoding];
        }
        else{
          str = @"none";
        }
      }
      //判断是否是数组类型
      else if ([[manager getAttributeForIndex:i andModel:model] rangeOfString:@"NSArray"].length){
        NSArray *array = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
        if(array.count){
          NSData *arrayData = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
          str = [[NSString alloc] initWithData:arrayData encoding:NSUTF8StringEncoding];
        }
        else{
          str = @"none";
        }
      }
      else{
        str = [NSString stringWithFormat:@"%@",[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]]];
        if (str == nil || [str isEqualToString:@"(null)"]) {
          str = @"none";
        }
      }
      [modelPropertyArray addObject: str];
    }
    result = [db executeUpdate:insertStr withArgumentsInArray:modelPropertyArray];
    [db close];
    //关闭数据库
//        if (![db close]) {
//            NSLog(@"![db2 close]");
//        }
//         dispatch_semaphore_signal(sem);
  }];
//    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
  return result;
}

/**插入数据表或者更新数据表数据**/
- (BOOL)insertOrUpdateModel:(id)model{
  // 判断数据库是否存在
  if (!_fmQueue) {
    [self creatDatabase];
  }
  __block BOOL result = NO;
  [_fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    // 判断数据库能否打开
    if (![db open]) {
      NSLog(@"数据库打开失败");
    }
    // 设置数据库缓存
    [db setShouldCacheStatements:YES];
    // 判断是否存在对应的userModel表
    if(![db tableExists:KCLASS_NAME(model)]){
      [self creatTable:model andFMDatabase:db];
    }
    //以上操作与创建表是做的判断逻辑相同
    
    //现在表中查询有没有相同的元素，如果有，做修改操作
    // 拼接查询语句头部
    NSString *selectStrHeader = [NSString stringWithFormat:@"select * from %@ where ",KCLASS_NAME(model)];
    // 拼接查询语句尾部
    NSString *selectStrTail = [NSString stringWithFormat:@"%@ = ?",[KMODEL_PROPERTYS objectAtIndex:0]];
    // 整个查询语句拼接
    NSString *selectStr = [NSString string];
    selectStr = [selectStr stringByAppendingFormat:@"%@%@",selectStrHeader,selectStrTail];
    FMResultSet * resultSet = [db executeQuery:selectStr,[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:0]]];
    
    if([resultSet next]){
      // 拼接更新语句的头部
      NSString *updateStrHeader = [NSString stringWithFormat:@"update %@ set ",KCLASS_NAME(model)];
      // 拼接更新语句的中部
      NSString *updateStrMiddle = [NSString string];
      for (int i = 0; i< KMODEL_PROPERTYS_COUNT; i++) {
        //判断该属性是否是字典类型
        if([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSDictionary"].length){
          updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@"%@ = ?",[NSString stringWithFormat:@"NSDictionary_%@",[KMODEL_PROPERTYS objectAtIndex:i]]];
        }
        //判断该属性类型是否是数组
        else if ([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSArray"].length){
          updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@"%@ = ?",[NSString stringWithFormat:@"NSArray_%@",[KMODEL_PROPERTYS objectAtIndex:i]]];
        }
        else{
          updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@"%@ = ?",[KMODEL_PROPERTYS objectAtIndex:i]];
        }
        if (i != KMODEL_PROPERTYS_COUNT -1) {
          updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@","];
        }
      }
      // 拼接更新语句的尾部
      NSString *updateStrTail = [NSString stringWithFormat:@" where %@ = '%@'",[KMODEL_PROPERTYS objectAtIndex:0],[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:0]]];
      // 整句拼接更新语句
      NSString *updateStr = [NSString string];
      updateStr = [updateStr stringByAppendingFormat:@"%@%@%@",updateStrHeader,updateStrMiddle,updateStrTail];
      NSMutableArray *propertyArray = [NSMutableArray array];
      
      for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
        NSString *midStr = [NSString string];
        //判断该属性类型是否为字典
        if([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSDictionary"].length){
          NSDictionary *dic = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
          if(dic.count){
            NSData *dicData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
            midStr = [[NSString alloc] initWithData:dicData encoding:NSUTF8StringEncoding];
          }
          else{
            midStr = @"none";
          }
        }
        //判断该属性是否为数组
        else if ([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSArray"].length){
          NSArray *array = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
          if(array.count){
            NSData *arrayData = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
            midStr = [[NSString alloc] initWithData:arrayData encoding:NSUTF8StringEncoding];
          }
          else{
            midStr = @"none";
          }
        }
        else{
          midStr = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
          // 判断属性值是否为空
          if (midStr == nil) {
            midStr = @"none";
          }
        }
        [propertyArray addObject:midStr];
      }
      result = [db executeUpdate:updateStr withArgumentsInArray:propertyArray];
      
      //    关闭数据库
      [resultSet close];
      [db close];
    }
    //向数据库中插入一条新数据
    else{
      // 拼接插入语句的头部
      NSString *insertStrHeader = [NSString stringWithFormat:@"INSERT INTO %@ (",KCLASS_NAME(model)];
      // 拼接插入语句的中部1
      NSString *insertStrMiddleOne = [NSString string];
      for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
        //判断该类型是否是字典
        if([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSDictionary"].length){
          insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"NSDictionary_%@",[KMODEL_PROPERTYS objectAtIndex:i]]];
        }
        //判断该类型是否是数组
        else if ([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSArray"].length){
          insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"NSArray_%@",[KMODEL_PROPERTYS objectAtIndex:i]]];
          NSLog(@"%@",insertStrMiddleOne);
        }
        else{
          insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@"%@",[KMODEL_PROPERTYS objectAtIndex:i]];
          NSLog(@"%@",insertStrMiddleOne);
        }
        if (i != KMODEL_PROPERTYS_COUNT -1) {
          insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@","];
        }
      }
      // 拼接插入语句的中部2
      NSString *insertStrMiddleTwo = [NSString stringWithFormat:@") VALUES ("];
      // 拼接插入语句的中部3
      NSString *insertStrMiddleThree = [NSString string];
      for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
        insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@"?"];
        if (i != KMODEL_PROPERTYS_COUNT-1) {
          insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@","];
        }
      }
      // 拼接插入语句的尾部
      NSString *insertStrTail = [NSString stringWithFormat:@")"];
      // 整句插入语句拼接
      NSString *insertStr = [NSString string];
      insertStr = [insertStr stringByAppendingFormat:@"%@%@%@%@%@",insertStrHeader,insertStrMiddleOne,insertStrMiddleTwo,insertStrMiddleThree,insertStrTail];
      NSMutableArray *modelPropertyArray = [NSMutableArray array];
      for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
        NSString *str = [NSString string];
        //判断该类型是否是字典
        if([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSDictionary"].length){
          NSDictionary *dic = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
          if(dic.count){
            NSData *dataDic = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
            str = [[NSString alloc] initWithData:dataDic encoding:4];
          }
          else{
            str = @"none";
          }
        }
        //判断该类型是否是数组
        else if ([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSArray"].length){
          NSArray *array = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
          if(array.count){
            NSData *arrayDic = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
            str = [[NSString alloc] initWithData:arrayDic encoding:4];
          }
          else{
            str = @"none";
          }
        }
        else{
          str = [NSString stringWithFormat:@"%@",[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]]];
          if (str == nil || [str isEqualToString:@"(null)"]) {
            str = @"none";
          }
        }
        [modelPropertyArray addObject: str];
      }
      result = [db executeUpdate:insertStr withArgumentsInArray:modelPropertyArray];
      [resultSet close];
      [db close];
    }
  }];
  return result;
}


/**删除指定的某一条数据，以该Model的第一个属性值作为约束条件**/
- (BOOL)deleteModel:(id)model{
  // 判断是否创建数据库
  if (!_fmQueue) {
    [self creatDatabase];
  }
  __block BOOL result = NO;
  [_fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    // 判断数据是否已经打开
    if (![db open]) {
      NSLog(@"数据库打开失败");
    }
    // 设置数据库缓存，优点：高效
    [db setShouldCacheStatements:YES];
    
    // 判断是否有该表
    if(![db tableExists:KCLASS_NAME(model)]){
      result = NO;
    }
    // 删除操作
    // 拼接删除语句
    NSString *deletStr = [NSString stringWithFormat:@"delete from %@ where %@ = ?",KCLASS_NAME(model),[KMODEL_PROPERTYS objectAtIndex:0]];
    result = [db executeUpdate:deletStr, [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:0]]];
    //            NSLog(@"%@",deletStr);
    // 关闭数据库
    [db close];
  }];
  
  return result;
}

/**删除整张表数据**/
- (BOOL)deleteWholeDataModel:(id)model{
  // 判断是否创建数据库
  if (!_fmQueue) {
    [self creatDatabase];
  }
  __block BOOL result = NO;
  [_fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    // 判断数据是否已经打开
    if (![db open]) {
      NSLog(@"数据库打开失败");
    }
    // 设置数据库缓存，优点：高效
    [db setShouldCacheStatements:YES];
    // 判断是否有该表
    if(![db tableExists:KCLASS_NAME(model)]){
      result = NO;
    }
    // 删除操作
    // 拼接删除语句
    NSString *deletStr = [NSString stringWithFormat:@"delete from %@",KCLASS_NAME(model)];
    result = [db executeUpdate:deletStr];
    NSLog(@"%@",deletStr);
    // 关闭数据库
    [db close];
  }];
  
  return result;
}


/**查询数据表中的所有数据**/
- (NSArray *)getAllDataModel:(id)model{
  if (!_fmQueue) {
    [self creatDatabase];
  }
  //定义一个可变数组，用来存放查询的结果，返回给调用者
  __block NSMutableArray *userModelArray = [NSMutableArray array];
  [_fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if (![db open]) {
      NSLog(@"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    if(![db tableExists:KCLASS_NAME(model)]){
      NSLog(@"该数据表不存在");
    }
    //定义一个结果集，存放查询的数据
    //拼接查询语句
    NSString *selectStr = [NSString stringWithFormat:@"select * from %@",KCLASS_NAME(model)];
    FMResultSet *resultSet = [db executeQuery:selectStr];
    //判断结果集中是否有数据，如果有则取出数据
    while ([resultSet next]) {
      // 用id类型变量的类去创建对象
      id modelResult = [[[model class]alloc] init];
      for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
        //判断是否是字典
        if([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSDictionary"].length){
          NSString *str = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:[NSString stringWithFormat:@"NSDictionary_%@",[KMODEL_PROPERTYS objectAtIndex:i]]]];
          if(str.length && ![str isEqualToString:@"none"] && ![str isEqualToString:@"(null)"]){
            NSData *dataDic = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:dataDic options:0 error:nil];
            if(dic.count){
              [modelResult setValue:dic forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
            }
          }
        }
        //判断是否是数组
        else if ([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSArray"].length){
          NSString *str = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:[NSString stringWithFormat:@"NSArray_%@",[KMODEL_PROPERTYS objectAtIndex:i]]]];
          if(str.length && ![str isEqualToString:@"none"] && ![str isEqualToString:@"(null)"]){
            NSData *dataArray = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:dataArray options:0 error:nil];
            if(array.count){
              [modelResult setValue:array forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
            }
          }
        }
        else{
          [modelResult setValue:[resultSet stringForColumn:[KMODEL_PROPERTYS objectAtIndex:i]] forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
        }
      }
      //将查询到的数据放入数组中。
      [userModelArray addObject:modelResult];
    }
    // 关闭数据库
    [resultSet close];
    [db close];
  }];
  
  return userModelArray;
}


/**通过表名，和Model实体的属性名、值作为约束进行查询数据表**/
- (id)getModel:(id)model andAttributeName:(NSString *)attributeName andAttributeValue:(NSString *)attributeValue{
  if (!_fmQueue) {
    [self creatDatabase];
  }
  __block id modelResult = [[[model class]alloc] init];
  [_fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if (![db open]) {
      NSLog(@"数据库打开失败");
    }
    
    [db setShouldCacheStatements:YES];
    if(![db tableExists:KCLASS_NAME(model)]){
      NSLog(@"该数据表不存在");
    }
    //定义一个结果集，存放查询的数据
    //拼接查询语句
    // 拼接查询语句头部
    NSString *selectStrHeader = [NSString stringWithFormat:@"select * from %@ where ",KCLASS_NAME(model)];
    // 拼接查询语句尾部
    NSString *selectStrTail = [NSString stringWithFormat:@"%@ = ?",attributeName];
    // 整个查询语句拼接
    NSString *selectStr = [NSString string];
    selectStr = [selectStr stringByAppendingFormat:@"%@%@",selectStrHeader,selectStrTail];
    FMResultSet *resultSet = [db executeQuery:selectStr,attributeValue];
    //判断结果集中是否有数据，如果有则取出数据
    while ([resultSet next]) {
      // 用id类型变量的类去创建对象
      id modelResult = [[[model class]alloc] init];
      for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
        //判断是否是字典
        if([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSDictionary"].length){
          NSString *str = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:[NSString stringWithFormat:@"NSDictionary_%@",[KMODEL_PROPERTYS objectAtIndex:i]]]];
          if(str.length && ![str isEqualToString:@"none"] && ![str isEqualToString:@"(null)"]){
            NSData *dataDic = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:dataDic options:0 error:nil];
            if(dic.count){
              [modelResult setValue:dic forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
            }
          }
        }
        //判断是否是数组
        else if ([[self getAttributeForIndex:i andModel:model] rangeOfString:@"NSArray"].length){
          NSString *str = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:[NSString stringWithFormat:@"NSArray_%@",[KMODEL_PROPERTYS objectAtIndex:i]]]];
          if(str.length && ![str isEqualToString:@"none"] && ![str isEqualToString:@"(null)"]) {
            NSData *dataArray = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:dataArray options:0 error:nil];
            if(array.count){
              [modelResult setValue:array forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
            }
          }
        }
        else {
          [modelResult setValue:[resultSet stringForColumn:[KMODEL_PROPERTYS objectAtIndex:i]] forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
        }
      }
    }
    [resultSet close];
    [db close];
  }];
  return modelResult;
}


/**修改指定数据表里面的指定某一条数据的某一个值**/
- (BOOL)updateModel:(id)model andConstraintNameStr:(NSString *)constraintNameStr andConstraintValueStr:(NSString *)constraintValueStr andUpdateNameStr:(NSString *)updateNameStr andUpdateValueStr:(NSString *)updateValueStr{
  if (!_fmQueue) {
    [self creatDatabase];
  }
  __block BOOL result = NO;
  [_fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    // 判断数据库能否打开
    if (![db open]) {
      NSLog(@"数据库打开失败");
    }
    // 设置数据库缓存
    [db setShouldCacheStatements:YES];
    //以上操作与创建表是做的判断逻辑相同
    
    //现在表中查询有没有相同的元素，如果有，做修改操作
    // 拼接查询语句头部
    NSString *selectStrHeader = [NSString stringWithFormat:@"select * from %@ where ",KCLASS_NAME(model)];
    // 拼接查询语句尾部
    NSString *selectStrTail = [NSString stringWithFormat:@"%@ = ?",constraintNameStr];
    // 整个查询语句拼接
    NSString *selectStr = [NSString string];
    selectStr = [selectStr stringByAppendingFormat:@"%@%@",selectStrHeader,selectStrTail];
    FMResultSet * resultSet = [db executeQuery:selectStr,constraintValueStr];
    if([resultSet next]){
      // 拼接更新语句的头部
      NSString *updateStrHeader = [NSString stringWithFormat:@"update %@ set ",KCLASS_NAME(model)];
      // 拼接更新语句的中部
      NSString *updateStrMiddle = [NSString string];
      updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@"%@ = ?",updateNameStr];
      // 拼接更新语句的尾部
      NSString *updateStrTail = [NSString stringWithFormat:@" where %@ = '%@'",constraintNameStr,constraintValueStr];
      // 整句拼接更新语句
      NSString *updateStr = [NSString string];
      updateStr = [updateStr stringByAppendingFormat:@"%@%@%@",updateStrHeader,updateStrMiddle,updateStrTail];
      result = [db executeUpdate:updateStr withArgumentsInArray:@[updateValueStr]];
    }
    // 关闭数据库
    [resultSet close];
    [db close];
  }];
  return result;
}


/**
 *  传递一个model实体
 *  @param model 实体
 *  @return 实体的属性
 */
- (NSArray *)getAllProperties:(id)model{
  
  u_int count;
  objc_property_t *properties  = class_copyPropertyList([model class], &count);
  NSMutableArray *propertiesArray = [NSMutableArray array];
  for (int i = 0; i < count ; i++){
    const char* propertyName = property_getName(properties[i]);
    [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
  }
  free(properties);
  return propertiesArray;
}

/**获取Model实体的第几个属性的属性类型**/
- (NSString *)getAttributeForIndex:(NSInteger)index andModel:(id)model{
  
  u_int count;
  objc_property_t *properties  = class_copyPropertyList([model class], &count);
  const char* attributes = property_getAttributes(properties[index]);
  return [NSString stringWithUTF8String: attributes];
}

@end
