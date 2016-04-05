//
//  HPCookBook.m
//  全民菜谱
//
//  Created by tarena on 16/1/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPCookBook.h"
#import "HPSteps.h"
@implementation HPCookBook
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.ctgIds = dict[@"ctgIds"];
        self.ctgTitles = dict[@"ctgTitles"];
        self.menuId = dict[@"menuId"];
        self.name = dict[@"name"];
        self.thumbnail = dict[@"thumbnail"];
        
        NSDictionary *recipeDict = dict[@"recipe"];
        self.recipe = [[HPRecipe alloc] initWithDic:recipeDict];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.ctgIds forKey:@"ctgIds"];
    [aCoder encodeObject:self.ctgTitles forKey:@"ctgTitles"];
    [aCoder encodeObject:self.menuId forKey:@"menuId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.recipe];
    [aCoder encodeObject:data forKey:@"recipe"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.ctgIds = [aDecoder decodeObjectForKey:@"ctgIds"];
        self.ctgTitles = [aDecoder decodeObjectForKey:@"ctgTitles"];
        self.menuId = [aDecoder decodeObjectForKey:@"menuId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
        NSData *data = [aDecoder decodeObjectForKey:@"recipe"];
        self.recipe = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return self;
}

- (void)setDiaryCookBook:(HPDiaryCookBook *)diaryCookBook{
    _diaryCookBook = diaryCookBook;
    self.name = diaryCookBook.name;
    HPRecipe *recipe = [[HPRecipe alloc] init];
    self.recipe = recipe;
    self.recipe.sumary = diaryCookBook.sumary;
    self.recipe.ingredients = [NSKeyedUnarchiver unarchiveObjectWithData:diaryCookBook.recipes];
    NSSortDescriptor *descroptor = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
    NSArray *methods = [diaryCookBook.step sortedArrayUsingDescriptors:@[descroptor]];
    NSMutableArray *array = [NSMutableArray array];
    for (HPSteps *step in methods) {
        HPMethod *method = [[HPMethod alloc] init];
        method.imageData = step.stepImage;
        method.step = step.stepString;
        [array addObject:method];
    }
    self.recipe.method = [array copy];
    
}

@end
