//
//  HPDiaryCookBook+CoreDataProperties.h
//  全民菜谱
//
//  Created by tarena on 16/1/25.
//  Copyright © 2016年 tarena. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HPDiaryCookBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPDiaryCookBook (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSData *recipes;
@property (nullable, nonatomic, retain) NSString *sumary;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSString *fulldate;
@property (nullable, nonatomic, retain) NSSet<HPSteps *> *step;

@end

@interface HPDiaryCookBook (CoreDataGeneratedAccessors)

- (void)addStepObject:(HPSteps *)value;
- (void)removeStepObject:(HPSteps *)value;
- (void)addStep:(NSSet<HPSteps *> *)values;
- (void)removeStep:(NSSet<HPSteps *> *)values;

@end

NS_ASSUME_NONNULL_END
