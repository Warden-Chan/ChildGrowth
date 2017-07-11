//
//  settingChildViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2017/2/20.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "settingChildViewController.h"
#import "RadioButton.h"
#import "STPickerDate.h"
#import "MBProgressHUD+XMG.h"
#import "finalRegisterViewController.h"
#import "LZCityPickerView.h"
#import "LZCityPickerController.h"

@interface settingChildViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,STPickerDateDelegate>
{
    UIView *bgView;
    UITextField *name;   //姓名
    UITextField *age;  //出生日期
    UITextField *childCity;  //出生城市
    UITextField *childid;  //身份证
    
}

@property (nonatomic,strong) UIButton *head; //头像
@property (nonatomic,strong)NSMutableArray* buttons;
//@property (nonatomic,strong)NSMutableArray* buttons2;
@end

@implementation settingChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.flag) {
       self.title=@"添加1/2";
    }else{
        self.title=@"注册4/5";
    }
    
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
    [addBtn setImage:[UIImage imageNamed:@"goback_back_orange_on"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
    [self createUI];
    [self createTextFields];
}

-(void)createTextFields
{
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 180,frame.size.width, 190)];
    //bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    name=[self createTextFielfFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入儿童姓名"];
    name.textAlignment=UITextAlignmentCenter;
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:name];
    
    
    NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:2];
    CGRect btnRect = CGRectMake((bgView.frame.size.width-150)*0.5, name.frame.size.height+name.frame.origin.y+10, 70, 30);
    for (NSString* optionTitle in @[@"男孩", @"女孩"]) {
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
//        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        btnRect.origin.x += 80;
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [bgView addSubview:btn];
        [buttons addObject:btn];
    }
    [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
    [buttons[0] setSelected:YES]; // Making the first button initially selected
    self.buttons = buttons;
    
//    NSMutableArray* buttons2 = [NSMutableArray arrayWithCapacity:2];
//    CGRect btnRect2 = CGRectMake((bgView.frame.size.width-150)*0.5, btnRect.size.height+btnRect.origin.y+10, 80, 30);
//    for (NSString* optionTitle in @[@"早产", @"足月产"]) {
//        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect2];
//        //        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
//        btnRect2.origin.x += 80;
//        [btn setTitle:optionTitle forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
//        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
//        [bgView addSubview:btn];
//        [buttons2 addObject:btn];
//    }
//    [buttons2[0] setGroupButtons:buttons2]; // Setting buttons into the group
//    [buttons2[0] setSelected:YES]; // Making the first button initially selected
//    self.buttons2 = buttons2;

    
    age=[self createTextFielfFrame:CGRectMake(10, btnRect.size.height+btnRect.origin.y+10, self.view.frame.size.width-20, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请选择儿童生日"];
    age.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:age];
    age.delegate = self;
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"yyyy年MM月dd日";
//    NSString *dataString = [formatter stringFromDate:date];
//    age.text = dataString;
    childCity =[self createTextFielfFrame:CGRectMake(10, age.bounds.size.height+age.frame.origin.y+10, self.view.frame.size.width-20, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请选择城市"];
    childCity.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:childCity];
    childCity.delegate = self;

    childid=[self createTextFielfFrame:CGRectMake(10, childCity.bounds.size.height+childCity.frame.origin.y+10, self.view.frame.size.width-20, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入儿童身份证号"];
    childid.clearButtonMode = UITextFieldViewModeWhileEditing;
    childid.textAlignment=NSTextAlignmentCenter;
    childid.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:childid];
    childid.delegate = self;
    
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.size.height+bgView.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"下一步" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(nextClick)];
    landBtn.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    landBtn.layer.cornerRadius=5.0f;
    
    [self.view addSubview:landBtn];
    
    

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [name resignFirstResponder];
//    [age resignFirstResponder];
    [childid resignFirstResponder];
    
}
//-(void)postImage:(UIImage *)image{
//    NSData *imageData = UIImagePNGRepresentation(image);
//    NSString *urlstring = [NSString stringWithFormat:@"http://192.168.1.121/childGrow/Mobile/"];
//    NSURL *url = [NSURL URLWithString:urlstring];
//    
//}
-(void)nextClick{
    finalRegisterViewController *VC = [[finalRegisterViewController alloc]init];
    VC.flag = self.flag;
    VC.userAccount = self.userAccount;
    VC.userPassword = self.userPassword;
    VC.userIcon = self.userIcon;
    VC.userName = self.userName;
    
    NSString *childSex = nil;
    if ([self.buttons[0] isSelected]) {
        childSex = @"男";
    }else{
        childSex = @"女";
    }
    VC.childIcon = self.head.imageView.image;
    VC.childName = name.text;
    VC.childSex = childSex;
    VC.childBirth = age.text;
    VC.childID = childid.text;
    //儿童城市
    VC.childCity = childCity.text;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)landClick
{
//    NSData *userIcon = UIImagePNGRepresentation(self.userIcon);
//    NSData *childIcon = UIImagePNGRepresentation(self.head.imageView.image);
    NSString *childSex = nil;
    if ([self.buttons[0] isSelected]) {
        childSex = @"男";
    }else{
    childSex = @"女";
    }
    NSString *childBirthdate = [self dataStringfromDataString:age.text];
    //提醒用户正在注册
    [MBProgressHUD showMessage:@"正在注册..." toView:self.view];
    //post测试
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlstring = [NSString stringWithFormat:@"http://121.40.89.113/childGrow/Mobile/register"];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSString *parmStr = [NSString stringWithFormat:@"userAccount=%@&userPassword=%@&userName=%@&childID=%@&childName=%@&childBirthdate=%@&childSex=%@",self.userAccount,self.userPassword,self.userName,childid.text,name.text,childBirthdate,childSex];
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
        //跳转到下一个界面
    //手动去执行线(segue)
//    [self performSegueWithIdentifier:@"contactVC" sender:nil];
    
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

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI
{
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 170)];
    [bg setImage:[UIImage imageNamed:@"mycenter_bg.png"]];
    bg.backgroundColor=[UIColor grayColor];
    [self.view addSubview:bg];
    
    _head=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, 70, 80, 80)];
    [_head setImage:[UIImage imageNamed:@"head"] forState:UIControlStateNormal];
    _head.layer.cornerRadius=40;
    _head.layer.masksToBounds = YES;
    _head.backgroundColor=[UIColor whiteColor];
    [_head addTarget:self action:@selector(changeHeadView1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_head];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, 120, 80, 80)];
    label.text=@"点击设置头像";
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
}



