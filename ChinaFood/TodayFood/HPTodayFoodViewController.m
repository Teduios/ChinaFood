//
//  HPTodayFoodViewController.m
//  全民菜谱
//
//  Created by tarena on 16/1/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPTodayFoodViewController.h"
#import "Masonry.h"
#import "HPCookBookCategoryManager.h"
#import "UIImageView+WebCache.h"
#import "HPCookBook.h"
#import "UIButton+WebCache.h"
#import "HPMethodViewController.h"
#import "RMPZoomTransitionAnimator.h"
#import "MBProgressHUD+KR.h"
@interface HPTodayFoodViewController ()<RMPZoomTransitionAnimating, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) NSMutableArray *books;
@property (nonatomic, strong) HPCookBook *cookBook;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation HPTodayFoodViewController

#pragma mark - 懒加载

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}


//content 里面的5个滚动视图数组
-(NSMutableArray *)views{
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

// api请求
- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];

    }
    return _manager;
}

- (NSMutableArray *)books{
    if (!_books) {
        _books = [NSMutableArray array];
    }
    return _books;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
        [self.view addSubview:_scrollView];
        // masonry 第三方框架，主要用途布局
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsMake(20, 0, 0, 0));
            make.bottom.mas_equalTo(-49);
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            UIView *lastView = nil;
            for (int i = 0; i < 5; i ++) {
                UIView *View = [[UIImageView alloc] init];
                View.userInteractionEnabled = YES;
                [_scrollView addSubview:View];
                [View mas_makeConstraints:^(MASConstraintMaker *make) {
                    //视图大小等同于_scrollView大小
                    make.size.mas_equalTo(_scrollView);
                    make.top.bottom.mas_equalTo(0);
                    //第一个视图居左_scrollView 距离0
                    if (i == 0) {
                        make.left.mas_equalTo(_scrollView);
                    }else{
                        //其他的居于上一个view 的右边 距离0
                        make.left.mas_equalTo(lastView.mas_right).mas_equalTo(0);
                        if (i == 5 - 1) {
                            //最后一个  增加居右属性_scrollView 为0
                            make.right.mas_equalTo(_scrollView).mas_equalTo(0);
                        }
                    }
                    //这里暂时不知道什么用，把这些视图都加到视图数组中
                [self.views addObject:View];
                }];
                //定义lastView,用于布局
                lastView = View;

            }
        }];
        
        
    }
    
    return _scrollView;
}

//把状态栏调整成白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //第三方框架 那个旋转的加载圆圈
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    //为什么这里是NO
    self.scrollView.hidden = NO;
    
    //写了一个类方法 取今天的日期 格式为 MMdd  例如2月4号 0204
    NSString *dateString = [self getCurrentDate];
    //数据持久化
    NSString *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    NSLog(@"date =  %@", date);
    if ([date isEqualToString:dateString] && [[NSUserDefaults standardUserDefaults] objectForKey:@"books"]) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"books"];
        NSMutableArray *mutablearray = [NSMutableArray array];
        for (NSData *data in array) {
            HPCookBook *book = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [mutablearray addObject:book];
        }
        self.books = [mutablearray copy];
        [self setUpButoon];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"date"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self callDataWithNum:arc4random()%17758 + 1];
    }
}



/**
 *  @param userName 用户名
 *
 *  @return 作用
 */
- (void)callDataWithNum:(int)i{
        NSString *str = [NSString stringWithFormat:@"http://apicloud.mob.com/v1/cook/menu/query?key=e041e9719d00&id=001000100700000%05d",i];
        [self.manager GET:str parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                NSDictionary *dict = responseObject[@"result"];
                NSLog(@"%@",[NSThread currentThread]);
            self.cookBook = [HPCookBookCategoryManager getCookBookWithDict:dict];
            if (self.cookBook.recipe.img.length > 0) {
                
                [self.books addObject:self.cookBook];
                
                if (self.books.count < 5) {
                    [self callDataWithNum:arc4random()%17758 + 1];
                }else{
                    //NSLog(@"%@", self.books);
                    //存储今天的图片
                    NSArray *todaybooks = self.books;
                    NSMutableArray *array = [NSMutableArray array];
                    for (HPCookBook *book in                         todaybooks) {
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:book];
                        [array addObject:data];
                    }
                    NSArray *books = [array copy];
                    [[NSUserDefaults standardUserDefaults] setObject:books forKey:@"books"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self setUpButoon];
                }
            }else{
                [self callDataWithNum:arc4random()%17758 + 1];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}

- (void)setUpButoon{
    [self.HUD hide:YES];
    for (int i = 0; i < 5; i ++) {
        UIView *view = self.views[i];
        self.cookBook = self.books[i];
        NSString *url = self.cookBook.recipe.img;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenHighlighted = NO;
        btn.tag = i;
        if (self.buttons.count < 5) {
            [self.buttons addObject:btn];
        }
        
        if (i == 0) {
            self.navigationItem.title = self.cookBook.name;
        }
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
    }

}

- (NSString *)getCurrentDate{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate date];
    NSString *dateString = [dateformatter stringFromDate:date];
    NSLog(@"日期dateString = %@", dateString);
    return dateString;
    

}

- (void)clickButton: (UIButton *)sender{
    NSLog(@"%@",@"ads");
    HPCookBook *book = self.books[sender.tag];
    HPMethodViewController *methodViewController = [[HPMethodViewController alloc] init];
    methodViewController.book = book;
    [self.navigationController pushViewController:methodViewController animated:YES];
    
}

#pragma mark - <RMPZoomTransitionAnimating>

- (UIImageView *)transitionSourceImageView
{
    CGFloat x = self.scrollView.contentOffset.x;
    int page = x / kScreenWidth;
    NSLog(@"%d",page);
    UIButton *btn = nil;
    switch (page) {
        case 0:
            btn = self.buttons[0];
            break;
        case 1:
            btn = self.buttons[1];
            break;
        case 2:
            btn = self.buttons[2];
            break;
        case 3:
            btn = self.buttons[3];
            break;
        case 4:
            btn = self.buttons[4];
            break;
        default:
            break;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:btn.currentBackgroundImage];
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = NO;
    imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return imageView;
}

- (UIColor *)transitionSourceBackgroundColor
{
    return self.view.backgroundColor;
}

- (CGRect)transitionDestinationImageViewFrame
{
    CGFloat x = self.scrollView.contentOffset.x;
    int page = x / kScreenWidth;
    UIButton *btn = nil;
    switch (page) {
        case 0:
            btn = self.buttons[0];
            break;
        case 1:
            btn = self.buttons[1];
        case 2:
            btn = self.buttons[2];
        case 3:
            btn = self.buttons[3];
        case 4:
            btn = self.buttons[4];
        default:
            break;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:btn.currentBackgroundImage];
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = NO;
    imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return imageView.frame;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = self.scrollView.contentOffset.x;
    int page = x / kScreenWidth;
    switch (page) {
        case 0:{
            HPCookBook *book = self.books[0];
            self.navigationItem.title = book.name;
        }
            break;
        case 1:{
            HPCookBook *book = self.books[1];
            self.navigationItem.title = book.name;
        }
            break;
        case 2:{
            HPCookBook *book = self.books[2];
            self.navigationItem.title = book.name;
        }
            break;
        case 3:{
            HPCookBook *book = self.books[3];
            self.navigationItem.title = book.name;
        }
            break;
        case 4:{
            HPCookBook *book = self.books[4];
            self.navigationItem.title = book.name;
        }
            break;
        default:
            break;
    }
}


@end
