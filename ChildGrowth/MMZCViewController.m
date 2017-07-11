//
//  MMZCViewController.m
//  MMR
//
//  Created by qianfeng on 15/6/30.
//  Copyright © 2015年 MaskMan. All rights reserved.
//

#import "MMZCViewController.h"
#import "forgetPassWardViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+XMG.h"
#import "MMZCHMViewController.h"
#import "AFHTTPSessionManager.h"


@interface MMZCViewController ()
{
    UIImageView *View;
    UIView *bgView;
    UITextField *pwd;
    UITextField *user;
    UIButton *QQBtn;
    UIButton *weixinBtn;
    UIButton *xinlangBtn;
}
@property(copy,nonatomic) NSString * accountNumber;
@property(copy,nonatomic) NSString * mmmm;
@property(copy,nonatomic) NSString * user;


@end

@implementation MMZCViewController

-(void)viewWillAppear:(BOOL)animated
{
   //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:216/255.0f green:209/255.0f blue:192/255.0f alpha:1]];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    //设置NavigationBar背景颜色
    View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //View.backgroundColor=[UIColor redColor];
    View.image=[UIImage imageNamed:@"bg4"];
    [self.view addSubview:View];
    
////    self.title=@"登陆";
////    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn:)];
////    [addBtn setImage:[UIImage imageNamed:@"goback_back_orange_on"]];
////    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
////    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
////    [self.navigationItem setLeftBarButtonItem:addBtn];
//    
//    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(zhuce)];
//    right.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
//    self.navigationItem.rightBarButtonItem=right;
   
    //为了显示背景图片自定义navgationbar上面的三个按钮
//    UIButton *but =[[UIButton alloc]initWithFrame:CGRectMake(5, 27, 35, 35)];
//    [but setImage:[UIImage imageNamed:@"goback_back_orange_on"] forState:UIControlStateNormal];
//    [but addTarget:self action:@selector(clickaddBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:but];
    
    UIButton *zhuce =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 30, 50, 30)];
    [zhuce setTitle:@"注册" forState:UIControlStateNormal];
    [zhuce setTitleColor:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1] forState:UIControlStateNormal];
    zhuce.font=[UIFont systemFontOfSize:17];
    [zhuce addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhuce];
    
    
    UILabel *lanel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-30)/2, 30, 50, 30)];
    lanel.text=@"登录";
    lanel.textColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.view addSubview:lanel];

    
    [self createButtons];
    [self createImageViews];
    [self createTextFields];
    
    [self createLabel];
}

-(void)clickaddBtn:(UIButton *)button
{
//      [kAPPDelegate appDelegateInitTabbar];
    self.view.backgroundColor=[UIColor whiteColor];
    exit(0);
}


-(void)createLabel
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-140)/2, 390, 140, 21)];
    label.text=@"第三方账号快速登录";
    label.textColor=[UIColor grayColor];
    label.textAlignment=UITextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:label];
}

