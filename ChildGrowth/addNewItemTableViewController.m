//
//  addNewItemTableViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2017/3/6.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "addNewItemTableViewController.h"
#import "HTextViewCell.h"
#import "UITextField+IndexPath.h"
#import "BRPlaceholderTextView.h"
#import "UIImageView+WebCache.h"
#import "listCellItem.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define iphone4 (CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size))
#define iphone5 (CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size))
#define iphone6 (CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size))
#define iphone6plus (CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size))
//默认最大输入字数为  kMaxTextCount  300
#define kMaxTextCount 200
#define HeightVC [UIScreen mainScreen].bounds.size.height//获取设备高度
#define WidthVC [UIScreen mainScreen].bounds.size.width//获取设备宽度
@interface addNewItemTableViewController ()<UIScrollViewDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    float _TimeNUMX;
    float _TimeNUMY;
    int _FontSIZE;
    float allViewHeight;
    //备注文本View高度
    float noteTextHeight;
}
/**
 *  主视图-
 */
@property (nonatomic, strong) UIScrollView *mianScrollView;
//文本输入TextView
@property (nonatomic, strong) BRPlaceholderTextView *noteTextView;
//背景
//@property (nonatomic, strong) UIView *noteTextBackgroudView;
//文字个数提示label
@property (nonatomic, strong) UILabel *textNumberLabel;
//图片
//@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) UIView * lineVCThree;
@property (nonatomic,strong) NSMutableDictionary * upDic;
@property (nonatomic,strong) NSMutableArray * photoArr;
@property (nonatomic,copy)   NSString * photoStr;
//@property (nonatomic,copy)   NSString * star_level;
@property (nonatomic,copy)   NSString * modelUrl;

//tableview
@property (strong, nonatomic) UITableView *tableView;
//保存按钮
@property (strong, nonatomic) UIButton *btn;
//标题数组
@property (nonatomic , strong)NSArray *titleArray;
//detail数组
@property (nonatomic , strong)NSArray *detailArray;
//数据内容
@property (nonatomic , strong)NSMutableArray *arrayDataSouce;
@property (nonatomic)NSInteger tableHeight;
//模型
@property(nonatomic,strong)listCellItem *cellItem;
@end

@implementation addNewItemTableViewController
NSString * const addIndentifier = @"addNewItemcell";
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellItem = [[listCellItem alloc]init];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
//    NSLog(@"从第%ld个来",self.type);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self steup];
    //通知响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBord)];
    [self.tableView addGestureRecognizer:gesture];
    
    
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _TimeNUMX = [self BackTimeNUMX];
    _TimeNUMY = [self BackTimeNUMY];
    
    [self createUI];

    
}
-(NSInteger)tableHeight{
    if (!_tableHeight) {
        switch ((int)self.type) {
            case 0:
                _tableHeight = 2*44;
                break;
            case 1:
                _tableHeight = 5*44;
                break;
            case 2:
                _tableHeight = 5*44;
                break;
            default:
                break;
        }
    }
    return _tableHeight;
}
//-(void)viewWillAppear:(BOOL)animated{
//NSLog(@"内容高度:%f",self.tableView.contentSize.height);
//}
-(void)steup{
    self.navigationItem.title = @"新添记录";
    //设置右侧是一个自定义的View(位置不需要自己决定,但是大小是要自己决定)
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageNamed:@"29-heart"] forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageNamed:@"29-heart"] forState:UIControlStateHighlighted];
    //让按钮自适应大小
    [btn sizeToFit];
    self.btn = btn;
    //    self.btn.enabled = NO;
    [self.btn addTarget:self action:@selector(savebtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn];
    //    self.btn.hidden = YES;
}
- (void)textFieldDidChanged:(NSNotification *)noti{
    /// 数据源赋值
    UITextField *textField=noti.object;
    NSIndexPath *indexPath = textField.indexPath;
    [self.arrayDataSouce replaceObjectAtIndex:indexPath.row withObject:textField.text];
}
#pragma mark 保存记录
-(void)savebtnClick{
    //把记录内容到根控制器(FootPrintViewController)
    self.cellItem.type = self.type;
    self.cellItem.height = self.arrayDataSouce[0];
    self.cellItem.weight = self.arrayDataSouce[1];
    self.cellItem.headc = self.arrayDataSouce[2];
    self.cellItem.describe = self.noteTextView.text;
    self.photoArr = [[NSMutableArray alloc] initWithArray:[self getBigImageArray]];
//    NSString *photosStr =[self.photoArr componentsJoinedByString:@","];
    NSMutableArray *imgDataArr = [NSMutableArray array];
    for (UIImage *img in self.bigImageArray) {
        NSData *imgData = UIImagePNGRepresentation(img);
        [imgDataArr addObject:imgData];
    }
//    UIImage *img = [UIImage imageNamed:@"Diary"];
//    NSData *imgdata =UIImagePNGRepresentation(img);
//    NSArray *arr = [NSArray arrayWithObject:imgdata];
    self.cellItem.photos = imgDataArr;
//    self.cellItem.photos = self.bigImgDataArray;
    if(self.delegate != nil)
    {
        [self.delegate addNewItemVC:self cellItem:self.cellItem];
    }
    [self.arrayDataSouce enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *string = (NSString *)obj;
        if (string.length == 0) {
            NSLog(@"第%lu个位置元素为空", (unsigned long)idx);
        }else{
            NSLog(@"%@", obj);
        }
    }];
    //返回上一级
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:{
            return self.titleArray.count;
//            switch ((int)self.type) {
//                case 0:
//                    return 0;
//                    break;
//                case 1:
//                    return 3;
//                    break;
//                case 2:
//                    return 2;
//                    break;
//                default:
//                    return 0;
//                    break;
//            }
            break;
        }
        default:
            return 0;
            break;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section ==2){
        static NSString *Id = @"HTextViewCell";
        HTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
        if (!cell) {
            cell = [[HTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        }
        /// 核心方法
        [cell setTitleString:self.titleArray[indexPath.row] detailString:self.detailArray[indexPath.row] andDataString:self.arrayDataSouce[indexPath.row] andIndexPath:indexPath];
        return cell;

    }else{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addIndentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addIndentifier];
    }

    // Configure the cell.
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = @"记录";
            switch ((int)self.type) {
                case 0:
                    cell.detailTextLabel.text = @"随意记";
                    break;
                case 1:
                    cell.detailTextLabel.text = @"生长记录";
                    break;
                case 2:
                    cell.detailTextLabel.text = @"辅食";
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 1:
        {
            
            cell.textLabel.text = @"时间";
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter  =[[NSDateFormatter alloc]init];
            formatter.dateFormat = @"MM月dd日 HH:mm";
            NSString *timeString = [formatter stringFromDate:date];
            cell.detailTextLabel.text = timeString;
            self.cellItem.time = timeString;
        }
            break;
        case 2:
        {
            break;
        }
        case 3:
        {
            cell.textLabel.text = @"描述";
            cell.detailTextLabel.text = @"辅食";
        }
            break;
        default:
            break;
    }
        [cell layoutSubviews];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSLog(@"要隐藏键盘了.......22222222222");
    
    }
