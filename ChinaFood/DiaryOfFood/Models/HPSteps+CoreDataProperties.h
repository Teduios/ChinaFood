//
//  HPSteps+CoreDataProperties.h
//  全民菜谱
//
//  Created by tarena on 16/1/25.
//  Copyright © 2016年 tarena. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HPSteps.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPSteps (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *number;
@property (nullable, nonatomic, retain) NSData *stepImage;
@property (nullable, nonatomic, retain) NSString *stepString;
@property (nullable, nonatomic, retain) NSString *fullDate;
@property (nullable, nonatomic, retain) HPDiaryCookBook *owner;

@end

NS_ASSUME_NONNULL_END
