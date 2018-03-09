//
//  DatabaseManager.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDatabaseAdditions.h"
#import <objc/runtime.h>

//get object model's className
#define KGETCLASS_NAME(model)     [NSString stringWithUTF8String:object_getClassName(model)]
//get object model properties
#define KGETMODEL_PROPERTIES      [self getAllProperties:model]
//get object model properties's count
#define KGETMODEL_PROPERTIESCOUNT [[self getAllProperties:model] count]

@implementation DatabaseManager{
  
  FMDatabase *_db;
}

// Singleton
+ (instancetype)shareDatabaseManager{
  
  static DatabaseManager *managerInstance = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    managerInstance = [[self alloc] init];
  });
  return managerInstance;
}
// Get database's path
- (NSString *)getDatabaseFilePath{
  
  NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
  NSString *dbFilePath   = [documentPath stringByAppendingPathComponent:@"db.sqlite"];
  NSLog(@"database path: %@",dbFilePath);
  
  return dbFilePath;
}
// Creat database
- (void)creatDatabase{
  
  _db = [FMDatabase databaseWithPath:[self getDatabaseFilePath]];
}
/**
 *  @return Object's all properties
 */
- (NSArray *)getAllProperties:(id)model{
  
  u_int count;
  objc_property_t *properties  = class_copyPropertyList([model class], &count);
  NSMutableArray *propertiesArray = [NSMutableArray array];
  for (int i = 0; i < count ; i++){
    const char *propertyName = property_getName(properties[i]);
    [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
  }
  free(properties);
  return propertiesArray;
}
// Judge db's status
- (BOOL)judgeDatabaseStataus{
  
  if (!_db){
    [self creatDatabase];
  }
  if (![_db open]){
    NSLog(@"database open faile!");
    return NO;
  }
  [_db setShouldCacheStatements:YES];
  return YES;
}
/**
 *  Judge Column is exists or not,if not add new
 */
- (BOOL)qureyCloumNameOfTableModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake{
  
  if (![self judgeDatabaseStataus])   return NO;
  NSMutableArray *cloumArray = [NSMutableArray new];
  NSString *tableStr = [NSString string];
  if (isTake) {
    tableStr = [model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]];
  }else{
    tableStr = KGETCLASS_NAME(model);
  }
  NSString *qureystr = [NSString stringWithFormat:@"PRAGMA table_info([%@])",tableStr];
  FMResultSet *resultSet = [_db executeQuery:qureystr];
  while ([resultSet next]) {
    NSString *str = [resultSet stringForColumn:@"name"];
    [cloumArray addObject:str];
  }
  BOOL result = YES;
  for (NSString *cloumStr in KGETMODEL_PROPERTIES) {
    
    BOOL b = NO;
    for (NSString *pro in cloumArray) {
      if ([cloumStr isEqualToString:pro]) {
        b = YES;
      }
    }
    if (b == NO) {
      NSString *alterStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ text",tableStr,cloumStr];
      result = [_db executeUpdate:alterStr];
    }
  }
  return result;
}
/**
 *  Creat table
 */
