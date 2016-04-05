//
//  HPWriteStepViewController.m
//  全民菜谱
//
//  Created by tarena on 16/1/22.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPWriteStepViewController.h"
#import "HPAddCell.h"
#import "HPDiaryStepCell.h"
#import "HPDetailStepViewController.h"

@interface HPWriteStepViewController ()<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HPWriteStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    [self setUpTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"title"];
    [self.tableView registerClass:[HPAddCell class] forCellReuseIdentifier:@"add"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HPDiaryStepCell" bundle:nil] forCellReuseIdentifier:@"step"];
    self.tableView.tableFooterView = [[UIView alloc] init];

}



- (void)setNavigation{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
}

- (NSFetchedResultsController *)resultController{
    if (_resultController != nil) {
        NSError *error1 = nil;
        if(![_resultController performFetch:&error1]){
            NSLog(@"error%@",error1);
        }
        return _resultController;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"HPSteps"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullDate=%@",self.diaryCookBook.fulldate];
    request.predicate = predicate;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
    request.sortDescriptors = @[sort];
    _resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate = self;
    NSError *error = nil;
    if(![_resultController performFetch:&error]){
        NSLog(@"error %@", error);
    }
    return _resultController;
}

- (void)setUpTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else {
        return self.resultController.fetchedObjects.count+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title" forIndexPath:indexPath];
        cell.textLabel.text = self.diaryCookBook.name;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessibilityLabel = @"编辑";
        return cell;
    }else{
        if (indexPath.row == self.resultController.fetchedObjects.count) {
            HPAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"add" forIndexPath:indexPath];
            cell.buttonTitle = @"添加步骤";
            return cell;
        }else{
            HPSteps *step = self.resultController.fetchedObjects[indexPath.row];
            HPDiaryStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"step" forIndexPath:indexPath];
            [cell.numberButton setTitle:[NSString stringWithFormat:@"%@", step.number] forState:UIControlStateNormal];
            cell.detailImage.image = [UIImage imageWithData:step.stepImage];
            cell.stepLabel.text = step.stepString;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row != self.resultController.fetchedObjects.count) {
            return 96;
        }else{
            return 44;
        }
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == self.resultController.fetchedObjects.count) {
            HPDetailStepViewController *dsvc = [[HPDetailStepViewController alloc] init];
            dsvc.resultController = self.resultController;
            dsvc.fullDate = self.diaryCookBook.fulldate;
            dsvc.stepNumber = self.resultController.fetchedObjects.count + 1;
            [self.navigationController pushViewController:dsvc animated:YES];
        }
    }else{
            [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    NSLog(@"数据发生改变");
    [self.tableView reloadData];
}

- (void)save{
    NSSet *set = [NSSet setWithArray:self.resultController.fetchedObjects];
    [self.diaryCookBook addStep:set];
    NSError *error = nil;
    if(![self.context save:&error]){
        NSLog(@"失败%@", error);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 删除操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定删除吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            HPSteps *diartStep = self.resultController.fetchedObjects[indexPath.row];
            [self.context deleteObject:diartStep];
            int num = 1;
            for (NSInteger i = 0; i < self.resultController.fetchedObjects.count  ; i++) {
                HPSteps *step = self.resultController.fetchedObjects[i];
                if (step == diartStep) {
                }else{
                    step.number = @(num);
                    num++;
                }
            }
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}








@end
