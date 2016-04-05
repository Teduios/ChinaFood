//
//  HPTypeViewController.m
//  全民菜谱
//
//  Created by tarena on 16/1/10.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPTypeViewController.h"
#import "HPCookBookCategoryManager.h"
#import "HPCookBook.h"
#import "HPTypeCell.h"
#import "HPMethodViewController.h"
#import "RMPZoomTransitionAnimator.h"
#import "MBProgressHUD+KR.h"
@interface HPTypeViewController ()<UITableViewDelegate, UITableViewDataSource, RMPZoomTransitionAnimating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allBooks;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation HPTypeViewController

- (NSMutableArray *)allBooks{
    if (!_allBooks) {
        _allBooks = [NSMutableArray array];
    }
    return _allBooks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.page = 1;
    [self setUpNavigation];
    [self setUpTableView];
    [self.tableView addSubview:self.HUD];
    [self.HUD show:self.tableView];
    [self.tableView registerClass:[HPTypeCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self askForData];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

-(AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (void)viewWillAppear:(BOOL)animated{
//    NSString *url = [NSString stringWithFormat:@"http://apicloud.mob.com/v1/cook/menu/search?key=e041e9719d00&cid=%@&page=1&size=20", self.ctgId];
//    NSLog(@"%@", url);
//    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
//        NSArray *lists = responseObject[@"result"][@"list"];
//        for (NSDictionary *list in lists) {
//            HPCookBook *book = [HPCookBookCategoryManager getCookBookWithDict:list];
//            if(book.recipe.img){
//                [self.allBooks addObject:book];
//            }
//        }
//        [self.tableView reloadData];
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"error %@", error.userInfo);
//    }];
    [self askForData];
}

- (void)askForData{
    NSString *url = [NSString stringWithFormat:@"http://apicloud.mob.com/v1/cook/menu/search?key=e041e9719d00&cid=%@&page=%ld&size=20",self.ctgId, self.page];
    NSLog(@"%@", url);
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
        NSArray *lists = responseObject[@"result"][@"list"];
        for (NSDictionary *list in lists) {
            HPCookBook *book = [HPCookBookCategoryManager getCookBookWithDict:list];
            if(book.recipe.img){
                [self.allBooks addObject:book];
            }
        }
        self.page += 1;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error %@", error.userInfo);
    }];
    

}

- (void) setUpNavigation{
    self.navigationItem.title = self.title;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickBackItem)];
}

- (void)clickBackItem{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setUpTableView{
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allBooks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HPTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HPCookBook *cookBook = self.allBooks[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cookBook = cookBook;
    if (![self.HUD isHidden]) {
        [self.HUD hide:YES];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 244;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HPMethodViewController *methodViewController = [[HPMethodViewController alloc] init];
    HPCookBook *cookBook = self.allBooks[indexPath.row];
    methodViewController.book = cookBook;
    
    [self.navigationController pushViewController:methodViewController animated:YES];
}

- (UIImageView *)transitionSourceImageView
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    HPTypeCell *cell = (HPTypeCell *)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:cell.mainButton.currentBackgroundImage];
    imageView.contentMode = cell.mainButton.contentMode;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = NO;
    CGRect frameInSuperview = [cell.mainButton convertRect:cell.mainButton.frame toView:self.tableView.superview];
    frameInSuperview.origin.x -= cell.layoutMargins.left;
    frameInSuperview.origin.y -= cell.layoutMargins.top;
    imageView.frame = frameInSuperview;
    NSLog(@"image%@", NSStringFromCGRect(imageView.frame));
    return imageView;
}

- (UIColor *)transitionSourceBackgroundColor
{
    return self.tableView.backgroundColor;
}

- (CGRect)transitionDestinationImageViewFrame
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    HPTypeCell *cell = (HPTypeCell *)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
    CGRect frameInSuperview = [cell.mainButton convertRect:cell.mainButton.frame toView:self.tableView.superview];
    frameInSuperview.origin.x -= cell.layoutMargins.left;
    frameInSuperview.origin.y -= cell.layoutMargins.top;
    NSLog(@"super%@",NSStringFromCGRect(frameInSuperview));
    return frameInSuperview;
}
@end
