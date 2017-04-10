//
//  ConsultCell.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/21.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "ConsultCell.h"
#import "Consult.h"

#define WDTextFont [UIFont systemFontOfSize:15]
#define WDNameFont [UIFont systemFontOfSize:14]
#define WDtimeFont [UIFont systemFontOfSize:12]

@interface ConsultCell ()
/** 图像 */
@property (nonatomic, weak) UIImageView *iconImageView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 咨询时间及年龄 */
@property (nonatomic, weak) UILabel *timeLabel;

/** 正文 */
@property (nonatomic, weak) UILabel *text_Label;

@end

@implementation ConsultCell

// 添加子控件的原则:把所有有可能显示的子控件都先添加进去
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /** 图像 */
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;

        

        
        /** 昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = WDNameFont;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        /** 咨询时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = WDtimeFont;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        /** 正文 */
        UILabel *text_Label = [[UILabel alloc] init];
        text_Label.font = WDTextFont;
        text_Label.numberOfLines = 0;
        [self.contentView addSubview:text_Label];
        self.text_Label = text_Label;
    }
    return self;
}

/**
 *  设置所有的子控件的frame
 */
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.iconImageView.frame = self.status.iconFrame;
//    self.nameLabel.frame = self.status.nameFrame;
//    self.vipImageView.frame = self.status.vipFrame;
//    self.text_Label.frame = self.status.textFrame;
//    self.pictureImageView.frame = self.status.pictureFrame;
//}

/**
 *  设置子控件的数据
 */
- (void)setConsult:(Consult *)consult
{
    _consult = consult;
    self.iconImageView.image = [UIImage imageNamed:consult.icon];
    self.nameLabel.text = consult.name;
    

    self.nameLabel.textColor = [UIColor blackColor];
    self.timeLabel.text = [NSString stringWithFormat:@"咨询于%@ 儿童5岁3个月",consult.time];
    
    self.text_Label.text = consult.text;
    

    
    self.iconImageView.frame = self.consult.iconFrame;
    self.nameLabel.frame = self.consult.nameFrame;
    self.timeLabel.frame = self.consult.timeFrame;
    self.text_Label.frame = self.consult.textFrame;

}

@end
