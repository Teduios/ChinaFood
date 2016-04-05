//
//  HPCategoryFrame.m
//  全民菜谱
//
//  Created by tarena on 16/1/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPCategoryFrame.h"
#import "HPCookBookCategoryTag.h"
#define kCol 5
#define kSpace 10
#define kButtonHeight 44


@implementation HPCategoryFrame
- (void)setCategories:(NSArray *)categories{
    _categories = categories;
    
    //titleFrame
    CGFloat labelX = kSpace;
    CGFloat labelY = kSpace;
    CGFloat labelW = 100;
    CGFloat labelH = 44;
    _titleFrame = CGRectMake(labelX, labelY, labelW, labelH);
    
    //viewFrame
    NSArray *tags = _categories[1];
    NSInteger num = tags.count;
    NSInteger allCount = num + kCol;
    int col = kCol;
    long int totalRow = (col + allCount - 1) / col;
    CGFloat viewX = 0;
    CGFloat viewY = CGRectGetMaxY(_titleFrame) + kSpace;
    CGFloat viewW = kScreenWidth;
    CGFloat viewH = kButtonHeight * totalRow + kSpace * (totalRow - 1);
    _categoryViewFrame = CGRectMake(viewX, viewY, viewW, viewH);
    
    CGFloat cellH = CGRectGetMaxY(_categoryViewFrame) + kSpace;
    _cellFrame = CGRectMake(0, 0, kScreenWidth, cellH);
    
    
    
    
}
@end
