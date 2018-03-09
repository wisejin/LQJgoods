//
//  NSDictionary+Extension.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

/*数组是否为空*/
- (BOOL)isEmpty{
  if (self.count == 0 || self == nil) {
    return YES;
  }
  return NO;
}

@end
