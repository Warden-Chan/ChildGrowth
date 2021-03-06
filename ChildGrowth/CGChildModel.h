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
@property(nonatomic) NSString *ChildId;
/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 姓名 */
@property (nonatomic, copy) NSString *name;

/** 年龄 */
@property (nonatomic, copy) NSString *age;

/** 性别 */
@property (nonatomic, copy) NSString *sex;

/** 父亲身高 */
@property (nonatomic, copy) NSString *fatherHeight;

/** 母亲身高 */
@property (nonatomic, copy) NSString *motherHeight;

/** 孕期 */
@property (nonatomic, copy) NSNumber *oregnancy;

/** 身高数组 */
@property (nonatomic, retain) NSMutableArray *heightArr;

/** 体重数组 */
@property (nonatomic, retain) NSMutableArray *weightArr;

/** 头围数组 */
@property (nonatomic, retain) NSMutableArray *headcArr;
/** BMI数组 */
@property (nonatomic, retain) NSMutableArray *BMIArr;
@end
