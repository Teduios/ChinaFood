//
//  HPCategoryFrame.h
//  全民菜谱
//
//  Created by tarena on 16/1/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPCategoryFrame : NSObject
@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) CGRect categoryViewFrame;
@property (nonatomic, assign) CGRect cellFrame;
@property (nonatomic, strong) NSArray *categories;
@end
