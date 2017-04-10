//
//  AddViewController.h
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/28.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGHeight,CGHeadc,CGWeight,AddViewController;
//1.定义协议
@protocol AddViewControllerDelegate <NSObject>

//2.定义协议方法
- (void)addinforVC:(AddViewController *)addinforVC heightItem:(CGHeight *)heightItem;
- (void)addinforVC:(AddViewController *)addinforVC headcItem:(CGHeadc *)headcItem;
- (void)addinforVC:(AddViewController *)addinforVC weightItem:(CGWeight *)weightItem;
@end
@interface AddViewController : UIViewController
@property(nonatomic) NSInteger ChartType;
@property (nonatomic, weak) id<AddViewControllerDelegate> delegate;

@end
