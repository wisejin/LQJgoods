//
//  KeyChainStore.h
//  BNEIH
//
//  Created by benniuMAC on 16/6/1.
//  Copyright © 2016年 BN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end





































