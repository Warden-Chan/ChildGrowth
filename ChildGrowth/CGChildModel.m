//
//  CGChildModel.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/29.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "CGChildModel.h"
#import "MJExtension.h"
@implementation CGChildModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"heightArr":@"CGHeight",@"weightArr":@"CGWeight",@"BMIArr":@"CGBMI",@"headcArr":@"CGHeadc"};
}
@end
