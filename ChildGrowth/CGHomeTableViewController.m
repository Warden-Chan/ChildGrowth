//
//  CGHomeTableViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/16.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "CGHomeTableViewController.h"
#import "SYNavigationDropdownMenu.h"
#import "MJExtension.h"
#import "FirstCell.h"
#import "Second.h"
#import "SecondCell.h"
#import "ThirdCell.h"
#import "Third.h"
#import "CGChildModel.h"
#import "Fourth.h"
#import "FourthCell.h"

@interface CGHomeTableViewController ()<SYNavigationDropdownMenuDataSource, SYNavigationDropdownMenuDelegate>
/** 所有的数据 */
@property (nonatomic, strong) NSArray *second;

@property (nonatomic, strong) NSMutableArray *childs;
@property (nonatomic, strong) CGChildModel *childmodel;
/** 当前儿童index */
@property (nonatomic,copy) NSNumber *childindex;
@property (nonatomic, strong) SYNavigationDropdownMenu *menu;
@end

@implementation CGHomeTableViewController

-(NSArray *)second{
    if(!_second){
        _second = [Second mj_objectArrayWithFilename:@"second.plist"];
    }
    return _second;
}
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

NSString *ID1 = @"first";
NSString *ID2 = @"second";
NSString *ID3 = @"third";
NSString *ID4 = @"fourth";
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条颜色
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    [self setup];
    // 根据ID 注册 对应的cell类型 
    [self.tableView registerClass:[FirstCell class] forCellReuseIdentifier:ID1];
    [self.tableView registerClass:[SecondCell class] forCellReuseIdentifier:ID2];
    [self.tableView registerClass:[ThirdCell class] forCellReuseIdentifier:ID3];
    [self.tableView registerClass:[FourthCell class] forCellReuseIdentifier:ID4];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
}

-(void)viewWillAppear:(BOOL)animated{
    _childs = [CGChildModel mj_objectArrayWithFilename:@"ChildInformation.plist"];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"ChildInformation.plist"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName]){
        _childs = [CGChildModel mj_objectArrayWithFile:fileName];
    }else {
        _childs = [CGChildModel mj_objectArrayWithFilename:@"ChildInformation.plist"];
    }
    [self readNSUserDefaults];
    NSString *tittle = [self titleArray][[self.childindex integerValue]];
   [self.menu setTitle:tittle forState:UIControlStateNormal];
//    [self navigationDropdownMenu:self.menu didSelectTitleAtIndex:[self.childindex intValue]];

    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setup {
    SYNavigationDropdownMenu *menu = [[SYNavigationDropdownMenu alloc] initWithNavigationController:self.navigationController];
    menu.dataSource = self;
    menu.delegate = self;
    self.navigationItem.titleView = menu;
    self.menu = menu;
}

- (NSArray<NSString *> *)titleArrayForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return self.titleArray;
}

- (CGFloat)arrowPaddingForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return 8.0;
}

- (UIImage *)arrowImageForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return [UIImage imageNamed:@"Arrow"];
}
//点击下拉菜单后
- (void)navigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu didSelectTitleAtIndex:(NSUInteger)index {
    //1.保存index
    self.childindex = [NSNumber numberWithUnsignedInteger:index];
    [self saveNSUserDefaults];
    
    //2.刷新
    [self.tableView reloadData];
}

#pragma mark - Property method

