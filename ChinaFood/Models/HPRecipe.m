//
//  HPRecipe.m
//  全民菜谱
//
//  Created by tarena on 16/1/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPRecipe.h"
#import "NSArray+HPJsonArray.h"
@implementation HPRecipe
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.img = dic[@"img"];
        
        self.ingredients = dic[@"ingredients"];
        self.ingredients = [NSArray arrayWithJsonString:dic[@"ingredients"]];
        self.sumary = dic[@"sumary"];
        self.title = dic[@"title"];
        NSString *methodStr = dic[@"method"];
        self.method = [self getMethodArrayWith:methodStr];
    }
    return self;
}

- (NSArray *)getMethodArrayWith:(NSString *)methodStr{
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *array = [NSArray arrayWithJsonString:methodStr];
    for (NSDictionary *methodDic in array) {
        HPMethod *method = [[HPMethod alloc] initWithDict:methodDic];
        [mutableArray addObject:method];
    }
    return [mutableArray copy];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.img forKey:@"img"];
    [aCoder encodeObject:self.ingredients forKey:@"ingredients"];
    [aCoder encodeObject:self.sumary forKey:@"sumary"];
    [aCoder encodeObject:self.title forKey:@"title"];
    NSMutableArray *array = [NSMutableArray array];
    for (HPMethod *method in self.method) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:method];
        [array addObject:data];
    }
    NSArray *methods = [array copy];
    [aCoder encodeObject:methods forKey:@"method"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.img = [aDecoder decodeObjectForKey:@"img"];
        self.ingredients = [aDecoder decodeObjectForKey:@"ingredients"];
        self.sumary = [aDecoder decodeObjectForKey:@"sumary"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        NSArray *array = [aDecoder decodeObjectForKey:@"method"];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSData *data in array) {
            HPMethod *method = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [mutableArray addObject:method];
        }
        self.method = [mutableArray copy];
        
    }
    return self;
}


@end
