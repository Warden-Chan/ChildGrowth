//
//  XMGStatus.m
//  12-自定义不等高的cell-frame01-
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "Second.h"

@implementation Second

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        
        CGFloat space = 10;
        /** 图像 */
        CGFloat iconX = space*2;
        CGFloat iconY = space;
        CGFloat iconWH = 28;
        self.iconFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
        
        /** 标题*/
        CGFloat nameX = CGRectGetMaxX(self.iconFrame) + space *0.5;
        CGFloat nameY = iconY +space*0.2;
        NSDictionary *nameAtt = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
        // 计算昵称文字的尺寸
        CGSize nameSize = [self.name sizeWithAttributes:nameAtt];
        CGFloat nameW = nameSize.width;
        CGFloat nameH = nameSize.height;
        self.nameFrame = CGRectMake(nameX, nameY, nameW, nameH);
        
        
        /** 正文 */
        CGFloat textX = iconX ;
        CGFloat textY = CGRectGetMaxY(self.iconFrame);
        CGFloat textW = [UIScreen mainScreen].bounds.size.width - 3 * space;
        NSDictionary *textAtt = @{NSFontAttributeName : [UIFont systemFontOfSize:19]};
        // 最大宽度是textW,高度不限制
        CGSize textSize = CGSizeMake(textW, MAXFLOAT);
        CGFloat textH = [self.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size.height;
        self.textFrame = CGRectMake(textX, textY, textW, textH);
        
            _cellHeight = CGRectGetMaxY(self.textFrame) + space;


    }
    return _cellHeight;
}

@end
