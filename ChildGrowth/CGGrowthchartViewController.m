//
//  CGGrowthchartViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/3.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "CGGrowthchartViewController.h"
#import "CGDetailViewController.h"
#import "SYNavigationDropdownMenu.h"
#import "TWRChart.h"
#import "AddViewController.h"
#import "DeleteTableViewController.h"
#import "CGChildModel.h"
#import "MJExtension.h"
#import "CGHeadc.h"
#import "CGHeight.h"
#import "CGWeight.h"
#import "CGBMI.h"
#import "ChildGrowth-Bridging-Header.h"
#import "ChildGrowth-Swift.h"
#import "percentImageView.h"
#import "AFHTTPSessionManager.h"



@interface CGGrowthchartViewController ()<SYNavigationDropdownMenuDataSource, SYNavigationDropdownMenuDelegate,AddViewControllerDelegate,DeleteTableViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *childs;
@property (nonatomic, strong) SYNavigationDropdownMenu *menu;
/** 当前儿童index */
@property (nonatomic,copy) NSNumber *childindex;
@property (nonatomic,copy) NSString *userAccount;
@property (nonatomic,copy) NSString *token;

@property (weak, nonatomic) IBOutlet UIButton *InputBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/** 数据数组 */
@property (nonatomic, strong) NSArray *heightdataArr;
@property (nonatomic, strong) NSArray *weightdataArr;
@property (nonatomic, strong) NSArray *headcdataArr;
@property (nonatomic, strong) NSArray *BMIdataArr;
@property (nonatomic, strong) NSArray *percentUnscramble;
//@property (nonatomic, strong) NSMutableArray *values1;
//@property (nonatomic, strong) NSMutableArray *values2;
//@property (nonatomic, strong) NSMutableArray *values3;
//@property (nonatomic, strong) NSMutableArray *values4;
//@property (nonatomic, strong) NSMutableArray *values5;
//@property (nonatomic, strong) NSMutableArray *values6;
//@property (nonatomic, strong) NSMutableArray *values7;
//@property (nonatomic, strong) NSMutableArray *values8;

/** Charts图表框架 */
@property (nonatomic, strong) IBOutlet LineChartView *chartView;
/**世界标准或中国标准**/
@property (weak, nonatomic) IBOutlet UISegmentedControl *StandardType;
/**Z评分或百分位**/
@property (weak, nonatomic) IBOutlet UISegmentedControl *ZorPercent;
/**曲线图内容类型**/
@property (weak, nonatomic) IBOutlet UISegmentedControl *ChartType;
/**曲线解读**/
@property(strong, nonatomic) UILabel *label0;
/**当前身高，超过多少百分比**/
@property(strong, nonatomic) UILabel *label;
/**健康评价**/
@property(strong, nonatomic) UILabel *label1;
/**百分位解读**/
@property(strong, nonatomic) UILabel *label2;
//@property(strong, nonatomic) UIImageView *pimageView;
@property(strong, nonatomic) percentImageView *pimage;


@property(strong, nonatomic) UILabel *label3;
- (IBAction)StandardTypeChange:(id)sender;

- (IBAction)ZorPercentChange:(id)sender;

- (IBAction)CharttpyeChange:(id)sender;
/** 曲线数据 */
@property (nonatomic, strong) NSArray *TypeArr;
@end

@implementation CGGrowthchartViewController

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

- (NSArray *)TypeArr{
    if (_TypeArr == nil) {
        // 加载数据
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"CGChartType" ofType:@"plist"];
        self.TypeArr = [NSArray arrayWithContentsOfFile:path];
        
    }
    return _TypeArr;
}
- (NSArray *)percentUnscramble{
    if (_percentUnscramble == nil) {
        // 加载数据
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"percentUnscramble" ofType:@"plist"];
        self.percentUnscramble = [NSArray arrayWithContentsOfFile:path];
        
    }
    return _percentUnscramble;
}
- (NSArray *)heightdataArr{
    if (_heightdataArr == nil) {
        // 加载数据
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"height" ofType:@"plist"];
        self.heightdataArr = [NSArray arrayWithContentsOfFile:path];
        
    }
    return _heightdataArr;
}
- (NSArray *)weightdataArr{
    if (_weightdataArr == nil) {
        // 加载数据
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"weight" ofType:@"plist"];
        self.weightdataArr = [NSArray arrayWithContentsOfFile:path];
        
    }
    return _weightdataArr;
}
- (NSArray *)headcdataArr{
    if (_headcdataArr == nil) {
        // 加载数据
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"headc" ofType:@"plist"];
        self.headcdataArr = [NSArray arrayWithContentsOfFile:path];
        
    }
    return _headcdataArr;
}
- (NSArray *)BMIdataArr{
    if (_BMIdataArr == nil) {
        // 加载数据
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"BMI" ofType:@"plist"];
        self.BMIdataArr = [NSArray arrayWithContentsOfFile:path];
        
    }
    return _BMIdataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self.StandardType addTarget:self action:@selector(TypeAction) forControlEvents:UIControlEventValueChanged];
    //    [self.ZorPercent addTarget:self action:@selector(ZoPAction) forControlEvents:UIControlEventValueChanged];
//    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1800);
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self chartsetup];
    //导航条颜色
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    //添加中间标题栏
    [self tittlesetup];
    //返回显示中文
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"取消";
    self.navigationItem.backBarButtonItem = backItem;
    
//    self.InputBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //initWithFrame
    //    _chartView = [[TWRChartView alloc] initWithFrame:CGRectMake(-15, 145, self.view.bounds.size.width+20, self.view.bounds.size.height-260)];
    //    _chartView.backgroundColor = [UIColor clearColor];
    //    [self.view addSubview:_chartView];
    //    [self loadLineChart];
    UIColor *color = [UIColor colorWithHexString:@"0997F7"];
    _label0 = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.chartView.frame)+20, self.view.bounds.size.width-20, 20)];
    [self.scrollView addSubview:_label0];
    _label0.textAlignment = NSTextAlignmentLeft;
    _label0.font = [UIFont fontWithName:@"Arial" size:17.0f];
    _label0.textColor = color;
    _label0.text = @"曲线解读：";
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.label0.frame), self.view.bounds.size.width-20, 40)];
    [self.scrollView addSubview:_label];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.numberOfLines = 0;
    _label.font = [UIFont fontWithName:@"Arial" size:16.0f];

    
    
    _label2 = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.label.frame)+30, self.view.bounds.size.width-20, 20)];
    [self.scrollView addSubview:_label2];
    _label2.textAlignment = NSTextAlignmentLeft;
    _label2.font = [UIFont fontWithName:@"Arial" size:17.0f];
    _label2.textColor = color;
    
//    _pimageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.label2.frame)+10, self.view.bounds.size.width-20, 70)];
//    UIImage *image = [UIImage imageNamed:@"pimage"];
//    _pimageView.image = image;
//    [self.scrollView addSubview:_pimageView];
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"percentImage" owner:nil options:nil];
    _pimage = views[0];
    _pimage.frame =CGRectMake(0,CGRectGetMaxY(self.label2.frame)+10, screenWidth, 95);
    [self.scrollView addSubview:_pimage];
    self.pimage = _pimage;
    //评测结果
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.pimage.frame), self.view.bounds.size.width-20,80)];
//    [self.scrollView addSubview:_label1];
    _label1.textAlignment = NSTextAlignmentLeft;
    _label1.numberOfLines = 0;
    _label1.font = [UIFont fontWithName:@"Arial" size:16.0f];
    
    _label3 = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.label1.frame)+10, self.view.bounds.size.width-20, 60)];
    [self.scrollView addSubview:_label3];
    _label3.textAlignment = NSTextAlignmentCenter;
    _label3.numberOfLines = 0;
    UIColor *color1 = [UIColor colorWithHexString:@"7A7A7A"];
    _label3.font = [UIFont fontWithName:@"Arial" size:12.0f];
    
//
    _label3.textColor = color1;
    
    [self reloadall];

}
-(CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}
-(void)viewWillAppear:(BOOL)animated{
    [self readNSUserDefaults];
    NSString *tittle = [self titleArray][[self.childindex integerValue]];
    [self.menu setTitle:tittle forState:UIControlStateNormal];
    [self reloadall];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.destinationViewController isKindOfClass:[AddViewController class]]){
    AddViewController *contactVC = (AddViewController *)segue.destinationViewController;
    contactVC.ChartType = self.ChartType.selectedSegmentIndex;
    contactVC.delegate = self;
    }else{
            DeleteTableViewController *contactVC = (DeleteTableViewController *)segue.destinationViewController;
        contactVC.delegate = self;
        //得到存放的数据
        CGChildModel *childmodel = self.childs[[self.childindex integerValue]];
        contactVC.childmodel = childmodel;
    }
    //[segue perform];
    //[segue.sourceViewController.navigationController pushViewController:segue.destinationViewController animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)chartsetup{
        LineChartView *chartview = [[LineChartView alloc]initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, self.view.bounds.size.height-260)];
        [self.scrollView addSubview:chartview];
        self.chartView = chartview;
    //    _chartView.delegate = self;
   _chartView.descriptionText= @"单位/岁";
//    NSLog(@"%@",_chartView.descriptionText);
        _chartView.chartDescription.enabled = NO;
        _chartView.noDataText = @"暂时没有数据";
        _chartView.dragEnabled = YES;
        [_chartView setScaleEnabled:YES];
        _chartView.pinchZoomEnabled = YES;
        _chartView.drawGridBackgroundEnabled = NO;
    _chartView.xAxis.labelPosition = 1;   //X轴的位置
        // x-axis limit line
        ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:10.0 label:@"Index 10"];
        llXAxis.lineWidth = 4.0;
        llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
        llXAxis.labelPosition = ChartLimitLabelPositionRightBottom;
        llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
        //[_chartView.xAxis addLimitLine:llXAxis];
    
        _chartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
        _chartView.xAxis.gridLineDashPhase = 0.f;
    //
    //    ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:150.0 label:@"Upper Limit"];
    //    ll1.lineWidth = 4.0;
    //    ll1.lineDashLengths = @[@5.f, @5.f];
    //    ll1.labelPosition = ChartLimitLabelPositionRightTop;
    //    ll1.valueFont = [UIFont systemFontOfSize:10.0];
    //
    //    ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:0.0 label:@"Lower Limit"];
    //    ll2.lineWidth = 4.0;
    //    ll2.lineDashLengths = @[@5.f, @5.f];
    //    ll2.labelPosition = ChartLimitLabelPositionRightBottom;
    //    ll2.valueFont = [UIFont systemFontOfSize:10.0];
    
//        ChartYAxis *leftAxis = _chartView.leftAxis;
//        [leftAxis removeAllLimitLines];
//        //    [leftAxis addLimitLine:ll1];
//        //    [leftAxis addLimitLine:ll2];
//        leftAxis.axisMaximum = 120.0;
//        leftAxis.axisMinimum = 30.0;
//        leftAxis.gridLineDashLengths = @[@5.f, @5.f];
//        leftAxis.drawZeroLineEnabled = NO;
//        leftAxis.drawLimitLinesBehindDataEnabled = YES;
//    
//        _chartView.rightAxis.enabled = YES;
    
        //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
        //[_chartView.viewPortHandler setMaximumScaleX: 2.f];
    //
//        BalloonMarker *marker = [[BalloonMarker alloc]
//                                 initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
//                                 font: [UIFont systemFontOfSize:12.0]
//                                 textColor: UIColor.whiteColor
//                                 insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
//        marker.chartView = _chartView;
//        marker.minimumSize = CGSizeMake(80.f, 40.f);
//        _chartView.marker = marker;
    
        _chartView.legend.form = ChartLegendFormLine;
    
//        [self setDataCount:20 range:45];
    
//        [_chartView animateWithXAxisDuration:2.5];
    
    
}

