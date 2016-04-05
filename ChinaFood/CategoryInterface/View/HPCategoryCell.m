//
//  HPCategoryCell.m
//  全民菜谱
//
//  Created by tarena on 16/1/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPCategoryCell.h"
#import "HPCookBookCategoryTag.h"
#import "HPCategoryFrame.h"
#import "HPTypeViewController.h"
#import "HPNavigationController.h"
#define kCol 5
#define kSpace 10
#define kButtonWidth ((kScreenWidth - (kCol + 1) * kSpace) / (kCol))
#define kButtonHeight 44
#define kImageWidth (2 * kButtonWidth + kSpace)
#define kImageHeight (2 * kButtonHeight + kSpace)
@implementation HPCategoryCell


- (void)setCategoryFrame:(HPCategoryFrame *)categoryFrame{
    _categoryFrame = categoryFrame;
    NSArray *categories = _categoryFrame.categories;
    HPCookBookCategoryTag *mainTag = categories[0];
    [self setTitleLableWithTagName:mainTag.name];
    NSArray *subTags = categories[1];
    [self setViewWithTags:subTags];
}

- (void)setViewWithTags:(NSArray *)tags{
    UIView *view = [[UIView alloc] init];
    self.view = view;
    view.frame = _categoryFrame.categoryViewFrame;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString *imageName = [NSString stringWithFormat:@"category%ld",_imageNum];
    imageView.image = [UIImage imageNamed:imageName];
    [view addSubview:imageView];
    CGFloat imageX = kSpace;
    CGFloat imageY = 0;
    CGFloat imageW = kButtonWidth * 2 + kSpace;
    CGFloat imageH = kButtonHeight * 2+ kSpace;
    imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    unsigned long totalNum = kCol + tags.count;
    int tagNum = 0;
    for (int i = 0; i < totalNum; i ++) {
        if(!(i == 0 || i == 1 || i == kCol || i == kCol + 1 )){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = tagNum;
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            if (tagNum < tags.count) {
                HPCookBookCategoryTag *tag = tags[tagNum];
                [btn setTitle:tag.name forState:UIControlStateNormal];
                CGFloat btnX = (i % kCol) * (kButtonWidth + kSpace) + kSpace;
                CGFloat btnY = (i / kCol) * (kButtonHeight + kSpace);
                CGFloat btnW = kButtonWidth;
                CGFloat btnH = kButtonHeight;
                btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
                [view addSubview:btn];
                
            }
            tagNum ++;
        
        }
    }
    
    [self.contentView addSubview:view];
    
    
}

- (void)setTitleLableWithTagName:(NSString *) name{
    UILabel *lable = [[UILabel alloc] init];
    self.label = lable;
    lable.font = [UIFont systemFontOfSize:13];
    lable.text = name;
    lable.frame = _categoryFrame.titleFrame;
    [self.contentView addSubview:lable];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

- (void)setImageNum:(NSInteger)imageNum{
    _imageNum = imageNum;
}

- (void)clickButton:(UIButton *)btn{
    HPCookBookCategoryTag *tag = _categoryFrame.categories[1][btn.tag];
    HPTypeViewController *tvc = [[HPTypeViewController alloc] init];
    tvc.ctgId = tag.ctgId;
    tvc.title = tag.name;
    HPNavigationController *navigationController = [[HPNavigationController alloc] initWithRootViewController:tvc];
    [self.categoryController presentViewController:navigationController animated:YES completion:nil];
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
}


@end
