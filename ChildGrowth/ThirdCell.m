//
//  ThirdCell.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/19.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "ThirdCell.h"
#import "YSProgressView.h"
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
@interface ThirdCell()
@property (nonatomic, weak) UILabel *heightHlable;
@property (nonatomic, weak) UILabel *heightBlable0;
@property (nonatomic, weak) UILabel *heightBlable25;
@property (nonatomic, weak) UILabel *heightBlable50;
@property (nonatomic, weak) UILabel *heightBlable75;
@property (nonatomic, weak) UILabel *heightBlable100;
@property (nonatomic, weak) UILabel *weightHlable;
@property (nonatomic, weak) UILabel *weightBlable0;
@property (nonatomic, weak) UILabel *weightBlable25;
@property (nonatomic, weak) UILabel *weightBlable50;
@property (nonatomic, weak) UILabel *weightBlable75;
@property (nonatomic, weak) UILabel *weightBlable100;
@property (nonatomic, weak) YSProgressView *ysView1;
@property (nonatomic, weak) YSProgressView *ysView2;
@end

@implementation ThirdCell
CGFloat spcae = 5;
// 添加子控件的原则:把所有有可能显示的子控件都先添加进去
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat Labelwidth =(screenWidth-spcae*8)/4;
         /**身高上方标签**/
        UILabel *heightHlable = [[UILabel alloc]init];
        heightHlable.text = @"身高超过32%的同龄用户";
        [self.contentView addSubview:heightHlable];
        self.heightHlable = heightHlable;
        [heightHlable makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae*4);
            make.left.equalTo(self.contentView).offset(spcae*5);
            make.size.equalTo(CGSizeMake(self.contentView.bounds.size.width-spcae, 15));
        }];
        
        /**身高进度条**/
    YSProgressView *ysView1 = [[YSProgressView alloc] initWithFrame:CGRectMake(spcae*4, spcae*8,screenWidth - spcae*8, 10)];
//        YSProgressView *ysView1 =[[YSProgressView alloc]init];
        ysView1.progressHeight = 10;
//        ysView1.progressTintColor = [UIColor cyanColor];
        
        ysView1.progressTintColor = [UIColor colorWithRed:0.973 green:0.745 blue:0.306 alpha:1.000];
        ysView1.trackTintColor = [UIColor colorWithRed:(CGFloat)0/255.0 green:(CGFloat)255/255.0 blue:(CGFloat)127/255.0 alpha:1.0000];
//        ysView1.progressValue = 1000;
        ysView1.progressValue = (screenWidth - spcae*8) *0.32;
    [self.contentView addSubview:ysView1];
//        [ysView1 makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(spcae*6);
//            make.left.equalTo(self.contentView).offset(spcae*6);
//            make.size.equalTo(CGSizeMake(self.bounds.size.width-spcae*6, 10));
//        }];
        
        /**身高下方标签**/
        UILabel *heightBlable0 = [[UILabel alloc]init];
        heightBlable0.text = @"0%";
        [self.contentView addSubview:heightBlable0];
        self.heightBlable0 = heightBlable0;
        [heightBlable0 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae*10);
            make.left.equalTo(self.contentView).offset(spcae*3);
            make.size.equalTo(CGSizeMake(Labelwidth, 15));
        }];
        UILabel *heightBlable25 = [[UILabel alloc]init];
        heightBlable25.text = @"25%";
//        heightBlable25.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:heightBlable25];
        self.heightBlable25 = heightBlable25;
        [heightBlable25 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae*10);
            make.left.equalTo(self.contentView).offset(spcae*2+Labelwidth);
            make.size.equalTo(CGSizeMake(Labelwidth, 15));
        }];
        UILabel *heightBlable50 = [[UILabel alloc]init];
        heightBlable50.text = @"50%";
//        heightBlable50.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:heightBlable50];
        self.heightBlable50 = heightBlable50;
        [heightBlable50 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae*10);
            make.left.equalTo(self.contentView).offset(spcae*2+Labelwidth*2);
            make.size.equalTo(CGSizeMake(Labelwidth, 15));
        }];
        UILabel *heightBlable75 = [[UILabel alloc]init];
        heightBlable75.text = @"75%";
//        heightBlable75.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:heightBlable75];
        self.heightBlable75 = heightBlable75;
        [heightBlable75 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae*10);
            make.left.equalTo(self.contentView).offset(spcae*2+Labelwidth*3);
            make.size.equalTo(CGSizeMake(Labelwidth, 15));
        }];
        UILabel *heightBlable100 = [[UILabel alloc]init];
        heightBlable100.text = @"100%";
