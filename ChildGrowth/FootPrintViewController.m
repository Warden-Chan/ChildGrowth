//
//  FootPrintViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/22.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "FootPrintViewController.h"
#import "NewItemCollectionViewController.h"
#import "MomentViewModel.h"
#import "MomentsTableViewCell.h"
#import "MJRefresh.h"
#import "NewItemCollectionViewController.h"
#import "addNewItemTableViewController.h"
#import "listCellItem.h"
#import "FMDatabase.h"
#import <sqlite3.h>
#import "SYNavigationDropdownMenu.h"
#import "CGChildModel.h"
#import "MJExtension.h"
@interface FootPrintViewController ()<UITableViewDelegate,UITableViewDataSource,addNewItemTableViewControllerDelegate,SYNavigationDropdownMenuDataSource, SYNavigationDropdownMenuDelegate>
{
    FMDatabase *db;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)NewItemClick:(id)sender;
//模型
//@property(nonatomic,strong)listCellItem *cellItem;
//@property (nonatomic,strong) NSMutableArray *cellItems;      //数据模型
@property (nonatomic,strong) NSMutableArray *momentFrames; //ViewModel(包含cell子控件的Frame)
@property (nonatomic, strong) SYNavigationDropdownMenu *menu;
/** 当前儿童index */
@property (nonatomic,copy) NSNumber *childindex;
@property (nonatomic, strong) NSMutableArray *childs;
@property (nonatomic, strong) CGChildModel *childmodel;
@end

