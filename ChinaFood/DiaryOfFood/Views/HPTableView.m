//
//  HPTableView.m
//  全民菜谱
//
//  Created by tarena on 16/1/26.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPTableView.h"

@implementation HPTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    id view = [super hitTest:point withEvent:event];
//    if (![view isKindOfClass:[UITextField class]]) {
//        [self endEditing:YES];
//        [UIView animateWithDuration:0 delay:0.0 options:7 << 16 animations:^{
//            self.superview.transform = CGAffineTransformMakeTranslation(0, 0);
//        } completion:nil];
//        NSLog(@"das");
//        return self;
//    }else{
//        return view;
//    }
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.superview endEditing:YES];
    [UIView animateWithDuration:0 delay:0.0 options:7 << 16 animations:^{
        self.superview.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];
}
@end