- (void)tittlesetup {
    //添加中间标题栏
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
//点击标题栏下拉菜单后
- (void)navigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu didSelectTitleAtIndex:(NSUInteger)index {
    //1.保存index
    self.childindex = [NSNumber numberWithUnsignedInteger:index];
    [self saveNSUserDefaults];
    
    //3.刷新
        [self reloadall];
}

#pragma mark - Property method

- (NSArray<NSString *> *)titleArray {
    NSMutableArray *childNameAges = [[NSMutableArray alloc] init];
    for (CGChildModel *childmodel in self.childs) {
        NSString *ConcreteAge = [self getConcreteAge:childmodel.age ismouth:NO];
        NSString *chNameAge = [NSString stringWithFormat:@"%@ %@",childmodel.name,ConcreteAge];
        [childNameAges addObject:chNameAge];
    }
    //    return @[childNameAges[0], @"李四2 5岁", @"王五3 8岁"];
    return childNameAges;
}
/**
 *  Loads a line chart using native code
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
-(NSString *)getCompareAge:(NSString *)birth latestDay:(NSString*)latestDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    //最新日期
    NSDate *lateDay = [dateFormatter dateFromString:latestDay];
    //用来得到详细的时差
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:lateDay options:0];
    NSString *CompareAge = [[NSString alloc] init];
    CompareAge = [NSString stringWithFormat:(@"%.1f"),(long)[date year]*12+(long)[date month]+(long)[date day]*0.033];
    return CompareAge;
}

//第一个早返回YES,第一个晚返回NO
-(BOOL)timeCompare:(NSString *)fDate sDate:(NSString *)sDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSDate *firstDate = [dateFormatter dateFromString:fDate];
    NSDate *secondDate = [dateFormatter dateFromString:sDate];
    if([firstDate compare:secondDate] == NSOrderedAscending){
        //        NSLog(@"first早");
        return YES;
    }else{
        //        NSLog(@"first晚");
        return NO;}
    
}
//图表和下部lable内容刷新
-(void)reloadall{
     _chartView.data = nil;
     [_chartView setNeedsDisplay];
    //得到存放的数据
    CGChildModel *childmodel = self.childs[[self.childindex integerValue]];
    //    NSString *str1 = @"2012年8月2日";
    //    NSString *str2 = @"2013年8月2日";
    //   BOOL blllo = [self timeCompare:str1 sDate:str2];
    //    [self.chartView stringByEvaluatingJavaScriptFromString:@""];
    switch (self.ChartType.selectedSegmentIndex) {
            
        case 0:    //身高
        {
            //根据评测年龄对数组进行排序(每次提交输入数据后执行一次)
            NSComparator cmptr = ^(CGHeight *obj1,CGHeight *obj2){
                NSString *obj1time = obj1.time;
                NSString *obj2time = obj2.time;
                if([self timeCompare:obj1time sDate:obj2time]){
                    return (NSComparisonResult)NSOrderedAscending;
                }
                if([self timeCompare:obj2time sDate:obj1time]){
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return (NSComparisonResult)NSOrderedSame;
            };
            NSArray *outArray = [childmodel.heightArr sortedArrayUsingComparator:cmptr];
            [childmodel.heightArr removeAllObjects];
            [childmodel.heightArr addObjectsFromArray:outArray];
            [self reloadheight:childmodel];
            break;
        }
        case 1:    //体重
        {
            //根据评测年龄对数组进行排序(每次提交输入数据后执行一次)
            NSComparator cmptr = ^(CGWeight *obj1,CGWeight *obj2){
                NSString *obj1time = obj1.time;
                NSString *obj2time = obj2.time;
                if([self timeCompare:obj1time sDate:obj2time]){
                    return (NSComparisonResult)NSOrderedAscending;
                }
                if([self timeCompare:obj2time sDate:obj1time]){
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return (NSComparisonResult)NSOrderedSame;
            };
            NSArray *outArray = [childmodel.weightArr sortedArrayUsingComparator:cmptr];
            [childmodel.weightArr removeAllObjects];
            [childmodel.weightArr addObjectsFromArray:outArray];
            [self reloadweight:childmodel];
            break;
        }
        case 2:    //头围
        {
            //根据评测年龄对数组进行排序(每次提交输入数据后执行一次)
            NSComparator cmptr = ^(CGHeadc *obj1,CGHeadc *obj2){
                NSString *obj1time = obj1.time;
                NSString *obj2time = obj2.time;
                if([self timeCompare:obj1time sDate:obj2time]){
                    return (NSComparisonResult)NSOrderedAscending;
                }
                if([self timeCompare:obj2time sDate:obj1time]){
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return (NSComparisonResult)NSOrderedSame;
            };
            NSArray *outArray = [childmodel.headcArr sortedArrayUsingComparator:cmptr];
            [childmodel.headcArr removeAllObjects];
            [childmodel.headcArr addObjectsFromArray:outArray];
            [self reloadheadc:childmodel];
            break;
        }
        case 3:     //BMI
        {
            //根据评测年龄对数组进行排序(每次提交输入数据后执行一次)
            NSComparator cmptr = ^(CGBMI *obj1,CGBMI *obj2){
                NSString *obj1time = obj1.time;
                NSString *obj2time = obj2.time;
                if([self timeCompare:obj1time sDate:obj2time]){
                    return (NSComparisonResult)NSOrderedAscending;
                }
                if([self timeCompare:obj2time sDate:obj1time]){
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return (NSComparisonResult)NSOrderedSame;
            };
            NSArray *outArray = [childmodel.BMIArr sortedArrayUsingComparator:cmptr];
            [childmodel.BMIArr removeAllObjects];
            [childmodel.BMIArr addObjectsFromArray:outArray];
            [self reloadBMI:childmodel];
            break;
        }
        default:
            break;
    }
}
-(void)reloadheight:(CGChildModel *)childmodel{
    NSArray *outArray = childmodel.heightArr;

//                childmodel.heightArr = outArray;
    //    NSLog(@"%@",outArray);
    //获取最大和最小测量年龄(单位月)
    CGHeight *firstheightItem = [outArray lastObject];
    NSString *firsttime = firstheightItem.time;
    CGHeight *lastheightItem = [outArray firstObject];
    NSString *lastttime = lastheightItem.time;
    int minmouth = [[self getCompareAge:childmodel.age latestDay:lastttime] intValue];
    int maxmouth = [[self getCompareAge:childmodel.age latestDay:firsttime] intValue];
//    int minmouth = [[self getConcreteAge:firsttime ismouth:YES] intValue];
//    int maxmouth = [[self getConcreteAge:lastttime ismouth:YES] intValue];
    int chartage = 0;
    //判别显示那种时间段曲线
    chartage = [self getChartAgeRange:minmouth Maxmouth:maxmouth whatTypeArr:@"height"];
    [self updateLineChart:self.heightdataArr chartage:chartage whatTypeArr:0];
    
}


-(void)reloadweight:(CGChildModel *)childmodel{
    NSArray *outArray = childmodel.weightArr;
//            childmodel.heightArr = outArray;
    //获取最大和最小测量年龄(单位月)
    CGWeight *firstweightItem = [outArray lastObject];
    NSString *firsttime = firstweightItem.time;
    CGWeight *lastweightItem = [outArray firstObject];
    NSString *lastttime = lastweightItem.time;
    int minmouth = [[self getCompareAge:childmodel.age latestDay:lastttime] intValue];
    int maxmouth = [[self getCompareAge:childmodel.age latestDay:firsttime] intValue];
    int chartage = 0;
    //判别显示那种时间段曲线
    chartage = [self getChartAgeRange:minmouth Maxmouth:maxmouth whatTypeArr:@"weight"];
    [self updateLineChart:self.weightdataArr chartage:chartage whatTypeArr:1];
    
}
-(void)reloadheadc:(CGChildModel *)childmodel{
    NSArray *outArray = childmodel.headcArr;
    //            childmodel.heightArr = outArray;
    //获取最大和最小测量年龄(单位月)
    CGHeadc *firstheadcItem = [outArray lastObject];
    NSString *firsttime = firstheadcItem.time;
    CGHeadc *lastheadcItem = [outArray firstObject];
    NSString *lastttime = lastheadcItem.time;
    int minmouth = [[self getCompareAge:childmodel.age latestDay:lastttime] intValue];
    int maxmouth = [[self getCompareAge:childmodel.age latestDay:firsttime] intValue];
    int chartage = 0;
    //判别显示那种时间段曲线
    chartage = [self getChartAgeRange:minmouth Maxmouth:maxmouth whatTypeArr:@"headc"];
    [self updateLineChart:self.headcdataArr chartage:chartage whatTypeArr:2];
}
-(void)reloadBMI:(CGChildModel *)childmodel{
  NSArray *outArray = childmodel.BMIArr;
    //            childmodel.heightArr = outArray;
    //获取最大和最小测量年龄(单位月)
    CGBMI *firstBMIItem = [outArray lastObject];
    NSString *firsttime = firstBMIItem.time;
    CGBMI *lastBMIItem = [outArray firstObject];
    NSString *lastttime = lastBMIItem.time;
    int minmouth = [[self getCompareAge:childmodel.age latestDay:lastttime] intValue];
    int maxmouth = [[self getCompareAge:childmodel.age latestDay:firsttime] intValue];
    int chartage = 0;
    //判别显示那种时间段曲线
    chartage = [self getChartAgeRange:minmouth Maxmouth:maxmouth whatTypeArr:@"BMI"];
    [self updateLineChart:self.BMIdataArr chartage:chartage whatTypeArr:3];
}
-(int)getChartAgeRange:(int)minmouth Maxmouth:(int)maxmouth whatTypeArr:(NSString *)whatTypeArr{
    int chartage;
    //判别显示那种时间段曲线
    if ([whatTypeArr isEqualToString:@"headc"]) {
        if(minmouth<=24){
            if (maxmouth <=24) {
                chartage = 1;   //曲线0-2岁
            }else{
                chartage = 2;   //曲线0-5岁
            }
        }else{
                chartage = 3;   //曲线2-5岁
        }
    }else{
    if(minmouth<=24){
        if (maxmouth <=24) {
            chartage = 1;   //曲线0-2岁
        }else if (maxmouth <=60){
            chartage = 2;   //曲线0-5岁
        }else{
            chartage = 3;   //曲线0-18岁
        }
    }else if (minmouth <=60){
        if (maxmouth <=60) {
            chartage = 4;   //曲线2-5岁
        }else{
            chartage = 5;   //曲线2-18岁
        }
    }else{
        chartage = 6;   //曲线5-18岁
    }
    }
    return chartage;
}
//设定曲线的数据数量以及范围
//- (void)setDataCount:(int)count range:(double)range
//{
//    NSMutableArray *values = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < 24; i++)
//    {
//        //        double val = arc4random_uniform(range) + 3;  //生成随机y值
//        NSArray *heightvalArr = self.heightdataArr[0][0][0][0][0];
//        double val = [heightvalArr[i] doubleValue];
//        [values addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
//    }
//    
//    LineChartDataSet *set1 = nil;
//    if (_chartView.data.dataSetCount > 0)
//    {
//        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
//        set1.values = values;
//        [_chartView.data notifyDataChanged];
//        [_chartView notifyDataSetChanged];
//    }
//    else
//    {
//        set1 = [[LineChartDataSet alloc] initWithValues:values label:@"DataSet 1"];
//        set1.drawValuesEnabled = NO;//不显示文字
//        set1.drawCirclesEnabled = NO;//是否绘制拐点
//        set1.lineDashLengths = @[@5.f, @2.5f];
//        set1.highlightLineDashLengths = @[@5.f, @2.5f];
//        [set1 setColor:UIColor.blackColor];
//        [set1 setCircleColor:UIColor.blackColor];
//        set1.lineWidth = 1.0;
//        set1.circleRadius = 3.0;
//        set1.drawCircleHoleEnabled = NO;
//        set1.valueFont = [UIFont systemFontOfSize:9.f];
//        set1.formLineDashLengths = @[@5.f, @2.5f];
//        set1.formLineWidth = 1.0;
//        set1.formSize = 15.0;
//        
//        NSArray *gradientColors = @[
//                                    (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
//                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
//                                    ];
//        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
//        
//        set1.fillAlpha = 1.f;
//        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
//        set1.drawFilledEnabled = YES;
//        
//        CGGradientRelease(gradient);
//        
//        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//        [dataSets addObject:set1];
//        
//        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
//        _chartView.data = data;
//        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
//        {
//            set.drawFilledEnabled = NO;
//        }
//    }
//}
-(LineChartDataSet *)setLineDataSet:(NSArray<ChartDataEntry *> * _Nullable)values labeltext:(NSString * _Nullable)labeltext isCirclesEnabled:(BOOL)isCirclesEnabled color:(UIColor *)color{
    LineChartDataSet *set =nil;
    set = [[LineChartDataSet alloc] initWithValues:values label:labeltext];
    set.drawValuesEnabled = NO;//不显示文字
    set.drawCirclesEnabled = isCirclesEnabled;//是否绘制拐点
    set.axisDependency = AxisDependencyLeft;
    [set setColor:color];
    [set setCircleColor:UIColor.blackColor];
    set.lineWidth = 1.0;
    set.circleRadius = 3.0;
    set.drawCircleHoleEnabled = NO;
    set.valueFont = [UIFont systemFontOfSize:9.f];
    
    NSArray *gradientColors = @[
                                (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                ];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    
    set.fillAlpha = 1.f;
    set.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
    set.drawFilledEnabled = YES;
    
    CGGradientRelease(gradient);
    return set;
}
//whatTypeArr :  0:height  1:weight  2:headc  3:BMI
-(void)updateLineChart:(NSArray *)typeArr chartage:(int)chartage whatTypeArr:(int)whatTypeArr{
    
        CGChildModel *childmodel = self.childs[[self.childindex integerValue]];
        NSString *SexStr = childmodel.sex;
        bool childSex  = [SexStr isEqualToString:@"女"];
    NSMutableArray *values1 = [[NSMutableArray alloc] init];
     NSMutableArray *values2 = [[NSMutableArray alloc] init];
     NSMutableArray *values3 = [[NSMutableArray alloc] init];
     NSMutableArray *values4 = [[NSMutableArray alloc] init];
     NSMutableArray *values5 = [[NSMutableArray alloc] init];
    NSMutableArray *values6 = [[NSMutableArray alloc] init];
    NSMutableArray *values7 = [[NSMutableArray alloc] init];
    NSMutableArray *values8 = [[NSMutableArray alloc] init];
    LineChartDataSet *set1 = nil, *set2 = nil, *set3 = nil, *set4 = nil, *set5 = nil, *set6 = nil,*set7 = nil,*set8 = nil;

//        NSArray *valArr1 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][0];
//        NSArray *valArr2 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][1];
//        NSArray *valArr3 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][2];
//        NSArray *valArr4 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][3];
//        NSArray *valArr5 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][4];
    NSArray *valArr1 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][0];
    NSArray *valArr2 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][1];
    NSArray *valArr3 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][2];
    NSArray *valArr4 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][3];
    NSArray *valArr5 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][4];
//        double val = [heightvalArr[i] doubleValue];
//     NSMutableArray *values1 = [[NSMutableArray alloc] init];
//        [values1 addObject:[[ChartDataEnt                                            ry alloc] initWithX:i y:val]];

//     NSArray *labels = [self getLablesByChartage:chartage]; //X坐标数组
    //儿童测量数据组

    if(self.ZorPercent.selectedSegmentIndex){  //百分位
        _label2.text = @"百分位解读：";
        if (whatTypeArr ==0) {
            for (CGHeight *heightItem in childmodel.heightArr) {
                double mouth = [[self getCompareAge:childmodel.age latestDay:heightItem.time] doubleValue];
                NSString *heightStr = [NSString stringWithFormat:@"%@", heightItem.height];
                double val = [heightStr doubleValue];
                if (self.StandardType.selectedSegmentIndex) {
                [values8 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
                }else{
                [values6 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
                }
            }
        }else if(whatTypeArr == 1){
            for (CGWeight *weightItem in childmodel.weightArr) {
                double mouth = [[self getCompareAge:childmodel.age latestDay:weightItem.time] doubleValue];
                NSString *weightStr = [NSString stringWithFormat:@"%@", weightItem.weight];
                double val = [weightStr doubleValue];
//                [values6 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
                if (self.StandardType.selectedSegmentIndex) {
                    [values8 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
                }else{
                    [values6 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
                }
            }
            }else if(whatTypeArr == 3){
                for (CGBMI *BMIItem in childmodel.BMIArr) {
                    double mouth = [[self getCompareAge:childmodel.age latestDay:BMIItem.time] doubleValue];
                    NSString *BMIStr = [NSString stringWithFormat:@"%@", BMIItem.value];
                    double val = [BMIStr doubleValue];
//                    [values6 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
                    if (self.StandardType.selectedSegmentIndex) {
                        [values8 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
                    }else{
                        [values6 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
                    }
                }
            }else{
                for (CGHeadc *headcItem in childmodel.headcArr) {
                    double mouth = [[self getCompareAge:childmodel.age latestDay:headcItem.time] doubleValue];
                    NSString *headcStr = [NSString stringWithFormat:@"%@", headcItem.headc];
                    double val = [headcStr doubleValue];
//                    [values6 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
                    if (self.StandardType.selectedSegmentIndex) {
                        [values8 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
                    }else{
                        [values6 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
                    }
                }
            }

        if (self.StandardType.selectedSegmentIndex) {   //0WHO标准|9城市标准1
            NSArray *valArr6 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][5];
            NSArray *valArr7 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][6];
            if (whatTypeArr ==3) {
                int b,e;
                switch (chartage) {
                    case 1:{   //0-2岁
                        b = 0;
                        e = 5;
                        break;
                    }
                    case 2:   //0-5
                    {
                        b = 0;
                        e = 11;
                        break;
                    }
                    case 3:   //0-18
                    {
                        b = 0;
                        e = 37;
                        break;
                    }
                    case 4:   //2-5
                    {
                        b = 4;
                        e = 11;
                        break;
                    }
                    case 5:    //2-18
                    {
                        b = 4;
                        e = 37;
                        break;
                    }
                    case 6:   //5-18
                    {
                        b = 10;
                        e = 37;
                        break;
                    }
                    default:
                        break;
                }
                for (int i= b; i<e; i++) {
                    double val1 = [valArr1[i-b] doubleValue];
                    double val2 = [valArr2[i-b] doubleValue];
                    double val3 = [valArr3[i-b] doubleValue];
                    double val4 = [valArr4[i-b] doubleValue];
                    double val5 = [valArr5[i-b] doubleValue];
                    double val6 = [valArr6[i-b] doubleValue];
                    double val7 = [valArr7[i-b] doubleValue];
                    int j = i *6;
                    [values1 addObject:[[ChartDataEntry alloc] initWithX:j y:val1]];
                    [values2 addObject:[[ChartDataEntry alloc] initWithX:j y:val2]];
                    [values3 addObject:[[ChartDataEntry alloc] initWithX:j y:val3]];
                    [values4 addObject:[[ChartDataEntry alloc] initWithX:j y:val4]];
                    [values5 addObject:[[ChartDataEntry alloc] initWithX:j y:val5]];
                    [values6 addObject:[[ChartDataEntry alloc] initWithX:j y:val6]];
                    [values7 addObject:[[ChartDataEntry alloc] initWithX:j y:val7]];
            }
                set1 = [self setLineDataSet:values1 labeltext:@"3th" isCirclesEnabled:NO color:[UIColor blackColor]];
                set2 = [self setLineDataSet:values2 labeltext:@"5th" isCirclesEnabled:NO color:[UIColor purpleColor]];
                set3 = [self setLineDataSet:values3 labeltext:@"15th" isCirclesEnabled:NO color:[UIColor orangeColor]];
                set4 = [self setLineDataSet:values4 labeltext:@"50th" isCirclesEnabled:NO color:[UIColor greenColor]];
                set5 = [self setLineDataSet:values5 labeltext:@"85th" isCirclesEnabled:NO color:[UIColor orangeColor]];
                set6 = [self setLineDataSet:values6 labeltext:@"95th" isCirclesEnabled:NO color:[UIColor purpleColor]];
                set7 = [self setLineDataSet:values7 labeltext:@"97th" isCirclesEnabled:NO color:[UIColor blackColor]];

            }else{
                int b,e;
            switch (chartage) {
                case 1:{   //0-2岁
                    b = 0;
                    e = 10;
                    break;
                }
                case 2:   //0-5
                {
                    b = 0;
                    e = 16;
                    break;
                }
                case 3:   //0-18
                {
                    b = 0;
                    e = 41;
                    break;
                }
                case 4:   //2-5
                {
                    b = 9;
                    e = 16;
                    break;
                }
                case 5:    //2-18
                {
                    b = 9;
                    e = 41;
                    break;
                }
                case 6:   //5-18
                {
                    b = 15;
                    e = 41;
                    break;
                }
                default:
                    break;
            }
                for (int i= b; i<e; i++) {
                    double val1 = [valArr1[i-b] doubleValue];
                    double val2 = [valArr2[i-b] doubleValue];
                    double val3 = [valArr3[i-b] doubleValue];
                    double val4 = [valArr4[i-b] doubleValue];
                    double val5 = [valArr5[i-b] doubleValue];
                    double val6 = [valArr6[i-b] doubleValue];
                    double val7 = [valArr7[i-b] doubleValue];
                    int j;
                    if(i<=3){
                        j = i *2;
                    }else if(i<=9){
                        j = (i-1) *3;
                    }else if(i<=39){
                        j = (i-5) *6;
                    }else{
                        j = 216;
                    }
                    [values1 addObject:[[ChartDataEntry alloc] initWithX:j y:val1]];
                    [values2 addObject:[[ChartDataEntry alloc] initWithX:j y:val2]];
                    [values3 addObject:[[ChartDataEntry alloc] initWithX:j y:val3]];
                    [values4 addObject:[[ChartDataEntry alloc] initWithX:j y:val4]];
                    [values5 addObject:[[ChartDataEntry alloc] initWithX:j y:val5]];
                    [values6 addObject:[[ChartDataEntry alloc] initWithX:j y:val6]];
                    [values7 addObject:[[ChartDataEntry alloc] initWithX:j y:val7]];
                }
                set1 = [self setLineDataSet:values1 labeltext:@"3th" isCirclesEnabled:NO color:[UIColor blackColor]];
                set2 = [self setLineDataSet:values2 labeltext:@"10th" isCirclesEnabled:NO color:[UIColor purpleColor]];
                set3 = [self setLineDataSet:values3 labeltext:@"25th" isCirclesEnabled:NO color:[UIColor orangeColor]];
                set4 = [self setLineDataSet:values4 labeltext:@"50th" isCirclesEnabled:NO color:[UIColor greenColor]];
                set5 = [self setLineDataSet:values5 labeltext:@"75th" isCirclesEnabled:NO color:[UIColor orangeColor]];
                set6 = [self setLineDataSet:values6 labeltext:@"90th" isCirclesEnabled:NO color:[UIColor purpleColor]];
                set7 = [self setLineDataSet:values7 labeltext:@"97th" isCirclesEnabled:NO color:[UIColor blackColor]];

            }
            set8 = [self setLineDataSet:values8 labeltext:@"儿童数据" isCirclesEnabled:YES color:[UIColor blackColor]];
            NSMutableArray *dataSets = [[NSMutableArray alloc] init];
            [dataSets addObject:set1];
            [dataSets addObject:set2];
            [dataSets addObject:set3];
            [dataSets addObject:set4];
            [dataSets addObject:set5];
            [dataSets addObject:set6];
            [dataSets addObject:set7];
            [dataSets addObject:set8];
            LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
            _chartView.data = data;
            for (id<ILineChartDataSet> set in _chartView.data.dataSets)
            {
                set.drawFilledEnabled = NO;
            }
            ChartYAxis *leftAxis = _chartView.leftAxis;
            [leftAxis removeAllLimitLines];
            leftAxis.axisMaximum = [valArr7.lastObject floatValue] +10;
            leftAxis.axisMinimum = [valArr1.firstObject floatValue] -10;
            leftAxis.gridLineDashLengths = @[@5.f, @5.f];
            leftAxis.drawZeroLineEnabled = NO;
            leftAxis.drawLimitLinesBehindDataEnabled = YES;
        }else{                           //世界标准
            switch (chartage) {
                case 1:{   //0-2岁
                    for (int i= 0; i<25; i++) {
                        double val1 = [valArr1[i] doubleValue];
                        double val2 = [valArr2[i] doubleValue];
                        double val3 = [valArr3[i] doubleValue];
                        double val4 = [valArr4[i] doubleValue];
                        double val5 = [valArr5[i] doubleValue];
                        [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                        [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                        [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                        [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                        [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                    }
                    break;
                }
                case 2:   //0-5
                {
                    for (int i= 0; i<60; i++) {
                        double val1 = [valArr1[i] doubleValue];
                        double val2 = [valArr2[i] doubleValue];
                        double val3 = [valArr3[i] doubleValue];
                        double val4 = [valArr4[i] doubleValue];
                        double val5 = [valArr5[i] doubleValue];
                        if (whatTypeArr == 0 || whatTypeArr == 3) {
                            if (i >24) {
                            [values1 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val1]];
                            [values2 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val2]];
                            [values3 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val3]];
                            [values4 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val4]];
                            [values5 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val5]];
                            }else{
                            [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                            [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                            [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                            [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                            [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                            }
                        }else{
                            [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                            [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                            [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                            [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                            [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                        }
                     }
                    break;
                }
                case 3:   //0-18 或0-10
                {
                    if (whatTypeArr == 1) {
                        for (int i= 0; i<120; i++) {
                            double val1 = [valArr1[i] doubleValue];
                            double val2 = [valArr2[i] doubleValue];
                            double val3 = [valArr3[i] doubleValue];
                            double val4 = [valArr4[i] doubleValue];
                            double val5 = [valArr5[i] doubleValue];
                            [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                            [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                            [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                            [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                            [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                        }
                    }else{
                    for (int i= 0; i<216; i++) {
                        double val1 = [valArr1[i] doubleValue];
                        double val2 = [valArr2[i] doubleValue];
                        double val3 = [valArr3[i] doubleValue];
                        double val4 = [valArr4[i] doubleValue];
                        double val5 = [valArr5[i] doubleValue];
                        if (whatTypeArr == 0 || whatTypeArr == 3){
                        if(i>24){
                            [values1 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val1]];
                            [values2 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val2]];
                            [values3 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val3]];
                            [values4 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val4]];
                            [values5 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val5]];
                        }else{
                            [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                            [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                            [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                            [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                            [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                        }
                    }else{
                            [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                            [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                            [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                            [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                            [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                        }
                    }
                    }
                    break;
                }
                 case 4:   //2-5
                {
                    for (int i= 24; i<60; i++) {
                        double val1 = [valArr1[i-24] doubleValue];
                        double val2 = [valArr2[i-24] doubleValue];
                        double val3 = [valArr3[i-24] doubleValue];
                        double val4 = [valArr4[i-24] doubleValue];
                        double val5 = [valArr5[i-24] doubleValue];
                        [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                        [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                        [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                        [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                        [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                    }
                    break;
                }
                case 5:    //2-18 或2-10
                {
                    if (whatTypeArr == 1) {
                        for (int i= 24; i<120; i++) {
                            double val1 = [valArr1[i-24] doubleValue];
                            double val2 = [valArr2[i-24] doubleValue];
                            double val3 = [valArr3[i-24] doubleValue];
                            double val4 = [valArr4[i-24] doubleValue];
                            double val5 = [valArr5[i-24] doubleValue];
                            [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                            [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                            [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                            [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                            [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                        }
                    }else{
                    for (int i= 24; i<216; i++) {
                        double val1 = [valArr1[i-24] doubleValue];
                        double val2 = [valArr2[i-24] doubleValue];
                        double val3 = [valArr3[i-24] doubleValue];
                        double val4 = [valArr4[i-24] doubleValue];
                        double val5 = [valArr5[i-24] doubleValue];
                        [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                        [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                        [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                        [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                        [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                    }
                    }
                    break;
                }
                case 6:   //5-10 or 5-10
                {
                    if (whatTypeArr == 1) {
                        for (int i= 60; i<120; i++) {
                            double val1 = [valArr1[i-60] doubleValue];
                            double val2 = [valArr2[i-60] doubleValue];
                            double val3 = [valArr3[i-60] doubleValue];
                            double val4 = [valArr4[i-60] doubleValue];
                            double val5 = [valArr5[i-60] doubleValue];
                            [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                            [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                            [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                            [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                            [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                        }
                    }
                    else{
                    for (int i= 60; i<216; i++) {
                        double val1 = [valArr1[i-60] doubleValue];
                        double val2 = [valArr2[i-60] doubleValue];
                        double val3 = [valArr3[i-60] doubleValue];
                        double val4 = [valArr4[i-60] doubleValue];
                        double val5 = [valArr5[i-60] doubleValue];
                        [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                        [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                        [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                        [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                        [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                    }
                    }
                    break;
                }
                default:
                    break;
            }
            set1 = [self setLineDataSet:values1 labeltext:@"3th" isCirclesEnabled:NO color:[UIColor purpleColor]];  //purpleColor
            set2 = [self setLineDataSet:values2 labeltext:@"15th" isCirclesEnabled:NO color:[UIColor orangeColor]];  //orangeColor
            set3 = [self setLineDataSet:values3 labeltext:@"50th" isCirclesEnabled:NO color:[UIColor greenColor]];   //greenColor
            set4 = [self setLineDataSet:values4 labeltext:@"85th" isCirclesEnabled:NO color:[UIColor orangeColor]];  //orangeColor
            set5 = [self setLineDataSet:values5 labeltext:@"97th" isCirclesEnabled:NO color:[UIColor purpleColor]];//purpleColor
            set6 = [self setLineDataSet:values6 labeltext:@"儿童数据" isCirclesEnabled:YES color:[UIColor blackColor]];
            
            NSMutableArray *dataSets = [[NSMutableArray alloc] init];
            [dataSets addObject:set1];
            [dataSets addObject:set2];
            [dataSets addObject:set3];
            [dataSets addObject:set4];
            [dataSets addObject:set5];
            [dataSets addObject:set6];
            LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
            _chartView.data = data;
            for (id<ILineChartDataSet> set in _chartView.data.dataSets)
            {
                set.drawFilledEnabled = NO;
            }
            ChartYAxis *leftAxis = _chartView.leftAxis;
            [leftAxis removeAllLimitLines];
            //    [leftAxis addLimitLine:ll1];
            //    [leftAxis addLimitLine:ll2];
            leftAxis.axisMaximum = [valArr5.lastObject floatValue] +10;
            leftAxis.axisMinimum = [valArr1.firstObject floatValue] -10;
            leftAxis.gridLineDashLengths = @[@5.f, @5.f];
            leftAxis.drawZeroLineEnabled = NO;
            leftAxis.drawLimitLinesBehindDataEnabled = YES;
        }

        
        _chartView.rightAxis.enabled = NO;
        
    }else{   //Z评分
        _label2.text = @"Z评分解读：";
        NSArray *valArr6 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][5];
        NSArray *valArr7 = typeArr[self.StandardType.selectedSegmentIndex][self.ZorPercent.selectedSegmentIndex][chartage-1][childSex][6];
        if (whatTypeArr == 0) {
            for (CGHeight *heightItem in childmodel.heightArr) {
                double mouth = [[self getCompareAge:childmodel.age latestDay:heightItem.time] doubleValue];
                NSString *heightStr = [NSString stringWithFormat:@"%@", heightItem.height];
                double val = [heightStr doubleValue];
                [values8 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
            }
        }else if(whatTypeArr == 1){
            for (CGWeight *weightItem in childmodel.weightArr) {
                double mouth = [[self getCompareAge:childmodel.age latestDay:weightItem.time] doubleValue];
                NSString *weightStr = [NSString stringWithFormat:@"%@", weightItem.weight];
                double val = [weightStr doubleValue];
                [values8 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
            }
        }else if(whatTypeArr == 3){
            for (CGBMI *BMIItem in childmodel.BMIArr) {
                double mouth = [[self getCompareAge:childmodel.age latestDay:BMIItem.time] doubleValue];
                NSString *BMIStr = [NSString stringWithFormat:@"%@", BMIItem.value];
                double val = [BMIStr doubleValue];
                [values8 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
            }
        }else{
            for (CGHeadc *headcItem in childmodel.headcArr) {
                double mouth = [[self getCompareAge:childmodel.age latestDay:headcItem.time] doubleValue];
                NSString *headcStr = [NSString stringWithFormat:@"%@", headcItem.headc];
                double val = [headcStr doubleValue];
                [values8 addObject:[[ChartDataEntry alloc] initWithX:mouth y:val]];
            }
        }
        if (!self.StandardType.selectedSegmentIndex) {   //0WHO标准|9城市标准1
        switch (chartage) {
            case 1:{  //0-2岁
                for (int i= 0; i<25; i++) {
                    double val1 = [valArr1[i] doubleValue];
                    double val2 = [valArr2[i] doubleValue];
                    double val3 = [valArr3[i] doubleValue];
                    double val4 = [valArr4[i] doubleValue];
                    double val5 = [valArr5[i] doubleValue];
                    double val6 = [valArr6[i] doubleValue];
                    double val7 = [valArr7[i] doubleValue];
                    [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                    [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                    [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                    [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                    [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                    [values6 addObject:[[ChartDataEntry alloc] initWithX:i y:val6]];
                    [values7 addObject:[[ChartDataEntry alloc] initWithX:i y:val7]];
                }
                break;
            }
            case 2:    //0-5岁
            {
                for (int i= 0; i<60; i++) {
                    double val1 = [valArr1[i] doubleValue];
                    double val2 = [valArr2[i] doubleValue];
                    double val3 = [valArr3[i] doubleValue];
                    double val4 = [valArr4[i] doubleValue];
                    double val5 = [valArr5[i] doubleValue];
                    double val6 = [valArr6[i] doubleValue];
                    double val7 = [valArr7[i] doubleValue];
                    if (whatTypeArr == 0 || whatTypeArr == 3){
                        if(i>24){
                        [values1 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val1]];
                        [values2 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val2]];
                        [values3 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val3]];
                        [values4 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val4]];
                        [values5 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val5]];
                        [values6 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val6]];
                        [values7 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val7]];
                        }else{
                            [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                            [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                            [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                            [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                            [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                            [values6 addObject:[[ChartDataEntry alloc] initWithX:i y:val6]];
                            [values7 addObject:[[ChartDataEntry alloc] initWithX:i y:val7]];
                        }
                    }else{
                        [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                        [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                        [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                        [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                        [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                        [values6 addObject:[[ChartDataEntry alloc] initWithX:i y:val6]];
                        [values7 addObject:[[ChartDataEntry alloc] initWithX:i y:val7]];
                    }
                }
                break;
            }
            case 3:
            {
                if(whatTypeArr == 1){
                    for (int i= 0; i<120; i++) {
                        double val1 = [valArr1[i] doubleValue];
                        double val2 = [valArr2[i] doubleValue];
                        double val3 = [valArr3[i] doubleValue];
                        double val4 = [valArr4[i] doubleValue];
                        double val5 = [valArr5[i] doubleValue];
                        double val6 = [valArr6[i] doubleValue];
                        double val7 = [valArr7[i] doubleValue];
                        [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                        [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                        [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                        [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                        [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                        [values6 addObject:[[ChartDataEntry alloc] initWithX:i y:val6]];
                        [values7 addObject:[[ChartDataEntry alloc] initWithX:i y:val7]];
                }
                }
                else{
                for (int i= 0; i<216; i++) {
                    double val1 = [valArr1[i] doubleValue];
                    double val2 = [valArr2[i] doubleValue];
                    double val3 = [valArr3[i] doubleValue];
                    double val4 = [valArr4[i] doubleValue];
                    double val5 = [valArr5[i] doubleValue];
                    double val6 = [valArr6[i] doubleValue];
                    double val7 = [valArr7[i] doubleValue];
                    if (whatTypeArr == 0 || whatTypeArr == 3) {
                        if(i>24){
                        [values1 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val1]];
                        [values2 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val2]];
                        [values3 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val3]];
                        [values4 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val4]];
                        [values5 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val5]];
                        [values6 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val6]];
                        [values7 addObject:[[ChartDataEntry alloc] initWithX:i-1 y:val7]];
                        }else{
                        [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                        [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                        [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                        [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                        [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                        [values6 addObject:[[ChartDataEntry alloc] initWithX:i y:val6]];
                        [values7 addObject:[[ChartDataEntry alloc] initWithX:i y:val7]];
                        }
                    }else{
                        [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                        [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                        [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                        [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                        [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                        [values6 addObject:[[ChartDataEntry alloc] initWithX:i y:val6]];
                        [values7 addObject:[[ChartDataEntry alloc] initWithX:i y:val7]];
                    }
                }
                    }
                break;
            }
            case 4:
            {
                for (int i= 24; i<60; i++) {
                    double val1 = [valArr1[i-24] doubleValue];
                    double val2 = [valArr2[i-24] doubleValue];
                    double val3 = [valArr3[i-24] doubleValue];
                    double val4 = [valArr4[i-24] doubleValue];
                    double val5 = [valArr5[i-24] doubleValue];
                    double val6 = [valArr6[i-24] doubleValue];
                    double val7 = [valArr7[i-24] doubleValue];
                    [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                    [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                    [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                    [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                    [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                    [values6 addObject:[[ChartDataEntry alloc] initWithX:i y:val6]];
                    [values7 addObject:[[ChartDataEntry alloc] initWithX:i y:val7]];
                }
               break;
            }
            case 5:
            {
                if(whatTypeArr == 1){
                    for (int i= 24; i<120; i++) {
                        double val1 = [valArr1[i-24] doubleValue];
                        double val2 = [valArr2[i-24] doubleValue];
                        double val3 = [valArr3[i-24] doubleValue];
                        double val4 = [valArr4[i-24] doubleValue];
                        double val5 = [valArr5[i-24] doubleValue];
                        double val6 = [valArr6[i-24] doubleValue];
                        double val7 = [valArr7[i-24] doubleValue];
                        [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                        [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                        [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                        [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                        [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                        [values6 addObject:[[ChartDataEntry alloc] initWithX:i y:val6]];
                        [values7 addObject:[[ChartDataEntry alloc] initWithX:i y:val7]];
                    }
                }else{
                for (int i= 24; i<216; i++) {
                    double val1 = [valArr1[i-24] doubleValue];
                    double val2 = [valArr2[i-24] doubleValue];
                    double val3 = [valArr3[i-24] doubleValue];
                    double val4 = [valArr4[i-24] doubleValue];
                    double val5 = [valArr5[i-24] doubleValue];
                    double val6 = [valArr6[i-24] doubleValue];
                    double val7 = [valArr7[i-24] doubleValue];
                    [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                    [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                    [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                    [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                    [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                    [values6 addObject:[[ChartDataEntry alloc] initWithX:i y:val6]];
                    [values7 addObject:[[ChartDataEntry alloc] initWithX:i y:val7]];
                }
                }
                break;
            }
            case 6:     //5-18岁
            {
                if(whatTypeArr == 1){
                    for (int i= 60; i<120; i++) {
                        double val1 = [valArr1[i-60] doubleValue];
                        double val2 = [valArr2[i-60] doubleValue];
                        double val3 = [valArr3[i-60] doubleValue];
                        double val4 = [valArr4[i-60] doubleValue];
                        double val5 = [valArr5[i-60] doubleValue];
                        double val6 = [valArr6[i-60] doubleValue];
                        double val7 = [valArr7[i-60] doubleValue];
                        [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                        [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                        [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                        [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                        [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                        [values6 addObject:[[ChartDataEntry alloc] initWithX:i y:val6]];
                        [values7 addObject:[[ChartDataEntry alloc] initWithX:i y:val7]];
                    }
                }else{
                for (int i= 60; i<216; i++) {
                    double val1 = [valArr1[i-60] doubleValue];
                    double val2 = [valArr2[i-60] doubleValue];
                    double val3 = [valArr3[i-60] doubleValue];
                    double val4 = [valArr4[i-60] doubleValue];
                    double val5 = [valArr5[i-60] doubleValue];
                    double val6 = [valArr6[i-60] doubleValue];
                    double val7 = [valArr7[i-60] doubleValue];
                    [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:val1]];
                    [values2 addObject:[[ChartDataEntry alloc] initWithX:i y:val2]];
                    [values3 addObject:[[ChartDataEntry alloc] initWithX:i y:val3]];
                    [values4 addObject:[[ChartDataEntry alloc] initWithX:i y:val4]];
                    [values5 addObject:[[ChartDataEntry alloc] initWithX:i y:val5]];
                    [values6 addObject:[[ChartDataEntry alloc] initWithX:i y:val6]];
                    [values7 addObject:[[ChartDataEntry alloc] initWithX:i y:val7]];
                }
                }
                break;
            }
            default:
                break;
        }
        }else{    //9城市曲线数据
            int b,e;
            switch (chartage) {
                case 1:{   //0-2岁
                    b = 0;
                    e = 10;
                    break;
                }
                case 2:   //0-5
                {
                    b = 0;
                    e = 16;
                    break;
                }
                case 3:   //0-18
                {
                    b = 0;
                    e = 41;
                    break;
                }
                case 4:   //2-5
                {
                    b = 9;
                    e = 16;
                    break;
                }
                case 5:    //2-18
                {
                    b = 9;
                    e = 41;
                    break;
                }
                case 6:   //5-18
                {
                    b = 15;
                    e = 41;
                    break;
                }
                default:
                    break;
            }
            for (int i= b; i<e; i++) {
                double val1 = [valArr1[i-b] doubleValue];
                double val2 = [valArr2[i-b] doubleValue];
                double val3 = [valArr3[i-b] doubleValue];
                double val4 = [valArr4[i-b] doubleValue];
                double val5 = [valArr5[i-b] doubleValue];
                double val6 = [valArr6[i-b] doubleValue];
                double val7 = [valArr7[i-b] doubleValue];
                int j;
                if(i<=3){
                    j = i *2;
                }else if(i<=9){
                    j = (i-1) *3;
                }else if(i<=39){
                    j = (i-5) *6;
                }else{
                    j = 216;
                }
                [values1 addObject:[[ChartDataEntry alloc] initWithX:j y:val1]];
                [values2 addObject:[[ChartDataEntry alloc] initWithX:j y:val2]];
                [values3 addObject:[[ChartDataEntry alloc] initWithX:j y:val3]];
                [values4 addObject:[[ChartDataEntry alloc] initWithX:j y:val4]];
                [values5 addObject:[[ChartDataEntry alloc] initWithX:j y:val5]];
                [values6 addObject:[[ChartDataEntry alloc] initWithX:j y:val6]];
                [values7 addObject:[[ChartDataEntry alloc] initWithX:j y:val7]];
            }
//            switch (chartage) {
//                case 1:{  //0-2岁
//                    for (int i= 0; i<10; i++) {
//                        double val1 = [valArr1[i] doubleValue];
//                        double val2 = [valArr2[i] doubleValue];
//                        double val3 = [valArr3[i] doubleValue];
//                        double val4 = [valArr4[i] doubleValue];
//                        double val5 = [valArr5[i] doubleValue];
//                        double val6 = [valArr6[i] doubleValue];
//                        double val7 = [valArr7[i] doubleValue];
//                        int j;
//                        if(i<=3){
//                            j = i *2;
//                        }else{
//                            j = (i-1) *3;
//                        }
//                        [values1 addObject:[[ChartDataEntry alloc] initWithX:j y:val1]];
//                        [values2 addObject:[[ChartDataEntry alloc] initWithX:j y:val2]];
//                        [values3 addObject:[[ChartDataEntry alloc] initWithX:j y:val3]];
//                        [values4 addObject:[[ChartDataEntry alloc] initWithX:j y:val4]];
//                        [values5 addObject:[[ChartDataEntry alloc] initWithX:j y:val5]];
//                        [values6 addObject:[[ChartDataEntry alloc] initWithX:j y:val6]];
//                        [values7 addObject:[[ChartDataEntry alloc] initWithX:j y:val7]];
//                    }
//                    break;
//                }
//                case 2:    //0-5岁
//                {
//                    for (int i= 0; i<16; i++) {
//                        double val1 = [valArr1[i] doubleValue];
//                        double val2 = [valArr2[i] doubleValue];
//                        double val3 = [valArr3[i] doubleValue];
//                        double val4 = [valArr4[i] doubleValue];
//                        double val5 = [valArr5[i] doubleValue];
//                        double val6 = [valArr6[i] doubleValue];
//                        double val7 = [valArr7[i] doubleValue];
//                        int j;
//                        if(i<=3){
//                            j = i *2;
//                        }else if(i<=9){
//                            j = (i-1) *3;
//                        }else{
//                            j = (i-5) *6;
//                        }
//                        [values1 addObject:[[ChartDataEntry alloc] initWithX:j y:val1]];
//                        [values2 addObject:[[ChartDataEntry alloc] initWithX:j y:val2]];
//                        [values3 addObject:[[ChartDataEntry alloc] initWithX:j y:val3]];
//                        [values4 addObject:[[ChartDataEntry alloc] initWithX:j y:val4]];
//                        [values5 addObject:[[ChartDataEntry alloc] initWithX:j y:val5]];
//                        [values6 addObject:[[ChartDataEntry alloc] initWithX:j y:val6]];
//                        [values7 addObject:[[ChartDataEntry alloc] initWithX:j y:val7]];
//                    }
//                    break;
//                }
//                case 3:   //0-18
//                {
//                    
//                    for (int i= 0; i<41; i++) {
//                        double val1 = [valArr1[i] doubleValue];
//                        double val2 = [valArr2[i] doubleValue];
//                        double val3 = [valArr3[i] doubleValue];
//                        double val4 = [valArr4[i] doubleValue];
//                        double val5 = [valArr5[i] doubleValue];
//                        double val6 = [valArr6[i] doubleValue];
//                        double val7 = [valArr7[i] doubleValue];
//                        int j;
//                        if(i<=3){
//                            j = i *2;
//                        }else if(i<=9){
//                            j = (i-1) *3;
//                        }else if(i<=39){
//                            j = (i-5) *6;
//                        }else{
//                            j = 216;
//                        }
//                        [values1 addObject:[[ChartDataEntry alloc] initWithX:j y:val1]];
//                        [values2 addObject:[[ChartDataEntry alloc] initWithX:j y:val2]];
//                        [values3 addObject:[[ChartDataEntry alloc] initWithX:j y:val3]];
//                        [values4 addObject:[[ChartDataEntry alloc] initWithX:j y:val4]];
//                        [values5 addObject:[[ChartDataEntry alloc] initWithX:j y:val5]];
//                        [values6 addObject:[[ChartDataEntry alloc] initWithX:j y:val6]];
//                        [values7 addObject:[[ChartDataEntry alloc] initWithX:j y:val7]];
//                    }
//                    
//                    break;
//                }
//                case 4:     //2-5
//                {
//                    for (int i= 9 ; i<16; i++) {
//                        double val1 = [valArr1[i-9] doubleValue];
//                        double val2 = [valArr2[i-9] doubleValue];
//                        double val3 = [valArr3[i-9] doubleValue];
//                        double val4 = [valArr4[i-9] doubleValue];
//                        double val5 = [valArr5[i-9] doubleValue];
//                        double val6 = [valArr6[i-9] doubleValue];
//                        double val7 = [valArr7[i-9] doubleValue];
//                        int j = (i-5) *6;
//                        [values1 addObject:[[ChartDataEntry alloc] initWithX:j y:val1]];
//                        [values2 addObject:[[ChartDataEntry alloc] initWithX:j y:val2]];
//                        [values3 addObject:[[ChartDataEntry alloc] initWithX:j y:val3]];
//                        [values4 addObject:[[ChartDataEntry alloc] initWithX:j y:val4]];
//                        [values5 addObject:[[ChartDataEntry alloc] initWithX:j y:val5]];
//                        [values6 addObject:[[ChartDataEntry alloc] initWithX:j y:val6]];
//                        [values7 addObject:[[ChartDataEntry alloc] initWithX:j y:val7]];
//                    }
//                    break;
//                }
//                case 5:     //2-18
//                {
//                    for (int i= 9 ; i<41; i++) {
//                        double val1 = [valArr1[i-9] doubleValue];
//                        double val2 = [valArr2[i-9] doubleValue];
//                        double val3 = [valArr3[i-9] doubleValue];
//                        double val4 = [valArr4[i-9] doubleValue];
//                        double val5 = [valArr5[i-9] doubleValue];
//                        double val6 = [valArr6[i-9] doubleValue];
//                        double val7 = [valArr7[i-9] doubleValue];
//                        int j ;
//                        if(i<=39){
//                            j = (i-5) *6;
//                        }else{
//                            j = 216;
//                        }
//                        [values1 addObject:[[ChartDataEntry alloc] initWithX:j y:val1]];
//                        [values2 addObject:[[ChartDataEntry alloc] initWithX:j y:val2]];
//                        [values3 addObject:[[ChartDataEntry alloc] initWithX:j y:val3]];
//                        [values4 addObject:[[ChartDataEntry alloc] initWithX:j y:val4]];
//                        [values5 addObject:[[ChartDataEntry alloc] initWithX:j y:val5]];
//                        [values6 addObject:[[ChartDataEntry alloc] initWithX:j y:val6]];
//                        [values7 addObject:[[ChartDataEntry alloc] initWithX:j y:val7]];
//                    }
//                    break;
//                }
//                case 6:     //5-18岁
//                {
//                    for (int i= 15 ; i<41; i++) {
//                        double val1 = [valArr1[i-15] doubleValue];
//                        double val2 = [valArr2[i-15] doubleValue];
//                        double val3 = [valArr3[i-15] doubleValue];
//                        double val4 = [valArr4[i-15] doubleValue];
//                        double val5 = [valArr5[i-15] doubleValue];
//                        double val6 = [valArr6[i-15] doubleValue];
//                        double val7 = [valArr7[i-15] doubleValue];
//                        int j ;
//                        if(i<=39){
//                            j = (i-5) *6;
//                        }else{
//                            j = 216;
//                        }
//                        [values1 addObject:[[ChartDataEntry alloc] initWithX:j y:val1]];
//                        [values2 addObject:[[ChartDataEntry alloc] initWithX:j y:val2]];
//                        [values3 addObject:[[ChartDataEntry alloc] initWithX:j y:val3]];
//                        [values4 addObject:[[ChartDataEntry alloc] initWithX:j y:val4]];
//                        [values5 addObject:[[ChartDataEntry alloc] initWithX:j y:val5]];
//                        [values6 addObject:[[ChartDataEntry alloc] initWithX:j y:val6]];
//                        [values7 addObject:[[ChartDataEntry alloc] initWithX:j y:val7]];
//                    }
//                     break;
//                }
//                default:
//                    break;
//            }
        }
        set1 = [self setLineDataSet:values1 labeltext:@"-3SD" isCirclesEnabled:NO color:[UIColor blackColor]];
        set2 = [self setLineDataSet:values2 labeltext:@"-2SD" isCirclesEnabled:NO color:[UIColor purpleColor]];
        set3 = [self setLineDataSet:values3 labeltext:@"-1SD" isCirclesEnabled:NO color:[UIColor orangeColor]];
        set4 = [self setLineDataSet:values4 labeltext:@"中位数" isCirclesEnabled:NO color:[UIColor greenColor]];
        set5 = [self setLineDataSet:values5 labeltext:@"1SD" isCirclesEnabled:NO color:[UIColor orangeColor]];
        set6 = [self setLineDataSet:values6 labeltext:@"2SD" isCirclesEnabled:NO color:[UIColor purpleColor]];
        set7 = [self setLineDataSet:values7 labeltext:@"3SD" isCirclesEnabled:NO color:[UIColor blackColor]];
        set8 = [self setLineDataSet:values8 labeltext:@"儿童数据" isCirclesEnabled:YES color:[UIColor blackColor]];
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        [dataSets addObject:set2];
        [dataSets addObject:set3];
        [dataSets addObject:set4];
        [dataSets addObject:set5];
        [dataSets addObject:set6];
        [dataSets addObject:set7];
        [dataSets addObject:set8];
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        _chartView.data = data;
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawFilledEnabled = NO;
        }
        //儿童测量数据组
//        TWRDataSet *dataSet8 = [[TWRDataSet alloc] initWithDataPoints:@[@"0",@"20"]];
//        TWRLineChart *line = [[TWRLineChart alloc] initWithLabels:labels dataSets:@[dataSet1, dataSet2, dataSet3, dataSet4, dataSet5,dataSet6,dataSet7,dataSet8] animated:NO];
        ChartYAxis *leftAxis = _chartView.leftAxis;
        [leftAxis removeAllLimitLines];
        //    [leftAxis addLimitLine:ll1];
        //    [leftAxis addLimitLine:ll2];
        leftAxis.axisMaximum = [valArr7.lastObject floatValue] +10;
        leftAxis.axisMinimum = [valArr1.firstObject floatValue] -10;
        leftAxis.gridLineDashLengths = @[@5.f, @5.f];
        leftAxis.drawZeroLineEnabled = NO;
        leftAxis.drawLimitLinesBehindDataEnabled = YES;
        
        _chartView.rightAxis.enabled = NO;
    }
 
    //设置最小显示值
//    self.chartView.leftAxis.axisMinValue = 20;
    
    //超过多少百分比计算。
    NSArray *valArr6;
    NSArray *valArr7;
    if (whatTypeArr == 2) {
//        valArr1 = typeArr[self.StandardType.selectedSegmentIndex][1][1][childSex][0];
//        valArr2 = typeArr[self.StandardType.selectedSegmentIndex][1][1][childSex][1];
//        valArr3 = typeArr[self.StandardType.selectedSegmentIndex][1][1][childSex][2];
//        valArr4 = typeArr[self.StandardType.selectedSegmentIndex][1][1][childSex][3];
//        valArr5 = typeArr[self.StandardType.selectedSegmentIndex][1][1][childSex][4];
        valArr1 = typeArr[0][1][1][childSex][0];
        valArr2 = typeArr[0][1][1][childSex][1];
        valArr3 = typeArr[0][1][1][childSex][2];
        valArr4 = typeArr[0][1][1][childSex][3];
        valArr5 = typeArr[0][1][1][childSex][4];
    }else{
//        valArr1 = typeArr[self.StandardType.selectedSegmentIndex][1][2][childSex][0];
//        valArr2 = typeArr[self.StandardType.selectedSegmentIndex][1][2][childSex][1];
//        valArr3 = typeArr[self.StandardType.selectedSegmentIndex][1][2][childSex][2];
//        valArr4 = typeArr[self.StandardType.selectedSegmentIndex][1][2][childSex][3];
//        valArr5 = typeArr[self.StandardType.selectedSegmentIndex][1][2][childSex][4];
        if(!self.StandardType.selectedSegmentIndex){  //0 ->WHO标准
        valArr1 = typeArr[0][1][2][childSex][0];
        valArr2 = typeArr[0][1][2][childSex][1];
        valArr3 = typeArr[0][1][2][childSex][2];
        valArr4 = typeArr[0][1][2][childSex][3];
        valArr5 = typeArr[0][1][2][childSex][4];
        }else{
        valArr1 = typeArr[1][1][2][childSex][0];
        valArr2 = typeArr[1][1][2][childSex][1];
        valArr3 = typeArr[1][1][2][childSex][2];
        valArr4 = typeArr[1][1][2][childSex][3];
        valArr5 = typeArr[1][1][2][childSex][4];
        valArr6 = typeArr[1][1][2][childSex][5];
        valArr7 = typeArr[1][1][2][childSex][6];
        }
    }
     int count = valArr1.count;
    float child_p;
    switch (whatTypeArr) {
        case 0:{
            CGHeight *lastheight= childmodel.heightArr.lastObject;
            NSString *lastheightStr = [NSString stringWithFormat:@"%@", lastheight.height];
            int mouth = [[self getCompareAge:childmodel.age latestDay:lastheight.time] intValue];
            float min_p = 0;
            float max_p = 0;
            float min = 0;
            float max = 0;
            
            if(!self.StandardType.selectedSegmentIndex){
                NSNumber *v1 = valArr1[mouth];
                NSNumber *v2 = valArr2[mouth];
                NSNumber *v3 = valArr3[mouth];
                NSNumber *v4 = valArr4[mouth];
                NSNumber *v5 = valArr5[mouth];
            if (mouth <= count) {
                if([lastheight.height compare:v1] >= 0 && [lastheight.height compare:v2] ==-1){
                    min_p = 3;
                    max_p = 15;
                    min = [v1 floatValue];
                    max = [v2 floatValue];
                }else if([lastheight.height compare:v2] >= 0 && [lastheight.height compare:v3] ==-1){
                    min_p = 15;
                    max_p = 50;
                    min = [v2 floatValue];
                    max = [v3 floatValue];
                }else if([lastheight.height compare:v3] >= 0 && [lastheight.height compare:v4] ==-1){
                    min_p = 50;
                    max_p = 85;
                    min = [v3 floatValue];
                    max = [v4 floatValue];
                }else if([lastheight.height compare:v4] >= 0 && [lastheight.height compare:v5] ==-1){
                    min_p = 85;
                    max_p = 97;
                    min = [v4 floatValue];
                    max = [v5 floatValue];
                }else if([lastheight.height compare:v5] >= 0){
                    min_p = 97;
                    max_p = 100;
                    min = [v5 floatValue];
                    max = [v5 floatValue] + 3;
                }else{
                    min_p = 0;
                    max_p = 3;
                    min = [v1 floatValue] - 3;
                    max = [v1 floatValue];
                }
                }
            }else{
                int mouthArr = [self chinaMouthToArr:mouth];
                NSNumber *v1 = valArr1[mouthArr];
                NSNumber *v2 = valArr2[mouthArr];
                NSNumber *v3 = valArr3[mouthArr];
                NSNumber *v4 = valArr4[mouthArr];
                NSNumber *v5 = valArr5[mouthArr];
                NSNumber *v6 = valArr6[mouthArr];
                NSNumber *v7 = valArr7[mouthArr];
                if (mouthArr <= count) {
                    if([lastheight.height compare:v1] >= 0 && [lastheight.height compare:v2] ==-1){
                        min_p = 3;
                        max_p = 10;
                        min = [v1 floatValue];
                        max = [v2 floatValue];
                    }else if([lastheight.height compare:v2] >= 0 && [lastheight.height compare:v3] ==-1){
                        min_p = 10;
                        max_p = 25;
                        min = [v2 floatValue];
                        max = [v3 floatValue];
                    }else if([lastheight.height compare:v3] >= 0 && [lastheight.height compare:v4] ==-1){
                        min_p = 25;
                        max_p = 50;
                        min = [v3 floatValue];
                        max = [v4 floatValue];
                    }else if([lastheight.height compare:v4] >= 0 && [lastheight.height compare:v5] ==-1){
                        min_p = 50;
                        max_p = 75;
                        min = [v4 floatValue];
                        max = [v5 floatValue];
                    }else if([lastheight.height compare:v5] >= 0 && [lastheight.height compare:v6] ==-1){
                        min_p = 75;
                        max_p = 90;
                        min = [v5 floatValue];
                        max = [v6 floatValue] ;
                    }else if([lastheight.height compare:v6] >= 0 && [lastheight.height compare:v7] ==-1){
                        min_p = 90;
                        max_p = 97;
                        min = [v6 floatValue];
                        max = [v7 floatValue];
                    }else if([lastheight.height compare:v7] >= 0){
                        min_p = 97;
                        max_p = 100;
                        min = [v5 floatValue];
                        max = [v5 floatValue] + 3;
                    }else{
                        min_p = 0;
                        max_p = 3;
                        min = [v1 floatValue] - 3;
                        max = [v1 floatValue];
                    }
                }
            }
            child_p = ([lastheight.height floatValue] - min)*(max_p - min_p)/(max - min) +min_p;
            if (child_p < 0) {
                child_p = 0;
            }else if (child_p > 100){
            child_p = 100;
            }
            self.label.text = [NSString stringWithFormat:@"当前身高%@cm \n 超过%.1f%%的同龄儿童",lastheightStr,child_p];
//            self.label1.text =[NSString stringWithFormat:@"%@发育不太理想，身高偏矮，属于中下等，请保持持续观察",childmodel.name];
            break;
        }
        case 1:{
            CGWeight *lastweight= childmodel.weightArr.lastObject;
            NSString *lastweightStr = [NSString stringWithFormat:@"%@", lastweight.weight];
            int mouth = [[self getCompareAge:childmodel.age latestDay:lastweight.time] intValue];
            
            float min_p = 0;
            float max_p = 0;
            float min = 0;
            float max = 1;
            
            if(!self.StandardType.selectedSegmentIndex){
                if (mouth <=121) {
                    NSNumber *v1 = valArr1[mouth];
                    NSNumber *v2 = valArr2[mouth];
                    NSNumber *v3 = valArr3[mouth];
                    NSNumber *v4 = valArr4[mouth];
                    NSNumber *v5 = valArr5[mouth];
                    
            
                if([lastweight.weight compare:v1] >= 0 && [lastweight.weight compare:v2] ==-1){
                    min_p = 3;
                    max_p = 15;
                    min = [v1 floatValue];
                    max = [v2 floatValue];
                }else if([lastweight.weight compare:v2] >= 0 && [lastweight.weight compare:v3] ==-1){
                    min_p = 15;
                    max_p = 50;
                    min = [v2 floatValue];
                    max = [v3 floatValue];
                }else if([lastweight.weight compare:v3] >= 0 && [lastweight.weight compare:v4] ==-1){
                    min_p = 50;
                    max_p = 85;
                    min = [v3 floatValue];
                    max = [v4 floatValue];
                }else if([lastweight.weight compare:v4] >= 0 && [lastweight.weight compare:v5] ==-1){
                    min_p = 85;
                    max_p = 97;
                    min = [v4 floatValue];
                    max = [v5 floatValue];
                }else if([lastweight.weight compare:v5] >= 0){
                    min_p = 97;
                    max_p = 100;
                    min = [v5 floatValue];
                    max = [v5 floatValue] + 3;
                }else{
                    min_p = 0;
                    max_p = 3;
                    min = [v1 floatValue] - 3;
                    max = [v1 floatValue];
                }
            }
            }else{
                int mouthArr = [self chinaMouthToArr:mouth];
                NSNumber *v1 = valArr1[mouthArr];
                NSNumber *v2 = valArr2[mouthArr];
                NSNumber *v3 = valArr3[mouthArr];
                NSNumber *v4 = valArr4[mouthArr];
                NSNumber *v5 = valArr5[mouthArr];
                NSNumber *v6 = valArr6[mouthArr];
                NSNumber *v7 = valArr7[mouthArr];
                if (mouthArr <= count) {
                    if([lastweight.weight compare:v1] >= 0 && [lastweight.weight compare:v2] ==-1){
                        min_p = 3;
                        max_p = 10;
                        min = [v1 floatValue];
                        max = [v2 floatValue];
                    }else if([lastweight.weight compare:v2] >= 0 && [lastweight.weight compare:v3] ==-1){
                        min_p = 10;
                        max_p = 25;
                        min = [v2 floatValue];
                        max = [v3 floatValue];
                    }else if([lastweight.weight compare:v3] >= 0 && [lastweight.weight compare:v4] ==-1){
                        min_p = 25;
                        max_p = 50;
                        min = [v3 floatValue];
                        max = [v4 floatValue];
                    }else if([lastweight.weight compare:v4] >= 0 && [lastweight.weight compare:v5] ==-1){
                        min_p = 50;
                        max_p = 75;
                        min = [v4 floatValue];
                        max = [v5 floatValue];
                    }else if([lastweight.weight compare:v5] >= 0 && [lastweight.weight compare:v6] ==-1){
                        min_p = 75;
                        max_p = 90;
                        min = [v5 floatValue];
                        max = [v6 floatValue] ;
                    }else if([lastweight.weight compare:v6] >= 0 && [lastweight.weight compare:v7] ==-1){
                        min_p = 90;
                        max_p = 97;
                        min = [v6 floatValue];
                        max = [v7 floatValue];
                    }else if([lastweight.weight compare:v7] >= 0){
                        min_p = 97;
                        max_p = 100;
                        min = [v5 floatValue];
                        max = [v5 floatValue] + 3;
                    }else{
                        min_p = 0;
                        max_p = 3;
                        min = [v1 floatValue] - 3;
                        max = [v1 floatValue];
                    }
                }
            }
            child_p = ([lastweight.weight floatValue] - min)*(max_p - min_p)/(max - min) +min_p;
            if (child_p < 0) {
                child_p = 0;
            }else if (child_p > 100){
                child_p = 100;
            }
            self.label.text = [NSString stringWithFormat:@"当前体重%@kg \n 超过%.1f%%的同龄儿童",lastweightStr,child_p];
//            self.label1.text =[NSString stringWithFormat:@"%@的身高较高，属于中上等，发育较早，请保持持续观察",childmodel.name];
            break;
        }
        case 2:{
            CGHeadc *lastheadc= childmodel.headcArr.lastObject;
            NSString *lastheadcStr = [NSString stringWithFormat:@"%.1f",[lastheadc.headc floatValue]];
            int mouth = [[self getCompareAge:childmodel.age latestDay:lastheadc.time] intValue];
            float min_p = 0;
            float max_p = 0;
            float min = 0;
            float max = 1;
            if (mouth <=61){
            NSNumber *v1 = valArr1[mouth];
            NSNumber *v2 = valArr2[mouth];
            NSNumber *v3 = valArr3[mouth];
            NSNumber *v4 = valArr4[mouth];
            NSNumber *v5 = valArr5[mouth];
            
            if (mouth <= count) {
                if([lastheadc.headc compare:v1] >= 0 && [lastheadc.headc compare:v2] ==-1){
                    min_p = 3;
                    max_p = 15;
                    min = [v1 floatValue];
                    max = [v2 floatValue];
                }else if([lastheadc.headc compare:v2] >= 0 && [lastheadc.headc compare:v3] ==-1){
                    min_p = 15;
                    max_p = 50;
                    min = [v2 floatValue];
                    max = [v3 floatValue];
                }else if([lastheadc.headc compare:v3] >= 0 && [lastheadc.headc compare:v4] ==-1){
                    min_p = 50;
                    max_p = 85;
                    min = [v3 floatValue];
                    max = [v4 floatValue];
                }else if([lastheadc.headc compare:v4] >= 0 && [lastheadc.headc compare:v5] ==-1){
                    min_p = 85;
                    max_p = 97;
                    min = [v4 floatValue];
                    max = [v5 floatValue];
                }else if([lastheadc.headc compare:v5] >= 0){
                    min_p = 97;
                    max_p = 100;
                    min = [v5 floatValue];
                    max = [v5 floatValue] + 3;
                }else{
                    min_p = 0;
                    max_p = 3;
                    min = [v1 floatValue] - 3;
                    max = [v1 floatValue];
                }
            }
            }
            child_p = ([lastheadc.headc floatValue] - min)*(max_p - min_p)/(max - min) +min_p;
            if (child_p < 0) {
                child_p = 0;
            }else if (child_p > 100){
                child_p = 100;
            }
            self.label.text = [NSString stringWithFormat:@"当前头围%@cm \n 超过%.1f%%的同龄儿童",lastheadcStr,child_p];
//            self.label1.text =[NSString stringWithFormat:@"%@的身高较高，属于中上等，发育较早，请保持持续观察",childmodel.name];
            break;
        }
        case 3:{
            CGBMI *lastBMI= childmodel.BMIArr.lastObject;
            NSString *lastBMIStr = [NSString stringWithFormat:@"%@", lastBMI.value];
            int mouth = [[self getCompareAge:childmodel.age latestDay:lastBMI.time] intValue];
            
            NSNumber *v1 = valArr1[mouth];
            NSNumber *v2 = valArr2[mouth];
            NSNumber *v3 = valArr3[mouth];
            NSNumber *v4 = valArr4[mouth];
            NSNumber *v5 = valArr5[mouth];
            float min_p = 0;
            float max_p = 0;
            float min = 0;
            float max = 0;
            if(!self.StandardType.selectedSegmentIndex){
            if (mouth <= count) {
                if([lastBMI.value compare:v1] >= 0 && [lastBMI.value compare:v2] ==-1){
                    min_p = 3;
                    max_p = 15;
                    min = [v1 floatValue];
                    max = [v2 floatValue];
                }else if([lastBMI.value compare:v2] >= 0 && [lastBMI.value compare:v3] ==-1){
                    min_p = 15;
                    max_p = 50;
                    min = [v2 floatValue];
                    max = [v3 floatValue];
                }else if([lastBMI.value compare:v3] >= 0 && [lastBMI.value compare:v4] ==-1){
                    min_p = 50;
                    max_p = 85;
                    min = [v3 floatValue];
                    max = [v4 floatValue];
                }else if([lastBMI.value compare:v4] >= 0 && [lastBMI.value compare:v5] ==-1){
                    min_p = 85;
                    max_p = 97;
                    min = [v4 floatValue];
                    max = [v5 floatValue];
                }else if([lastBMI.value compare:v5] >= 0){
                    min_p = 97;
                    max_p = 100;
                    min = [v5 floatValue];
                    max = [v5 floatValue] + 3;
                }else{
                    min_p = 0;
                    max_p = 3;
                    min = [v1 floatValue] - 3;
                    max = [v1 floatValue];
                }
            }
            }else{
                NSNumber *v6 = valArr6[mouth];
                NSNumber *v7 = valArr7[mouth];
                if (mouth <= count) {
                    if([lastBMI.value compare:v1] >= 0 && [lastBMI.value compare:v2] ==-1){
                        min_p = 3;
                        max_p = 10;
                        min = [v1 floatValue];
                        max = [v2 floatValue];
                    }else if([lastBMI.value compare:v2] >= 0 && [lastBMI.value compare:v3] ==-1){
                        min_p = 10;
                        max_p = 25;
                        min = [v2 floatValue];
                        max = [v3 floatValue];
                    }else if([lastBMI.value compare:v3] >= 0 && [lastBMI.value compare:v4] ==-1){
                        min_p = 25;
                        max_p = 50;
                        min = [v3 floatValue];
                        max = [v4 floatValue];
                    }else if([lastBMI.value compare:v4] >= 0 && [lastBMI.value compare:v5] ==-1){
                        min_p = 50;
                        max_p = 75;
                        min = [v4 floatValue];
                        max = [v5 floatValue];
                    }else if([lastBMI.value compare:v5] >= 0 && [lastBMI.value compare:v6] ==-1){
                        min_p = 75;
                        max_p = 90;
                        min = [v5 floatValue];
                        max = [v6 floatValue] ;
                    }else if([lastBMI.value compare:v6] >= 0 && [lastBMI.value compare:v7] ==-1){
                        min_p = 90;
                        max_p = 97;
                        min = [v6 floatValue];
                        max = [v7 floatValue];
                    }else if([lastBMI.value compare:v7] >= 0){
                        min_p = 97;
                        max_p = 100;
                        min = [v5 floatValue];
                        max = [v5 floatValue] + 3;
                    }else{
                        min_p = 0;
                        max_p = 3;
                        min = [v1 floatValue] - 3;
                        max = [v1 floatValue];
                    }
                }
            }
            child_p = ([lastBMI.value floatValue] - min)*(max_p - min_p)/(max - min) +min_p;
            if (child_p < 0) {
                child_p = 0;
            }else if (child_p > 100){
                child_p = 100;
            }
            self.label.text = [NSString stringWithFormat:@"当前BMI%@ \n 超过%.1f%%的同龄儿童",lastBMIStr,child_p];
//            self.label1.text =[NSString stringWithFormat:@"综合身高、体重来看%@的体型发育属于中等水平，发育良好，请保持持续观察",childmodel.name];
            break;
        }
        default:
            break;
    }
    int point;
    if(child_p <3){
        point = 0;
    }else if (child_p <10){
    point = 1;
    }else if (child_p <25){
        point = 2;
    }else if (child_p <75){
        point = 3;
    }else if (child_p <90){
        point = 4;
    }else if (child_p <97){
        point = 5;
    }else{
        point = 6;
    }
    if(self.ZorPercent.selectedSegmentIndex){
        [self.scrollView addSubview:self.pimage];
        self.label1.text =[NSString stringWithFormat:@"      %@的%@",childmodel.name,self.percentUnscramble[whatTypeArr][point]];
        self.label1.font = [UIFont fontWithName:@"Arial" size:16.0f];
        CGFloat lab1Height = [self getHeightByWidth:self.view.bounds.size.width-20 title:self.label1.text font:self.label1.font];
        self.label1.frame = CGRectMake(10,CGRectGetMaxY(self.pimage.frame)+20, self.view.bounds.size.width-20,lab1Height);
        self.pimage.percent = child_p;
        if (!self.StandardType.selectedSegmentIndex) {
            self.label3.text = @"本次评测百分位数据参照\n 《世界卫生组织儿童生长发育标准（2006年版）》";
        }else{
            self.label3.text = @"本次评测百分位数据参照\n 《中国0-18岁青少年身高、体重、BMI的生长曲线（2009）》";
        }
        [self.scrollView addSubview:self.label3];
    }else{
        self.label1.font = [UIFont fontWithName:@"Arial" size:14.0f];
    self.label1.text =[NSString stringWithFormat:@"%@",self.percentUnscramble[4]];
        [self.pimage removeFromSuperview];
    CGFloat lab1Height = [self getHeightByWidth:self.view.bounds.size.width-20 title:self.label1.text font:self.label1.font];
    self.label1.frame = CGRectMake(10,CGRectGetMaxY(self.label2.frame)+10, self.view.bounds.size.width-20,lab1Height);
        [self.label3 removeFromSuperview];
       	
    }
    
    
    [self.scrollView addSubview:self.label1];

}
-(int)chinaMouthToArr:(int)mouth{
    int mouthArr;
    if (mouth <=6) {
        mouthArr = mouth/2;
    }else if (mouth <=21){
        mouthArr = mouth/3 +1;
    }else {
        mouthArr = mouth/6 +5;
    }
    return mouthArr;
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.TypeArr.count;
//    }
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return  80;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc]init];
//    // 设置cell右边的指示样式
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//
//    //    // 取出indexPath.row对应的模型
//        // 设置数据
//        cell.textLabel.text = [self.TypeArr[indexPath.row] objectForKey:@"text"];
//        NSString *icon = [self.TypeArr[indexPath.row] objectForKey:@"icon"];
//        cell.imageView.image = [UIImage imageNamed:icon];
//
//    return cell;
//}
//点击或选中后执行
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"****************%ld",(long)self.StandardType.selectedSegmentIndex);
//    CGDetailViewController *detailVC = [CGDetailViewController initWithIndexpath:indexPath StandardType:self.StandardType.selectedSegmentIndex ZorPercent:self.ZorPercent.selectedSegmentIndex];
//    [self.navigationController pushViewController:detailVC animated:YES];
//
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)StandardTypeChange:(id)sender {
    [self.ChartType setEnabled:YES forSegmentAtIndex:2];
    [self.ChartType setEnabled:YES forSegmentAtIndex:3];
    if (self.StandardType.selectedSegmentIndex) {    //中国
        [self.ChartType setEnabled:NO forSegmentAtIndex:2];
        if (!self.ZorPercent.selectedSegmentIndex) {
            [self.ChartType setEnabled:NO forSegmentAtIndex:3];
        }
    }

    [self reloadall];
}

- (IBAction)ZorPercentChange:(id)sender {
    [self.ChartType setEnabled:YES forSegmentAtIndex:2];
    [self.ChartType setEnabled:YES forSegmentAtIndex:3];
    if (self.StandardType.selectedSegmentIndex) {
        [self.ChartType setEnabled:NO forSegmentAtIndex:2];
        if (!self.ZorPercent.selectedSegmentIndex) {
            [self.ChartType setEnabled:NO forSegmentAtIndex:3];
        }
    }
    [self reloadall];
}

- (IBAction)CharttpyeChange:(id)sender {
     self.InputBtn.enabled = YES;
    [self.StandardType setEnabled:YES forSegmentAtIndex:1];
    [self.ZorPercent setEnabled:YES forSegmentAtIndex:1];
    switch (self.ChartType.selectedSegmentIndex) {
        case 0:
            
            [self.InputBtn setTitle:@"添加身高数据" forState:UIControlStateNormal];
            break;
        case 1:

            [self.InputBtn setTitle:@"添加体重数据" forState:UIControlStateNormal];
            break;
        case 2:
            [self.StandardType setEnabled:NO forSegmentAtIndex:1];
            [self.InputBtn setTitle:@"添加头围数据" forState:UIControlStateNormal];
            break;
        case 3:
        {
            self.InputBtn.enabled = NO;
            [self.InputBtn setTitle:@"不需输入" forState:UIControlStateNormal];
            if (self.StandardType.selectedSegmentIndex) {
                [self.ZorPercent setEnabled:NO forSegmentAtIndex:1];
            }
            if (!self.ZorPercent.selectedSegmentIndex) {
                [self.StandardType setEnabled:NO forSegmentAtIndex:1];
            }
            break;
        }
        default:
            break;
    }
    [self reloadall];
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
//whattype    0:height   1`:weight   2:headc
-(void)isEarlythanbirthorOverrange:(NSString *)time birthday:(NSString *)birthtime whattype:(int)whattype value:(NSNumber *)value{
    int mouth =[[self getCompareAge:birthtime latestDay:time] intValue];
    if(mouth <0){
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入日期不能早于出生日期！" preferredStyle:UIAlertControllerStyleAlert];
    //    UIPreviewActionStyleDefault=0 UIPreviewActionStyleSelected,UIPreviewActionStyleDestructive,
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIPreviewActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    //弹出提示框
    [self presentModalViewController:alert animated:true];
    }else{

        switch (whattype) {
            case 0:{
               float max = [self.heightdataArr[0][0][2][0][6][mouth] floatValue] +30;  //最大值
               float min = [self.heightdataArr[0][0][2][0][0][mouth] floatValue] -30;  //最小值
                if ([value floatValue] >max) {
                    //初始化提示框
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请正确输入身高数据！" preferredStyle:UIAlertControllerStyleAlert];
                    //    UIPreviewActionStyleDefault=0 UIPreviewActionStyleSelected,UIPreviewActionStyleDestructive,
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIPreviewActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    //弹出提示框
                    [self presentModalViewController:alert animated:true];
                }
                break;
            }
            case 1:{
                
                break;
            }
            case 2:{
                if ([value floatValue] <25) {
                    //初始化提示框
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请正确输入头围数据！" preferredStyle:UIAlertControllerStyleAlert];
                    //    UIPreviewActionStyleDefault=0 UIPreviewActionStyleSelected,UIPreviewActionStyleDestructive,
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIPreviewActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    //弹出提示框
                    [self presentModalViewController:alert animated:true];
                }
                break;
            }
            default:
                break;
        }
    }
}
// type--- 0:height  1:weight  2:headc  3:BMI
-(void)postEditData:(NSNumber *)data importtime:(NSString *)importtime type:(int)type childId:(NSString *)childId{
//    NSString *token = [self readNSUserDefaultstoken];
    NSString *parm;
    switch (type) {
        case 0:
            parm =@"height";
            break;
        case 1:
            parm =@"weight";
            break;
        case 2:
            parm =@"headc";
            break;
        case 3:
            parm =@"bmi";
            break;
        default:
            break;
    }
   
    NSString *newImporttime = [self dataStringfromDataString:importtime];
//    NSNumber *childID = [NSNumber numberWithInteger:childId];
//    NSString *userAccount = @"123456";
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.利用AFN管理者发送请求
    NSDictionary *params = @{
                             @"parm" : parm,
                             @"data" : data,
                             @"childID" : childId,
                             @"importTime" : newImporttime,
                             @"token" : self.token
                             };
    [manager POST:@"http://192.168.1.121/childGrow/Mobile/dataEdit" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        dispatch_semaphore_signal(semaphore);
        NSLog(@"请求成功---%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
    }];
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //post
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSString *urlstring = [NSString stringWithFormat:@"http://192.168.1.121/childGrow/Mobile/dataEdit"];
//    NSURL *url = [NSURL URLWithString:urlstring];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
//    NSString *parmStr = [NSString stringWithFormat:@"parm=%@&data=%@&childID=%@&importTime=%@&token=%@",parm,data,childId,importtime,token];
//    NSData *data1 = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data1];
//    [request setHTTPMethod:@"POST"];
//    //    [NSURLConnection connectionWithRequest:request delegate:self];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (data != nil) {
//            //解析数据
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"*****************%@",dict);
//        }
//        
//    }];
//    [dataTask resume];
}
// type--- 0:height  1:weight  2:headc  3:BMI
-(void)postdata:(NSNumber *)data importtime:(NSString *)importtime type:(int)type childId:(NSString *)childId BirthDate:(NSString *)birthdate{
//    NSString *token = [self readNSUserDefaultstoken];
    NSString *parm;
    switch (type) {
        case 0:
            parm =@"height";
            break;
        case 1:
            parm =@"weight";
            break;
        case 2:
            parm =@"headc";
            break;
        case 3:
            parm =@"bmi";
            break;
        default:
            break;
    }
    NSString *newImporttime = [self dataStringfromDataString:importtime];
    NSString *newBirthdate = [self dataStringfromDataString:birthdate];
    // 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.利用AFN管理者发送请求
    NSDictionary *params = @{
                             @"parm" : parm,
                             @"data" : data,
                             @"userAccount" : self.userAccount,
                             @"childID" : childId,
                             @"importTime" : newImporttime,
                             @"token" : self.token,
                             @"childBirthdate":newBirthdate
                             };
    [manager POST:@"http://192.168.1.121/childGrow/Mobile/dataAdd" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
    }];
    //post
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSString *urlstring = [NSString stringWithFormat:@"http://192.168.1.121/childGrow/Mobile/dataAdd"];
//    NSURL *url = [NSURL URLWithString:urlstring];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
//    NSString *parmStr = [NSString stringWithFormat:@"parm=%@&data=%@&userAccount=%@&childID=%@&importTime=%@&token=%@",parm,data,self.userAccount,childId,importtime,self.token];
//    NSData *data1 = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data1];
//    [request setHTTPMethod:@"POST"];
//    //    [NSURLConnection connectionWithRequest:request delegate:self];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (data != nil) {
//            //解析数据
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"*****************%@",dict);
//        }
//        
//    }];
//    [dataTask resume];
}
-(void)postDelete:(NSString *)importtime childId:(NSString *)childId{
    NSString *newImporttime = [self dataStringfromDataString:importtime];
    // 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.利用AFN管理者发送请求
    NSDictionary *params = @{
                             @"childID" : childId,
                             @"importTime" : newImporttime,
                             @"token" : self.token
                             };
    [manager POST:@"http://192.168.1.121/childGrow/Mobile/dataDelete" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
    }];

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
//判断是否有同一天的任何数据0:height  1:weight  2:headc  3:BMI
-(BOOL)hasSameimportTimeData:(NSString *)importtime childModel:(CGChildModel *)childmodel type:(int)type{
    switch (type) {
        case 0:   //height
        {
            for (CGWeight *weightItem in childmodel.weightArr) {
                if ([importtime isEqualToString:weightItem.time]) {
                    return YES;
                }
            }
           for (CGBMI *bmiItem in childmodel.BMIArr) {
               if ([importtime isEqualToString:bmiItem.time]) {
                    return YES;
                }
           }
           for (CGHeadc *headcItem in childmodel.headcArr) {
            if ([importtime isEqualToString:headcItem.time]) {
                    return YES;
                }
            }
           }
            break;
        case 1:    //weight
        {
            for (CGHeight *heightItem in childmodel.heightArr) {
                if ([importtime isEqualToString:heightItem.time]) {
                    return YES;
                }
            }
            for (CGHeadc *headcItem in childmodel.headcArr) {
                if ([importtime isEqualToString:headcItem.time]) {
                    return YES;
                }
            }
            for (CGBMI *bmiItem in childmodel.BMIArr) {
                if ([importtime isEqualToString:bmiItem.time]) {
                    return YES;
                }
            }
            
        }
            break;
        case 2:   //headc
        {
            for (CGHeight *heightItem in childmodel.heightArr) {
                if ([importtime isEqualToString:heightItem.time]) {
                    return YES;
                }
            }
            for (CGBMI *bmiItem in childmodel.BMIArr) {
                if ([importtime isEqualToString:bmiItem.time]) {
                    return YES;
                }
            }
            for (CGWeight *weightItem in childmodel.weightArr) {
                if ([importtime isEqualToString:weightItem.time]) {
                    return YES;
                }
            }
        }
            break;
        case 3:   //bmi
        {
            for (CGHeight *heightItem in childmodel.heightArr) {
                if ([importtime isEqualToString:heightItem.time]) {
                    return YES;
                }
            }
            for (CGWeight *weightItem in childmodel.weightArr) {
                if ([importtime isEqualToString:weightItem.time]) {
                    return YES;
                }
            }
            for (CGHeadc *headcItem in childmodel.headcArr) {
                if ([importtime isEqualToString:headcItem.time]) {
                    return YES;
                }
            }
        }
            break;
        default:
            return NO;
            break;
    }
    return NO;
}
#pragma mark - 协议实现
-(void)addinforVC:(AddViewController *)addinforVC heightItem:(CGHeight *)heightItem{
    //1.创建队列
    /*
     第一个参数:C语言的字符串,标签
     第二个参数:队列的类型
     DISPATCH_QUEUE_CONCURRENT:并发
     DISPATCH_QUEUE_SERIAL:串行
     */
    //dispatch_queue_t queue = dispatch_queue_create("com.520it.download", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_queue_create("upload", DISPATCH_QUEUE_SERIAL);
//      [self postEditData:heightItem.height importtime:heightItem.time type:0];
    //保存存放的数据(修改模型)
    CGChildModel *childmodel = self.childs[[self.childindex integerValue]];
    //输入时间判定（1，不能重复 。 2，不能早于出生）
    //不能早于出生
    [self isEarlythanbirthorOverrange:heightItem.time birthday:childmodel.age whattype:0 value:heightItem.height];
    //自动移除重复的
    int same =0;
    for (CGHeight *height in childmodel.heightArr) {
        if([heightItem.time isEqualToString:height.time]){
            [childmodel.heightArr removeObject:height];
            same = 1;
                 // post修改
                [self postEditData:heightItem.height importtime:heightItem.time type:0 childId:childmodel.ChildId];
        }
    }
    //添加到数据数组
    
    if (childmodel.heightArr ==nil) {
        childmodel.heightArr = [[NSMutableArray alloc]init];
    }
        [childmodel.heightArr addObject:heightItem];
    //判断是否有同一天的任何数据
    if (!same) {
        if ([self hasSameimportTimeData:heightItem.time childModel:childmodel type:0]) {
            
                // post修改
                [self postEditData:heightItem.height importtime:heightItem.time type:0 childId:childmodel.ChildId];

        }
        else{

                // post上传
                [self postdata:heightItem.height importtime:heightItem.time type:0 childId:childmodel.ChildId BirthDate:childmodel.age];

        }
    }
    //判断 身高体重若有相同日期。计算BMI
    for (CGHeight *height in childmodel.heightArr) {
        for (CGWeight *weight in childmodel.weightArr) {
            if([heightItem.time isEqualToString:height.time] && [heightItem.time isEqualToString:weight.time]){
                for (CGBMI *bmi in childmodel.BMIArr) {
                    if([bmi.time isEqualToString:heightItem.time]){
                        [childmodel.BMIArr removeObject:bmi];
                    }
                }
                CGBMI * bmi = [[CGBMI alloc]init];
                bmi.time = weight.time;
                float m= [height.height floatValue] *0.01;
                float bvalue = [weight.weight floatValue] /pow(m, 2);
                bmi.value = [NSNumber numberWithFloat:bvalue];
                if (childmodel.BMIArr ==nil) {
                    
                    childmodel.BMIArr = [[NSMutableArray alloc]init];
                }
                [childmodel.BMIArr addObject:bmi];
//                dispatch_async(queue, ^{
//                    //post修改bmi
//                    [self postEditData:bmi.value importtime:bmi.time type:3 childId:childmodel.ChildId];
//                });
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//                NSString *token = [self readNSUserDefaultstoken];
                NSString *parm =@"bmi";
//                NSNumber *childID = [NSNumber numberWithInteger:childmodel.ChildId];
                //    NSString *userAccount = @"123456";
                dispatch_group_async(group, queue, ^{
                    // 1.创建AFN管理者
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    NSString *importTime = [self dataStringfromDataString:bmi.time];
                    // 2.利用AFN管理者发送请求
                    NSDictionary *params = @{
                                             @"parm" : parm,
                                             @"data" : bmi.value,
                                             @"childID" : childmodel.ChildId,
                                             @"importTime" : importTime,
                                             @"token" : self.token
                                             };
                    [manager POST:@"http://192.168.1.121/childGrow/Mobile/dataEdit" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        dispatch_semaphore_signal(semaphore);
                        NSLog(@"请求成功---%@", responseObject);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"请求失败---%@", error);
                    }];
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                });
                break;
                
            }
        }
    }
            //保存
            self.childs[[self.childindex integerValue]] =childmodel;
    
            [self writeAllChildInfortoPlist];
            //刷新图表
            [self reloadall];
