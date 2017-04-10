//
//  addNewItemTableViewController.h
//  ChildGrowth
//
//  Created by ChenWanda on 2017/3/6.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWPublishBaseController.h"
@class listCellItem,addNewItemTableViewController;
//1.定义协议
@protocol addNewItemTableViewControllerDelegate <NSObject>

//2.定义协议方法
- (void)addNewItemVC:(addNewItemTableViewController *)addnewitemVC cellItem:(listCellItem *)cellItem;
@end
@interface addNewItemTableViewController :HWPublishBaseController
@property (nonatomic) NSInteger type;
@property (nonatomic, weak) id<addNewItemTableViewControllerDelegate> delegate;
@end
