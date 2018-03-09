//
//  ReactNativeHandler.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTAppState.h>

typedef void (^senderBlock)(id);

@interface ReactNativeHandler : RCTEventEmitter<RCTBridgeModule>
+ (ReactNativeHandler *)sharedNativeHandler;

@end
