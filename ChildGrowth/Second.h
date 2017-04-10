//
//  XMGStatus.h
//  12-自定义不等高的cell-frame01-
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Second : NSObject

/** 文字/图片数据***/
/** 图像 */
@property (nonatomic, copy) NSString *icon;

/** 标题 */
@property (nonatomic, copy) NSString *name;

/** 正文(内容) */
@property (nonatomic, copy) NSString *text;




/** frame数据***/
/** 图像的frame */
@property (nonatomic, assign) CGRect iconFrame;
/** 标题的frame */
@property (nonatomic, assign) CGRect nameFrame;
/** 正文frame */
@property (nonatomic, assign) CGRect textFrame;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