-(void)createTextFields
{
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 75, frame.size.width-20, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.alpha=0.7;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    user=[self createTextFielfFrame:CGRectMake(60, 10, 271, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入您手机号码"];
    //user.text=@"13419693608";
    user.keyboardType=UIKeyboardTypeNumberPad;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
   
    pwd=[self createTextFielfFrame:CGRectMake(60, 60, 271, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"密码" ];
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    //pwd.text=@"123456";
    //密文样式
    pwd.secureTextEntry=YES;
    //pwd.keyboardType=UIKeyboardTypeNumberPad;

    
    UIImageView *userImageView=[self createImageViewFrame:CGRectMake(20, 10, 25, 25) imageName:@"ic_landing_nickname" color:nil];
    UIImageView *pwdImageView=[self createImageViewFrame:CGRectMake(20, 60, 25, 25) imageName:@"mm_normal" color:nil];
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    [bgView addSubview:user];
    [bgView addSubview:pwd];
    
    [bgView addSubview:userImageView];
    [bgView addSubview:pwdImageView];
    [bgView addSubview:line1];
}


-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}

-(void)createImageViews
{
    //    UIImageView *userImageView=[self createImageViewFrame:CGRectMake(25, 10, 25, 25) imageName:@"ic_landing_nickname" color:nil];
    //    UIImageView *pwdImageView=[self createImageViewFrame:CGRectMake(25, 60, 25, 25) imageName:@"ic_landing_password" color:nil];
    //    UIImageView *line1=[self createImageViewFrame:CGRectMake(25, 50, 260, 1.5) imageName:nil color:[UIColor lightGrayColor]];
    //
    //    //UIImageView *line2=[self createImageViewFrame:CGRectMake(88, 210, 280, 1) imageName:nil color:[UIColor grayColor]];
    
    UIImageView *line3=[self createImageViewFrame:CGRectMake(2, 400, 100, 1) imageName:nil color:[UIColor lightGrayColor]];
    UIImageView *line4=[self createImageViewFrame:CGRectMake(self.view.frame.size.width-100-4, 400, 100, 1) imageName:nil color:[UIColor lightGrayColor]];
    
    //    [bgView addSubview:userImageView];
    //    [bgView addSubview:pwdImageView];
    //    [bgView addSubview:line1];
    //[self.view addSubview:line2];
    [self.view addSubview:line3];
    [self.view addSubview:line4];
    
}


-(void)createButtons
{
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, 190, self.view.frame.size.width-20, 37) backImageName:nil title:@"登录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:19] target:self action:@selector(landClick)];
    landBtn.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    landBtn.layer.cornerRadius=5.0f;
    
    UIButton *newUserBtn=[self createButtonFrame:CGRectMake(5, 235, 70, 30) backImageName:nil title:@"快速注册" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(registration:)];
    //newUserBtn.backgroundColor=[UIColor lightGrayColor];
    
    UIButton *forgotPwdBtn=[self createButtonFrame:CGRectMake(self.view.frame.size.width-75, 235, 60, 30) backImageName:nil title:@"找回密码" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(fogetPwd:)];
    //fogotPwdBtn.backgroundColor=[UIColor lightGrayColor];
  
    
      #define Start_X 60.0f           // 第一个按钮的X坐标
      #define Start_Y 440.0f           // 第一个按钮的Y坐标
      #define Width_Space 50.0f        // 2个按钮之间的横间距
      #define Height_Space 20.0f      // 竖间距
      #define Button_Height 50.0f    // 高
      #define Button_Width 50.0f      // 宽


    
    //微信
    weixinBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2, 440, 50, 50)];
    //weixinBtn.tag = UMSocialSnsTypeWechatSession;
    weixinBtn.layer.cornerRadius=25;
    weixinBtn=[self createButtonFrame:weixinBtn.frame backImageName:@"ic_landing_wechat" title:nil titleColor:nil font:nil target:self action:@selector(onClickWX:)];
    //qq
    QQBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2-100, 440, 50, 50)];
    //QQBtn.tag = UMSocialSnsTypeMobileQQ;
    QQBtn.layer.cornerRadius=25;
    QQBtn=[self createButtonFrame:QQBtn.frame backImageName:@"ic_landing_qq" title:nil titleColor:nil font:nil target:self action:@selector(onClickQQ:)];
    
    //新浪微博
    xinlangBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2+100, 440, 50, 50)];
    //xinlangBtn.tag = UMSocialSnsTypeSina;
    xinlangBtn.layer.cornerRadius=25;
    xinlangBtn=[self createButtonFrame:xinlangBtn.frame backImageName:@"ic_landing_microblog" title:nil titleColor:nil font:nil target:self action:@selector(onClickSina:)];
    
    [self.view addSubview:weixinBtn];
    [self.view addSubview:QQBtn];
    [self.view addSubview:xinlangBtn];
    [self.view addSubview:landBtn];
    [self.view addSubview:newUserBtn];
    [self.view addSubview:forgotPwdBtn];

    
}


- (void)onClickQQ:(UIButton *)button
{
}

- (void)onClickWX:(UIButton *)button
{
}


- (void)onClickSina:(UIButton *)button
{
    
}

                     
-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}


