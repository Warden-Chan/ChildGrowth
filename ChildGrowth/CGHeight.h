//
//  CGHeight.h
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/29.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGHeight : NSObject
/** 测量时间 */
@property (nonatomic, retain) NSString *time;
/** 身高 */
@property (nonatomic, retain) NSNumber *height;

+ (instancetype)itemWithHeight:(NSNumber *)height time:(NSString *)time;
@end
