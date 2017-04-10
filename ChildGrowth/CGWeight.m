//
//  CGWeight.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/29.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "CGWeight.h"

@implementation CGWeight
+ (instancetype)itemWithWeight:(NSNumber *)weight time:(NSString *)time{
    CGWeight *item = [[CGWeight alloc] init];
    item.weight = weight;
    item.time  = time;
    return item;
}
@end
