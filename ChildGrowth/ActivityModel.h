//
//  ActivityModel.h
//  Button-CollectionView
//
//  Created by WangQiao on 16/7/19.
//  Copyright © 2016年 wq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic) BOOL             isSelected;

@end
