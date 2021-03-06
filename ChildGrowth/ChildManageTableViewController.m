//
//  ChildManageTableViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2017/3/24.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "ChildManageTableViewController.h"
#import "CGChildModel.h"
#import "MJExtension.h"
#import "MyTableViewCell.h"
#import "settingChildViewController.h"
#import "AFHTTPSessionManager.h"
#import "finalRegisterViewController.h"
@interface ChildManageTableViewController ()<finalRegisterViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *childs;
@property (nonatomic, strong) CGChildModel *childmodel;
@property(nonatomic,strong)NSMutableArray *childAges;
@property (nonatomic,copy) NSString *token;
@end

@implementation ChildManageTableViewController
-(NSArray *)childs{
    if(!_childs){
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"ChildInformation.plist"];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:fileName]){
            _childs = [CGChildModel mj_objectArrayWithFile:fileName];
        }else {
            _childs = [CGChildModel mj_objectArrayWithFilename:@"ChildInformation.plist"];
        }
    }
    return _childs;
}
- (NSArray<NSString *> *)childAges {
    NSMutableArray *childAges = [[NSMutableArray alloc] init];
    for (CGChildModel *childmodel in self.childs) {
        NSString *ConcreteAge = [self getConcreteAge:childmodel.age ismouth:NO];
        NSString *childAge = [NSString stringWithFormat:@"%@",ConcreteAge];
        [childAges addObject:childAge];
    }
    //    return @[@"张三", @"李四2 5岁", @"王五3 8岁"];
    return childAges;
}
NSString * const childManageindentifier = @"childManageCell";
NSString * const childAddindentifier = @"childAddCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section ==0) {
        return 1;
    }else{
    return self.childs.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:childAddindentifier];
        if (!cell){
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:childManageindentifier];
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"添加儿童";
        return cell;
    }else{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:childManageindentifier];
    if (!cell){
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:childManageindentifier];
    }
    
    // Configure the cell.
            CGChildModel *chlidItem = self.childs[indexPath.row];
            NSString *icon =chlidItem.icon;
    UIImage *iconimg = [UIImage imageNamed:icon];
//    [self scaleToSize:iconimg size:CGSizeMake(20, 20)];
            NSString *name = chlidItem.name;
            NSString *age = self.childAges[indexPath.row];
//    [cell.imageView setBounds:CGRectMake(0, 0, 30, 30)];
//    [cell.imageView setContentMode:UIViewContentModeScaleToFill];
    cell.imageView.image = iconimg;
            cell.textLabel.text = name;
            cell.detailTextLabel.text = age;
            [cell subviews];
    return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
//图片缩放值制定尺寸
-(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    //创建一个bitmap的context，并设置为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    //绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //从当前context中创建一个改变大小后的图片
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    //使当前的context出堆栈
    UIGraphicsEndImageContext();
    return scaleImage;
}
//删除功能
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        //1.接口删除
        CGChildModel *childItem = self.childs[indexPath.row];
        [self readNSUserDefaults];
        [self postDeletechildId:childItem.ChildId];
        //2.本地数据删除
        [self.childs removeObject:childItem];
        [self writeAllChildInfortoPlist];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        settingChildViewController *newVC= [[settingChildViewController alloc]init];
        newVC.flag = YES;
        [self.navigationController pushViewController:newVC animated:YES];
    }
}
-(void)postDeletechildId:(NSString *)childId{
    // 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.利用AFN管理者发送请求
    NSDictionary *params = @{
                             @"childID" : childId,
                             @"token" : self.token
                             };
    [manager POST:@"http://121.40.89.113/childGrow/Mobile/deleteChildID" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
    }];
    
}
/*
// Override to support c onditional editing of the table view.
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
//输入时间，得到具体年龄:年月日
-(NSString *)getConcreteAge:(NSString *)birth ismouth:(BOOL)ismouth{
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    
    NSDate *nowDate = [NSDate date];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    
    //用来得到详细的时差
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0];
    NSString *ConcreteAge = [[NSString alloc] init];
    if(ismouth){
        ConcreteAge = [NSString stringWithFormat:(@"%ld"),(long)[date year]*12+(long)[date month]];
    }else{
        if([date year] >0)
        {
            ConcreteAge = [NSString stringWithFormat:(@"%ld岁%ld月"),(long)[date year],(long)[date month]];
        }
        else if([date month] >0)
        {
            ConcreteAge = [NSString stringWithFormat:(@"%ld月%ld天"),(long)[date month],(long)[date day]];
        }
        else if([date day]>0){
            ConcreteAge = [NSString stringWithFormat:(@"%ld天"),(long)[date day]];
        }
        else {
            ConcreteAge = @"0天";
        }
    }
    return ConcreteAge;
}
-(void)writeAllChildInfortoPlist{
    //    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ChildInformation" ofType:@"plist"];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"ChildInformation.plist"];
    
    NSMutableArray *childsArr = [[NSMutableArray alloc]init];
    for (int i=0;i<self.childs.count;i++) {
        CGChildModel *childmodel = self.childs[i];
        NSDictionary *childDict = childmodel.mj_keyValues;
        [childsArr addObject:childDict];
    }
    //     NSLog(@"%@",childsDict);
    [childsArr writeToFile:fileName atomically:YES];
    
}
#pragma mark - addChildViewControllerDelegate
-(void)addChildinfo:(finalRegisterViewController *)addchildinfo childItem:(CGChildModel *)childitem{
    [self.childs addObject:childitem];
    [self writeAllChildInfortoPlist];
    [self.tableView reloadData];
}
//保存数据到NSUserDefaults
-(void)saveNSUserDefaults
{
    
    
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    //读取NSDate日期类型的数据
    NSNumber *childindex = [userDefaults valueForKey:@"childindex"];
    
    NSNumber *index = [[NSNumber alloc]initWithInt:[childindex intValue]-1];
    [userDefaults setValue:index forKey:@"childindex"];
    
    //这里建议同步存储到磁盘中，但是不是必须的
    [userDefaults synchronize];
    
}
//从NSUserDefaults中读取数据
-(void)readNSUserDefaults
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    //读取数据到各个label中
    //读取整型int类型的数据
    
    //读取NSDate日期类型的数据
    NSString *token = [userDefaultes valueForKey:@"token"];
    self.token = token;
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
