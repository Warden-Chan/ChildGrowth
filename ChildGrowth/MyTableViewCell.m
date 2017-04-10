//
//  MyTableViewCell.m
//  ChildGrowth
//
//  Created by ChenWanda on 2017/3/27.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    UIImage *img = self.imageView.image;
    self.imageView.image =[UIImage imageNamed:@"小孩2"];
    [super layoutSubviews];
    self.imageView.image = img;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
