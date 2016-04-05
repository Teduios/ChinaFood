//
//  HPMethodCellFrame.m
//  全民菜谱
//
//  Created by tarena on 16/1/12.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPMethodCellFrame.h"
#import "HPMethod.h"
@implementation HPMethodCellFrame
- (void)setMethod:(HPMethod *)method{
    _method = method;
    CGSize labelSize = [self.method.step boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor blackColor]} context:nil].size;
    if(method.img||method.imageData){
        self.imgFrame = CGRectMake(20, 10, kScreenWidth - 40, kScreenWidth - 40);
        self.labelFrame = CGRectMake(10, CGRectGetMaxY(self.imgFrame) + 10, labelSize.width, labelSize.height);
        self.cellFrame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.labelFrame) + 10);
    }else{
        self.labelFrame = CGRectMake(10, 10, labelSize.width, labelSize.height);
        self.cellFrame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.labelFrame) + 10);
    }
}
@end
