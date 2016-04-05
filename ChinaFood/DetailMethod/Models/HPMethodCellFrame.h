//
//  HPMethodCellFrame.h
//  全民菜谱
//
//  Created by tarena on 16/1/12.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HPMethod;
@interface HPMethodCellFrame : NSObject
@property (nonatomic, strong) HPMethod *method;
@property (nonatomic, assign) CGRect imgFrame;
@property (nonatomic, assign) CGRect labelFrame;
@property (nonatomic, assign) CGRect cellFrame;
@end
