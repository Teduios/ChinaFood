//
//  HPCookBookCategoryManager.h
//  全民菜谱
//
//  Created by tarena on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HPCookBook;
typedef NS_ENUM(int, HPType) {
    HPTypeVariety,
    HPTypeCraft,
    HPTypeStyle,
    HPTypePeople,
    HPTypeFunction
    
};
@interface HPCookBookCategoryManager : NSObject
+ (instancetype) sharedCategoryManager;
+ (NSArray *)getCategoryByType:(HPType)type;
+ (NSArray *)getAllCategory;
+ (HPCookBook *)getCookBookWithDict:(NSDictionary *)dict;
@end
