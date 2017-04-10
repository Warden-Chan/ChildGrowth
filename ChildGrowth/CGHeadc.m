//
//  CGHeadc.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/29.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "CGHeadc.h"

@implementation CGHeadc
+ (instancetype)itemWithHeadc:(NSNumber *)headc time:(NSString *)time{
    CGHeadc *item = [[CGHeadc alloc] init];
    item.headc = headc;
    item.time  = time;
    return item;
}
@end
