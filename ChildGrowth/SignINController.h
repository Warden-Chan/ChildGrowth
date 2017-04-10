//
//  SignINController.h
//  PCN
//
//  Created by 蒙奇D路飞 on 16/8/19.
//  Copyright © 2016年 com.smh.pcn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GradientView,CLLocation;
typedef void(^ClickSignBtn)(BOOL isSignSuccess);
@interface SignINController : UIViewController
@property (strong,nonatomic) GradientView *gradientView;
@property (assign,nonatomic) int signCount;
@property (strong,nonatomic) CLLocation *signLocation;
@property (strong,nonatomic) ClickSignBtn clickSignBtn;
@end
