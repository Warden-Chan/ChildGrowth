//
//  HTextViewCell.m
//  Textfield
//
//  Created by 朱同海 on 16/7/6.
//  Copyright © 2016年 朱同海. All rights reserved.
//

#import "HTextViewCell.h"
#import "UITextField+IndexPath.h"

@interface HTextViewCell ()
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation HTextViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

- (void)setTitleString:(NSString *)string detailString:(NSString *)detailString andDataString:(NSString *)dataString andIndexPath:(NSIndexPath *)indexPath{
    // 核心代码
    self.textField.indexPath = indexPath;
    self.textField.text = dataString;
    self.titleLabel.text = string;
    self.detailLabel.text = detailString;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(120, 5, 160, 30)];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
//        _textField.layer.borderColor = [UIColor cyanColor].CGColor;
//        _textField.layer.borderWidth = 0.5;
    }
    return _textField;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
    }
    return _titleLabel;
}
-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 0, self.frame.size.width-280, 40)];
    }
    return _detailLabel;
}

@end
