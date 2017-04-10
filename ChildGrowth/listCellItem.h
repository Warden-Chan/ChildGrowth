//
//  listCellItem.h
//  ChildGrowth
//
//  Created by ChenWanda on 2017/3/15.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface listCellItem : NSObject
@property (nonatomic, copy) NSString *time;
@property (nonatomic) NSInteger ChildId;
@property (nonatomic) NSInteger type;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *headc;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, copy) NSString *contentStr;
@end