#pragma mark - private
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        [self.view endEditing:YES];
        
    }
    
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        NSLog(@"点击结束了");
    }
    
- (void)hiddenKeyBord{
        NSLog(@"要隐藏键盘了........1111111111111");
        [self.view endEditing:YES];
    }
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 5;
//}
#pragma marks- lazy
- (NSMutableArray *)arrayDataSouce{
    if (!_arrayDataSouce) {
        _arrayDataSouce = [NSMutableArray array];
        [_arrayDataSouce addObject:@""];
        [_arrayDataSouce addObject:@""];
        [_arrayDataSouce addObject:@""];
        
    }
    return _arrayDataSouce;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        switch ((int)self.type) {
            case 0:
                _titleArray = nil;
                break;
            case 1:
                _titleArray = @[@"身高：", @"体重：", @"头围："];
                break;
            case 2:
                _titleArray = @[@"早餐：", @"午餐：", @"晚餐："];
                break;
            default:
                break;
        }
        
    }
    return _titleArray;
}
- (NSArray *)detailArray{
    if (!_detailArray) {
        switch ((int)self.type) {
            case 0:
                _detailArray = nil;
                break;
            case 1:
                _detailArray = @[@"厘米", @"公斤", @"厘米"];
                break;
            case 2:
                _detailArray = @[@"", @"", @""];
                break;
            default:
                break;
        }
        
    }
    return _detailArray;
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
/**
 *  取消输入
 */
- (void)viewTapped{
    [self.view endEditing:YES];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    self.view.frame = CGRectMake(0, 0-60*_TimeNUMY, WidthVC,HeightVC);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.view.frame = CGRectMake(0, 0, WidthVC, HeightVC);
}

- (void)createUI{

    
    _mianScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, WidthVC, HeightVC)];
    _mianScrollView.contentSize =CGSizeMake(WidthVC, HeightVC);
    _mianScrollView.bounces =YES;
    _mianScrollView.showsVerticalScrollIndicator = false;
    _mianScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_mianScrollView];
    [_mianScrollView setDelegate:self];
    self.showInView = _mianScrollView;
