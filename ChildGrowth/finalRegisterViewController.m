//
//  finalRegisterViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2017/5/11.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "finalRegisterViewController.h"
#import "MBProgressHUD+XMG.h"
#import "CGChildModel.h"
@interface finalRegisterViewController ()
{
    UIView *bgView1;
    UIView *bgView2;
    UIView *bgView3;
    UITextField *birthHeight;
    UITextField *birthWeight;
    UITextField *birthHeadc;
    UITextField *fatherHeight;
    UITextField *motherHeight;
    UITextField *childbearingAge;  //怀孕年龄
    UITextField *oregnancy;      //孕期
    UIButton *registerButton;
}
@property (nonatomic,copy) NSString *token;
@end

@implementation finalRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.flag) {
        self.title=@"添加2/2";
    }else{
        self.title=@"注册5/5";
    }
    
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
    [addBtn setImage:[UIImage imageNamed:@"goback_back_orange_on"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
    [self create1PartTextFields];
    [self create2PartTextFields];
    [self create3PartTextFields];
}
-(void)create1PartTextFields
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 75, self.view.frame.size.width-90, 30)];
    label.text=@"填写儿童出生信息";
    label.textColor=[UIColor grayColor];
    label.textAlignment=UITextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:13];
    
    [self.view addSubview:label];
    
    
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView1=[[UIView alloc]initWithFrame:CGRectMake(10, 100, frame.size.width-20, 120)];
    bgView1.layer.cornerRadius=3.0;
    bgView1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView1];
    
    birthHeight=[self createTextFielfFrame:CGRectMake(130, 6, 90, 30) font:[UIFont systemFontOfSize:14] placeholder:@"选填"];
    birthHeight.clearButtonMode = UITextFieldViewModeWhileEditing;
    birthHeight.keyboardType=UIKeyboardTypeDecimalPad;
    
    
    
    birthWeight=[self createTextFielfFrame:CGRectMake(130, 46, 90, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"选填"];
    birthWeight.clearButtonMode = UITextFieldViewModeWhileEditing;
    //code.text=@"mojun1992225";
    //密文样式
//    code.secureTextEntry=YES;
    birthWeight.keyboardType=UIKeyboardTypeDecimalPad;
    
    birthHeadc=[self createTextFielfFrame:CGRectMake(130, 86, 90, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"选填"];
    birthHeadc.clearButtonMode = UITextFieldViewModeWhileEditing;
    birthHeadc.keyboardType=UIKeyboardTypeDecimalPad;
    
    UILabel *birthHeightlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 8, 90, 25)];
    birthHeightlabel.text=@"出身身高(cm)";
    birthHeightlabel.textColor=[UIColor blackColor];
    birthHeightlabel.textAlignment=UITextAlignmentLeft;
    birthHeightlabel.font=[UIFont systemFontOfSize:14];
    
    UILabel *birthWeightlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 48, 90, 25)];
    birthWeightlabel.text=@"出身体重(kg)";
    birthWeightlabel.textColor=[UIColor blackColor];
    birthWeightlabel.textAlignment=UITextAlignmentLeft;
    birthWeightlabel.font=[UIFont systemFontOfSize:14];
    
    UILabel *birthHeadclabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 88, 90, 25)];
    birthHeadclabel.text=@"出身头围(cm)";
    birthHeadclabel.textColor=[UIColor blackColor];
    birthHeadclabel.textAlignment=UITextAlignmentLeft;
    birthHeadclabel.font=[UIFont systemFontOfSize:14];
    
    
    UIImageView *line11=[self createImageViewFrame:CGRectMake(20, 40, bgView1.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    UIImageView *line12=[self createImageViewFrame:CGRectMake(20, 80, bgView1.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
//    UIButton *registerButton=[self createButtonFrame:CGRectMake(10, bgView1.frame.size.height+bgView1.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"注册" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(RegisterClick)];
//    registerButton.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
//    registerButton.layer.cornerRadius=5.0f;
    
    
    [bgView1 addSubview:birthHeight];
    [bgView1 addSubview:birthWeight];
    [bgView1 addSubview:birthHeadc];
    
    [bgView1 addSubview:birthHeightlabel];
    [bgView1 addSubview:birthWeightlabel];
    [bgView1 addSubview:birthHeadclabel];
    [bgView1 addSubview:line11];
    [bgView1 addSubview:line12];
//    [self.view addSubview:registerButton];
    
}
-(void)create2PartTextFields{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 225, self.view.frame.size.width-90, 30)];
    label.text=@"填写父母信息";
    label.textColor=[UIColor grayColor];
    label.textAlignment=UITextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:13];
    
    [self.view addSubview:label];
    
    
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView2=[[UIView alloc]initWithFrame:CGRectMake(10, 250, frame.size.width-20, 80)];
    bgView2.layer.cornerRadius=3.0;
    bgView2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView2];
    
    fatherHeight=[self createTextFielfFrame:CGRectMake(130, 6, 90, 30) font:[UIFont systemFontOfSize:14] placeholder:@"选填"];
    fatherHeight.clearButtonMode = UITextFieldViewModeWhileEditing;
    fatherHeight.keyboardType=UIKeyboardTypeDecimalPad;
    
    
    
    motherHeight=[self createTextFielfFrame:CGRectMake(130, 46, 90, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"选填"];
    motherHeight.clearButtonMode = UITextFieldViewModeWhileEditing;
    //code.text=@"mojun1992225";
    //密文样式
    //    code.secureTextEntry=YES;
    motherHeight.keyboardType=UIKeyboardTypeDecimalPad;
    
    
    
    UILabel *fatherHeightlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 8, 90, 25)];
    fatherHeightlabel.text=@"父亲身高(cm)";
    fatherHeightlabel.textColor=[UIColor blackColor];
    fatherHeightlabel.textAlignment=UITextAlignmentLeft;
    fatherHeightlabel.font=[UIFont systemFontOfSize:14];
    
    UILabel *motherHeightlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 48, 90, 25)];
    motherHeightlabel.text=@"母亲身高(cm)";
    motherHeightlabel.textColor=[UIColor blackColor];
    motherHeightlabel.textAlignment=UITextAlignmentLeft;
    motherHeightlabel.font=[UIFont systemFontOfSize:14];
    
    
    
    UIImageView *line21=[self createImageViewFrame:CGRectMake(20, 40, bgView1.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
//    UIButton *registerButton=[self createButtonFrame:CGRectMake(10, bgView2.frame.size.height+bgView2.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"注册" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(RegisterClick)];
//    registerButton.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
//    registerButton.layer.cornerRadius=5.0f;
    
    
    [bgView2 addSubview:fatherHeight];
    [bgView2 addSubview:motherHeight];

    
    [bgView2 addSubview:fatherHeightlabel];
    [bgView2 addSubview:motherHeightlabel];

    [bgView2 addSubview:line21];
//    [self.view addSubview:registerButton];
}
-(void)create3PartTextFields{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 330 , self.view.frame.size.width-90, 30)];
    label.text=@"孕期信息";
    label.textColor=[UIColor grayColor];
    label.textAlignment=UITextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:13];
    
    [self.view addSubview:label];
    
    
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView3=[[UIView alloc]initWithFrame:CGRectMake(10, 355, frame.size.width-20, 80)];
    bgView3.layer.cornerRadius=3.0;
    bgView3.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView3];
    
    childbearingAge=[self createTextFielfFrame:CGRectMake(130, 6, 90, 30) font:[UIFont systemFontOfSize:14] placeholder:@"选填"];
    childbearingAge.clearButtonMode = UITextFieldViewModeWhileEditing;
    childbearingAge.keyboardType=UIKeyboardTypeDecimalPad;
    
    
    
    oregnancy=[self createTextFielfFrame:CGRectMake(130, 46, 90, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"选填"];
    oregnancy.clearButtonMode = UITextFieldViewModeWhileEditing;
    oregnancy.keyboardType=UIKeyboardTypeDecimalPad;
    
    
    
    UILabel *childbearingAgelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 8, 90, 25)];
    childbearingAgelabel.text=@"育龄(年)";
    childbearingAgelabel.textColor=[UIColor blackColor];
    childbearingAgelabel.textAlignment=UITextAlignmentLeft;
    childbearingAgelabel.font=[UIFont systemFontOfSize:14];
    
    UILabel *oregnancylabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 48, 90, 25)];
    oregnancylabel.text=@"孕期(周)";
    oregnancylabel.textColor=[UIColor blackColor];
    oregnancylabel.textAlignment=UITextAlignmentLeft;
    oregnancylabel.font=[UIFont systemFontOfSize:14];
    
    
    
    UIImageView *line=[self createImageViewFrame:CGRectMake(20, 40, bgView1.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    UIButton *registerButton=[self createButtonFrame:CGRectMake(10, bgView3.frame.size.height+bgView3.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"注册" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(RegisterClick)];
    registerButton.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    registerButton.layer.cornerRadius=5.0f;
    
    
    [bgView3 addSubview:childbearingAge];
    [bgView3 addSubview:oregnancy];
    
    
    [bgView3 addSubview:childbearingAgelabel];
    [bgView3 addSubview:oregnancylabel];
    
    [bgView3 addSubview:line];
    [self.view addSubview:registerButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)RegisterClick{
    NSString *childBirthdate = [self dataStringfromDataString:self.childBirth];
    if (self.flag) {  //添加步骤
        [self readNSUserDefaults];
        //提醒用户正在添加
        [MBProgressHUD showMessage:@"正在添加..." toView:self.view];
        //post测试
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *urlstring = [NSString stringWithFormat:@"http://121.40.89.113/childGrow/Mobile/addChildID"];
        NSURL *url = [NSURL URLWithString:urlstring];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        NSString *parmStr = [NSString stringWithFormat:@"userAccount=%@&childID=%@&childName=%@&childBirthdate=%@&childSex=%@&token=%@&birthCity=%@&fullMonth=%@&fatherHeight=%@&motherHeight=%@&birthHeight=%@&birthWeight=%@&birthHeadc=%@",self.userAccount,self.childID,self.childName,childBirthdate,self.childSex,self.token,self.childCity,oregnancy.text,fatherHeight.text,motherHeight.text,birthHeight.text,birthWeight.text,birthHeadc.text];
        NSData *data1 = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data1];
        [request setHTTPMethod:@"POST"];
        //    [NSURLConnection connectionWithRequest:request delegate:self];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            float flag= [[dict objectForKey:@"flag"] floatValue];
            if (flag ==1) {
                //隐藏HUD
                [MBProgressHUD hideHUDForView:self.view];
                //提醒用户成功
                [MBProgressHUD showMessage:@"添加成功" toView:self.view];
                
                //本地数据更新！@！！！！
                CGChildModel *childmodel = [[CGChildModel alloc]init];
                childmodel.ChildId = self.childID;
                childmodel.name = self.childName;
                childmodel.age = self.childBirth;
                childmodel.sex = self.childSex;
                childmodel.fatherHeight = fatherHeight.text;
                childmodel.motherHeight = motherHeight.text;
                childmodel.oregnancy = oregnancy.text;
                [self.delegate addChildinfo:self childItem:childmodel];
                [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -2)] animated:YES];
                //                [self.navigationController popViewControllerAnimated:YES];
                //            //隐藏HUD
                //            [MBProgressHUD hideHUDForView:self.view];
                
                
            }else if (flag ==2){
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showMessage:@"该身份证儿童已存在" toView:self.view];
                //隐藏HUD
                
                //                [self.navigationController popToRootViewControllerAnimated:YES];
                //            //隐藏HUD
                [MBProgressHUD hideHUDForView:self.view];
                
                
            }else{
                // //隐藏HUD
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showMessage:@"添加失败" toView:self.view];
                //隐藏HUD
                [MBProgressHUD hideHUDForView:self.view];
                
            }
            
            
            NSLog(@"*****************%@",dict);
            
        }];
        [dataTask resume];
    }else{  //注册步骤
//    NSString *childBirthdate = [self dataStringfromDataString:self.childBirth];
    //提醒用户正在注册
    [MBProgressHUD showMessage:@"正在注册..." toView:self.view];
    //post测试
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlstring = [NSString stringWithFormat:@"http://121.40.89.113/childGrow/Mobile/register"];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSString *parmStr = [NSString stringWithFormat:@"userAccount=%@&userPassword=%@&userName=%@&childID=%@&childName=%@&childBirthdate=%@&childSex=%@&birthCity=%@&fullMonth=%@&fatherHeight=%@&motherHeight=%@&birthHeight=%@&birthWeight=%@&birthHeadc=%@",self.userAccount,self.userPassword,self.userName,self.childID,self.childName,childBirthdate,self.childSex,self.childCity,oregnancy.text,fatherHeight.text,motherHeight.text,birthHeight.text,birthWeight.text,birthHeadc.text];
    NSData *data1 = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data1];
    [request setHTTPMethod:@"POST"];
    //    [NSURLConnection connectionWithRequest:request delegate:self];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        float flag= [[dict objectForKey:@"flag"] floatValue];
        if (flag ==1) {
            //提醒用户注册成功
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessage:@"注册成功" toView:self.view];
                //隐藏HUD
                [MBProgressHUD hideHUDForView:self.view];
                [self.navigationController popToRootViewControllerAnimated:YES];
                //            //隐藏HUD
                //            [MBProgressHUD hideHUDForView:self.view];
                
            });
        }else if (flag ==2){
            //提醒用户注册成功
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessage:@"账号或该身份证儿童已存在" toView:self.view];
                //隐藏HUD
                [MBProgressHUD hideHUDForView:self.view];
                [self.navigationController popToRootViewControllerAnimated:YES];
                //            //隐藏HUD
                //            [MBProgressHUD hideHUDForView:self.view];
                
            });
        }else{
            //提醒用户注册成功
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessage:@"注册失败" toView:self.view];
                //隐藏HUD
                [MBProgressHUD hideHUDForView:self.view];
                [self.navigationController popToRootViewControllerAnimated:YES];
                //            //隐藏HUD
                //            [MBProgressHUD hideHUDForView:self.view];
                
            });
        }
        
        
        NSLog(@"*****************%@",dict);
        
    }];
    [dataTask resume];
    }
}

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [birthHeight resignFirstResponder];
    [birthWeight resignFirstResponder];
    [birthHeadc resignFirstResponder];
    [fatherHeight resignFirstResponder];
    [motherHeight resignFirstResponder];
    [childbearingAge resignFirstResponder];
    [oregnancy resignFirstResponder];
    
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
//将yyyy年M月d日格式的日期转成yyyy-MM-dd
-(NSString *)dataStringfromDataString:(NSString *)datastring{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年M月d日"];
    NSDate *data =[formatter dateFromString:datastring];
    NSDateFormatter *Dataformatter =[[NSDateFormatter alloc]init];
    [Dataformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *DateString = [Dataformatter stringFromDate:data];
    //    NSLog(@"``````````%@```````DateString:%@",data,DateString);
    return DateString;
}
//从NSUserDefaults中读取数据
-(void)readNSUserDefaults
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    //读取数据到各个label中
    //读取整型int类型的数据
    
    //读取NSDate日期类型的数据
    NSString *token = [userDefaultes valueForKey:@"token"];
    NSString *userAccount = [userDefaultes valueForKey:@"userAccount"];
    self.token = token;
    self.userAccount = userAccount;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
