//
//  CGDetailViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/10.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "CGDetailViewController.h"
#import "TWRChart.h"
@interface CGDetailViewController ()
@property(strong, nonatomic) TWRChartView *chartView;
@property(strong, nonatomic) UILabel *label;
/** 数据数组 */
@property (nonatomic, strong) NSArray *dataArr;
/** 曲线图类型 */
@property (nonatomic, strong) NSIndexPath *indexPath;
/**世界标准（YES）或中国标准(NO)**/
@property(nonatomic) NSInteger StandardType;
/**Z评分(YES)或百分位(NO)**/
@property(nonatomic) NSInteger ZorPercent;

@end

@implementation CGDetailViewController
+(id)initWithIndexpath:(NSIndexPath *)indexPath StandardType:(NSInteger)StandardType ZorPercent:(NSInteger)ZorPercent{
    CGDetailViewController *VC = [[CGDetailViewController alloc] init];
    VC.indexPath = indexPath;
    VC.StandardType =StandardType;
    VC.ZorPercent =ZorPercent;
    return VC;

}
- (NSArray *)dataArr{
    if (_dataArr == nil) {
        // 加载数据
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"height" ofType:@"plist"];
        self.dataArr = [NSArray arrayWithContentsOfFile:path];
        
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationItem.title = @"曲线图";
        //设置右侧是一个自定义的View(位置不需要自己决定,但是大小是要自己决定)
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"29-heart"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"29-heart"] forState:UIControlStateHighlighted];
        //让按钮自适应大小
        [btn sizeToFit];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //initWithFrame
    _chartView = [[TWRChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 440)];
    _chartView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_chartView];
       [self loadLineChart];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 440, self.view.bounds.size.width, self.view.bounds.size.height-440)];
    [self.view addSubview:_label];
    [self loadResult];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)btnClick{
    NSLog(@"%s",__func__);
}
-(void)loadResult{
    NSString *str = [NSString stringWithFormat:@"通过点击第%ld行来到了这里",(long)_indexPath.row];
    _label.text = str ;
}
/**
 *  Loads a line chart using native code
 */
- (void)loadLineChart {//曲线图
    // Build chart data
    
    TWRDataSet *dataSet1 = [[TWRDataSet alloc] initWithDataPoints:self.dataArr[self.StandardType][self.ZorPercent][0][0][0]];
    TWRDataSet *dataSet2 = [[TWRDataSet alloc] initWithDataPoints:self.dataArr[self.StandardType][self.ZorPercent][0][0][1]];
    TWRDataSet *dataSet3 = [[TWRDataSet alloc] initWithDataPoints:self.dataArr[self.StandardType][self.ZorPercent][0][0][2]];
    TWRDataSet *dataSet4 = [[TWRDataSet alloc] initWithDataPoints:self.dataArr[self.StandardType][self.ZorPercent][0][0][3]];
    TWRDataSet *dataSet5 = [[TWRDataSet alloc] initWithDataPoints:self.dataArr[self.StandardType][self.ZorPercent][0][0][4]];
    TWRDataSet *dataSet6 = [[TWRDataSet alloc] initWithDataPoints:self.dataArr[self.StandardType][self.ZorPercent][0][0][5]];
    TWRDataSet *dataSet7 = [[TWRDataSet alloc] initWithDataPoints:self.dataArr[self.StandardType][self.ZorPercent][0][0][6]];
    //    TWRDataSet *dataSet1 = [[TWRDataSet alloc] initWithDataPoints:@[@0, @0, @9.9, @12.5, @5,@12]];
    //    TWRDataSet *dataSet2 = [[TWRDataSet alloc] initWithDataPoints:@[@5, @40.5, @18.7, @25.6, @8, @0]];
    //    TWRDataSet *dataSet3 = [[TWRDataSet alloc] initWithDataPoints:@[@8, @10.5, @38.7, @15.6, @10, @0]];
    //    TWRDataSet *dataSet4 = [[TWRDataSet alloc] initWithDataPoints:@[@10, @20.5, @24.7, @22.6, @12, @0]];
    //    TWRDataSet *dataSet5 = [[TWRDataSet alloc] initWithDataPoints:@[@11.2, @13.5, @12.7, @35.6, @15, @0]];
    
    
    
    dataSet1.strokeColor = [UIColor yellowColor];
    dataSet2.strokeColor = [UIColor redColor];
    dataSet3.strokeColor = [UIColor cyanColor];
    dataSet4.strokeColor = [UIColor magentaColor];
    dataSet5.strokeColor = [UIColor greenColor];
    dataSet6.strokeColor = [UIColor blackColor];
    dataSet7.strokeColor = [UIColor blackColor];
    
    dataSet1.fillColor = [UIColor colorWithRed:253 / 255.0 green:229 / 255.0 blue:85 / 255.0 alpha:0.1];
    dataSet2.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.1];
    dataSet3.fillColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.1];
    dataSet4.fillColor = [UIColor colorWithRed:244 / 255.0 green:0 blue:238 / 255.0 alpha:0.1];
    dataSet5.fillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.1];
    
    dataSet1.pointColor = [UIColor yellowColor];
    dataSet2.pointColor = [UIColor redColor];
    dataSet3.pointColor = [UIColor cyanColor];
    dataSet4.pointColor = [UIColor magentaColor];
    dataSet5.pointColor = [UIColor greenColor];
    
    NSArray *labels = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24"];
    
    TWRLineChart *line = [[TWRLineChart alloc] initWithLabels:labels
                                                     dataSets:@[dataSet1, dataSet2, dataSet3, dataSet4, dataSet5,dataSet6,dataSet7]
                                                     animated:NO];
    _chartView.scalesPageToFit = YES;
    //    _chartView.multipleTouchEnabled = YES;
    _chartView.userInteractionEnabled = YES;
    
    //    _chartView.autoresizingMask = ()
    // Load data
    [_chartView loadLineChart:line];
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
