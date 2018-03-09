//
//  CustomPictureBrowseCell.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/2/27.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "CustomPictureBrowseCell.h"

@implementation CustomPictureBrowseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//NSURL
- (void)setImgUrlArray:(NSArray *)imgUrlArray{
  _imgUrlArray = imgUrlArray;
  [_imgView1 sd_setImageWithURL:[NSURL URLWithString:_imgUrlArray[0]]];
  [_imgView2 sd_setImageWithURL:[NSURL URLWithString:_imgUrlArray[1]]];
  [_imgView3 sd_setImageWithURL:[NSURL URLWithString:_imgUrlArray[2]]];
  [_imgView4 sd_setImageWithURL:[NSURL URLWithString:_imgUrlArray[3]]];
  [_imgView5 sd_setImageWithURL:[NSURL URLWithString:_imgUrlArray[4]]];
}

//filePath
- (void)setFilePathArray:(NSArray *)filePathArray{
  _filePathArray = filePathArray;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    NSData *data0 = [NSData dataWithContentsOfURL:[NSURL URLWithString:_filePathArray[0]] options:NSDataReadingMappedAlways error:nil];
    UIImage *image0 = [[UIImage alloc]initWithData:data0];
    
    NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:_filePathArray[1]] options:NSDataReadingMappedAlways error:nil];
    UIImage *image1 = [[UIImage alloc]initWithData:data1];
    
    NSData *data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:_filePathArray[2]] options:NSDataReadingMappedAlways error:nil];
    UIImage *image2 = [[UIImage alloc]initWithData:data2];
    
    NSData *data3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:_filePathArray[3]] options:NSDataReadingMappedAlways error:nil];
    UIImage *image3 = [[UIImage alloc]initWithData:data3];
    
    NSData *data4 = [NSData dataWithContentsOfURL:[NSURL URLWithString:_filePathArray[4]] options:NSDataReadingMappedAlways error:nil];
    UIImage *image4 = [[UIImage alloc]initWithData:data4];
    
    if (data0 && data1 && data2 && data3 && data4) {
      dispatch_async(dispatch_get_main_queue(), ^{
        //在这里做UI操作(UI操作都要放在主线程中执行)
        _imgView1.image = image0;
        _imgView2.image = image1;
        _imgView3.image = image2;
        _imgView4.image = image3;
        _imgView5.image = image4;
      });
    }
  });
}

//UIImage
- (void)setImgArray:(NSArray *)imgArray{
  _imgArray = imgArray;
  _imgView1.image = _imgArray[0];
  _imgView2.image = _imgArray[1];
  _imgView3.image = _imgArray[2];
  _imgView4.image = _imgArray[3];
  _imgView5.image = _imgArray[4];
}

@end
