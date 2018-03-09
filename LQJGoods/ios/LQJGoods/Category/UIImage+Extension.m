//
//  UIImage+Extension.m
//  BNBravat
//
//  Created by Lengyixiao on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

//图片尺寸等比放缩
- (UIImage *)uniformCompressImageSizeScale:(CGFloat)scale{
  
  if (scale >= 1.0) return self;
  CGFloat width  = self.size.width * scale;
  CGFloat height = self.size.height * scale;
  UIGraphicsBeginImageContext(CGSizeMake(width, height));
  [self drawInRect:CGRectMake(0, 0, width, height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}
//图片(目标尺寸)尺寸等比放缩
- (UIImage *)uniformCompressImageSizeTargetSize:(CGSize)size{
  
  CGFloat scale = 1.0;
  CGFloat scale_w = size.width/self.size.width;
  CGFloat scale_h = size.height/self.size.height;
  if (scale_w < 1.0 && scale_h < 1.0) {
    /*取较大的比例系数*/
    scale = (scale_w >= scale_h) ? scale_w : scale_h;
  }
  CGFloat width  = self.size.width * scale;
  CGFloat height = self.size.height * scale;
  UIGraphicsBeginImageContext(CGSizeMake(width, height));
  [self drawInRect:CGRectMake(0, 0, width, height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}
//按指定文件大小循环压图片(可能压不到制定文件大小)
- (UIImage *)compressImageMaxFileSize:(NSInteger)dataSize{
  
  CGFloat scale = 1.0;
  CGFloat maxScale = 0.1;
  NSData *imageData = UIImageJPEGRepresentation(self, scale);
  while (imageData.length > dataSize && scale > maxScale) {
    scale -= 0.1;
    imageData = UIImageJPEGRepresentation(self, scale);
  }
  UIImage *endImage = [UIImage imageWithData:imageData];
  return endImage;
}
//压缩到指定文件大小循环压缩图片[质量和尺寸都变]
- (UIImage *)uniformCompressImageTargetFileSize:(NSInteger)dataSize{
  
  CGFloat scale = 1.0;
  CGFloat sizeScale = 1.0;
  NSData *imageData = UIImageJPEGRepresentation(self, scale);
  while (imageData.length > dataSize && scale > 0.1) {
    scale -= 0.1;
    imageData = UIImageJPEGRepresentation(self, scale);
  }
  UIImage *endImage = [[UIImage imageWithData:imageData] uniformCompressImageSizeScale:sizeScale];
  while (imageData.length > dataSize && sizeScale >= 0.1) {
    sizeScale -= 0.1;
    endImage = [[UIImage imageWithData:imageData] uniformCompressImageSizeScale:sizeScale];
  }
  return endImage;
}
//压缩图片(尺寸和质量压缩)
- (UIImage *)compressImageSizeScale:(CGFloat)sizeScale qualityScale:(CGFloat)qualityScale{
  
  CGFloat width  = self.size.width * sizeScale;
  CGFloat height = self.size.height * sizeScale;
  UIGraphicsBeginImageContext(CGSizeMake(width, height));
  [self drawInRect:CGRectMake(0, 0, width, height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  UIImage *endImage = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, qualityScale)];
  return endImage;
}

#pragma mark 加载本地GIF动画
+ (UIImage *)sd_animatedGIFWithData:(NSData *)data {
  if (!data) {
    return nil;
  }
  
  CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
  
  size_t count = CGImageSourceGetCount(source);
  
  UIImage *animatedImage;
  
  if (count <= 1) {
    animatedImage = [[UIImage alloc] initWithData:data];
  }
  else {
    NSMutableArray *images = [NSMutableArray array];
    
    NSTimeInterval duration = 0.0f;
    
    for (size_t i = 0; i < count; i++) {
      CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
      
      duration += [self sd_frameDurationAtIndex:i source:source];
      
      [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
      
      CGImageRelease(image);
    }
    
    if (!duration) {
      duration = (1.0f / 10.0f) * count;
    }
    
    animatedImage = [UIImage animatedImageWithImages:images duration:duration];
  }
  
  CFRelease(source);
  
  return animatedImage;
}

+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
  float frameDuration = 0.1f;
  CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
  NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
  NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
  
  NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
  if (delayTimeUnclampedProp) {
    frameDuration = [delayTimeUnclampedProp floatValue];
  }
  else {
    
    NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
    if (delayTimeProp) {
      frameDuration = [delayTimeProp floatValue];
    }
  }
  
  // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
  // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
  // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
  // for more information.
  
  if (frameDuration < 0.011f) {
    frameDuration = 0.100f;
  }
  
  CFRelease(cfFrameProperties);
  return frameDuration;
}

+ (UIImage *)sd_animatedGIFNamed:(NSString *)name {
  CGFloat scale = [UIScreen mainScreen].scale;
  
  if (scale > 1.0f) {
    NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
    
    NSData *data = [NSData dataWithContentsOfFile:retinaPath];
    
    if (data) {
      return [UIImage sd_animatedGIFWithData:data];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
    
    data = [NSData dataWithContentsOfFile:path];
    
    if (data) {
      return [UIImage sd_animatedGIFWithData:data];
    }
    
    return [UIImage imageNamed:name];
  }
  else {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data) {
      return [UIImage sd_animatedGIFWithData:data];
    }
    
    return [UIImage imageNamed:name];
  }
}

- (UIImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size {
  if (CGSizeEqualToSize(self.size, size) || CGSizeEqualToSize(size, CGSizeZero)) {
    return self;
  }
  
  CGSize scaledSize = size;
  CGPoint thumbnailPoint = CGPointZero;
  
  CGFloat widthFactor = size.width / self.size.width;
  CGFloat heightFactor = size.height / self.size.height;
  CGFloat scaleFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor;
  scaledSize.width = self.size.width * scaleFactor;
  scaledSize.height = self.size.height * scaleFactor;
  
  if (widthFactor > heightFactor) {
    thumbnailPoint.y = (size.height - scaledSize.height) * 0.5;
  }
  else if (widthFactor < heightFactor) {
    thumbnailPoint.x = (size.width - scaledSize.width) * 0.5;
  }
  
  NSMutableArray *scaledImages = [NSMutableArray array];
  
  UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
  
  for (UIImage *image in self.images) {
    [image drawInRect:CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledSize.width, scaledSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    [scaledImages addObject:newImage];
  }
  
  UIGraphicsEndImageContext();
  
  return [UIImage animatedImageWithImages:scaledImages duration:self.duration];
}

//根据拍照的图片方式（竖拍、横排）进行重绘制处理
+ (UIImage *)fixOrientation:(UIImage *)srcImg {
  if (srcImg.imageOrientation == UIImageOrientationUp) {
    return srcImg;
  }
  
  CGAffineTransform transform = CGAffineTransformIdentity;
  switch (srcImg.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
      
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
      transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
      
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
      transform = CGAffineTransformRotate(transform, -M_PI_2);
      break;
    case UIImageOrientationUp:
    case UIImageOrientationUpMirrored:
      break;
  }
  
  switch (srcImg.imageOrientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
      
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
    case UIImageOrientationUp:
    case UIImageOrientationDown:
    case UIImageOrientationLeft:
    case UIImageOrientationRight:
      break;
  }
  
  CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height, CGImageGetBitsPerComponent(srcImg.CGImage), 0, CGImageGetColorSpace(srcImg.CGImage), CGImageGetBitmapInfo(srcImg.CGImage));
  CGContextConcatCTM(ctx, transform);
  switch (srcImg.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
      break;
      
    default:
      CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
      break;
  }
  
  CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
  UIImage *img = [UIImage imageWithCGImage:cgimg];
  CGContextRelease(ctx);
  CGImageRelease(cgimg);
  return img;
}

@end
