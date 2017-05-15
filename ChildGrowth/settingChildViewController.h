//
//  settingChildViewController.h
//  ChildGrowth
//
//  Created by ChenWanda on 2017/2/20.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingChildViewController : UIViewController
//0：注册  1：添加儿童
@property (nonatomic,assign)BOOL flag;
//用户账号
@property (nonatomic,strong)NSString *userAccount;
//用户密码
@property (nonatomic,strong)NSString *userPassword;
//用户头像
@property (nonatomic,strong)UIImage *userIcon;
//用户昵称
@property (nonatomic,strong)NSString *userName;
@end
