//
//  listCellItem.m
//  ChildGrowth
//
//  Created by ChenWanda on 2017/3/15.
//  Copyright © 2017年 HDU.eduHDU.EDU.CN. All rights reserved.
//

#import "listCellItem.h"

@implementation listCellItem
-(NSString *)contentStr{
    NSString *contStr;
    switch (_type) {
        case 0:
            contStr = _describe;
            break;
        case 1:
        {
            NSString *cont1;
            NSString *cont2;
            NSString *cont3;
            if ([_height isEqualToString:@""]) {
               cont1 = @"身高:未测量";
            }else{
            cont1 =[NSString stringWithFormat:@"身高:%@厘米",_height];
            }
            if ([_weight isEqualToString:@""]) {
                cont2 = @"体重:未测量";
            }else{
                cont2 =[NSString stringWithFormat:@"体重:%@公斤",_weight];
            }
            if ([_headc isEqualToString:@""]) {
                cont3 = @"头围:未测量";
            }else{
                cont3 =[NSString stringWithFormat:@"头围:%@厘米",_headc];
            }
            contStr = [NSString stringWithFormat:@"%@ %@ %@\n%@",cont1,cont2,cont3,_describe];
            break;
        }
        default:
            contStr = _describe;
            break;
    }
    return contStr;
}
@end