//        heightBlable100.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:heightBlable100];
        self.heightBlable100 = heightBlable100;
        [heightBlable100 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae*10);
            make.left.equalTo(self.contentView).offset(Labelwidth*4);
            make.size.equalTo(CGSizeMake(Labelwidth, 15));
        }];
        
        /**体重上方标签**/
        UILabel *weightHlable = [[UILabel alloc]init];
         weightHlable.text = @"体重超过76%的同龄用户";
        [self.contentView addSubview:weightHlable];
        self.weightHlable = weightHlable;
        [weightHlable makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(heightBlable0.bottom).offset(spcae*6);
            make.left.equalTo(self.contentView).offset(spcae*5);
            make.size.equalTo(CGSizeMake(self.contentView.frame.size.width-spcae*6, 15));
        }];
        
        /**体重进度条**/
            YSProgressView *ysView2 = [[YSProgressView alloc] initWithFrame:CGRectMake(spcae*4, spcae*23, screenWidth - spcae*8, 10)];
//        YSProgressView *ysView2 =[[YSProgressView alloc]init];
        //    ysView.progressHeight = 10;
//        ysView2.progressTintColor = [UIColor cyanColor];
//            ysView2.trackTintColor = [UIColor colorWithRed:0.973 green:0.745 blue:0.306 alpha:1.000];
        ysView2.progressTintColor = [UIColor colorWithRed:0.973 green:0.745 blue:0.306 alpha:1.000];
        ysView2.trackTintColor = [UIColor colorWithRed:(CGFloat)0/255.0 green:(CGFloat)255/255.0 blue:(CGFloat)127/255.0 alpha:1.0000];
        //    ysView.progressValue = 1000;
        ysView2.progressValue = (screenWidth - spcae*8) *0.76;
        [self.contentView addSubview:ysView2];
//        [ysView2 makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weightHlable.bottom).offset(spcae);
//            make.left.equalTo(self.contentView);
//            make.size.equalTo(CGSizeMake(self.contentView.frame.size.width-spcae, 15));
//        }];
//        
        /**体重下方标签**/
        UILabel *weightBlable0 = [[UILabel alloc]init];
        weightBlable0.text = @"0%";
        [self.contentView addSubview:weightBlable0];
        self.weightBlable0 = weightBlable0;
        [weightBlable0 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ysView2.bottom);
            make.left.equalTo(self.contentView).offset(spcae*3);
            make.size.equalTo(CGSizeMake(Labelwidth, 15));
        }];
        UILabel *weightBlable25 = [[UILabel alloc]init];
        weightBlable25.text = @"25%";
        [self.contentView addSubview:weightBlable25];
        self.weightBlable25 = weightBlable25;
        [weightBlable25 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ysView2.bottom);
            make.left.equalTo(self.contentView).offset(spcae*2+Labelwidth);
            make.size.equalTo(CGSizeMake(Labelwidth, 15));
        }];
        UILabel *weightBlable50 = [[UILabel alloc]init];
        weightBlable50.text = @"50%";
        [self.contentView addSubview:weightBlable50];
        self.weightBlable50 = weightBlable50;
        [weightBlable50 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ysView2.bottom);
            make.left.equalTo(self.contentView).offset(spcae*2+Labelwidth*2);
            make.size.equalTo(CGSizeMake(Labelwidth, 15));
        }];
        UILabel *weightBlable75 = [[UILabel alloc]init];
        weightBlable75.text = @"75%";
        [self.contentView addSubview:weightBlable75];
        self.weightBlable75 = weightBlable75;
        [weightBlable75 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ysView2.bottom);
            make.left.equalTo(self.contentView).offset(spcae*2+Labelwidth*3);
            make.size.equalTo(CGSizeMake(Labelwidth, 15));
        }];
        UILabel *weightBlable100 = [[UILabel alloc]init];
        weightBlable100.text = @"100%";
        [self.contentView addSubview:weightBlable100];
        self.weightBlable100 = weightBlable100;
        [weightBlable100 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ysView2.bottom);
            make.left.equalTo(self.contentView).offset(Labelwidth*4);
            make.size.equalTo(CGSizeMake(Labelwidth, 15));
        }];
        
    }
    return self;
}
-(void)setThird:(Third *)third{
    self.heightHlable.text = [NSString stringWithFormat:@"身高超过%.1f%%的同龄用户",third.height];
    self.weightHlable.text = [NSString stringWithFormat:@"体重超过%.1f%%的同龄用户",third.weight];
    self.ysView1.progressValue = (screenWidth - spcae*8) *0.32;
     self.ysView2.progressValue = (screenWidth - spcae*8) *0.76;
}


@end
