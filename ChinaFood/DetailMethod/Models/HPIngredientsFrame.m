//
//  HPIngredientsFrame.m
//  全民菜谱
//
//  Created by tarena on 16/1/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPIngredientsFrame.h"

@implementation HPIngredientsFrame


- (void)setIngredinet:(NSString *)ingredinet{
    _ingredinet = ingredinet;
    NSLog(@"ingredinet  %@", ingredinet);
    CGSize labelSize = [_ingredinet boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor blackColor]} context:nil].size;
    NSLog(@"labelSize  %@", NSStringFromCGSize(labelSize));
    self.textFrame = CGRectMake(10, 10, labelSize.width, labelSize.height);
    self.cellFrame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.textFrame) + 10);
}


@end
