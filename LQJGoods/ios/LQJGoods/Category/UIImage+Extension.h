//
//  UIImage+Extension.h
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+GIF.h"

@interface UIImage (Extension)

// 图片尺寸等比缩
- (UIImage *)uniformCompressImageSizeScale:(CGFloat)scale;
// 图片(目标尺寸)尺寸等比缩
- (UIImage *)uniformCompressImageSizeTargetSize:(CGSize)size;
// 按指定文件大小循环压图片(可能压不到制定文件大小)
- (UIImage *)compressImageMaxFileSize:(NSInteger)dataSize;
// 压缩到指定文件大小循环压缩图片[质量和尺寸都变]
- (UIImage *)uniformCompressImageTargetFileSize:(NSInteger)dataSize;
// 压缩图片(尺寸和质量压缩)
- (UIImage *)compressImageSizeScale:(CGFloat)sizeScale qualityScale:(CGFloat)qualityScale;


+ (UIImage *)sd_animatedGIFNamed:(NSString *)name;

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;

- (UIImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size;

+ (UIImage *)fixOrientation:(UIImage *)srcImg;
@end