//登录
-(void)landClick
{
 
    //如果用户名跟密码正确,跳转到下一个界面
    //提醒用户正在登录
    [MBProgressHUD showMessage:@"正在登录..." toView:self.view];
    
    // 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.利用AFN管理者发送请求
    NSDictionary *params = @{
                             @"userAccount" : user.text,
                             @"userPassword" : pwd.text
                             };
    [manager POST:@"http://121.40.89.113/childGrow/Mobile/login" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        if ([[dict objectForKey:@"flag"]  isEqual:@1]) {
            //1、记录token到userdeafult
            NSString *token = [dict objectForKey:@"token"];
            //将上述数据全部存储到NSUserDefaults中
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
            [userDefaults setValue:token forKey:@"token"];
            [userDefaults setValue:user.text forKey:@"userAccount"];
            [userDefaults setValue:pwd.text forKey:@"userPassword"];
            //这里建议同步存储到磁盘中，但是不是必须的
            [userDefaults synchronize];
            //2、生成ChildInformation   1.info  2.data
            NSDictionary *info = [dict objectForKey:@"info"];
            NSMutableArray *childArr = [[NSMutableArray alloc]init];
            if(![info isKindOfClass:[NSNull class]]){
                for (NSDictionary *childinfo in [info allValues]) {
                    NSNumber *childid = [childinfo objectForKey:@"childid"];
                    NSString *childname =[childinfo objectForKey:@"childname"];
                    NSString *birthdate =[childinfo objectForKey:@"childbirthdate"];
                    NSString *childbirthdate = [self dataStringfromDataString:birthdate];
                    NSString *childsex =[childinfo objectForKey:@"childsex"];
                    NSString *fatherHeight = [childinfo objectForKey:@"fatherheight"];
                    NSString *motherHeight = [childinfo objectForKey:@"motherheight"];
                    NSString *oregnancy = [childinfo objectForKey:@"fullmonth"];

                    NSMutableDictionary *childdic= [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                                    @"ChildId":childid,
                                                                                                    @"name":childname,
                                                                                                    @"age":childbirthdate,
                                                                                                    @"sex":childsex,
                                                                                                    @"icon":@"",
                                                                                                    @"fatherHeight":fatherHeight,
                                                                                                    
                                                                @"motherHeight":motherHeight,
                                                                                                    
                                                                @"oregnancy":oregnancy
                                                                                                    }];
                    [childArr addObject:childdic];
                }
                NSDictionary *data = [dict objectForKey:@"data"];
                if(![data isKindOfClass:[NSNull class]]){
                    for (NSInteger i=0;i<childArr.count;i++) {    //一条info数据
                        NSDictionary *childdic = childArr[i];
                        NSNumber *childinfoid = [childdic objectForKey:@"ChildId"];
                        NSMutableArray *heightArr = [[NSMutableArray alloc]init];
                        NSMutableArray *weightArr = [[NSMutableArray alloc]init];
                        NSMutableArray *headcArr = [[NSMutableArray alloc]init];
                        NSMutableArray *BMIArr = [[NSMutableArray alloc]init];
                        
                        for (NSDictionary *childdata in [data allValues]) {   //一条data数据
                            NSNumber *childid = [childdata objectForKey:@"childid"];
                            if ([childinfoid isEqual:childid]) {
                                NSString *importtime =[childdata objectForKey:@"importtime"];
                                NSString *time = [self dataStringfromDataString:importtime];
                                NSNumber *height = [childdata objectForKey:@"childheight"];
                                NSNumber *weight = [childdata objectForKey:@"childweight"];
                                NSNumber *headc = [childdata objectForKey:@"childheadc"];
                                NSNumber *value = [childdata objectForKey:@"childbmi"];
                                id heightid = height;
                                id weightid = weight;
                                id headcid = headc;
                                id valueid = value;
                                if (![heightid isKindOfClass:[NSNull class]]) {
                                    if ([height floatValue] >0) {
                                        
                                        
                                        NSDictionary *dicItem = @{ @"height":height,
                                                                   @"time":time
                                                                   };
                                        [heightArr addObject:dicItem];
                                    }
                                }
                                if (![weightid isKindOfClass:[NSNull class]]) {
                                    if ([weight floatValue] >0) {
                                        NSDictionary *dicItem = @{ @"weight":weight,
                                                                   @"time":time
                                                                   };
                                        [weightArr addObject:dicItem];
                                    }
                                    
                                }
                                if (![headcid isKindOfClass:[NSNull class]]) {
                                    if ([headc floatValue] >0) {
                                        NSDictionary *dicItem = @{ @"headc":headc,
                                                                   @"time":time
                                                                   };
                                        [headcArr addObject:dicItem];
                                    }
                                    
                                }
                                if (![valueid isKindOfClass:[NSNull class]]) {
                                    if ([value floatValue] >0) {
                                        NSDictionary *dicItem = @{ @"value":value,
                                                                   @"time":time
                                                                   };
                                        [BMIArr addObject:dicItem];
                                    }
                                    
                                }
                            }
                        }
                        //添加
                        //                            NSMutableDictionary *childDic = [[NSMutableDictionary alloc]initWithDictionary:childArr[i]];
                        [childArr[i] setObject:heightArr forKey:@"heightArr"];
                        [childArr[i] setObject:weightArr forKey:@"weightArr"];
                        [childArr[i] setObject:headcArr forKey:@"headcArr"];
                        [childArr[i] setObject:BMIArr forKey:@"BMIArr"];
                    }
                }
                //  childArr写到ChildInformation.plist
                NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"ChildInformation.plist"];
                //                        NSMutableArray *childsArr = [[NSMutableArray alloc]init];
                //                        for (int i=0;i<self.childs.count;i++) {
                //                            CGChildModel *childmodel = self.childs[i];
                //                            NSDictionary *childDict = childmodel.mj_keyValues;
                //                            [childsArr addObject:childDict];
                //                        }
                //     NSLog(@"%@",childsDict);
                
                //写入
                [childArr writeToFile:fileName atomically:YES];
            }
//            dispatch_sync(dispatch_get_main_queue(), ^{
                //隐藏HUD
                [MBProgressHUD hideHUDForView:self.view];
                [self performSegueWithIdentifier:@"contactVC" sender:nil];
//            });
            
        }else{
            //提醒用户
            //                            NSLog(@"用户名或密码");
            //隐藏HUD

                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:@"用户名或密码错误"];

            
        }
        NSLog(@"请求成功---%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请求超时"];
        NSLog(@"请求失败---%@", error);
    }];

    
