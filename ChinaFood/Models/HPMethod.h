//
//  HPMethod.h
//  全民菜谱
//
//  Created by tarena on 16/1/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPMethod : NSObject<NSCoding>
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *step;
@property (nonatomic, strong) NSData *imageData;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
