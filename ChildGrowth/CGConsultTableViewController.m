//
//  ConsultTableViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/21.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "CGConsultTableViewController.h"
#import "MJExtension.h"
#import "Consult.h"
#import "ConsultCell.h"
@interface CGConsultTableViewController ()
/** 所有的咨询数据 */
@property (nonatomic, strong) NSArray *consults;
@end

@implementation CGConsultTableViewController
- (NSArray *)consults
{
    if (!_consults) {
        _consults = [Consult mj_objectArrayWithFilename:@"statuses.plist"];
    }
    return _consults;
}

NSString *CID = @"consult";
- (void)viewDidLoad {
    [super viewDidLoad];
        [self.tableView registerClass:[ConsultCell class] forCellReuseIdentifier:CID];
    // 设置tableView每一组的尾部高度
        self.tableView.sectionFooterHeight = 20;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.consults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 访问缓存池
    ConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:CID];
    
    // 传递模型数据
    cell.consult = self.consults[indexPath.row];
    return cell;
}
#pragma mark - 代理方法
// 得出方案:在这个方法返回之前就要计算cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    Consult *consult = self.consults[indexPath.row];
    return consult.cellHeight;
}
////点击或选中后执行
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    CGDetailViewController *detailVC = 
//    [self.navigationController pushViewController:detailVC animated:YES];
//    
//}
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
