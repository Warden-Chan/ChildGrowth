//
//  consult.h
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/21.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Consult : NSObject
/** 文字/图片数据***/
/** 图像 */
@property (nonatomic, copy) NSString *icon;

/** 昵称 */
@property (nonatomic, copy) NSString *name;
/** 时间 */
@property (nonatomic, copy) NSString *time;
///** 年龄 */
//@property (nonatomic, copy) NSString *age;
/** 正文(内容) */
@property (nonatomic, copy) NSString *text;




/** frame数据***/
/** 图像的frame */
@property (nonatomic, assign) CGRect iconFrame;
/** 昵称的frame */
@property (nonatomic, assign) CGRect nameFrame;
/** 咨询时间的frame */
@property (nonatomic, assign) CGRect timeFrame;

/** 正文frame */
@property (nonatomic, assign) CGRect textFrame;


/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end
