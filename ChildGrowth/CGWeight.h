//
//  CGWeight.h
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/29.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGWeight : NSObject
/** 测量时间 */
@property (nonatomic, copy) NSString *time;
/** 体重 */
@property (nonatomic, copy) NSNumber *weight;

+ (instancetype)itemWithWeight:(NSNumber *)weight time:(NSString *)time;
@end
