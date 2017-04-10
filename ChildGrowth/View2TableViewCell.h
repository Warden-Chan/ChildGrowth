//
//  View2TableViewCell.h
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/15.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
//制定协议
@protocol View2TableViewCellDelegate<NSObject>
-(void)choseButton:(UIButton *)button;
@end
@interface View2TableViewCell : UITableViewCell
@property(assign,nonatomic)id<View2TableViewCellDelegate>delegate;
@end
