//
//  HPRecipe.h
//  全民菜谱
//
//  Created by tarena on 16/1/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPMethod.h"
@interface HPRecipe : NSObject<NSCoding>
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSArray *ingredients;
@property (nonatomic, strong) NSArray *method;
@property (nonatomic, strong) NSString *sumary;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
