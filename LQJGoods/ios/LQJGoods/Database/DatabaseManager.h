//
//  DatabaseManager.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseManager : NSObject

/**
 *  Singleton
 *
 *  @return DatabaseManager object
 */
+ (instancetype)shareDatabaseManager;


/**
 *  Creat table
 */
- (void)creatTable:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake;


/**
 *  Judge Column is exists or not,if not add new
 */
- (BOOL)qureyCloumNameOfTableModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake;


/**
 *  insert data
 */
- (BOOL)insertDataModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake;


/**
 * insert or update data
 */
- (BOOL)insertOrUpdateModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake;


/**
 *  Delete data based on model's value of first property
 */
- (BOOL)deleteDataModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake;
/**
 *  Delete data based on model's value of one property
 */
- (BOOL)deleteDataModel:(id)model fromRowValue:(NSString *)valueStr rowKey:(NSString *)keyStr andIsTakeFirstAttributeAsTableName:(BOOL)isTake;


/**
 * 1.Delete table data
 */
- (BOOL)deleteTableDataFromModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake;
/**
 * 2.Delete table data
 */
- (BOOL)truncateTableDataFromModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake;
/**
 * Delete table
 */
- (BOOL)dropTableFromModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake;


/**
 * Qurey all model and return array
 */
- (NSArray *)getAllModel:(id)model andIsTakeFirstAttributeAsTableName:(BOOL)isTake;


/**
 * Qurey all tableName
 */
- (NSArray *)getAllTableName;

@end
