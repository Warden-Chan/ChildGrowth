//
//  percentImageView.m
//  ChildGrowth
//
//  Created by ChenWanda on 2017/3/15.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "percentImageView.h"
@interface percentImageView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pimageLeft;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation percentImageView


-(void)setPercent:(CGFloat)percent
{
    _percent = percent;
    self.label.textAlignment  = NSTextAlignmentCenter;
    self.label.text = [NSString stringWithFormat:@"%.1f%%",percent];
    CGFloat labelW =self.label.bounds.size.width;
    CGFloat pW = screenWidth-labelW;
    CGFloat A;
    CGFloat B;
    CGFloat a;
    CGFloat b;
    if (percent <=3) {
        A = 0;
        B = 14.5;
        a = 0;
        b = 3;
    }else if (percent <=25){
        A = 14.5;
        B = 23.5;
        a = 3;
        b = 25;
    }else if (percent <=75){
        A = 23.5;
        B = 69.5;
        a = 25;
        b = 75;
    }else if(percent <=97){
        A = 69.5;
        B = 78.5;
        a = 75;
        b = 97;
    }else{
        A = 78.5;
        B = 93;
        a = 97;
        b = 100;
    }
    CGFloat constant = ((B-A)*(percent -a)/(b-a)+A)*pW/93;
    self.pimageLeft.constant = constant;
//    self.pimageLeft.constant = percent *(screenWidth-self.label.bounds.size.width) /100;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
