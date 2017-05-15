//
//  AddViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/28.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "AddViewController.h"
#import "CGHeadc.h"
#import "CGHeight.h"
#import "CGWeight.h"
#import "AHRuler.h"
#import "STPickerDate.h"

#define HOMECOLOR [UIColor colorWithRed:53/255.0 green:153/255.0 blue:54/255.0 alpha:1]
#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface AddViewController ()<AHRrettyRulerDelegate,UITextFieldDelegate,STPickerDateDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textDate;
@property (strong, nonatomic) UIButton *btn;
@property (nonatomic, copy) NSNumber *rulerValue;
@property(strong, nonatomic) UILabel *label;
@property(strong, nonatomic) AHRuler *ruler;
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textDate.delegate = self;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年M月d日";
    NSString *dataString = [formatter stringFromDate:date];
    self.textDate.text = dataString;
    
   _label = [[UILabel alloc] init];
    _label.font = [UIFont boldSystemFontOfSize:40.f];
   
    _label.textColor = HOMECOLOR;
    
    _label.frame = CGRectMake(20, 300, [UIScreen mainScreen].bounds.size.width - 20 * 2, 50);
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];

    
    // 2.创建 AHRuler 对象 并设置代理对象
    _ruler = [[AHRuler alloc] initWithFrame:CGRectMake(20, 350, [UIScreen mainScreen].bounds.size.width - 20 * 2, 140)];
    _ruler.rulerDeletate = self;
    [self.view addSubview:_ruler];
    //保存按钮
    [self steup];
    [self loadtype];  //判定显示身高，体重，BMI
}
#pragma mark - --- delegate 视图委托 ---

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    
    if (textField == self.textDate) {
        [self.textDate resignFirstResponder];
        
        STPickerDate *pickerDate = [[STPickerDate alloc]init];
        [pickerDate setDelegate:self];
        [pickerDate show];
    }
    
}
- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *text = [NSString stringWithFormat:@"%zd年%zd月%zd日", year, month, day];
    self.textDate.text = text;
//    self.btn.hidden = NO;
}
-(void)loadtype{
    switch (self.ChartType) {
        case 0:
            NSLog(@"----------0");
            self.label.text = @"100.0cm";
            [self.ruler showRulerScrollViewWithCount:2300 average:[NSNumber numberWithFloat:0.1] currentValue:100.f smallMode:YES];
            break;
        case 1:
            NSLog(@"----------1");
             self.label.text = @"60kg";
            [self.ruler showRulerScrollViewWithCount:1500 average:[NSNumber numberWithFloat:0.1] currentValue:60.f smallMode:YES];
            break;
        case 2:
            NSLog(@"----------2");
             self.label.text = @"45cm";
            [self.ruler showRulerScrollViewWithCount:650 average:[NSNumber numberWithFloat:0.1] currentValue:45.f smallMode:YES];
            break;
        default:
            break;
    }
}
- (void)ahRuler:(AHRulerScrollView *)rulerScrollView {
    CGFloat unrunlerValue = roundf(rulerScrollView.rulerValue *100) /100;
    self.rulerValue = [NSNumber numberWithFloat:unrunlerValue];
    switch (self.ChartType) {
        case 0:
            self.label.text = [NSString stringWithFormat:@"%.1fcm",rulerScrollView.rulerValue];
            break;
        case 1:
            self.label.text = [NSString stringWithFormat:@"%.1fkg",rulerScrollView.rulerValue];
            break;
        case 2:
            self.label.text = [NSString stringWithFormat:@"%.1fcm",rulerScrollView.rulerValue];
            break;
            
        default:
            break;
    }
    
}
-(void)steup{
    //设置右侧是一个自定义的View(位置不需要自己决定,但是大小是要自己决定)
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageNamed:@"29-heart"] forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageNamed:@"29-heart"] forState:UIControlStateHighlighted];
    //让按钮自适应大小
    [btn sizeToFit];
    self.btn = btn;
    self.btn.enabled = NO;
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn];
//    self.btn.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)btnClick{
//    NSLog(@"%s",__func__);
    
    //把输入的时间和数据传递到上一个控制器(CGGrowthchartViewController)
    //把输入的时间和数据封装一个模型
    switch (self.ChartType) {
        case 0:{
         CGHeight *heightitem =[CGHeight itemWithHeight:self.rulerValue time:self.textDate.text];
//            if([self.delegate respondsToSelector:@selector(addinforVC: heightItem:)]){
            [self.delegate addinforVC:self heightItem:heightitem];
//            }
        }
            break;
        case 1:
        {
            CGWeight *weightitem = [CGWeight itemWithWeight:self.rulerValue time:self.textDate.text];
//            if([self.delegate respondsToSelector:@selector(addinforVC:weightItem:)]){
                [self.delegate addinforVC:self weightItem:weightitem];
//            }
        }
             break;
        
           
        case 2:
        {
            CGHeadc *headcitem = [CGHeadc itemWithHeadc:self.rulerValue time:self.textDate.text];
//            if([self.delegate respondsToSelector:@selector(addinforVC:headcItem:)]){
                [self.delegate addinforVC:self headcItem:headcitem];
//            }
        }
            break;
            
        default:
            break;
    }

    
    //返回上一级
    [self.navigationController popViewControllerAnimated:YES];
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
