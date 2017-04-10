//
//  CGHeight.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/29.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "CGHeight.h"

@implementation CGHeight

+ (instancetype)itemWithHeight:(NSNumber *)height time:(NSString *)time{
    CGHeight *item = [[CGHeight alloc] init];
    item.height = height;
    item.time  = time;
    return item;
}
@end
