//
//  HPCategoryViewController.m
//  全民菜谱
//
//  Created by tarena on 16/1/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPCategoryViewController.h"
#import "HPCookBookCategoryManager.h"
#import "HPCategoryCell.h"
#import "HPCategoryFrame.h"
#import "UIView+DCAnimationKit.h"
@interface HPCategoryViewController ()<UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate>
@property (nonatomic, strong) NSArray *allCatrgories;
@property (nonatomic, weak) UITableView *tableview;
@property (nonatomic, strong) NSArray *categoryFrames;
@end

@implementation HPCategoryViewController

- (NSArray *)categoryFrames{
    if (!_categoryFrames) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSArray *category in self.allCatrgories) {
            HPCategoryFrame *frame = [[HPCategoryFrame alloc] init];
            frame.categories = category;
            [mutableArray addObject:frame];
        }
        _categoryFrames = [mutableArray copy];
    }
    return _categoryFrames;
}

-(NSArray *)allCatrgories{
    if (!_allCatrgories) {
        _allCatrgories = [HPCookBookCategoryManager getAllCategory];
    }
    return _allCatrgories;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    
    self.tabBarController.delegate = self;
    [self.tableview expandIntoView:self.view finished:NULL];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerClass:[HPCategoryCell class] forCellReuseIdentifier:@"cell"];
    
}



- (void)setUpTableView{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor blackColor];
    self.tableview = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-49);
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categoryFrames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HPCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.label removeFromSuperview];
    [cell.view removeFromSuperview];
    HPCategoryFrame *frame = self.categoryFrames[indexPath.row];
    cell.imageNum = indexPath.row;
    cell.categoryFrame = frame;
    if (!cell.categoryController) {
        cell.categoryController = self;
    }
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HPCategoryFrame *frame = self.categoryFrames[indexPath.row];
    CGFloat height = frame.cellFrame.size.height;
    return height;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[HPCategoryViewController class]]) {
        [self.tableview expandIntoView:self.view finished:NULL];
    }
}





@end
