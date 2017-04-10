//
//  BusinessCell.m
//  Button-CollectionView
//
//  Created by WangQiao on 16/7/19.
//  Copyright © 2016年 wq. All rights reserved.
//

#import "BusinessCell.h"
#import "ActivityModel.h"

typedef enum : NSUInteger {
    
    kNormalState = 20,
    kSelectedState,
    
} ETouchEventState;

@interface BusinessCell ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BusinessCell
static CGFloat const textLabelHeight =20;
- (void)setUpCell {

    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5;
}

- (void)buildUpSubviews {
    //1.添加imageView
    CGFloat imageHeight = self.bounds.size.height - textLabelHeight;
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageHeight, imageHeight)];
    [self addSubview:self.imageView];
    //2.添加textLabel
    self.textLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(0, imageHeight, self.bounds.size.width, textLabelHeight)];
    self.textLabel.textColor         = [UIColor redColor];
    self.textLabel.backgroundColor   = [UIColor whiteColor];
    self.textLabel.font              = [UIFont systemFontOfSize:15];
    self.textLabel.textAlignment     = NSTextAlignmentCenter;
    self.textLabel.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self addSubview:self.textLabel];
}

- (void)loadContent {
    
    ActivityModel * model = self.data;
    UIImage *image = [UIImage imageNamed:model.imageName];
    self.textLabel.text = model.typeName;
    self.imageView.image = image;
    if (model.isSelected) {
        
        [self changToState:kSelectedState animation:NO];
        
    } else {
    
        [self changToState:kNormalState animation:NO];
    }
}

- (void)changToState:(ETouchEventState)state animation:(BOOL)animation {
    
    if (state == kNormalState) {
        
        self.textLabel.textColor = [UIColor blackColor];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
    } else if (state == kSelectedState) {
    
        self.textLabel.textColor = [UIColor orangeColor];
        self.layer.borderColor = [UIColor orangeColor].CGColor;
    }
}

- (void)touchEvent {
    
    ActivityModel * model = self.data;
    
    if (model.isSelected == YES) {
        
        model.isSelected = NO;
        
        [self changToState:kNormalState animation:NO];
        
    } else if (model.isSelected == NO) {
        
        model.isSelected = YES;
        
        [self changToState:kSelectedState animation:NO];
    }
}

@end
