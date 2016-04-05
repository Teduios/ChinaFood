//
//  HPTypeCell.h
//  全民菜谱
//
//  Created by tarena on 16/1/10.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPCookBook.h"
@interface HPTypeCell : UITableViewCell
@property (nonatomic, strong) HPCookBook *cookBook;
//@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIButton *mainButton;
@end
