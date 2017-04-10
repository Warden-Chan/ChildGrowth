//
//  FourthCell.h
//  ChildGrowth
//
//  Created by ChenWanda on 2016/12/6.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGHeight,CGWeight,CGBMI;
@interface FourthCell : UITableViewCell
/** 模型 */
@property (nonatomic, strong) CGHeight *heights;
@property (nonatomic, strong) CGWeight *weights;
@property (nonatomic, strong) CGBMI *BMIs;
@end
