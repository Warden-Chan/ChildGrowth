 //
//  AppDelegate.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/10/21.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import <SMS_SDK/SMSSDK.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import "CGChildModel.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //登录状态判定
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取NSDate日期类型的数据
    NSString *token = [userDefaultes valueForKey:@"token"];
    NSString *userAccount = [userDefaultes valueForKey:@"userAccount"];
    NSString *userPassword = [userDefaultes valueForKey:@"userPassword"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if (token ==nil) {
        id view = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
        self.window.rootViewController = view;
    }else{
        [self login:userAccount userPassword:userPassword];
    }
    
    [SMSSDK registerApp:@"1d389e4dff110" withSecret:@"e6ea828c569ffe110011dc8f7facc1be"];
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"1d5341447ac8c"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;

             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx93178b83797d351a"
                                       appSecret:@"37531a863741a29890076699f01b8c08"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    return YES;
}
-(void)login:(NSString *)userAccount userPassword:(NSString *)userPassword{
    // 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.利用AFN管理者发送请求
    NSDictionary *params = @{
                             @"userAccount" : userAccount,
                             @"userPassword" : userPassword
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
            //这里建议同步存储到磁盘中，但是不是必须的
            [userDefaults synchronize];
            NSLog(@"登录成功---");
            
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
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        id view = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
        self.window.rootViewController = view;
        NSLog(@"登录失败---%@", error);
    }];
}
     
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