-(void)changeHeadView1:(UIButton *)tap
{
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"更改图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册上传", nil];
    menu.delegate=self;
    menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
    
}

//*************************代理方法*******************************
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"index:%zd",buttonIndex);
    //0->拍照，1->相册
    
    if (buttonIndex == 0) {
        [self snapImage];
    } else if (buttonIndex == 1) {
        [self localPhoto];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //完成选择
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //NSLog(@"type:%@",type);
    if ([type isEqualToString:@"public.image"]) {
        //转换成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            //设置头像
            [_head setImage:image forState:UIControlStateNormal];
            //上传头像
            //[self updatePhotoFor:image];
        }];
        
    }
}


#pragma mark --头像上传
-(void)updatePhoto:(NSString *)base64Str
{
    //    NSString *url =[NSString stringWithFormat:@"%@%@",Host_DSXVipManager,@"/service/member"];
    //
    //    NSDictionary *dict = @{@"action":@"avatar",@"owner":@"guide",@"username":[UserModel getUserDefaultLoginName],@"password":[UserModel getUserDefaultPassword],@"filename":@"head.jpg",@"data":base64Str,@"operId":[UserModel getUserDefaultId],@"operType":@"guide"};
    //    [[NetRequestManager sharedInstance] sendRequest:[NSURL URLWithString:url] parameterDic:dict requestTag:0 delegate:self userInfo:nil];
}

//*****************************拍照**********************************
- (void) snapImage
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        __block UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        ipc.navigationBar.barTintColor =[UIColor whiteColor];
        ipc.navigationBar.tintColor = [UIColor whiteColor];
        ipc.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor]};
        [self presentViewController:ipc animated:YES completion:^{
            ipc = nil;
        }];
    } else {
        NSLog(@"模拟器无法打开照相机");
    }
}

#define CommonThimeColor HEXCOLOR(0x11a0ee)
-(void)localPhoto
{
    __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    picker.navigationBar.barTintColor =[UIColor whiteColor];
    picker.navigationBar.tintColor = [UIColor blackColor];
    picker.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor blackColor]};
    [self presentViewController:picker animated:YES completion:^{
        picker = nil;
    }];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - --- delegate 视图委托 ---

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [name resignFirstResponder];
//    [childid resignFirstResponder];
    
    if (textField == age) {
        [age resignFirstResponder];
        
        STPickerDate *pickerDate = [[STPickerDate alloc]init];
        [pickerDate setDelegate:self];
        [pickerDate show];
    }else if (textField ==childCity){
        [childCity resignFirstResponder];
        [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
            
            // 选择结果回调
            childCity.text = address;
//            NSLog(@"%@--%@--%@--%@",address,province,city,area);
            
        }];
    }
    
}
- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *text = [NSString stringWithFormat:@"%zd年%zd月%zd日", year, month, day];
    age.text = text;
    //    self.btn.hidden = NO;
}
@end
