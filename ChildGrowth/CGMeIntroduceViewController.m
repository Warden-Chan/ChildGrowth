//
//  CGMeIntroduceViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2017/6/14.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "CGMeIntroduceViewController.h"
#import <QuickLook/QuickLook.h>
@interface CGMeIntroduceViewController ()<QLPreviewControllerDelegate>
@property(nonatomic,strong) QLPreviewController *qlPreview;
@end

@implementation CGMeIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    QLPreviewController *qlPreview = [[QLPreviewController alloc]init];
    qlPreview.dataSource = self;
    qlPreview.delegate =self;
    self.qlPreview = qlPreview;
    [self presentViewController:qlPreview animated:YES completion:^{
        
    }];
//    [self previewController:qlPreview previewItemAtIndex:0];
}
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    // 加载数据
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"测量方法" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    return url;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
