//
//  HTextViewCell.h
//  Textfield
//
//  Created by 朱同海 on 16/7/6.
//  Copyright © 2016年 朱同海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTextViewCell : UITableViewCell

- (void)setTitleString:(NSString *)string detailString:(NSString *)detailString andDataString:(NSString *)dataString andIndexPath:(NSIndexPath *)indexPath;
@end
