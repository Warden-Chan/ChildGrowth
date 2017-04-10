//
//  consult.m
//  ChildGrowth
//
//  Created by ChenWanda on 2016/11/21.
//  Copyright © 2016年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "Consult.h"

@implementation Consult
- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        
        CGFloat space = 10;
        /** 图像 */
        CGFloat iconX = space;
        CGFloat iconY = space;
        CGFloat iconWH = 30;
        self.iconFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
        
        /** 昵称 */
        CGFloat nameX = CGRectGetMaxX(self.iconFrame) + space;
        CGFloat nameY = iconY;
        NSDictionary *nameAtt = @{NSFontAttributeName : [UIFont systemFontOfSize:17]};
        // 计算昵称文字的尺寸
        CGSize nameSize = [self.name sizeWithAttributes:nameAtt];
        CGFloat nameW = nameSize.width;
        CGFloat nameH = nameSize.height;
        self.nameFrame = CGRectMake(nameX, nameY, nameW, nameH);
        
        /** 时间 */
        CGFloat timeX = CGRectGetMaxX(self.iconFrame) + space;
        CGFloat timeY = CGRectGetMaxY(self.nameFrame);
        NSDictionary *timeAtt = @{NSFontAttributeName : [UIFont systemFontOfSize:12]};
        // 计算尺寸
        CGSize timeSize = [self.time sizeWithAttributes:timeAtt];
        CGFloat timeW = timeSize.width +160;
        CGFloat timeH = timeSize.height;
        self.timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
        
        /** 正文 */
        CGFloat textX = iconX;
        CGFloat textY = CGRectGetMaxY(self.iconFrame) + space;
        CGFloat textW = [UIScreen mainScreen].bounds.size.width - 2 * space;
        NSDictionary *textAtt = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
        // 最大宽度是textW,高度不限制
        CGSize textSize = CGSizeMake(textW, MAXFLOAT);
        CGFloat textH = [self.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size.height;
        self.textFrame = CGRectMake(textX, textY, textW, textH);
        

            _cellHeight = CGRectGetMaxY(self.textFrame) + space;
        
        
    }
    return _cellHeight;
}

@end
