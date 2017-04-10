//
//  CGChildModel.h
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/29.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CGChildModel : NSObject
/**  ID */
@property(nonatomic) NSInteger ChildId;
/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 姓名 */
@property (nonatomic, copy) NSString *name;

/** 年龄 */
@property (nonatomic, copy) NSString *age;

/** 性别 */
@property (nonatomic, copy) NSString *sex;

/** 身高数组 */
@property (nonatomic, retain) NSMutableArray *heightArr;

/** 体重数组 */
@property (nonatomic, retain) NSMutableArray *weightArr;

/** 头围数组 */
@property (nonatomic, retain) NSMutableArray *headcArr;
/** BMI数组 */
@property (nonatomic, retain) NSMutableArray *BMIArr;
@end