//    CGFloat tableHeight =0;
//    switch ((int)self.type) {
//        case 0:
//            tableHeight = 2* 44;
//            break;
//        case 1:
//            tableHeight = 5 * 44;
//            break;
//        case 2:
//            tableHeight = 5 * 44;
//            break;
//        default:
//            break;
//    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WidthVC, self.tableHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//        _tableView.scrollEnabled = NO;
    [self.mianScrollView addSubview:_tableView];
    self.tableView = _tableView;
    /** 初始化collectionView */
    [self initPickerView];
    
    [self initViews];
}

/**
 *  初始化视图
 */
- (void)initViews{
//    _noteTextBackgroudView = [[UIView alloc]init];
//    _noteTextBackgroudView.backgroundColor = [UIColor whiteColor];
    
    ///照片
    //    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20*_TimeNUMX, 20*_TimeNUMY, 80*_TimeNUMX, 90*_TimeNUMY)];
    //    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.modelUrl] placeholderImage:[UIImage imageNamed:@"plus"]];
    //    UIButton * clickImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(20*_TimeNUMX, 20*_TimeNUMY, 80*_TimeNUMX, 90*_TimeNUMY)];
    //    [clickImageBtn addTarget:self action:@selector(ClickImage:) forControlEvents:UIControlEventTouchUpInside];
    //    clickImageBtn.backgroundColor = [UIColor clearColor];
    
    ///详情
    //    NSArray * infoArr = @[self.typeStr,self.upPeople];
    //    for (int i = 0; i<infoArr.count; i++) {
    //        UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(120*_TimeNUMX, 20*_TimeNUMY+30*_TimeNUMY*i, WidthVC-120*_TimeNUMX, 30*_TimeNUMY)];
    //        infoLabel.text = infoArr[i];
    //        infoLabel.font = [UIFont systemFontOfSize:14.0+_FontSIZE];
    //        [_noteTextBackgroudView addSubview:infoLabel];
    //    }
    //    UILabel * info3Label = [[UILabel alloc] initWithFrame:CGRectMake(120*_TimeNUMX, 80*_TimeNUMY, WidthVC-120*_TimeNUMX, 40*_TimeNUMY)];
    //    info3Label.numberOfLines = 0;
    //    info3Label.text = self.address;
    //    info3Label.font = [UIFont systemFontOfSize:14.0+_FontSIZE];
    //    [_noteTextBackgroudView addSubview:info3Label];
    //
//    UIView * lineVCOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0*_TimeNUMY, WidthVC, 10*_TimeNUMY)];
//    lineVCOne.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
//    UILabel * evaluateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*_TimeNUMX, 0, 50*_TimeNUMX, 30*_TimeNUMY)];
//    evaluateLabel.text = @"描述";
//    evaluateLabel.font = [UIFont systemFontOfSize:17.0+_FontSIZE];
    
    //    UIView * rView = [[UIView alloc]initWithFrame:CGRectMake(80*_TimeNUMX, lineVCOne.frame.origin.y+lineVCOne.frame.size.height+5*_TimeNUMY, 150*_TimeNUMX, 40*_TimeNUMY)];
    //    rView.ratingType = INTEGER_TYPE;//整颗星
    //    rView.delegate = self;
    
    //    UIView * lineVCTwo = [[UIView alloc] initWithFrame:CGRectMake(0, evaluateLabel.frame.origin.y+evaluateLabel.frame.size.height+10*_TimeNUMY, WidthVC, 10*_TimeNUMY)];
    //    lineVCTwo.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //文本输入框
    _noteTextView = [[BRPlaceholderTextView alloc]init];
    _noteTextView.keyboardType = UIKeyboardTypeDefault;
    //文字样式
    [_noteTextView setFont:[UIFont fontWithName:@"Heiti SC" size:15.5]];
    _noteTextView.maxTextLength = kMaxTextCount;
    [_noteTextView setTextColor:[UIColor blackColor]];
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont boldSystemFontOfSize:15.5];
    _noteTextView.placeholder= @"  选填，可以添加文字或照片";
    self.noteTextView.returnKeyType = UIReturnKeyDone;
    [self.noteTextView setPlaceholderColor:[UIColor lightGrayColor]];
    [self.noteTextView setPlaceholderOpacity:1];
    _noteTextView.textContainerInset = UIEdgeInsetsMake(5, 15, 5, 15);
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.backgroundColor = [UIColor whiteColor];
    _textNumberLabel.text = [NSString stringWithFormat:@"0/%d    ",kMaxTextCount];
    
    self.lineVCThree = [[UIView alloc] init];
    self.lineVCThree.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
   
    
//    [_mianScrollView addSubview:_noteTextBackgroudView];
    
    
    [_mianScrollView addSubview:_noteTextView];
    [_mianScrollView addSubview:_textNumberLabel];
    [_mianScrollView addSubview:self.lineVCThree];

    
