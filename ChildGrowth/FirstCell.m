//
//  XMGTgCell.m
//  02-自定义等高的cell-代码-frame01
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FirstCell.h"
#import "takePhoto.h"
#import "CGChildModel.h"
#import "CGHeight.h"
#import "CGWeight.h"
#import "CGBMI.h"
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#define WDfont [UIFont systemFontOfSize:18]
#import "Masonry.h"

@interface FirstCell ()

/** 头像 */
@property (nonatomic, weak) UIButton *iconButtonView;

/** 年龄 */
//@property (nonatomic, weak) UILabel *ageLabel; 

/** 身高 */
@property (nonatomic, weak) UILabel *heightLabel;

/** 购体重 */
@property (nonatomic, weak) UILabel *weightLabel;
/** BMI */
@property (nonatomic, weak) UILabel *BMILabel;
/** 测量日期 */
@property (nonatomic, weak) UILabel *timeLabel;
@end

@implementation FirstCell

// 在这个方法中添加所有的子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat spcae = 10;

        

        /** 头像按钮 */
//         UIButton *iconButtonView = [UIButton buttonWithType:UIButtonTypeRoundedRect];    //圆角按钮
        UIButton *iconButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButtonView.layer setMasksToBounds:YES];
        [iconButtonView.layer setCornerRadius:60];
//        NSLog(@"------%@",self.contentView);
        [iconButtonView.layer setBorderWidth:2.0];
        [self.contentView addSubview:iconButtonView];
        [iconButtonView addTarget:self action:@selector(headerimage) forControlEvents:UIControlEventTouchUpInside];
        self.iconButtonView = iconButtonView;
        [iconButtonView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae);
            make.left.equalTo(self.contentView).offset(spcae *1.5);
            make.bottom.equalTo(self.contentView).offset(-spcae);
            make.width.equalTo(self.contentView.height).offset(-2*spcae);
        }];
        /*背景气泡*/
//        CGRect frame = CGRectMake(125, 10, 205, 150);
        CGRect frame = CGRectMake(125, 10, self.frame.size.width-60, 150);
        UIImageView *image = [[UIImageView alloc] initWithFrame:frame];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        layer.frame = image.bounds;
        layer.contents = (id)[UIImage imageNamed:@"bubble1"].CGImage;
        layer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
        layer.contentsScale = [UIScreen mainScreen].scale;
        image.alpha = 0.18;
        image.layer.mask = layer;
        image.layer.frame = image.frame;
        image.image = [UIImage imageNamed:@"bubble1"];
//        [image makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(spcae * 0.5);
//            make.left.equalTo(self.iconButtonView).offset(spcae);
//            make.size.equalTo(CGSizeMake(210, 155));
//        }];
        [self.contentView addSubview:image];
        /** 年龄 */
//        UILabel *ageLabel = [[UILabel alloc] init];
//        ageLabel.font = [UIFont systemFontOfSize:24];
//        [self.contentView addSubview:ageLabel];
//        self.ageLabel = ageLabel;
//        [ageLabel makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(iconButtonView.top).offset(spcae);
//            make.left.equalTo(iconButtonView.right).offset(spcae);
//            make.right.equalTo(self.contentView).offset(-spcae);
//            make.height.equalTo(20);
//        }];
        
        /** 身高 */
        UILabel *heightLabel = [[UILabel alloc] init];
//        heightLabel.textColor = [UIColor orangeColor];
//        heightLabel.textAlignment = NSTextAlignmentCenter;
        heightLabel.font = WDfont;
        heightLabel.numberOfLines=0;
        [self.contentView addSubview:heightLabel];
        self.heightLabel = heightLabel;
        [heightLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae*2);
//            make.top.equalTo(iconButtonView.centerY);
            make.left.equalTo(iconButtonView.right).offset(spcae*3);
