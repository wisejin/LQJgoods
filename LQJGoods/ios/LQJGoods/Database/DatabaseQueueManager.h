//
//  DatabaseQueueManager.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseQueueManager : NSObject

/**
 *  单例方法
 *  @return DatabaseQueueManager对象
 */
+ (instancetype)sharedInstace;

/**
 *  创建数据表
 *  @param model 要创建的数据表名，也就是Model的类名
 *  @param db    要操作的数据库对象（这里因为要用到并发队列操作数据库才用到的）
 */
- (void)creatTable:(id)model andFMDatabase:(FMDatabase *)db;

/**
 *  只插入表操作
 *  @param model 要插入的数据实体，并以Model的类名作为表名
 *  @return 插入操作是否成功返回值
 */
- (BOOL)insertDataModel:(id)model;

/**
 *  插入表或者更新表数据操作，以Model的一个属性值作为约束条件
 *  @param model 要插入或者更新操作的实体Model
 *  @return 插入或者更新操作是否成功
 */
- (BOOL)insertOrUpdateModel:(id)model;

/**
 *  删除指定的某一条数据，以该Model的第一个属性值作为约束条件
 *  @param model 要操作的实体Model
 *  @return 操作是否成功
 */
- (BOOL)deleteModel:(id)model;

/**
 *  删除整张表的所有数据
 *  @param model 要操作的实体Model
 *  @return 操作是否成功
 */
- (BOOL)deleteWholeDataModel:(id)model;

/**
 *  查询数据表中的所有数据
 *  @param model 要操作的Model实体
 *  @return 返回查询到是数据对象数组
 */
- (NSArray *)getAllDataModel:(id)model;

/**
 *  通过表名，和Model实体的属性名、值作为约束进行查询数据表
 *  @param model          要查询Model实体
 *  @param attributeName  属性名
 *  @param attributeValue 属性值
 *  @return 返回查询到的Model实体
 */

- (id)getModel:(id)model andAttributeName:(NSString *)attributeName andAttributeValue:(NSString *)attributeValue;

/**
 *  修改指定数据表里面的指定某一条数据的某一个值
 *  @param model              要修改的Model实体
 *  @param constraintNameStr  要约束的字段名
 *  @param constraintValueStr 要约束的字段值
 *  @param updateNameStr      要修改的字段名
 *  @param updateValueStr     要修改的字段值
 *  @return 操作是否成功
 */
- (BOOL)updateModel:(id)model andConstraintNameStr:(NSString *)constraintNameStr andConstraintValueStr:(NSString *)constraintValueStr andUpdateNameStr:(NSString *)updateNameStr andUpdateValueStr:(NSString *)updateValueStr;

@end


