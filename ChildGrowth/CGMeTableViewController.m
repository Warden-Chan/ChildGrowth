//
//  CGMeTableViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/7.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "CGMeTableViewController.h"
#import "View2TableViewCell.h"
#import "MeDetailTableViewController.h"
#import "settingChildViewController.h"
#import "ChildManageTableViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "feedBackViewController.h"
@interface CGMeTableViewController ()<UITableViewDelegate,View2TableViewCellDelegate>
/** 标签数据 */
@property (nonatomic, strong) NSArray *Groups;
@end

@implementation CGMeTableViewController

-(NSArray *)Groups{
    if(!_Groups){
    _Groups = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CGMe" ofType:@"plist"]];
    }
    return _Groups;
}
NSString *ID = @"view2cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条颜色
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    [self.tableView registerClass:[View2TableViewCell class] forCellReuseIdentifier:ID];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //post测试
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSString *urlstring = [NSString stringWithFormat:@"http://192.168.1.121/childGrow/Mobile/login"];
//    NSURL *url = [NSURL URLWithString:urlstring];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
//    NSString *parmStr = [NSString stringWithFormat:@"mobileID=188688&password=123456"];
//    NSData *data1 = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data1];
//    [request setHTTPMethod:@"POST"];
//    //    [NSURLConnection connectionWithRequest:request delegate:self];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        //解析数据
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        NSLog(@"*****************%@",dict);
//        
//    }];
//    [dataTask resume];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"%s",__func__);
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"%s",__func__);
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.Groups.count+2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 2;
            break;
        default:
            return 0;
            break;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
// 取出indexPath.row对应的模型
  
    if(indexPath.section>1){
       
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        // 设置cell右边的指示样式
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 设置数据
    cell.textLabel.text = [self.Groups[indexPath.section-2][indexPath.row] objectForKey:@"text"];
    NSString *icon = [self.Groups[indexPath.section-2][indexPath.row] objectForKey:@"icon"];
    cell.imageView.image = [UIImage imageNamed:icon];
         return cell;
    }else if(indexPath.section ==1){
        // 访问缓存池
    View2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.delegate = self;
    return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        // 设置cell右边的指示样式
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *imagename1 = @"dropdown_anim__00053";
        cell.imageView.image = [UIImage imageNamed:imagename1];
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = @"省份-地区";
        return cell;
    }
   
}
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
////    if([segue.destinationViewController isKindOfClass:[MeDetailTableViewController class]]){
////        MeDetailTableViewController *VC = (MeDetailTableViewController *)segue.destinationViewController;
////    }
//}
//点击或选中后执行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MeDetailTableViewController *meVC = [[MeDetailTableViewController alloc] initWithNibName:@"MeDetailTableViewController" bundle:[NSBundle mainBundle]];
//    [self performSegueWithIdentifier:@"MeDetailTableViewController" sender:self];
//    MeDetailTableViewController *meVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountManagerController"];
//    UIStoryboard *meStoryBoard =[UIStoryboard storyboardWithName:@"CGMe" bundle:nil];
    switch (indexPath.section) {
        case 0:
        {
            //跳转到下一个界面
            //手动去执行线(segue)
            [self performSegueWithIdentifier:@"detailVC" sender:nil];
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                    //我的积分
                    break;
                case 1:
                    //好大夫在线
                    [self showWebSite];
                    break;
                case 2:
                    //收藏
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
            
            break;
        case 4:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //问题帮助与反馈
                    feedBackViewController *VC= [[feedBackViewController alloc]init];
                    [self.navigationController pushViewController:VC animated:YES];
                    break;
                }
                case 1:
                    //推荐朋友安装
                    [self sharesheet];
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
    

}
-(void)showWebSite{
    NSURL *url = [NSURL URLWithString:@"http://www.haodf.com"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}
-(void)sharesheet{
    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    NSArray* imageArray = @[@"http://mob.com/Assets/images/logo.png?v=20150320"];
//    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}
//返回每一组尾部控件
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if(section==4){
//        return [UIButton buttonWithType:UIButtonTypeContactAdd];
//    }else{
//        return NULL;
//    }
//}
//返回每一样的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 | indexPath.section == 1){
        return 80;
    }else{
        return 44;
    }
}
#pragma mark - View2TableViewCellDelegate
-(void)choseButton:(UIButton *)button{
    if(button.tag == 21){
//        settingChildViewController *addVC = [[settingChildViewController alloc]init];
//        addVC.title = @"添加儿童";
        ChildManageTableViewController *manageVC = [[ChildManageTableViewController alloc]init];
         [self.navigationController pushViewController:manageVC animated:YES];
    }else if (button.tag ==22){
    [self performSegueWithIdentifier:@"qiandaoVC" sender:nil];
//    [self.navigationController pushViewController:[[SignINController alloc]init] animated:YES];
    }else{
        //NSUserDefaults中
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
        [userDefaults removeObjectForKey:@"token"];
        //这里建议同步存储到磁盘中，但是不是必须的
        [userDefaults synchronize];
        UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            id view = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
            window.rootViewController = view;
//        [self.tabBarController setSelectedIndex:0];
        CATransition *myTransition = [CATransition animation];
        myTransition.duration = 0.35; //持续时长0.35秒
        myTransition.timingFunction = UIViewAnimationCurveEaseInOut;//计时函数，从头到尾的流畅度
        myTransition.type = kCATransitionFade;
        [window.layer addAnimation:myTransition forKey:nil];
    NSLog(@"代理实现tag:%ld",button.tag);
    
}
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
