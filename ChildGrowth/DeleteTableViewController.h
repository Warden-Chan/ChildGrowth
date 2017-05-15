//
//  DeleteTableViewController.h
//  ChildGrowth
//
//  Created by ChenWanda on 2016/12/30.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGChildModel,DeleteTableViewController;
//1.定义协议
@protocol DeleteTableViewControllerDelegate <NSObject>

//2.定义协议方法
- (void)deleteforVC:(DeleteTableViewController *)deleteforVC childItem:(CGChildModel *)childItem deleteItem:(NSMutableArray *)deleteitem;
@end
@interface DeleteTableViewController : UITableViewController

@property (nonatomic, strong) CGChildModel *childmodel;
@property (nonatomic, weak) id<DeleteTableViewControllerDelegate> delegate;


@end
