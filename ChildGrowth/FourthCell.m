//
//  FourthCell.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/12/6.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "FourthCell.h"
#import "CGHeight.h"
#import "CGWeight.h"
#import "CGBMI.h"
#define WDFont [UIFont systemFontOfSize:14]
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
@interface FourthCell()
/** 天平图像 */
@property (nonatomic, weak) UIImageView *sacleImageView;
/** 身高 */
//@property (nonatomic, weak) UILabel *heightLabel;
/** 体重 */
//@property (nonatomic, weak) UILabel *weightLabel;
/** BMI */
@property (nonatomic, weak) UILabel *BMILabel;
@end
@implementation FourthCell

// 添加子控件的原则:把所有有可能显示的子控件都先添加进去
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat spcae = 10;
        /** 天平图像 */
        UIImageView *sacleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(spcae,0, self.frame.size.width, 250)];
        sacleImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:sacleImageView];
        self.sacleImageView = sacleImageView;

//        [self.sacleImageView makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView);
//            make.left.equalTo(self.contentView).offset(spcae);
//            make.size.equalTo(CGSizeMake(self.bounds.size.width-2*spcae, 250));
//        }];
        
        
        /** 身高 */
//       UILabel *heightLabel = [[UILabel alloc] init];
//        [self.contentView addSubview:heightLabel];
//        self.heightLabel.font = WDFont;
//        self.heightLabel = heightLabel;
//        self.heightLabel.textAlignment =0;
//        self.heightLabel.frame = CGRectMake(60, 16, 100, 24);
        /** 体重 */
//        UILabel *weightLabel = [[UILabel alloc] init];
//        weightLabel.numberOfLines = 0;
//        [self.contentView addSubview:weightLabel];
//        self.weightLabel.font = WDFont;
//        self.weightLabel = weightLabel;
//        
//        self.weightLabel.frame = CGRectMake(210, 30, 100, 24);
        /** BMI */
        UILabel *BMILabel = [[UILabel alloc] init];
        BMILabel.numberOfLines = 0;
//        text_Label.numberOfLines = 0;
        [self.contentView addSubview:BMILabel];
        self.BMILabel = BMILabel;
        self.BMILabel.font = WDFont;
//        self.BMILabel.text = @"BMI:18 体型正常";
        self.BMILabel.frame = CGRectMake(self.frame.size.width/2 -50, 230, 130, 40);
    }
    return self;
}

/**
 *  设置子控件的数据
 */
//- (void)setHeights:(CGHeight *)heights
//{
//    _heights = heights;
//    self.heightLabel.text = [NSString stringWithFormat:@"身高%@cm",heights.height];
//    self.heightLabel.textColor = [UIColor blackColor];
//    
//}
//- (void)setWeights:(CGWeight *)weights{
//    _weights = weights;
//    self.weightLabel.text = [NSString stringWithFormat:@"体重%@kg",weights.weight];
//    self.weightLabel.textColor = [UIColor blackColor];
//}
- (void)setBMIs:(CGBMI *)BMIs{
    _BMIs = BMIs;
    
    self.BMILabel.textColor = [UIColor orangeColor];
    if (BMIs.value.floatValue < 18.5) {
        self.sacleImageView.image = [UIImage imageNamed:@"scale2"];
        self.BMILabel.text = [NSString stringWithFormat:@"BMI:%.1f 体型偏瘦 超过%d%%同龄用户",BMIs.value.floatValue,30];
//        self.heightLabel.frame = CGRectMake(45, 30, 100, 24);
//        self.weightLabel.frame = CGRectMake(180, 16, 100, 24);
//        self.heightLabel.frame = CGRectMake(80, 20, 100, 24);
//        self.weightLabel.frame = CGRectMake(290, 60, 100, 24);
    }else if (18.5 <= BMIs.value.floatValue && BMIs.value.floatValue<= 24.9){
        self.sacleImageView.image = [UIImage imageNamed:@"scale1"];
        self.BMILabel.text = [NSString stringWithFormat:@"BMI:%.1f 体型正常 超过%d%%同龄用户",BMIs.value.floatValue,50];
//        CGRect heightLabelFrame = self.heightLabel.frame;
//        CGRect weightLabelFrame = self.weightLabel.frame;
//        heightLabelFrame.origin.y = 30;
//        weightLabelFrame.origin.y -=10;
//        self.heightLabel.frame = CGRectMake(45, 24, 100, 24);
//        self.weightLabel.frame = CGRectMake(180, 24, 100, 24);
    }else{
        self.sacleImageView.image = [UIImage imageNamed:@"scale3"];
        self.BMILabel.text = [NSString stringWithFormat:@"BMI:%.1f 体型偏胖 超过%d%%同龄用户",BMIs.value.floatValue,70];
//        self.heightLabel.frame = CGRectMake(45, 16, 100, 24);
//        self.weightLabel.frame = CGRectMake(180, 30, 100, 24);
    }
    
}
@end
