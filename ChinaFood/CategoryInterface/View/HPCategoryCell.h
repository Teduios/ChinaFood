//
//  HPCategoryCell.h
//  全民菜谱
//
//  Created by tarena on 16/1/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPCategoryFrame;
@interface HPCategoryCell : UITableViewCell
@property (nonatomic, strong) HPCategoryFrame *categoryFrame;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, assign) NSInteger imageNum;
@property (nonatomic, strong) UIViewController *categoryController;
@end
