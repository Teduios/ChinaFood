//
//  HPMethod.m
//  全民菜谱
//
//  Created by tarena on 16/1/5.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HPMethod.h"

@implementation HPMethod
//制作方法中的步骤以及image赋值 
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.img forKey:@"img"];
    [aCoder encodeObject:self.step forKey:@"step"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.img = [aDecoder decodeObjectForKey:@"img"];
        self.step = [aDecoder decodeObjectForKey:@"step"];
    }
    return self;
}
    
    
@end
