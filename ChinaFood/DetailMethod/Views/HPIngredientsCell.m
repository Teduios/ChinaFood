//
//  HPIngredientsCell.m
//  全民菜谱
//
//  Created by tarena on 16/1/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPIngredientsCell.h"
#import "HPIngredientsFrame.h"
@interface HPIngredientsCell()
@property (nonatomic, strong) UILabel *ingredientsLabel;
@end
@implementation HPIngredientsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.ingredientsLabel = [[UILabel alloc] init];
        self.ingredientsLabel.font = [UIFont systemFontOfSize:12];
        self.ingredientsLabel.numberOfLines = 0;
        [self.contentView addSubview:self.ingredientsLabel];
    }
    return self;
}

- (void)setIngredientFrame:(HPIngredientsFrame *)ingredientFrame{
    _ingredientFrame = ingredientFrame;
    self.ingredientsLabel.text = ingredientFrame.ingredinet;
    self.ingredientsLabel.frame = ingredientFrame.textFrame;
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
}


@end
