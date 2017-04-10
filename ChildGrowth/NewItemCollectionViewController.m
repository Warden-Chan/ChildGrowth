//
//  NewItemCollectionViewController.m
//  ChildGrowth
//
//  Created by ChenWanda on 2017/1/12.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "NewItemCollectionViewController.h"
#import "GridCollectionView.h"
#import "CustomCollectionViewCell.h"
#import "TypeCellClass.h"
#import "BusinessCell.h"
#import "UIView+SetRect.h"
#import "ActivityModel.h"
#import "addNewItemTableViewController.h"

typedef enum : NSUInteger {
    
    kBusinessOne = 20,
    kBusinessTwo,
    
} EBusinessTag;
@interface NewItemCollectionViewController ()<GridCollectionViewDelegate>
@property (nonatomic, strong) GridCollectionView *gridOneView;

/**
 *  数据源
 */
@property (nonatomic, strong) NSArray  *dataArray;
@end

@implementation NewItemCollectionViewController

//static NSString * const reuseIdentifier = @"CollectionCell";
//-(instancetype)init{
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    // 修改item的大小
//    flowLayout.itemSize = CGSizeMake(100, 100);
//    
//    // 修改行间距
//    flowLayout.minimumLineSpacing = 40;
//    
//    // 修改每一个item的间距
//    flowLayout.minimumInteritemSpacing = 50;
//    
//    // 修改滚动方向
//    //    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    
//    // 修改每一组的边距
//    flowLayout.sectionInset = UIEdgeInsetsMake(100, 20, 30, 40);
//    
//    return [super initWithCollectionViewLayout:flowLayout];
//}
-(NSArray *)dataArray{
    if(_dataArray == nil){
        // 加载数据
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"content" ofType:@"plist"];
        _dataArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _dataArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    [self.view addSubview:self.eventCollection];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择记录类型";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSMutableArray *mulArray = [[NSMutableArray alloc] init];
        NSArray *array= @[@"随意记", @"生长发育", @"辅食"];
         NSArray *imageArr= @[@"Diary", @"growth", @"touxiang"];
        for (NSString *string in array) {
            NSUInteger num =  [array indexOfObject:string];
            ActivityModel *model = [[ActivityModel alloc] init];
            model.typeName       = string;
            model.imageName = imageArr[num];
            [mulArray addObject:model];
        }
        
        self.gridOneView   = [[GridCollectionView alloc] initWithFrame: CGRectMake(0, 20, self.view.frame.size.width, screenHeight)];
        self.gridOneView.contentInsets       = UIEdgeInsetsMake(15, 15, 15, 15);
        self.gridOneView.HorizontalGap       = 15;
        self.gridOneView.verticalGap         = 15;
        self.gridOneView.cellHeight          = screenHeight;
        self.gridOneView.HorizontalCellCount = 3;
        self.gridOneView.dataArray           = mulArray;
        self.gridOneView.tag                 = kBusinessOne;
        
        TypeCellClass *typeCell = [[TypeCellClass alloc] init];
        typeCell.className      = [BusinessCell class];
        typeCell.registID       = @"BusinessCell";
        
        self.gridOneView.registCell = typeCell;
        self.gridOneView.delegate   = self;
        [self.gridOneView setUpFrame];
        [self.view addSubview:self.gridOneView];
    
}
- (void)gridCollectionView:(GridCollectionView *)gridCollectionView didSelected:(CustomCollectionViewCell *)cell {
    
    if (gridCollectionView.tag == kBusinessOne) {
        
        [gridCollectionView.dataArray enumerateObjectsUsingBlock:^(ActivityModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            cell.indexPath.row == idx ? (model.isSelected = YES):(model.isSelected = NO);
        }];
        
        [gridCollectionView LoadData];
        NSLog(@"点击第%ld个",cell.indexPath.row);
        addNewItemTableViewController *VC = [[addNewItemTableViewController alloc]init];
        VC.delegate = self.navigationController.childViewControllers[0];
        VC.type  = cell.indexPath.row;
        [self.navigationController pushViewController:VC animated:YES];
    } else if ( gridCollectionView.tag == kBusinessTwo) {
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 2;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor orangeColor];
//    // Configure the cell
//    
//    return cell;
//}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