- (NSArray<NSString *> *)titleArray {
    NSMutableArray *childNameAges = [[NSMutableArray alloc] init];
    for (CGChildModel *childmodel in self.childs) {
        NSString *ConcreteAge = [self getConcreteAge:childmodel.age ismouth:NO];
        NSString *chNameAge = [NSString stringWithFormat:@"%@ %@",childmodel.name,ConcreteAge];
        [childNameAges addObject:chNameAge];
    }
    //    return @[@"张三", @"李四2 5岁", @"王五3 8岁"];
    return childNameAges;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section== 0) {
    // 访问缓存池
    FirstCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    
    // 设置数据(传递模型)
//    cell.fs = self.fs[0];
    cell.childmodel = self.childs[[self.childindex integerValue]];
    
    return cell;
    }else if(indexPath.section == 2){
        // 访问缓存池
        SecondCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
//        cell.backgroundColor = [UIColor colorWithRed:(CGFloat)135/255.0 green:(CGFloat)206/255.0 blue:(CGFloat)250/255.0 alpha:(CGFloat)0.3f];
        CGChildModel *childmodel = self.childs[[self.childindex integerValue]];
        NSString *mouth = [self getConcreteAge:childmodel.age ismouth:YES];
        if(mouth.intValue <3){
            cell.status = self.second[0];
//            return cell;
        }else if (mouth.intValue <6){
            cell.status = self.second[1];
//            return cell;
        }else if (mouth.intValue <9){
            cell.status = self.second[2];
//            return cell;
        }else if (mouth.intValue <12){
            cell.status = self.second[3];
//            return cell;
        }else if (mouth.intValue <18){
            cell.status = self.second[4];
//            return cell;
        }else if (mouth.intValue <24){
            cell.status = self.second[5];
//            return cell;
        }else if (mouth.intValue <30){
            cell.status = self.second[6];
//            return cell;
        }else if (mouth.intValue <36){
            cell.status = self.second[7];
//            return cell;
        }else if (mouth.intValue <48){
            cell.status = self.second[8];
//            return cell;
        }else if (mouth.intValue <60){
            cell.status = self.second[9];
//            return cell;
        }else if (mouth.intValue <72){
            cell.status = self.second[10];
//            return cell;
        }else{
            cell.status = self.second[11];
//            return cell;
        }
//        cell.status = self.second[5];
        return cell;
    }
    else if(indexPath.section == 1){
        // 访问缓存池
        ThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:ID3];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else{
        
        CGChildModel *childmodel = self.childs[[self.childindex integerValue]];
        self.childmodel = childmodel;
        FourthCell *cell = [tableView dequeueReusableCellWithIdentifier:ID4];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        cell.heights = self.childmodel.heightArr.lastObject;
//        cell.weights = self.childmodel.weightArr.lastObject;
        cell.BMIs = self.childmodel.BMIArr.lastObject;
        return cell;
    }
   }
//点击或选中后执行
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    CGDetailViewController *detailVC =
//    [self.navigationController pushViewController:detailVC animated:YES];
//
//}
//去掉UItableview headerview黏性(sticky)
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView)
//    {
//        CGFloat sectionHeaderHeight = 100; //sectionHeaderHeight
//        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
//            
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//            
//        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
//            
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//            
//        }
//    }
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section ==0) {
        return 0;
//    }else{
//    return 30;
//    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==3) {
        return 0;
    }
    return 20;
}
// 得出方案:在这个方法返回之前就要计算cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 150;
    }else if(indexPath.section == 2){
    NSLog(@"heightForRowAtIndexPath--%zd",indexPath.row);
        CGChildModel *childmodel = self.childs[[self.childindex integerValue]];
        self.childmodel = childmodel;
       NSString *mouth = [self getConcreteAge:childmodel.age ismouth:YES];
        if(mouth.intValue <3){
            Second *status = self.second[0];
            return status.cellHeight;
        }else if (mouth.intValue <6){
            Second *status = self.second[1];
            return status.cellHeight;
        }else if (mouth.intValue <9){
            Second *status = self.second[2];
            return status.cellHeight;
        }else if (mouth.intValue <12){
            Second *status = self.second[3];
            return status.cellHeight;
        }else if (mouth.intValue <18){
            Second *status = self.second[4];
            return status.cellHeight;
        }else if (mouth.intValue <24){
            Second *status = self.second[5];
            return status.cellHeight;
        }else if (mouth.intValue <30){
            Second *status = self.second[6];
            return status.cellHeight;
        }else if (mouth.intValue <36){
            Second *status = self.second[7];
            return status.cellHeight;
        }else if (mouth.intValue <48){
            Second *status = self.second[8];
            return status.cellHeight;
        }else if (mouth.intValue <60){
            Second *status = self.second[9];
            return status.cellHeight;
        }else if (mouth.intValue <72){
            Second *status = self.second[10];
            return status.cellHeight;
        }else{
            Second *status = self.second[11];
            return status.cellHeight;
        }
   
    }else if(indexPath.section == 3){
    return 270;
    }else {
    return 160;
    }
}
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
//保存数据到NSUserDefaults
-(void)saveNSUserDefaults
{

    
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [userDefaults setValue:self.childindex forKey:@"childindex"];

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
    NSNumber *childindex = [userDefaultes valueForKey:@"childindex"];
    self.childindex = childindex;
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
