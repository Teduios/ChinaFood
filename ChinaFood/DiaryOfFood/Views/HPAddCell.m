//
//  HPAddCell.m
//  全民菜谱
//
//  Created by tarena on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPAddCell.h"
@interface HPAddCell()

@end
@implementation HPAddCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton.userInteractionEnabled = NO;
        [self.addButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.addButton];
    }
    return self;
}

- (void)setButtonTitle:(NSString *)buttonTitle{
    _buttonTitle = buttonTitle;
    [self.addButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.addButton.frame = CGRectMake(0, 0, kScreenWidth, 44);
}




@end
