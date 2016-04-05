//
//  HPWriteIngredientsCell.m
//  全民菜谱
//
//  Created by tarena on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPWriteIngredientsCell.h"
@interface HPWriteIngredientsCell()


@end
@implementation HPWriteIngredientsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.ingredients = [[UITextField alloc] init];
        NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor grayColor]};
        self.ingredients.placeholder = @"食材名";
        self.ingredients.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.ingredients.placeholder attributes:attrs];
        [self.contentView addSubview:self.ingredients];
        self.usage = [[UITextField alloc] init];
        self.usage.placeholder = @"用量";
        self.usage.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.usage.placeholder attributes:attrs];
        [self.contentView addSubview:self.usage];

    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.ingredients.frame = CGRectMake(10, 0, kScreenWidth / 2 - 10, 44);
    self.usage.frame = CGRectMake(kScreenWidth / 2 + 10, 0, kScreenWidth / 2 - 10, 44);
    
}

@end
