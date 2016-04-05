//
//  HPSumaryCell.m
//  全民菜谱
//
//  Created by tarena on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPSumaryCell.h"

@interface HPSumaryCell()<UITextViewDelegate>

@end

@implementation HPSumaryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textView = [[HPTextView alloc] init];
        self.textView.delegate = self;
        self.textView.myPlaceholder = @"填写这道菜的简介(最多500字)";
        self.textView.myPlaceholderColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.textView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textView.frame = CGRectMake(10, 10, kScreenWidth - 20, 60);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (self.textView == textView)
    {
        if ([toBeString length] > 500) {
            textView.text = [toBeString substringToIndex:500];
            return NO;
        }
    }
    return YES;

}
@end
