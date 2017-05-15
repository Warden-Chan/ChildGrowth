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
@property (nonatomic, weak) UILabel *heightBlable;
@property (nonatomic, weak) UILabel *weightHlable;
@property (nonatomic, weak) UILabel *weightBlable;
@property (nonatomic, weak) YSProgressView *ysView1;
@property (nonatomic, weak) YSProgressView *ysView2;
@end

@implementation ThirdCell
// 添加子控件的原则:把所有有可能显示的子控件都先添加进去
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat spcae = 5;
         /**身高上方标签**/
        UILabel *heightHlable = [[UILabel alloc]init];
        heightHlable.text = @"身高超过50%的同龄用户";
        [self.contentView addSubview:heightHlable];
        self.heightHlable = heightHlable;
        [heightHlable makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae*4);
            make.left.equalTo(self.contentView).offset(spcae*5);
            make.size.equalTo(CGSizeMake(self.contentView.bounds.size.width-spcae, 15));
        }];
        
        /**身高进度条**/
    YSProgressView *ysView1 = [[YSProgressView alloc] initWithFrame:CGRectMake(spcae*5, spcae*8,screenWidth - spcae*7, 10)];
//        YSProgressView *ysView1 =[[YSProgressView alloc]init];
        ysView1.progressHeight = 10;
//        ysView1.progressTintColor = [UIColor cyanColor];
        
        ysView1.progressTintColor = [UIColor colorWithRed:0.973 green:0.745 blue:0.306 alpha:1.000];
        ysView1.trackTintColor = [UIColor colorWithRed:(CGFloat)0/255.0 green:(CGFloat)255/255.0 blue:(CGFloat)127/255.0 alpha:1.0000];
//        ysView1.progressValue = 1000;
        ysView1.progressValue = (self.bounds.size.width - spcae*6) *0.5;
    [self.contentView addSubview:ysView1];
//        [ysView1 makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(spcae*6);
//            make.left.equalTo(self.contentView).offset(spcae*6);
//            make.size.equalTo(CGSizeMake(self.bounds.size.width-spcae*6, 10));
//        }];
        
        /**身高下方标签**/
        UILabel *heightBlable = [[UILabel alloc]init];
        heightBlable.text = @"0%       25%         50%         80%    100%";
        [self.contentView addSubview:heightBlable];
        self.heightBlable = heightBlable;
        [heightBlable makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae*10);
            make.left.equalTo(self.contentView).offset(spcae*5);
            make.size.equalTo(CGSizeMake(self.contentView.frame.size.width-spcae*4, 15));
        }];
        
        /**体重上方标签**/
        UILabel *weightHlable = [[UILabel alloc]init];
         weightHlable.text = @"体重超过80%的同龄用户";
        [self.contentView addSubview:weightHlable];
        self.weightHlable = weightHlable;
        [weightHlable makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(heightBlable.bottom).offset(spcae*6);
            make.left.equalTo(self.contentView).offset(spcae*5);
            make.size.equalTo(CGSizeMake(self.contentView.frame.size.width-spcae*6, 15));
        }];
        
        /**体重进度条**/
            YSProgressView *ysView2 = [[YSProgressView alloc] initWithFrame:CGRectMake(spcae*5, spcae*23, screenWidth - spcae*7, 10)];
//        YSProgressView *ysView2 =[[YSProgressView alloc]init];
        //    ysView.progressHeight = 10;
//        ysView2.progressTintColor = [UIColor cyanColor];
//            ysView2.trackTintColor = [UIColor colorWithRed:0.973 green:0.745 blue:0.306 alpha:1.000];
        ysView2.progressTintColor = [UIColor colorWithRed:0.973 green:0.745 blue:0.306 alpha:1.000];
        ysView2.trackTintColor = [UIColor colorWithRed:(CGFloat)0/255.0 green:(CGFloat)255/255.0 blue:(CGFloat)127/255.0 alpha:1.0000];
        //    ysView.progressValue = 1000;
        ysView2.progressValue = (self.bounds.size.width - spcae*6) *0.8;
        [self.contentView addSubview:ysView2];
//        [ysView2 makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weightHlable.bottom).offset(spcae);
//            make.left.equalTo(self.contentView);
//            make.size.equalTo(CGSizeMake(self.contentView.frame.size.width-spcae, 15));
//        }];
//        
        /**体重下方标签**/
        UILabel *weightBlable = [[UILabel alloc]init];
        weightBlable.text = @"0%       25%         50%         80%    100%";
        [self.contentView addSubview:weightBlable];
        self.weightBlable = weightBlable;
        [weightBlable makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ysView2.bottom);
            make.left.equalTo(self.contentView).offset(spcae*5);
            make.size.equalTo(CGSizeMake(self.contentView.frame.size.width, 15));
        }];
    }
    return self;
}


@end
