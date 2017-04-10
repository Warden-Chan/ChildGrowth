//
//  DeleteTableViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/12/30.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "DeleteTableViewController.h"
#import "CGChildModel.h"
#import "CGHeight.h"
#import "CGWeight.h"
#import "CGHeadc.h"
#import "CGBMI.h"
@interface DeleteTableViewController ()
@property (strong, nonatomic) UIButton *btn;
@end

@implementation DeleteTableViewController

//+ (instancetype)initWithChildmodel:(CGChildModel *)childmodel{
//    DeleteTableViewController *DVC = [[DeleteTableViewController alloc]init];
//    DVC.childmodel = childmodel;
//    return DVC;
//}
NSString * const indentifier = @"deletecell";
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:indentifier];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    [self steup];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    self.btn.enabled = NO;
    [self.btn addTarget:self action:@selector(savebtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn];
//    self.btn.hidden = YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
return @"删除";
}
-(void)savebtnClick{
    //把 到上一个控制器(CGGrowthchartViewController)
    if(self.delegate != nil)
    {
       [self.delegate deleteforVC:self childItem:self.childmodel];
    }
    //返回上一级
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section ==0) {
        return self.childmodel.heightArr.count;
    }else if (section ==1){
        return self.childmodel.weightArr.count;
    }else if (section ==2){
        return self.childmodel.headcArr.count;
    }else{
    return self.childmodel.BMIArr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:indentifier];
    }

        // Configure the cell.
    switch (indexPath.section) {
        case 0:
        {
            CGHeight *heightItem = self.childmodel.heightArr[indexPath.row];
            float heightf = [heightItem.height floatValue];
            NSString *heightStr =  [NSString stringWithFormat:@"%.1fcm",heightf];
            NSString *timeStr = [heightItem.time substringFromIndex:2];
            cell.textLabel.text = timeStr;
            cell.detailTextLabel.text = heightStr;
        }
            break;
        case 1:
        {
            CGWeight *weightItem = self.childmodel.weightArr[indexPath.row];
            float weightf = [weightItem.weight floatValue];
            NSString *weightStr =  [NSString stringWithFormat:@"%.1fkg",weightf];
            NSString *timeStr = [weightItem.time substringFromIndex:2];
            cell.textLabel.text = timeStr;
            cell.detailTextLabel.text = weightStr;
        }
            break;
        case 2:
        {
            CGHeadc *headcItem = self.childmodel.headcArr[indexPath.row];
            float headcf = [headcItem.headc floatValue];
            NSString *headcStr =  [NSString stringWithFormat:@"%.1fcm",headcf];
            NSString *timeStr = [headcItem.time substringFromIndex:2];
            cell.textLabel.text = timeStr;
            cell.detailTextLabel.text = headcStr;
        }
            break;
        case 3:
        {
            CGBMI *BMIItem = self.childmodel.BMIArr[indexPath.row];
            float BMIf = [BMIItem.value floatValue];
            NSString *BMIStr =  [NSString stringWithFormat:@"%.1f",BMIf];
            NSString *timeStr = [BMIItem.time substringFromIndex:2];
            cell.detailTextLabel.text = BMIStr;
            cell.textLabel.text = timeStr;
        }
            break;
        default:
            break;
    }
    [cell layoutSubviews];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *header = nil;
    switch (section) {
        case 0:
            header = @"身高记录";
            break;
        case 1:
            header = @"体重记录";
            break;
        case 2:
            header = @"头围记录";
            break;
        case 3:
            header = @"BMI记录";
            break;
        default:
            break;
    }
    return  header;
}
//删除功能
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        switch (indexPath.section) {
            case 0:{
              CGHeight *heightItem = self.childmodel.heightArr[indexPath.row];
                [self.childmodel.heightArr removeObject:heightItem];
            }
                break;
            case 1:
            {
                CGWeight *weightItem = self.childmodel.weightArr[indexPath.row];
                [self.childmodel.weightArr removeObject:weightItem];
            }
                break;
            case 2:
            {
                CGHeadc *headcItem = self.childmodel.headcArr[indexPath.row];
                [self.childmodel.headcArr removeObject:headcItem];
            }
                break;
            case 3:
            {
                CGBMI *BMIItem = self.childmodel.BMIArr[indexPath.row];
                [self.childmodel.BMIArr removeObject:BMIItem];
            }
                break;
            default:
                break;
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
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
