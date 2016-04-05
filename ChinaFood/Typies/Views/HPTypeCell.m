//
//  HPTypeCell.m
//  全民菜谱
//
//  Created by tarena on 16/1/10.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPTypeCell.h"
#import "UIButton+WebCache.h"
#define kSpace 10
#define kmainViewHeight 200
#define ktitleHeight 44
@interface HPTypeCell()

@property (nonatomic, strong) UILabel *nameLabel;

@end
@implementation HPTypeCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.opaque = YES;
        //self.mainView = [[UIView alloc] init];
        //self.mainView.opaque = YES;
        //[self.contentView addSubview:self.mainView];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.opaque = YES;
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = [UIColor colorWithRed:155.0 / 255 green:166.0 / 255 blue:170.0 / 255 alpha:1];
        self.mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mainButton.opaque = YES;
        self.mainButton.userInteractionEnabled = NO;
        self.mainButton.tag = 1;
        [self.contentView addSubview:self.mainButton];
        [self.mainButton addSubview:self.nameLabel];




    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.mainButton.frame = CGRectMake(0, kSpace, kScreenWidth , kmainViewHeight);
    //self.mainButton.frame = CGRectMake(0, 0, kScreenWidth, kmainViewHeight);
    self.nameLabel.frame = CGRectMake(20, kmainViewHeight - 44, 200, 44);



}

-(void)setCookBook:(HPCookBook *)cookBook{
    _cookBook = cookBook;
    NSURL *url = [NSURL URLWithString:_cookBook.recipe.img];
    [self.mainButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    self.nameLabel.text = _cookBook.name;
    NSArray *array = [cookBook.ctgTitles componentsSeparatedByString:@","];

    for (id subview in self.contentView.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subview;
            if (btn.tag!=1) {
                [btn removeFromSuperview];
            }
        }
    }
    
    UIButton *lastButton = nil;
    for (int i = 0; i < array.count; i ++) {
        NSString *str = array[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:str forState:UIControlStateNormal];
        CGSize size = [str boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
        NSLog(@"%@",str);
        NSLog(@"%@", NSStringFromCGSize(size));
        [self.contentView addSubview:btn];
        btn.frame = CGRectMake((20 + CGRectGetMaxX(lastButton.frame)) , 220, size.width, 20);
        lastButton = btn;
    }
}


@end