//    //初始化提示框
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该日期已有记录，是否覆盖原记录" preferredStyle:UIAlertControllerStyleAlert];
//    //    UIPreviewActionStyleDefault=0 UIPreviewActionStyleSelected,UIPreviewActionStyleDestructive,
//    [alert addAction:[UIAlertAction actionWithTitle:@"覆盖" style:UIPreviewActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [childmodel.heightArr addObject:heightItem];
//        self.childs[[self.childindex integerValue]] =childmodel;
//        
//        [self writeAllChildInfortoPlist];
//        //刷新图表
//        [self reloadall];
//        
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIPreviewActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    //弹出提示框
//    [self presentModalViewController:alert animated:true];

    
    //    NSLog(@"111111--111111");
}
-(void)addinforVC:(AddViewController *)addinforVC weightItem:(CGWeight *)weightItem{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_queue_create("upload", DISPATCH_QUEUE_SERIAL);
    //保存存放的数据(修改模型)
    
    CGChildModel *childmodel = self.childs[[self.childindex integerValue]];
    //输入时间判定（1，不能重复 。 2，不能早于出生）
    //不能早于出生
    [self isEarlythanbirthorOverrange:weightItem.time birthday:childmodel.age whattype:1 value:weightItem.weight];
    
    int same = 0;
    //自动移除重复的
    for (CGWeight *weight in childmodel.weightArr) {
        if([weightItem.time isEqualToString:weight.time]){
            [childmodel.weightArr removeObject:weight];
            same = 1;
                // post修改
                [self postEditData:weightItem.weight importtime:weightItem.time type:1 childId:childmodel.ChildId];
//            NSString *token = [self readNSUserDefaultstoken];
//            NSString *parm =@"weight";
//             NSString *childId = @"88888888";
//            //    NSString *userAccount = @"123456";
//            NSString *importTime = [self dataStringfromDataString:weightItem.time];
//            // 1.创建AFN管理者
//            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            
//            // 2.利用AFN管理者发送请求
//            NSDictionary *params = @{
//                                     @"parm" : parm,
//                                     @"data" : weightItem.weight,
//                                     @"childID" : childId,
//                                     @"importTime" : importTime,
//                                     @"token" : token
//                                     };
//            [manager POST:@"http://192.168.1.121/childGrow/Mobile/dataEdit" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//               
//                NSLog(@"请求成功---%@", responseObject);
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"请求失败---%@", error);
//            }];
            
            
        }
    }
    if (childmodel.weightArr ==nil) {
        childmodel.weightArr =[[NSMutableArray alloc]init];
    }
    [childmodel.weightArr addObject:weightItem];
    //判断是否有同一天的任何数据
    if (!same) {
        if ([self hasSameimportTimeData:weightItem.time childModel:childmodel type:1]) {

                // post修改
    [self postEditData:weightItem.weight importtime:weightItem.time type:1 childId:childmodel.ChildId];

//            NSString *token = [self readNSUserDefaultstoken];
//            NSString *parm =@"weight";
//            NSString *childId = @"88888888";
//            //    NSString *userAccount = @"123456";
//            // 1.创建AFN管理者
//            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            
//            // 2.利用AFN管理者发送请求
//            NSDictionary *params = @{
//                                     @"parm" : parm,
//                                     @"data" : weightItem.weight,
//                                     @"childID" : childId,
//                                     @"importTime" : weightItem.time,
//                                     @"token" : token
//                                     };
//            [manager POST:@"http://192.168.1.121/childGrow/Mobile/dataEdit" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                
//                NSLog(@"请求成功---%@", responseObject);
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"请求失败---%@", error);
//            }];
            
        }
        else{
//            dispatch_async(queue, ^{
                // post上传
                [self postdata:weightItem.weight importtime:weightItem.time type:1 childId:childmodel.ChildId BirthDate:childmodel.age];
//            });
        }
    }
        
    //判断 身高体重若有相同日期。计算BMI
    for (CGHeight *height in childmodel.heightArr) {
        for (CGWeight *weight in childmodel.weightArr) {
            if([weightItem.time isEqualToString:height.time] && [weightItem.time isEqualToString:weight.time]){
                for (CGBMI *bmi in childmodel.BMIArr) {
                    if([bmi.time isEqualToString:weightItem.time]){
                        [childmodel.BMIArr removeObject:bmi];
                    }
                }
                CGBMI * bmi = [[CGBMI alloc]init];
                bmi.time = weight.time;
                float m= [height.height floatValue] *0.01;
                float bvalue = [weight.weight floatValue] /(m*m);
                bmi.value = [NSNumber numberWithFloat:bvalue];
                if (childmodel.BMIArr ==nil) {
                    
                    childmodel.BMIArr = [[NSMutableArray alloc]init];
                }
                [childmodel.BMIArr addObject:bmi];
//                dispatch_async(queue, ^{
                    //post修改bmi
//                    [self postEditData:bmi.value importtime:bmi.time type:3];
//                });
                
                
//                NSString *token = [self readNSUserDefaultstoken];
                NSString *parm =@"bmi";
//                NSNumber *childID = [NSNumber numberWithInteger:childmodel.ChildId];
                //    NSString *userAccount = @"123456";
               dispatch_group_async(group, queue, ^{
                   dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                // 1.创建AFN管理者
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                   NSString *importTime = [self dataStringfromDataString:bmi.time];
                // 2.利用AFN管理者发送请求
                NSDictionary *params = @{
                                         @"parm" : parm,
                                         @"data" : bmi.value,
                                         @"childID" : childmodel.ChildId,
                                         @"importTime" : importTime,
                                         @"token" : self.token
                                         };
                [manager POST:@"http://192.168.1.121/childGrow/Mobile/dataEdit" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    dispatch_semaphore_signal(semaphore);
                    NSLog(@"请求成功---%@", responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"请求失败---%@", error);
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
               });
                break;
            }
           
        }
    }

    //保存
    self.childs[[self.childindex integerValue]] =childmodel;
    
    [self writeAllChildInfortoPlist];
    //刷新图表
    [self reloadall];
    //    NSLog(@"2222222--22222222");
}
-(void)addinforVC:(AddViewController *)addinforVC headcItem:(CGHeadc *)headcItem{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //保存存放的数据(修改模型)
    CGChildModel *childmodel = self.childs[[self.childindex integerValue]];
    //输入时间判定（1，不能重复 。 2，不能早于出生）
    //不能早于出生
//    [self isEarlythanbirth:headcItem.time birthday:childmodel.age];
    [self isEarlythanbirthorOverrange:headcItem.time birthday:childmodel.age whattype:2 value:headcItem.headc];
    //自动移除重复的
    int same = 0;
    for (CGHeadc *headc in childmodel.weightArr) {
        if([headcItem.time isEqualToString:headc.time]){
            [childmodel.headcArr removeObject:headc];
            same = 1;
            dispatch_async(queue, ^{
                // post修改
                [self postEditData:headcItem.headc importtime:headcItem.time type:2 childId:childmodel.ChildId];
            });
        }
    }
    if (childmodel.headcArr ==nil) {
        childmodel.headcArr = [[NSMutableArray alloc]init];
    }
    [childmodel.headcArr addObject:headcItem];
    //判断是否有同一天的任何数据
    if (!same) {
        if ([self hasSameimportTimeData:headcItem.time childModel:childmodel type:2]) {
            dispatch_async(queue, ^{
                // post修改
                [self postEditData:headcItem.headc importtime:headcItem.time type:2 childId:childmodel.ChildId];
            });
        }
        else{
            dispatch_async(queue, ^{
                // post上传
                [self postdata:headcItem.headc importtime:headcItem.time type:2 childId:childmodel.ChildId BirthDate:childmodel.age];
            });
        }
    }
    self.childs[[self.childindex integerValue]] =childmodel;
    
    [self writeAllChildInfortoPlist];
    //刷新图表
    [self reloadall];
    //    NSLog(@"333333333--33333333");
}
-(void)deleteforVC:(DeleteTableViewController *)deleteforVC childItem:(CGChildModel *)childItem deleteItem:(NSMutableArray *)deleteitem{
    //保存存放的数据(修改模型)
    self.childs[[self.childindex integerValue]] = childItem;
    [self writeAllChildInfortoPlist];
    //刷新图表
    [self reloadall];
    //将修改上传云端
    NSArray *heightArr = deleteitem[0];
    NSArray *weightArr = deleteitem[1];
    NSArray *headcArr = deleteitem[2];
    NSArray *BMIArr = deleteitem[3];
    if (![heightArr isKindOfClass:[NSNull class]]) {
        for (NSDictionary *heightDic in heightArr) {
            NSString *time= [heightDic objectForKey:@"time"];
            
            if ([self hasSameimportTimeData:time childModel:childItem type:0]) {
                //修改
                NSNumber *height = [heightDic objectForKey:@"height"];
                [self postEditData:height importtime:time type:0 childId:childItem.ChildId];
            }else {
            //删除
                [self postDelete:time childId:childItem.ChildId];
            }
        }
    }
    if (![weightArr isKindOfClass:[NSNull class]]) {
        for (NSDictionary *weightDic in weightArr) {
            NSString *time= [weightDic objectForKey:@"time"];
            
            if ([self hasSameimportTimeData:time childModel:childItem type:1]) {
                //修改
                NSNumber *weight = [weightDic objectForKey:@"weight"];
                [self postEditData:weight importtime:time type:1 childId:childItem.ChildId];
            }else {
                //删除
                [self postDelete:time childId:childItem.ChildId];
            }
        }
    }
    if (![headcArr isKindOfClass:[NSNull class]]) {
        for (NSDictionary *headcDic in headcArr) {
            NSString *time= [headcDic objectForKey:@"time"];
            
            if ([self hasSameimportTimeData:time childModel:childItem type:2]) {
                //修改
                NSNumber *height = [headcDic objectForKey:@"height"];
                [self postEditData:height importtime:time type:2 childId:childItem.ChildId];
            }else {
                //删除
                [self postDelete:time childId:childItem.ChildId];
            }
        }
    }
    if (![BMIArr isKindOfClass:[NSNull class]]) {
        for (NSDictionary *bmiDic in BMIArr) {
            NSString *time= [bmiDic objectForKey:@"time"];
            
            if ([self hasSameimportTimeData:time childModel:childItem type:3]) {
                //修改
                NSNumber *bmi = [bmiDic objectForKey:@"value"];
                [self postEditData:bmi importtime:time type:3 childId:childItem.ChildId];
            }else {
                //删除
                [self postDelete:time childId:childItem.ChildId];
            }
        }
    }
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
    
    //读取NSDate日期类型的数据
    NSNumber *childindex = [userDefaultes valueForKey:@"childindex"];
    NSString *token = [userDefaultes valueForKey:@"token"];
    NSString *userAccount = [userDefaultes valueForKey:@"userAccount"];
    self.childindex = childindex;
    self.token = token;
    self.userAccount = userAccount;
}
//从NSUserDefaults中读取token数据
//-(NSString *)readNSUserDefaultstoken
//{
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    
//    //读取NSString类型的数据
//    NSString *token = [userDefaultes valueForKey:@"token"];
//     return token;
//}
@end
