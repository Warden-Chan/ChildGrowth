//
//  finalRegisterViewController.h
//  ChildGrowth
//
//  Created by ChenWanda on 2017/5/11.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGChildModel,finalRegisterViewController;
//1.定义协议
@protocol finalRegisterViewControllerDelegate <NSObject>
//2.定义协议方法
@optional
- (void)addChildinfo:(finalRegisterViewController *)addchildinfo childItem:(CGChildModel *)childitem;
@end
@interface finalRegisterViewController : UIViewController
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

//儿童名字
@property (nonatomic,strong)NSString *childName;
//儿童生日
@property (nonatomic,strong)NSString *childBirth;
//儿童身份证
@property (nonatomic,strong)NSString *childID;
//儿童性别
@property (nonatomic,strong)NSString *childSex;
//儿童城市
@property (nonatomic,strong)NSString *childCity;
//儿童头像
@property (nonatomic,strong)UIImage *childIcon;
@property (nonatomic, weak) id<finalRegisterViewControllerDelegate> delegate;
@end