//        NSURLSession *session = [NSURLSession sharedSession];
//        NSString *urlstring = [NSString stringWithFormat:@"http://192.168.1.121/childGrow/Mobile/login"];
//        NSURL *url = [NSURL URLWithString:urlstring];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
//        NSString *parmStr = [NSString stringWithFormat:@"userAccount=%@&userPassword=%@",user.text,pwd.text];
//        NSData *data1 = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:data1];
//        [request setHTTPMethod:@"POST"];
//        //    [NSURLConnection connectionWithRequest:request delegate:self];
//        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            //解析数据
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            if ([[dict objectForKey:@"flag"]  isEqual:@1]) {
//                //1、记录token到userdeafult
//                NSString *token = [dict objectForKey:@"token"];
//                //将上述数据全部存储到NSUserDefaults中
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
//                [userDefaults setValue:token forKey:@"token"];
//                //这里建议同步存储到磁盘中，但是不是必须的
//                [userDefaults synchronize];
//                //2、生成ChildInformation   1.info  2.data
//                NSDictionary *info = [dict objectForKey:@"info"];
//                NSMutableArray *childArr = [[NSMutableArray alloc]init];
//                if(!(info==nil)){
//                for (NSDictionary *childinfo in [info allValues]) {
//            NSNumber *childid = [childinfo objectForKey:@"childid"];
//            NSString *childname =[childinfo objectForKey:@"childname"];
//            NSString *birthdate =[childinfo objectForKey:@"childbirthdate"];
//            NSString *childbirthdate = [self dataStringfromDataString:birthdate];
//            NSString *childsex =[childinfo objectForKey:@"childsex"];
//            NSMutableDictionary *childdic= [[NSMutableDictionary alloc]initWithDictionary:@{
//                                                                                                   @"ChildId":childid,
//                                                                                                   @"name":childname,
//                                                                                                   @"age":childbirthdate,
//                                                                                                   @"sex":childsex,
//                                                                                                   @"icon":@""
//                                                                                                   }];
//                    [childArr addObject:childdic];
//                }
//                NSDictionary *data = [dict objectForKey:@"data"];
//                    if(!(data==nil)){
//                        for (NSInteger i=0;i<childArr.count;i++) {    //一条info数据
//                            NSDictionary *childdic = childArr[i];
//                            NSNumber *childinfoid = [childdic objectForKey:@"ChildId"];
//                            NSMutableArray *heightArr = [[NSMutableArray alloc]init];
//                            NSMutableArray *weightArr = [[NSMutableArray alloc]init];
//                            NSMutableArray *headcArr = [[NSMutableArray alloc]init];
//                            NSMutableArray *BMIArr = [[NSMutableArray alloc]init];
//                            
//                        for (NSDictionary *childdata in [data allValues]) {   //一条data数据
//                         NSNumber *childid = [childdata objectForKey:@"childid"];
//                            if ([childinfoid isEqual:childid]) {
//                            NSString *time =[childdata objectForKey:@"importtime"];
//                            NSNumber *height = [childdata objectForKey:@"childheight"];
//                            NSNumber *weight = [childdata objectForKey:@"childweight"];
//                            NSNumber *headc = [childdata objectForKey:@"childheadc"];
//                            NSNumber *value = [childdata objectForKey:@"childbmi"];
//                                id heightid = height;
//                                id weightid = weight;
//                                id headcid = headc;
//                                id valueid = value;
//                                if (![heightid isKindOfClass:[NSNull class]]) {
//                                    if ([height floatValue] >0) {
//                                        
//                                    
//                                    NSDictionary *dicItem = @{ @"height":height,
//                                                               @"time":time
//                                                              };
//                                    [heightArr addObject:dicItem];
//                                        }
//                                }
//                                if (![weightid isKindOfClass:[NSNull class]]) {
//                                    if ([weight floatValue] >0) {
//                                        NSDictionary *dicItem = @{ @"weight":weight,
//                                                                   @"time":time
//                                                                   };
//                                        [weightArr addObject:dicItem];
//                                    }
//                                    
//                                }
//                                if (![headcid isKindOfClass:[NSNull class]]) {
//                                    if ([headc floatValue] >0) {
//                                        NSDictionary *dicItem = @{ @"headc":headc,
//                                                                   @"time":time
//                                                                   };
//                                        [headcArr addObject:dicItem];
//                                    }
//                                   
//                                }
//                                if (![valueid isKindOfClass:[NSNull class]]) {
//                                    if ([value floatValue] >0) {
//                                        NSDictionary *dicItem = @{ @"value":value,
//                                                                   @"time":time
//                                                                   };
//                                        [BMIArr addObject:dicItem];
//                                    }
//                                    
//                                }
//                            }
//                         }
//                           //添加
////                            NSMutableDictionary *childDic = [[NSMutableDictionary alloc]initWithDictionary:childArr[i]];
//                            [childArr[i] setObject:heightArr forKey:@"heightArr"];
//                            [childArr[i] setObject:weightArr forKey:@"weightArr"];
//                            [childArr[i] setObject:headcArr forKey:@"headcArr"];
//                            [childArr[i] setObject:BMIArr forKey:@"BMIArr"];
//                        }
//                    }
//                    //  childArr写到ChildInformation.plist
//                        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//                        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"ChildInformation.plist"];
////                        NSMutableArray *childsArr = [[NSMutableArray alloc]init];
////                        for (int i=0;i<self.childs.count;i++) {
////                            CGChildModel *childmodel = self.childs[i];
////                            NSDictionary *childDict = childmodel.mj_keyValues;
////                            [childsArr addObject:childDict];
////                        }
//                        //     NSLog(@"%@",childsDict);
//                        [childArr writeToFile:fileName atomically:YES];
//                }
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    //隐藏HUD
//                    [MBProgressHUD hideHUDForView:self.view];
//                    [self performSegueWithIdentifier:@"contactVC" sender:nil];
//                });
//                
//            }else{
//                //提醒用户
////                            NSLog(@"用户名或密码");
//                //隐藏HUD
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [MBProgressHUD hideHUDForView:self.view];
//                    [MBProgressHUD showError:@"用户名或密码错误"];
//                });
//                
//                }
//            NSLog(@"*****************%@",dict);
//            
//        }];
//        [dataTask resume];
    
    //延时执行任务GCD
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        if([user.text isEqualToString:@"18868824160"] && [pwd.text isEqualToString:@"123"]) {
//            //隐藏HUD
//            [MBProgressHUD hideHUDForView:self.view];
//            //跳转到下一个界面
//            //手动去执行线(segue)
//            [self performSegueWithIdentifier:@"contactVC" sender:nil];
//            
//        }else{
//            //提醒用户
//            NSLog(@"用户名或密码");
//            //隐藏HUD
//            [MBProgressHUD hideHUDForView:self.view];
//            [MBProgressHUD showError:@"用户名或密码"];
//        }
//    
//    });
    
    
    
//    if ([user.text isEqualToString:@""])
//    {
////        [SVProgressHUD showInfoWithStatus:@"亲,请输入用户名"];
//        return;
//    }
//    else if (user.text.length <11)
//    {
//        //[SVProgressHUD showInfoWithStatus:@"您输入的手机号码格式不正确"];
//        return;
//    }
//    else if ([pwd.text isEqualToString:@""])
//    {
//        //[SVProgressHUD showInfoWithStatus:@"亲,请输入密码"];
//        return;
//    }
//    else if (pwd.text.length <6)
//    {
//        //[SVProgressHUD showInfoWithStatus:@"亲,密码长度至少六位"];
//        return;
//    }
    
}

//注册
-(void)zhuce
{
//    [self performSegueWithIdentifier:@"zhuceVC" sender:nil];
    [self.navigationController pushViewController:[[MMZCHMViewController alloc]init] animated:YES];
}

-(void)registration:(UIButton *)button
{
   [self.navigationController pushViewController:[[MMZCHMViewController alloc]init] animated:YES];
//    [self performSegueWithIdentifier:@"zhuceVC" sender:nil];
}

-(void)fogetPwd:(UIButton *)button
{
   [self.navigationController pushViewController:[[forgetPassWardViewController alloc]init] animated:YES];
}
//将yyyy-MM-dd格式的日期转成yyyy年M月d日
-(NSString *)dataStringfromDataString:(NSString *)datastring{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *data =[formatter dateFromString:datastring];
    NSDateFormatter *Dataformatter =[[NSDateFormatter alloc]init];
    [Dataformatter setDateFormat:@"yyyy年M月d日"];
    NSString *DateString = [Dataformatter stringFromDate:data];
    //    NSLog(@"``````````%@```````DateString:%@",data,DateString);
    return DateString;
}
#pragma mark - 工具
//手机号格式化
-(NSString*)getHiddenStringWithPhoneNumber:(NSString*)number middle:(NSInteger)countHiiden{
    // if (number.length>6) {
    
    if (number.length<countHiiden) {
        return number;
    }
    NSInteger count=countHiiden;
    NSInteger leftCount=number.length/2-count/2;
    NSString *xings=@"";
    for (int i=0; i<count; i++) {
        xings=[NSString stringWithFormat:@"%@%@",xings,@"*"];
    }
    
    NSString *chuLi=[number stringByReplacingCharactersInRange:NSMakeRange(leftCount, count) withString:xings];
    // chuLi=[chuLi stringByReplacingCharactersInRange:NSMakeRange(number.length-count, count-leftCount) withString:xings];
    
    return chuLi;
}

//手机号格式化后还原
-(NSString*)getHiddenStringWithPhoneNumber1:(NSString*)number middle:(NSInteger)countHiiden{
    // if (number.length>6) {
    if (number.length<countHiiden) {
        return number;
    }
    NSString *xings=@"";
    for (int i=0; i<1; i++) {
        //xings=[NSString stringWithFormat:@"%@",[CheckTools getUser]];
    }
    
    NSString *chuLi=[number stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:@""];
    // chuLi=[chuLi stringByReplacingCharactersInRange:NSMakeRange(number.length-count, count-leftCount) withString:xings];
    
    return chuLi;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