//    [_noteTextBackgroudView addSubview:self.photoImageView];
    //    [_noteTextBackgroudView addSubview:clickImageBtn];
    //    [_noteTextBackgroudView addSubview:lineVCOne];
//    [_noteTextBackgroudView addSubview:evaluateLabel];
    //    [_noteTextBackgroudView addSubview:rView];
    //    [_noteTextBackgroudView addSubview:lineVCTwo];
    
    [self updateViewsFrame];
    
}

/**
 *  界面布局 frame
 */
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 105*_TimeNUMY;
    }
    
//    _noteTextBackgroudView.frame = CGRectMake(0, 0, WidthVC, 30*_TimeNUMY);
    
    //文本编辑框
    _noteTextView.frame = CGRectMake(0, 10*_TimeNUMY+CGRectGetMaxY(self.tableView.frame), WidthVC, noteTextHeight);
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15*_TimeNUMY      , WidthVC-10*_TimeNUMX, 15*_TimeNUMY);
    
    self.lineVCThree.frame = CGRectMake(0*_TimeNUMX,_noteTextView.frame.origin.y+_noteTextView.frame.size.height, WidthVC, 10*_TimeNUMY);
    
    //photoPicker
    [self updatePickerViewFrameY:self.lineVCThree.frame.origin.y + self.lineVCThree.frame.size.height];
    

    
//    allViewHeight = self.sureBtn.frame.origin.y+self.sureBtn.frame.size.height+10*_TimeNUMY;
    
    _mianScrollView.contentSize = self.mianScrollView.contentSize = CGSizeMake(0,allViewHeight);
}
/**
 *  恢复原始界面布局
 */
-(void)resumeOriginalFrame{
//    _noteTextBackgroudView.frame = CGRectMake(0, 0, WidthVC, 200*_TimeNUMY);
    //文本编辑框
    _noteTextView.frame = CGRectMake(0, 40*_TimeNUMY, WidthVC, noteTextHeight);
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15*_TimeNUMY      , WidthVC-10*_TimeNUMX, 15*_TimeNUMY);
}

- (void)pickerViewFrameChanged{
    [self updateViewsFrame];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //当前输入字数
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,kMaxTextCount];
    if (_noteTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    [self textChanged];
   
    return YES;
}

//文本框每次输入文字都会调用  -> 更改文字个数提示框
- (void)textViewDidChangeSelection:(UITextView *)textView{
    //
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,kMaxTextCount];
    if (_noteTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    [self textChanged];
}

/**
 *  文本高度自适应
 */
-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    //获取尺寸
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    
    
    //如果文本框没字了恢复初始尺寸
    if (orgRect.size.height > 70) {
        noteTextHeight = orgRect.size.height;
    }else{
        noteTextHeight = 70;
    }
    
    [self updateViewsFrame];
}

#pragma mark - UIScrollViewDelegate
//用户向上偏移到顶端取消输入,增强用户体验
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        [self.view endEditing:YES];
    }
}

#pragma mark 点击出大图方法
- (void)ClickImage:(UIButton *)sender{
    
}

#pragma mark 确定评价的方法
- (void)ClickSureBtn:(UIButton *)sender{
    if (self.noteTextView.text.length == 0 || self.noteTextView.text.length < 10) {
        NSLog(@"您的评价描述字数不够哦!");
        
        return;
    }
    if (self.noteTextView.text.length > kMaxTextCount) {
        NSLog(@"您的评价描述字数太多了哦!");
        return;
    }
    
    self.photoArr = [[NSMutableArray alloc] initWithArray:[self getBigImageArray]];
    
    if (self.photoArr.count >9){
        NSLog(@"最多上传9张照片!");
        
    }else if (self.photoArr.count == 0){
        NSLog(@"请上传照片!");
        
    }else{
        /** 上传的接口方法 */
    }
}

#pragma mark 返回不同型号的机器的倍数值
- (float)BackTimeNUMX {
    float numX = 0.0;
    if (iphone4) {
        numX = 320 / 375.0;
        return numX;
    }
    if (iphone5) {
        numX = 320 / 375.0;
        return numX;
    }
    if (iphone6) {
        return 1.0;
    }
    if (iphone6plus) {
        numX = 414 / 375.0;
        return numX;
    }
    return numX;
}
- (float)BackTimeNUMY {
    float numY = 0.0;
    if (iphone4) {
        numY = 480 / 667.0;
        _FontSIZE = -2;
        return numY;
    }
    if (iphone5) {
        numY = 568 / 667.0;
        _FontSIZE = -2;
        return numY;
    }
    if (iphone6) {
        _FontSIZE = 0;
        return 1.0;
    }
    if (iphone6plus) {
        numY = 736 / 667.0;
        _FontSIZE = 2;
        return numY;
    }
    return numY;
}
@end
