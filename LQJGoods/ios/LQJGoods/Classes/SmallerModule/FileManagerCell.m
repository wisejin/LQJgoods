//
//  FileManagerCell.m
//  LQJGoods
//
//  Created by 廖其进 on 2018/3/5.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "FileManagerCell.h"

@implementation FileManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFileDataModel:(FileDataModel *)fileDataModel{
  _fileDataModel = fileDataModel;
  
  if(_fileDataModel.isSelect){
    _selectImgView.image = [UIImage imageNamed:@"smaller_file_select"];
  }else{
    _selectImgView.image = [UIImage imageNamed:@"smaller_file_normal"];
  }
  
  //后缀名 word文档：.docx  PPT文档：.pptx  Excel文档：.xlsx  PDF文档：.pdf  TXT文档：.txt  RTF文档：.rtf
  if([_fileDataModel.suffixName isEqualToString:@".docx"] || [_fileDataModel.suffixName isEqualToString:@".doc"]){
    _fileLogoImgView.image = [UIImage imageNamed:@"smaller_file_word"];
  }else if([_fileDataModel.suffixName isEqualToString:@".pptx"] || [_fileDataModel.suffixName isEqualToString:@".ppt"]){
    _fileLogoImgView.image = [UIImage imageNamed:@"smaller_file_ppt"];
  }else if([_fileDataModel.suffixName isEqualToString:@".xlsx"] || [_fileDataModel.suffixName isEqualToString:@".xls"]){
    _fileLogoImgView.image = [UIImage imageNamed:@"smaller_file_excel"];
  }else if([_fileDataModel.suffixName isEqualToString:@".pdf"]){
    _fileLogoImgView.image = [UIImage imageNamed:@"smaller_file_pdf"];
  }else if([_fileDataModel.suffixName isEqualToString:@".txt"]){
    _fileLogoImgView.image = [UIImage imageNamed:@"smaller_file_txt"];
  }else if([_fileDataModel.suffixName isEqualToString:@".rtf"] || [_fileDataModel.suffixName isEqualToString:@".rtfd"]){
    _fileLogoImgView.image = [UIImage imageNamed:@"smaller_file_rtf"];
  }else{
    _fileLogoImgView.image = [UIImage imageNamed:@"smaller_file_other"];
  }
  
  _titleLabel.text = _fileDataModel.name;
  _storageLabel.text = [NSString stringWithFormat:@"%@",_fileDataModel.fileSizeStr];
  _dateLabel.text = _fileDataModel.dateStr;
  
}



@end














