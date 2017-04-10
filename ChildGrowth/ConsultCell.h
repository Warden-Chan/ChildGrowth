//
//  ConsultCell.h
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/21.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Consult;
@interface ConsultCell : UITableViewCell
/** 咨询模型 */
@property (nonatomic, strong) Consult *consult;
@end
