//
//  CGHeadc.h
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/29.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGHeadc : NSObject
/** 测量时间 */
@property (nonatomic, copy) NSString *time;
/** 头围 */
@property (nonatomic, copy) NSNumber *headc;

+ (instancetype)itemWithHeadc:(NSNumber *)headc time:(NSString *)time;
@end
