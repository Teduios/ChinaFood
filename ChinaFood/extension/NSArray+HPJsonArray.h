//
//  NSArray+HPJsonArray.h
//  全民菜谱
//
//  Created by tarena on 16/1/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (HPJsonArray)
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;
@end