- (void)creatTable:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake{
  
  if (![self judgeDatabaseStataus])  return;
  //Set model's first prooerty as tableName
  if(isTake){
    //Judge the table is exists or not
    if(![_db tableExists:[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]]){
      
      //1.SQL string header
      NSString *creatTableStrHeader = [NSString stringWithFormat:@"create table %@ (id INTEGER PRIMARY KEY",[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
      //2.SQL string middle
      NSString *creatTableStrMiddle = [NSString string];
      for (int i = 0; i < KGETMODEL_PROPERTIESCOUNT; i++){
        creatTableStrMiddle = [creatTableStrMiddle stringByAppendingFormat:@",%@ TEXT",[KGETMODEL_PROPERTIES objectAtIndex:i]];
      }
      //3.SQL string tail
      NSString *creatTableStrTail =[NSString stringWithFormat:@")"];
      //4.SQL string append
      NSString *creatTableStr = [NSString stringWithFormat:@"%@%@%@",creatTableStrHeader,creatTableStrMiddle,creatTableStrTail];
      [_db executeUpdate:creatTableStr];
      NSLog(@"db creat success");
    }
    [_db close];
  }
  //Set model's className as tableName
  else{
    if (![_db tableExists:KGETCLASS_NAME(model)]){
      
      NSString *creatTableStrHeader = [NSString stringWithFormat:@"create table %@ (id INTEGER PRIMARY KEY AUTOINCREMENT",KGETCLASS_NAME(model)];
      NSString *creatTableStrMiddle =[NSString string];
      for (int i = 0; i < KGETMODEL_PROPERTIESCOUNT; i++){
        
        creatTableStrMiddle = [creatTableStrMiddle stringByAppendingFormat:@",%@ TEXT",[KGETMODEL_PROPERTIES objectAtIndex:i]];
      }
      NSString *creatTableStrTail =[NSString stringWithFormat:@")"];
      NSString *creatTableStr = [NSString stringWithFormat:@"%@%@%@",creatTableStrHeader,creatTableStrMiddle,creatTableStrTail];
      [_db executeUpdate:creatTableStr];
      NSLog(@"db creat success");
    }
    [_db close];
  }
}
/**
 *  insert data
 */
- (BOOL)insertDataModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake{
  
  if (![self judgeDatabaseStataus])   return NO;
  if(isTake){
    
    if(![_db tableExists:[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]]){
      [self creatTable:model andIsTakeFirstAttributeAsTableName:YES];
    }
    NSString *insertStrHeader = [NSString stringWithFormat:@"INSERT INTO %@ (",[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    NSString *insertStrMiddleOne = [NSString string];
    for (int i = 0; i < KGETMODEL_PROPERTIESCOUNT; i++){
      
      insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@"%@",[KGETMODEL_PROPERTIES objectAtIndex:i]];
      if (i != KGETMODEL_PROPERTIESCOUNT - 1){
        insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@","];
      }
    }
    NSString *insertStrMiddleTwo = [NSString stringWithFormat:@") VALUES ("];
    NSString *insertStrMiddleThree = [NSString string];
    for (int i = 0; i < KGETMODEL_PROPERTIESCOUNT; i++){
      
      insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@"?"];
      if (i != KGETMODEL_PROPERTIESCOUNT - 1){
        insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@","];
      }
    }
    NSString *insertStrTail = [NSString stringWithFormat:@")"];
    NSString *insertStr = [NSString stringWithFormat:@"%@%@%@%@%@",insertStrHeader,insertStrMiddleOne,insertStrMiddleTwo,insertStrMiddleThree,insertStrTail];
    NSMutableArray *modelPropertyArray = [NSMutableArray array];
    for (int i = 0; i < KGETMODEL_PROPERTIESCOUNT; i++){
      
      NSString *str = [NSString stringWithFormat:@"%@",[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:i]]];
      if (str == nil) {
        str = @"None";
      }
      [modelPropertyArray addObject: str];
    }
    BOOL result = [_db executeUpdate:insertStr withArgumentsInArray:modelPropertyArray];
    [_db close];
    return result;
  }
  else{
    if(![_db tableExists:KGETCLASS_NAME(model)]){
      [self creatTable:model andIsTakeFirstAttributeAsTableName:NO];
    }
    NSString *insertStrHeader = [NSString stringWithFormat:@"INSERT INTO %@ (",KGETCLASS_NAME(model)];
    NSString *insertStrMiddleOne = [NSString string];
    for (int i = 0; i < KGETMODEL_PROPERTIESCOUNT; i++) {
      
      insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@"%@",[KGETMODEL_PROPERTIES objectAtIndex:i]];
      if (i != KGETMODEL_PROPERTIESCOUNT -1) {
        insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@","];
      }
    }
    NSString *insertStrMiddleTwo = [NSString stringWithFormat:@") VALUES ("];
    NSString *insertStrMiddleThree = [NSString string];
    for (int i = 0; i < KGETMODEL_PROPERTIESCOUNT; i++) {
      
      insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@"?"];
      if (i != KGETMODEL_PROPERTIESCOUNT-1) {
        insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@","];
      }
    }
    NSString *insertStrTail = [NSString stringWithFormat:@")"];
    NSString *insertStr = [NSString stringWithFormat:@"%@%@%@%@%@",insertStrHeader,insertStrMiddleOne,insertStrMiddleTwo,insertStrMiddleThree,insertStrTail];
    NSMutableArray *modelPropertyArray = [NSMutableArray array];
    for (int i = 0; i < KGETMODEL_PROPERTIESCOUNT; i++) {
      
      NSString *str = [NSString stringWithFormat:@"%@",[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:i]]];
      if (str == nil) {
        str = @"None";
      }
      [modelPropertyArray addObject: str];
    }
    BOOL result = [_db executeUpdate:insertStr withArgumentsInArray:modelPropertyArray];
    [_db close];
    return result;
  }
}

