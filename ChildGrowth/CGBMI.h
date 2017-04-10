//
//  CGBMI.h
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/29.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGBMI : NSObject
/** 测量时间 */
@property (nonatomic, copy) NSString *time;
/** BMI */
@property (nonatomic, copy) NSNumber *value;
@end