//            make.bottom.equalTo(iconButtonView.bottom);
            make.size.equalTo(CGSizeMake(70, 50));
        }];
        
        /** 体重 */
        UILabel *weightLabel = [[UILabel alloc] init];
        weightLabel.textAlignment = NSTextAlignmentRight;
//        weightLabel.textColor = [UIColor orangeColor];
        weightLabel.font = WDfont;
        weightLabel.numberOfLines=0;
        [self.contentView addSubview:weightLabel];
        self.weightLabel = weightLabel;
        [weightLabel makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(heightLabel.top);
            make.left.equalTo(heightLabel.right);
//            make.bottom.equalTo(iconButtonView.bottom);
//            make.right.equalTo(ageLabel.right);
            make.size.equalTo(CGSizeMake(70, 50));
            
        }];
        
        /** BMI */
        UILabel *BMILabel = [[UILabel alloc] init];
        BMILabel.textAlignment = NSTextAlignmentLeft;
//        BMILabel.textColor = [UIColor orangeColor]; //lightGrayColor
        BMILabel.font = WDfont;
        BMILabel.numberOfLines = 0;
        BMILabel.textAlignment = 0;
        [self.contentView addSubview:BMILabel];
        self.BMILabel = BMILabel;
        [BMILabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(heightLabel.bottom).offset(spcae );
            //            make.bottom.equalTo(iconButtonView.bottom);
            make.left.equalTo(heightLabel.left);
            make.size.equalTo(CGSizeMake(70, 50));
            
        }];
        UILabel *timeLabel =  [[UILabel alloc]init];
//        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = [UIFont systemFontOfSize:17];
        timeLabel.numberOfLines = 0;
        timeLabel.textAlignment = 0;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        [timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(heightLabel.bottom).offset(spcae);
            //            make.bottom.equalTo(iconButtonView.bottom);
            make.left.equalTo(weightLabel.left);
            make.size.equalTo(CGSizeMake(80, 50));
        }];
    }
    return self;
}
-(void)headerimage{
    [takePhoto sharePicture:^(UIImage *HeadImage){
        
//        NSLog(@"%@",HeadImage);
        [self.iconButtonView setImage:HeadImage forState:UIControlStateNormal];
        
    }];
}
/**
 *  设置子控件的数据
 */

-(void)setChildmodel:(CGChildModel *)childmodel{
    _childmodel =childmodel;
    [self.iconButtonView setImage:[UIImage imageNamed:childmodel.icon] forState:UIControlStateNormal];
    CGHeight *heightItem= childmodel.heightArr.lastObject;
    CGWeight *weightItem= childmodel.weightArr.lastObject;
    CGBMI *BMIItem= childmodel.BMIArr.lastObject;
    CGFloat heightf = [heightItem.height floatValue];
    CGFloat weightf = [weightItem.weight floatValue];
    CGFloat BMIf = [BMIItem.value floatValue];
    self.heightLabel.text = [NSString stringWithFormat:@"身高:\n%.1fcm",heightf];
    self.weightLabel.text = [NSString stringWithFormat:@"体重:\n%.1fkg",weightf];
    self.BMILabel.text = [NSString stringWithFormat:@"BMI:\n%.1f",BMIf];
//    NSString *timestring = [heightItem.time substringWithRange:NSMakeRange(2, 6)];
    NSString *timestring = [heightItem.time substringFromIndex:2];
    NSArray *arrary = [timestring componentsSeparatedByString:@"月"];
    NSString *timestring1 = arrary[0];
    NSString *timestring2 = [NSString stringWithFormat:@"%@月",timestring1];
    self.timeLabel.text = [NSString stringWithFormat:@" 测量日期:\n%@",timestring2];
//    CGFloat hei = [heightItem.height floatValue] /100;
//    double heip =  pow(hei, 2);
//    CGFloat bmi = [weightItem.weight floatValue]/heip;
//    self.BMILabel.text = [NSString stringWithFormat:@"BMI:\n%.1f",bmi];

}
@end