@implementation FootPrintViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setUI];
    [self setup];
    [self databaseSteup];
    [self refreshMomentFrames];
    // Do any additional setup after loading the view.
}
-(void)databaseSteup{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"ChildGrowth.sqlite"];
    
    //2.获得数据库
    db = [FMDatabase databaseWithPath:fileName];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([db open])
    {
        //4.创表
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS zujicell(id integer primary key autoincrement,ChildId integer NOT NULL, time text NOT NULL,type integer NOT NULL,height float DEFAULT NULL,weight float DEFAULT NULL,headc float DEFAULT NULL,describe text DEFAULT NULL,photos);"];
        if (result)
        {
            NSLog(@"创建表成功");
        }
    }
}
//获取记录的列表
-(NSArray *)recordList{
    NSString *sql = @"select * from zujicell";
    FMResultSet *resultSet = [db executeQuery:sql];
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    while ([resultSet next]) {
        listCellItem *cellitem = [[listCellItem alloc]init];
        cellitem.ChildId =[[resultSet stringForColumn:@"ChildId"] integerValue];
        cellitem.time = [resultSet stringForColumn:@"time"];
        cellitem.type = [[resultSet stringForColumn:@"type"] integerValue];
        cellitem.height = [resultSet stringForColumn:@"height"];
        cellitem.weight = [resultSet stringForColumn:@"weight"];
        cellitem.headc = [resultSet stringForColumn:@"headc"];
        cellitem.describe = [resultSet stringForColumn:@"describe"];
//        NSString *photosStr = [resultSet stringForColumn:@"photos"];
//        cellitem.photos = [photosStr componentsSeparatedByString:@","];        
        NSArray *photosArr = [NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:@"photos"]];
        cellitem.photos = photosArr;
        [marr addObject:cellitem];
    }
    return marr;
}
//添加一条记录
-(void)addcellzujiItem:(listCellItem *)cellItem{
NSString *sql = @"insert into zujicell (ChildId,time,type,height,weight,headc,describe,photos) values(?,?,?,?,?,?,?,?)";
    
    NSData *photosData = [NSKeyedArchiver archivedDataWithRootObject:cellItem.photos];
    BOOL b = [db executeUpdate:sql,
              @(cellItem.ChildId),
              cellItem.time,
              @(cellItem.type),
              cellItem.height,
              cellItem.weight,
              cellItem.headc,
              cellItem.describe,
              photosData];
    if (!b) {
        NSLog(@"插入失败");
    }else{
        NSLog(@"插入成功");
    }
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
    [self refreshMomentFrames];
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
- (void)setUI{
//    self.title = @"SoolyMoments";
    //设置navigationBar不透明
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //导航条颜色
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    self.view.backgroundColor = [UIColor whiteColor];
    
//     _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.textDate.frame.origin.y+self.textDate.frame.size.height,screenWidth,screenHeight-self.textDate.frame.size.height)];
    //下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [_tableView.mj_header beginRefreshing];
    [self.view addSubview:self.tableView];
    [self.view sendSubviewToBack:self.tableView];
    self.tableView =_tableView;
}
- (IBAction)NewItemClick:(id)sender {
    NewItemCollectionViewController *VC = [[NewItemCollectionViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

//- (NSMutableArray *)cellItems{
//    if (!_cellItems) {
//        _cellItems = [NSMutableArray array];
//        _cellItems = [Moments moments];
//    }
//    return _cellItems;
//}

- (void)refreshMomentFrames{
    CGChildModel *child = self.childs[[self.childindex intValue]];
        NSMutableArray *momentFrames = [NSMutableArray array];
        NSArray *cellItems = [self recordList];
        //数据模型 => ViewModel(包含cell子控件的Frame)
        for (listCellItem *cellItem in cellItems) {
            MomentViewModel *momentFrame = [[MomentViewModel alloc] init];
            if (cellItem.ChildId == [child.ChildId integerValue]) {
                momentFrame.cellItem = cellItem;
                [momentFrames addObject:momentFrame];
            }
            
        }
     self.momentFrames =[NSMutableArray arrayWithArray:momentFrames];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[NewItemCollectionViewController class]]){
        NewItemCollectionViewController *contactVC = (NewItemCollectionViewController *)segue.destinationViewController;
//        contactVC.delegate = self;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
#pragma mark - 加载最新数据

- (void)loadNewData{
    //模拟增加数据
//    NSArray *cellItems = [self recordList];    
//    self.momentFrames = [NSMutableArray arrayWithArray:cellItems];
//    for (listCellItem *cellItem in cellItems) {
//        MomentViewModel *momentFrames = [[MomentViewModel alloc] init];
//        momentFrames.cellItem = cellItem;
//        [_momentFrames addObject:momentFrames];
//    }
    [self refreshMomentFrames];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
}


#pragma mark - tableView的方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.momentFrames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MomentsTableViewCell *cell = [MomentsTableViewCell momentsTableViewCellWithTableView:tableView];
    cell.momentFrames = self.momentFrames[indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentViewModel *momentFrame = self.momentFrames[indexPath.section];
    listCellItem *cellItem = momentFrame.cellItem;
    switch (cellItem.type) {
        case 0:
            cell.backgroundColor =[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
            break;
        case 1:
            cell.backgroundColor =[UIColor colorWithRed:240.0/255 green:140.0/255 blue:240.0/255 alpha:1.0];
            break;
        case 2:
            cell.backgroundColor =[UIColor colorWithRed:240.0/255 green:240.0/255 blue:140.0/255 alpha:1.0];
            break;
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取数据
    MomentViewModel *momentFrame = self.momentFrames[indexPath.section];
    return momentFrame.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return circleCellMargin;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//#pragma mark - 数据源方法 
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 15;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [[UITableViewCell alloc]init];
//    cell.textLabel.text = @"hhhhhh";
//    return cell;
//}

-(void)addNewItemVC:(addNewItemTableViewController *)addnewitemVC cellItem:(listCellItem *)cellItem{
    
    //保存存放的数据(修改模型)
//    self.cellItem = cellItem;
    CGChildModel *child = self.childs[[self.childindex intValue]];
    cellItem.ChildId = [child.ChildId integerValue];
    [self addcellzujiItem:cellItem];  //添加到足迹数据库
//    [self writeAllChildInfortoPlist];
    //刷新图表
//    [self loadNewData];
    [self refreshMomentFrames];
    [self.tableView reloadData];
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
@end
