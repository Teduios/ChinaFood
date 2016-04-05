//
//  HPCookBook.h
//  全民菜谱
//
//  Created by tarena on 16/1/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPRecipe.h"
#import "HPDiaryCookBook.h"

@interface HPCookBook : NSObject<NSCoding>
@property (nonatomic, strong) NSArray *ctgIds;
@property (nonatomic, strong) NSString *ctgTitles;
@property (nonatomic, strong) NSString *menuId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) HPRecipe *recipe;
@property (nonatomic, strong) HPDiaryCookBook *diaryCookBook;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
