//
//  View2TableViewCell.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/15.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "View2TableViewCell.h"
#import "View2UIButton.h"
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"


@interface View2TableViewCell()
@property (strong, nonatomic) View2UIButton *view1;
@property (strong, nonatomic) View2UIButton *view2;
@property (strong, nonatomic) View2UIButton *view3;
@end
@implementation View2TableViewCell
// 在这个方法中添加所有的子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&");
        
        CGFloat spcae = 10;
        CGFloat W = screenWidth-spcae*2;
        /** 图标1 */
        self.view1 = [[[NSBundle mainBundle] loadNibNamed:@"View2" owner:nil options:nil] lastObject];
//         self.view1 = [[View2UIButton alloc] init];
//       self.view1.backgroundColor = [UIColor blueColor];
        NSString *imagename1 = @"Person_add";
        self.view1.imageview.image = [UIImage imageNamed:imagename1];
        self.view1.lable.text = @"儿童管理";
        self.view1.tag = 21;
        [self.view1 addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.view1];
       
        [self.view1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae);
            make.left.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-spcae);
            make.width.equalTo(W/3);
        }];
        /** 图标2 */
        self.view2 = [[[NSBundle mainBundle] loadNibNamed:@"View2" owner:nil options:nil] lastObject];
        NSString *imagename2 = @"76-baby";
        self.view2.imageview.image = [UIImage imageNamed:imagename2];
         self.view2.lable.text = @"签到";
        self.view2.tag = 22;
         [self.view2 addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.view2];

        [self.view2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae);
            make.left.equalTo(self.view1.right).offset(spcae);
            make.bottom.equalTo(self.contentView).offset(-spcae);
            make.width.equalTo(W/3);
        }];
        /** 图标3 */
        self.view3 = [[[NSBundle mainBundle] loadNibNamed:@"View2" owner:nil options:nil] lastObject];
        NSString *imagename3 = @"19-gear";
        self.view3.imageview.image = [UIImage imageNamed:imagename3];
      self.view3.lable.text = @"退出登录";
        self.view3.tag = 23;
         [self.view3 addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.view3];

        [self.view3 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(spcae);
            make.left.equalTo(self.view2.right).offset(spcae);
            make.bottom.equalTo(self.contentView).offset(-spcae);
            make.width.equalTo(W/3);
        }];
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)ButtonClicked:(UIButton *)sender{
    [_delegate choseButton:sender];
}
//-(void)click1{
//    NSLog(@"第一个按钮");
//    
//}
//-(void)click2{
//    NSLog(@"第二个按钮");
//}
//-(void)click3{
//    NSLog(@"第三个按钮");
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
