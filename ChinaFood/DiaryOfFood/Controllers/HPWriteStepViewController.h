//
//  HPWriteStepViewController.h
//  全民菜谱
//
//  Created by tarena on 16/1/22.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HPDiaryCookBook.h"
@interface HPWriteStepViewController : UIViewController
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) HPDiaryCookBook *diaryCookBook;
@property (nonatomic, strong) NSFetchedResultsController *resultController;



@end
