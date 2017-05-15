//
//  addChildViewController.h
//  ChildGrowth
//
//  Created by ChenWanda on 2017/4/24.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGChildModel,addChildViewController;
//1.定义协议
@protocol addChildViewControllerDelegate <NSObject>
//2.定义协议方法
- (void)addChildinfo:(addChildViewController *)addchildinfo childItem:(CGChildModel *)childitem;
@end

@interface addChildViewController : UIViewController
@property (nonatomic, weak) id<addChildViewControllerDelegate> delegate;
@end
