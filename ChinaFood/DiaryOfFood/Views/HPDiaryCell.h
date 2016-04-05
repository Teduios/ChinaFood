//
//  HPDiaryCell.h
//  全民菜谱
//
//  Created by tarena on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPDiaryCookBook.h"
@interface HPDiaryCell : UITableViewCell
@property (nonatomic, strong) HPDiaryCookBook *book;
@property (weak, nonatomic) IBOutlet UIImageView *foodBookImageView;
@end
