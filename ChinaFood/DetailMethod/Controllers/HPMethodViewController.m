//
//  HPMethodViewController.m
//  全民菜谱
//
//  Created by tarena on 16/1/11.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPMethodViewController.h"
#import "HPCookBook.h"
#import "RMPZoomTransitionAnimator.h"
#import "HPMethodCell.h"
#import "HPMethodCellFrame.h"
#import "HPIngredientsFrame.h"
#import "HPIngredientsCell.h"

#define kImageViewH 220
#define kSpace 10
#define kNameLabelH 44
@interface HPMethodViewController ()<UITableViewDelegate, UITableViewDataSource, RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeadView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray *frames;
@property (nonatomic, strong) NSArray *ingredientsFrames;
@end

@implementation HPMethodViewController

- (NSArray *)ingredientsFrames{
    if (!_ingredientsFrames) {
        _ingredientsFrames = [NSArray array];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSString *ingredinet in self.book.recipe.ingredients){
            HPIngredientsFrame *frame = [[HPIngredientsFrame alloc] init] ;
            frame.ingredinet = ingredinet;
            NSLog(@"textFrame %@", NSStringFromCGRect(frame.textFrame));
            [mutableArray addObject:frame];
        }
        _ingredientsFrames = [mutableArray copy];
    }
    return _ingredientsFrames;
}

- (NSArray *)frames{
    if (!_frames) {
        _frames = [NSArray array];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (HPMethod *method in self.book.recipe.method) {
            HPMethodCellFrame *frame = [[HPMethodCellFrame alloc] init];
            frame.method = method;
            NSLog(@"%@",frame);
            [mutableArray addObject:frame];
        }
        _frames = [mutableArray copy];
        
    }
    return _frames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpHeadView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void) setUpTableView{
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.tableView];
  
}

- (void) setUpHeadView{

    self.tableHeadView = [[UIView alloc] init];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kImageViewH)];
    [self.tableHeadView addSubview:self.imageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kImageViewH + kSpace, kScreenWidth, kNameLabelH)];
    nameLabel.text = self.book.name;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableHeadView addSubview:nameLabel];
    
    UILabel *sumaryLabel = [[UILabel alloc] init];
    sumaryLabel.numberOfLines = 0;
    CGSize sumaryLabelSize = [self.book.recipe.sumary boundingRectWithSize:CGSizeMake(kScreenWidth - 2 * kSpace, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]} context:nil].size;
    sumaryLabel.font = [UIFont systemFontOfSize:13];
    sumaryLabel.frame = CGRectMake(kSpace, CGRectGetMaxY(nameLabel.frame) + kSpace , sumaryLabelSize.width, sumaryLabelSize.height );
    sumaryLabel.text = self.book.recipe.sumary;
    [self.tableHeadView addSubview:sumaryLabel];
    self.tableHeadView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(sumaryLabel.frame) + 10);
    [self.tableView setTableHeaderView:self.tableHeadView];
    
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.ingredientsFrames.count;
    }else{
    
        return self.frames.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HPIngredientsCell *ingredientsCell = [tableView dequeueReusableCellWithIdentifier:@"ingredientsCell"];
        if (ingredientsCell == nil) {
            ingredientsCell = [[HPIngredientsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ingredientsCell"];
        }
        ingredientsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        HPIngredientsFrame *ingredientsFrame = self.ingredientsFrames[indexPath.row];
        ingredientsCell.ingredientFrame = ingredientsFrame;
        return ingredientsCell;
    }else{
    
        HPMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[HPMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        HPMethodCellFrame *frame = self.frames[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.methodCellframe = frame;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HPIngredientsFrame *frame = self.ingredientsFrames[indexPath.row];
        return frame.cellFrame.size.height;
    }else{
        HPMethodCellFrame *frame = self.frames[indexPath.row];
        return frame.cellFrame.size.height;
    
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"食材";
    }else{
        return @"做法";
    }
}




- (UIView *)getSeparator{
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor blackColor];
    separator.alpha = 0.5;
    return separator;
}

#pragma mark - <RMPZoomTransitionAnimating>

- (UIImageView *)transitionSourceImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imageView.image];
    imageView.contentMode = self.imageView.contentMode;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = NO;
    imageView.frame = CGRectMake(0, 64, kScreenWidth, 220);
    return imageView;
}

- (UIColor *)transitionSourceBackgroundColor
{
    return self.view.backgroundColor;
}

- (CGRect)transitionDestinationImageViewFrame
{
    return CGRectMake(0, 64, kScreenWidth, 220);
}

#pragma mark - <RMPZoomTransitionDelegate>

- (void)zoomTransitionAnimator:(RMPZoomTransitionAnimator *)animator
         didCompleteTransition:(BOOL)didComplete
      animatingSourceImageView:(UIImageView *)imageView
{
    self.imageView.image = imageView.image;
}

@end
