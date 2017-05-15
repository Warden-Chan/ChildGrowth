//
//  XMGTgCell.h
//  02-自定义等高的cell-代码-frame01
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGChildModel;
@interface FirstCell : UITableViewCell

/** 内容模型 */

@property(nonatomic,strong)CGChildModel *childmodel;
@property (nonatomic, strong) NSMutableArray *childs;
@property (nonatomic,copy) NSNumber *childindex;
@end
