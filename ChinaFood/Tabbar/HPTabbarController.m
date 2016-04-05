//
//  HPTabbarController.m
//  全民菜谱
//
//  Created by tarena on 16/1/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPTabbarController.h"
#import "HPTodayFoodViewController.h"
#import "HPCategoryViewController.h"
#import "HPNavigationController.h"
#import "HPDiaryNavigationController.h"
@interface HPTabbarController ()

@end

@implementation HPTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpItem];
    [self setUpChildVc];
}

- (void)setUpItem{
    NSMutableDictionary *normalAtrrs = [NSMutableDictionary dictionary];
    //文字颜色
    normalAtrrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UIBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAtrrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void) setUpChildVc{
    HPTodayFoodViewController *tvc = [[HPTodayFoodViewController alloc] init];
    tvc.automaticallyAdjustsScrollViewInsets = NO;
    HPNavigationController *nc = [[HPNavigationController alloc] initWithRootViewController:tvc];
    nc.tabBarItem.title = @"今日食谱";
    
    [self addChildViewController:nc];
    
    HPCategoryViewController *hvc = [[HPCategoryViewController alloc] init];
    hvc.tabBarItem.title = @"分类";
    [self addChildViewController:hvc];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DiaryOfFoodStoryboard" bundle:nil];
    HPDiaryNavigationController *dvc = storyboard.instantiateInitialViewController;
    dvc.tabBarItem.title = @"美食日记";
    [self addChildViewController:dvc];
}



@end
