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
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlstring = [NSString stringWithFormat:@"http://192.168.1.121/thinkphp/index.php/mobile/login"];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSString *parmStr = [NSString stringWithFormat:@"mobileID=188688&password=123456"];
    NSData *data1 = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data1];
    [request setHTTPMethod:@"POST"];
    //    [NSURLConnection connectionWithRequest:request delegate:self];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"*****************%@",dict);
        
    }];
    [dataTask resume];
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
    if(indexPath.section ==0 ){
//    MeDetailTableViewController *meVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountManagerController"];
//    [self.navigationController pushViewController:[[MeDetailTableViewController alloc]init] animated:YES];
        //跳转到下一个界面
        //手动去执行线(segue)
        [self performSegueWithIdentifier:@"detailVC" sender:nil];
    }
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
    }
    NSLog(@"代理实现tag:%ld",button.tag);
    
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
