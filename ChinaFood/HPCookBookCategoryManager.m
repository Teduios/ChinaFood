//
//  HPCookBookCategoryManager.m
//  全民菜谱
//
//  Created by tarena on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPCookBookCategoryManager.h"
#import "HPCookBookCategoryTag.h"
#import "HPMethod.h"
#import "HPCookBook.h"
@implementation HPCookBookCategoryManager

+ (instancetype) sharedCategoryManager{
    static HPCookBookCategoryManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HPCookBookCategoryManager alloc] init];
    });
    return manager;
}

+ (NSDictionary *) getDictionartWithType: (NSUInteger)index{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"category" ofType:@"plist"];
    NSArray *category = [NSArray arrayWithContentsOfFile:path];
    NSDictionary *dict = category[index];

    return dict;

}

+ (NSArray *)getCategoryByType:(HPType)type{
    
    NSDictionary *dict = [self getDictionartWithType:type];
    NSArray *array = dict[@"childs"];
    NSMutableArray *mutablearray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        NSDictionary *categoryInfo = dict[@"categoryInfo"];
        HPCookBookCategoryTag *tag = [[HPCookBookCategoryTag alloc] init];
        [tag setValuesForKeysWithDictionary:categoryInfo];
        [mutablearray addObject:tag];
    }
    return [mutablearray copy];
}

+ (NSArray *)getAllCategory{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        NSMutableArray *typeArray = [NSMutableArray array];
        NSDictionary *dict = [self getDictionartWithType:i];
        NSDictionary *mainDic = dict[@"categoryInfo"];
        HPCookBookCategoryTag *tag = [[HPCookBookCategoryTag alloc] init];
        [tag setValuesForKeysWithDictionary:mainDic];
        NSArray *categoryArray = [self getCategoryByType:i];
        [typeArray addObject:tag];
        [typeArray addObject:categoryArray];
        [mutableArray addObject:typeArray];
    }
    return [mutableArray copy];
}

+ (HPCookBook *)getCookBookWithDict:(NSDictionary *)dict{
    HPCookBook *cookBook = [[HPCookBook alloc] initWithDict:dict];
    return cookBook;
}


@end
