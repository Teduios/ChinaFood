//
//  HPDetailStepViewController.h
//  全民菜谱
//
//  Created by tarena on 16/1/25.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HPSteps.h"
@interface HPDetailStepViewController : UIViewController
@property (nonatomic, strong) NSFetchedResultsController *resultController;
@property (nonatomic, strong) HPSteps *step;
@property (nonatomic, strong) NSString *fullDate;
@property (nonatomic, assign) NSInteger stepNumber;
@end
