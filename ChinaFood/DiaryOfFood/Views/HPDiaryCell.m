//
//  HPDiaryCell.m
//  全民菜谱
//
//  Created by tarena on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPDiaryCell.h"
@interface HPDiaryCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodBookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;

@end

@implementation HPDiaryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBook:(HPDiaryCookBook *)book{
    _book = book;
    self.dateLabel.text = book.date;
    self.timeLabel.text = book.time;
    self.foodBookImageView.image = [UIImage imageWithData:book.image];
    self.foodBookNameLabel.text = book.name;
    self.experienceLabel.text = book.sumary;
}

@end
