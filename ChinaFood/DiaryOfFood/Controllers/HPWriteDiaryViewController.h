//
//  HPWriteDiaryViewController.h
//  全民菜谱
//
//  Created by tarena on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HPDiaryCookBook.h"
@interface HPWriteDiaryViewController : UIViewController
@property (nonatomic, strong) NSFetchedResultsController *resultController;
@property (nonatomic, strong) HPDiaryCookBook* cookBook;
@property (nonatomic, strong) NSManagedObjectContext *context;


@end
