//
//  HPDiaryViewController.m
//  全民菜谱
//
//  Created by tarena on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPDiaryViewController.h"
#import "HPWriteDiaryViewController.h"
#import <CoreData/CoreData.h>
#import "HPDiaryCookBook.h"
#import "HPDiaryCell.h"
#import "HPMethodViewController.h"
#import "HPCookBook.h"
#import "RMPZoomTransitionAnimator.h"
@interface HPDiaryViewController ()<NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, RMPZoomTransitionAnimating>
@property (weak, nonatomic) IBOutlet UILabel *noDiaryLabel;
@property (weak, nonatomic) IBOutlet UITableView *diaryTableView;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *resultController;
@end

@implementation HPDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setContext];
    [self setUpTableView];
}


- (void)setUpTableView{
    self.diaryTableView.delegate = self;
    self.diaryTableView.dataSource = self;
    self.diaryTableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    /** 将要出现*/
    [super viewWillAppear:animated];
    
    if ([self.tabBarController.tabBar isHidden]) {
        self.tabBarController.tabBar.hidden = NO;
    }
    /** coredata内容数量 */
    if (self.resultController.fetchedObjects.count == 0) {
        self.diaryTableView.hidden = YES;
    }else{
        self.diaryTableView.hidden = NO;
    }
}


- (void)setContext{
    /** coredata 内容，存储数据*/
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"HPMyDiaryFoodBook" withExtension:@"momd"];
    NSManagedObjectModel *objModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:objModel];
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *databasePath = [documentPath stringByAppendingPathComponent:@"sqlite.db"];
    NSError *error = nil;
   [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:databasePath] options:nil error:&error];
    [self.context setPersistentStoreCoordinator:coordinator];
    
}

- (NSFetchedResultsController *)resultController{
    if (_resultController!= nil) {
        return _resultController;
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HPDiaryCookBook"];
    /** 排序 */
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    request.sortDescriptors = @[sortDescriptor1, sortDescriptor2];
    
    _resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate = self;
    NSError *error = nil;
    if (![_resultController performFetch:&error]) {
        NSLog(@"执行监听请求失败:%@", error.userInfo);
    }
    return _resultController;
}


- (IBAction)clickWriteDiaryButton:(UIBarButtonItem *)sender {
    /** 一个懒加载 一个是set方法*/
    HPWriteDiaryViewController *wdvc = [[HPWriteDiaryViewController alloc] init];
    wdvc.resultController = self.resultController;
    wdvc.context = self.context;
    /** 推出写日记界面 */
    [self.navigationController pushViewController:wdvc animated:YES];
}

#pragma mark - tableviewDataSource&&delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HPDiaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diaryCell" forIndexPath:indexPath];
    HPDiaryCookBook *book = self.resultController.fetchedObjects[indexPath.row];
    cell.book = book;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    id object = self.resultController.fetchedObjects[indexPath.row];
//    HPDiaryCookBook *diaryBook = nil;
//    /** 看不懂*/
//    if ([object isKindOfClass:[HPDiaryCookBook class]]) {
//        diaryBook = object;
//    }
    
    HPDiaryCookBook *diaryBook = self.resultController.fetchedObjects[indexPath.row];
    /** */
    HPMethodViewController *mvc = [[HPMethodViewController alloc] init];
    HPCookBook *cookBook = [[HPCookBook alloc] init];
    cookBook.diaryCookBook = diaryBook;
    mvc.book = cookBook;
    [self.navigationController pushViewController:mvc animated:YES];
    
    
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{

    NSLog(@"controllerDidChangeContent");
    [self.diaryTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

/** 哪里调用*/
- (UIImageView *)transitionSourceImageView
{
    NSIndexPath *selectedIndexPath = [self.diaryTableView indexPathForSelectedRow];
    HPDiaryCell *cell = (HPDiaryCell *)[self.diaryTableView cellForRowAtIndexPath:selectedIndexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:cell.foodBookImageView.image];
    imageView.contentMode = cell.foodBookImageView.contentMode;
    
    imageView.clipsToBounds = YES;
    /** 图片用户交互*/
    imageView.userInteractionEnabled = NO;
    CGFloat y = 76.5 + selectedIndexPath.row * 90;
    
    NSLog(@"%f",y);
    CGRect frameInSuperview = CGRectMake(100, y, 65, 65);
    
    imageView.frame = frameInSuperview;
    
    NSLog(@"image%@", NSStringFromCGRect(imageView.frame));
    return imageView;
}

- (UIColor *)transitionSourceBackgroundColor
{
    return self.diaryTableView.backgroundColor;
}

- (CGRect)transitionDestinationImageViewFrame
{
    NSIndexPath *selectedIndexPath = [self.diaryTableView indexPathForSelectedRow];
    CGFloat y = 76.5 + selectedIndexPath.row * 90;
    CGRect frameInSuperview = CGRectMake(100, y, 65, 65);
    NSLog(@"super%@",NSStringFromCGRect(frameInSuperview));
    return frameInSuperview;
}

#pragma mark - 删除操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"一旦删除将无法复原" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            HPDiaryCookBook *diaryCookBook = self.resultController.fetchedObjects[indexPath.row];
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HPSteps"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullDate = %@",diaryCookBook.fulldate];
            request.predicate = predicate;
            NSError *error = nil;
            NSArray *resultArray = [self.context executeFetchRequest:request error:&error];
            for (NSManagedObject *diaryStep in resultArray) {
                [self.context deleteObject:diaryStep];
            }
            [self.context deleteObject:diaryCookBook];
            if(![self.context save:&error]){
                NSLog(@"删除失败%@", error);
            }
            
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
    
}



@end