/**
 * insert or update data
 */
- (BOOL)insertOrUpdateModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake{
  
  if (![self judgeDatabaseStataus])   return NO;
  if(isTake){
    
    if(![_db tableExists:[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]]){
      [self creatTable:model andIsTakeFirstAttributeAsTableName:YES];
    }
    // Query value is exists or not
    NSString *selectStrHeader = [NSString stringWithFormat:@"select * from %@ where ",[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    NSString *selectStrTail = [NSString stringWithFormat:@"%@ = ?",[KGETMODEL_PROPERTIES objectAtIndex:0]];
    NSString *selectStr = [NSString stringWithFormat:@"%@%@",selectStrHeader,selectStrTail];
    FMResultSet * resultSet = [_db executeQuery:selectStr,[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    // The query result is exists, to update
    if([resultSet next]){
      
      NSString *updateStrHeader = [NSString stringWithFormat:@"update %@ set ",KGETCLASS_NAME(model)];
      NSString *updateStrMiddle = [NSString string];
      for (int i = 0; i< KGETMODEL_PROPERTIESCOUNT; i++) {
        
        updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@"%@ = ?",[KGETMODEL_PROPERTIES objectAtIndex:i]];
        if (i != KGETMODEL_PROPERTIESCOUNT -1) {
          updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@","];
        }
      }
      NSString *updateStrTail = [NSString stringWithFormat:@" where %@ = '%@'",[KGETMODEL_PROPERTIES objectAtIndex:0],[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
      NSString *updateStr = [NSString stringWithFormat:@"%@%@%@",updateStrHeader,updateStrMiddle,updateStrTail];
      NSMutableArray *propertyArray = [NSMutableArray array];
      for (int i = 0; i < KGETMODEL_PROPERTIESCOUNT; i++) {
        
        NSString *midStr = [model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:i]];
        if (midStr == nil) {
          midStr = @"None";
        }
        [propertyArray addObject:midStr];
      }
      BOOL result = [_db executeUpdate:updateStr withArgumentsInArray:propertyArray];
      [_db close];
      return result;
    }
    // The query result isn't exists, to insert
    else{
      [self insertDataModel:model andIsTakeFirstAttributeAsTableName:YES];
    }
  }
  else{
    if(![_db tableExists:KGETCLASS_NAME(model)]){
      [self creatTable:model andIsTakeFirstAttributeAsTableName:NO];
    }
    // Query value is exists or not
    NSString *selectStrHeader = [NSString stringWithFormat:@"select * from %@ where ",KGETCLASS_NAME(model)];
    NSString *selectStrTail = [NSString stringWithFormat:@"%@ = ?",[KGETMODEL_PROPERTIES objectAtIndex:0]];
    NSString *selectStr = [NSString string];
    selectStr = [selectStr stringByAppendingFormat:@"%@%@",selectStrHeader,selectStrTail];
    FMResultSet * resultSet = [_db executeQuery:selectStr,[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    // The query result is exists, to updata
    if([resultSet next]){
      
      NSString *updateStrHeader = [NSString stringWithFormat:@"update %@ set ",KGETCLASS_NAME(model)];
      NSString *updateStrMiddle = [NSString string];
      for (int i = 0; i< KGETMODEL_PROPERTIESCOUNT; i++) {
        
        updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@"%@ = ?",[KGETMODEL_PROPERTIES objectAtIndex:i]];
        if (i != KGETMODEL_PROPERTIESCOUNT - 1) {
          updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@","];
        }
      }
      NSString *updateStrTail = [NSString stringWithFormat:@" where %@ = '%@'",[KGETMODEL_PROPERTIES objectAtIndex:0],[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
      NSString *updateStr = [NSString stringWithFormat:@"%@%@%@",updateStrHeader,updateStrMiddle,updateStrTail];
      NSMutableArray *propertyArray = [[NSMutableArray alloc] init];
      for (int i = 0; i < KGETMODEL_PROPERTIESCOUNT; i++) {
        
        NSString *midStr = [NSString stringWithFormat:@"%@",[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:i]]];
        if (midStr == nil) {
          midStr = @"None";
        }
        [propertyArray addObject:midStr];
      }
      BOOL result = [_db executeUpdate:updateStr withArgumentsInArray:propertyArray];
      [_db close];
      return result;
    }
    // The query result isn't exists, to insert
    else{
      [self insertDataModel:model andIsTakeFirstAttributeAsTableName:NO];
    }
  }
  return NO;
}

/**
 *  Delete data based on model's value of first property
 */
- (BOOL)deleteDataModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake{
  
  if (![self judgeDatabaseStataus])   return NO;
  if(isTake){
    if(![_db tableExists:[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]]){
      return NO;
    }
    // Delete string
    NSString *deletStr = [NSString stringWithFormat:@"delete from %@ where %@ = ?",[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]],[KGETMODEL_PROPERTIES objectAtIndex:0]];
    BOOL result = [_db executeUpdate:deletStr, [model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    [_db close];
    return result;
  }
  else{
    if(![_db tableExists:KGETCLASS_NAME(model)]){
      return NO;
    }
    // Delete string
    NSString *deletStr = [NSString stringWithFormat:@"delete from %@ where %@ = ?",KGETCLASS_NAME(model),[KGETMODEL_PROPERTIES objectAtIndex:0]];
    BOOL result = [_db executeUpdate:deletStr, [model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    [_db close];
    return result;
  }
}
/**
 *  Delete data based on model's value of one property
 */
- (BOOL)deleteDataModel:(id)model fromRowValue:(NSString *)valueStr rowKey:(NSString *)keyStr andIsTakeFirstAttributeAsTableName:(BOOL)isTake{
  
  if (![self judgeDatabaseStataus])   return NO;
  if(isTake){
    if(![_db tableExists:[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]]){
      return NO;
    }
    NSString *deletStr = [NSString stringWithFormat:@"delete from %@ where %@ = ?",[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]],keyStr];
    BOOL result = [_db executeUpdate:deletStr,valueStr];
    [_db close];
    return result;
  }
  else{
    if(![_db tableExists:KGETCLASS_NAME(model)]){
      return NO;
    }
    NSString *deletStr = [NSString stringWithFormat:@"delete from %@ where %@ = ?",KGETCLASS_NAME(model),keyStr];
    BOOL result = [_db executeUpdate:deletStr,valueStr];
    [_db close];
    return result;
  }
}
/**
 * 1.Delete table data
 */
- (BOOL)deleteTableDataFromModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake{
  
  if (![self judgeDatabaseStataus])   return NO;
  if(isTake){
    if(![_db tableExists:[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]]){
      return NO;
    }
    NSString *deletStr = [NSString stringWithFormat:@"delete from %@",[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    BOOL result = [_db executeUpdate:deletStr, [model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    [_db close];
    return result;
  }
  else{
    if(![_db tableExists:KGETCLASS_NAME(model)]){
      return NO;
    }
    NSString *deletStr = [NSString stringWithFormat:@"delete from %@",KGETCLASS_NAME(model)];
    BOOL result = [_db executeUpdate:deletStr, [model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    [_db close];
    return result;
  }
}
/**
 * 2.Delete table data
 */
- (BOOL)truncateTableDataFromModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake{
  
  if (![self judgeDatabaseStataus])   return NO;
  if(isTake){
    if(![_db tableExists:[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]]){
      return NO;
    }
    NSString *deletStr = [NSString stringWithFormat:@"truncate table %@ reuse storage",[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    BOOL result = [_db executeUpdate:deletStr, [model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    [_db close];
    return result;
  }
  else{
    if(![_db tableExists:KGETCLASS_NAME(model)]){
      return NO;
    }
    NSString *deletStr = [NSString stringWithFormat:@"truncate table %@ reuse storage",KGETCLASS_NAME(model)];
    BOOL result = [_db executeUpdate:deletStr, [model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    [_db close];
    return result;
  }
}
/**
 * Delete table
 */
- (BOOL)dropTableFromModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake{
  
  if (![self judgeDatabaseStataus])   return NO;
  if(isTake){
    if(![_db tableExists:[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]]){
      return NO;
    }
    NSString *deletStr = [NSString stringWithFormat:@"drop table %@",[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    BOOL result = [_db executeUpdate:deletStr, [model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    [_db close];
    return result;
  }
  else{
    if(![_db tableExists:KGETCLASS_NAME(model)]){
      return NO;
    }
    NSString *deletStr = [NSString stringWithFormat:@"drop table %@",KGETCLASS_NAME(model)];
    BOOL result = [_db executeUpdate:deletStr, [model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    [_db close];
    return result;
  }
}
/**
 * Qurey all model and return array
 */
- (NSArray *)getAllModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake{
  
  if (![self judgeDatabaseStataus])  return nil;
  if (isTake){
    if(![_db tableExists:[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]]){
      return nil;
    }
    NSMutableArray *modelArray = [NSMutableArray array];
    NSString *selectStr = [NSString stringWithFormat:@"select * from %@",[model valueForKey:[KGETMODEL_PROPERTIES objectAtIndex:0]]];
    FMResultSet *resultSet = [_db executeQuery:selectStr];
    while ([resultSet next]) {
      
      id modelResult = [[[model class] alloc] init];
      for (int i = 0; i < KGETMODEL_PROPERTIESCOUNT; i++) {
        
        [modelResult setValue:[resultSet stringForColumn:[KGETMODEL_PROPERTIES objectAtIndex:i]] forKey:[KGETMODEL_PROPERTIES objectAtIndex:i]];
      }
      [modelArray addObject:modelResult];
    }
    [_db close];
    return modelArray;
  }
  else{
    if(![_db tableExists:KGETCLASS_NAME(model)]){
      return nil;
    }
    NSMutableArray *modelArray = [NSMutableArray array];
    NSString *selectStr = [NSString stringWithFormat:@"select * from %@",KGETCLASS_NAME(model)];
    FMResultSet *resultSet = [_db executeQuery:selectStr];
    while ([resultSet next]) {
      
      id modelResult = [[[model class]alloc] init];
      for (int i = 0; i < KGETMODEL_PROPERTIESCOUNT; i++) {
        
        [modelResult setValue:[resultSet stringForColumn:[KGETMODEL_PROPERTIES objectAtIndex:i]] forKey:[KGETMODEL_PROPERTIES objectAtIndex:i]];
      }
      [modelArray addObject:modelResult];
    }
    [_db close];
    return modelArray;
  }
}
/**
 * Qurey all tableName
 */
- (NSArray *)getAllTableName{
  
  NSMutableArray *tableNameArray = [NSMutableArray array];
  FMResultSet *resultSet = [_db executeQuery:@"select name from sqlite_master where type='table' order by name"];
  while ([resultSet next]) {
    
    NSString * tableName = [resultSet stringForColumn:@"name"];
    [tableNameArray addObject:tableName];
  }
  [_db close];
  return tableNameArray;
}

@end


