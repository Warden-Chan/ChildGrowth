//
//  XMGStatusCell.m
//  12-自定义不等高的cell-frame01-
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "SecondCell.h"
#import "Second.h"
#import "UIColor+HexString.h"

#define XMGTextFont [UIFont systemFontOfSize:14]
#define XMGNameFont [UIFont systemFontOfSize:18]
@interface SecondCell ()

/** 图像 */
@property (nonatomic, weak) UIImageView *iconImageView;
/** 标题 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *text_Label;

@end

@implementation SecondCell

// 添加子控件的原则:把所有有可能显示的子控件都先添加进去
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /** 图像 */
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        

        
        /** 标题 */
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = XMGNameFont;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        /** 正文 */
        UILabel *text_Label = [[UILabel alloc] init];
        text_Label.font = XMGTextFont;
        text_Label.numberOfLines = 0;
        text_Label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:text_Label];
        self.text_Label = text_Label;
    }
    return self;
}
-(void)setAttributeLabelWithtextColorPairs:(NSArray*)colorTextPairs
{
    //获取Label的带属性字符串
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.text_Label.attributedText];
    NSString *text = self.text_Label.text;
    NSRange oriRange = NSMakeRange(0, 0), changedRange = NSMakeRange(0, 0);
    //调整行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:10];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    for (NSDictionary *textColorDic in colorTextPairs) {
        //计算要修改的textRange
        NSRange textRange = [text rangeOfString:textColorDic.allKeys.firstObject];
        NSUInteger location = (oriRange.location + oriRange.length) + textRange.location;
        changedRange = NSMakeRange(location, textRange.length);
        //修改指定范围的textColor
        UIColor *curColor = nil;
        if ([textColorDic.allValues.firstObject isKindOfClass:[UIColor class]]) {
            curColor = textColorDic.allValues.firstObject;
        }else{
            curColor = [UIColor colorWithHexString:textColorDic.allValues.firstObject];
        }
        [attrStr addAttribute:NSForegroundColorAttributeName value:curColor range:changedRange];
        //将修改的range改为旧的Range
        oriRange = changedRange;
        //从匹配字符串的结尾开始截取剩下的字符串
        if (textRange.location != NSNotFound &&
            self.text_Label.text.length > (textRange.location + textRange.length)) {
            text = [text substringFromIndex:textRange.location + textRange.length];
        }
    }

    //将修改好的AttributedString赋值给Label
    self.text_Label.attributedText = attrStr;
    [self.text_Label sizeToFit];
}

/**
 *  设置子控件的数据
 */
- (void)setStatus:(Second *)status
{
    _status = status;
    self.iconImageView.image = [UIImage imageNamed:status.icon];
    self.nameLabel.text = status.name;
    

    self.nameLabel.textColor = [UIColor blackColor];
    
    
    self.text_Label.text = status.text;
    [self setAttributeLabelWithtextColorPairs:@[@{@"1、":@"FF7200"},@{@"2、":@"FF7200"},@{@"3、":@"FF7200"},@{@"4、":@"FF7200"},@{@"5、":@"FF7200"},@{@"6、":@"FF7200"},@{@"7、":@"FF7200"},@{@"8、":@"FF7200"},@{@"9、":@"FF7200"}
  ]];  //@{@"7":[UIColor redColor]}

    
    self.iconImageView.frame = self.status.iconFrame;
    self.nameLabel.frame = self.status.nameFrame;
    self.text_Label.frame = self.status.textFrame;
    
}

@end
