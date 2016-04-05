//
//  HPTextView.m
//  全民菜谱
//
//  Created by tarena on 16/1/19.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPTextView.h"
@interface HPTextView()
@property (nonatomic, weak) UILabel *placeholderLabel;
@end


@implementation HPTextView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:242.0 / 255 green:242.0 / 255 blue:242.0 / 255 alpha:1.0];
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        self.myPlaceholderColor = [UIColor lightGrayColor];
        self.font = [UIFont systemFontOfSize:12];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textDidChange{
    self.placeholderLabel.hidden = self.hasText;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.placeholderLabel.y = 8;
    self.placeholderLabel.x = 5;
    self.placeholderLabel.width = self.width - self.placeholderLabel.x * 2.0; //设置UILabel的x
    
    CGSize maxSize = CGSizeMake(self.placeholderLabel.width, MAXFLOAT);
    self.placeholderLabel.height = [self.myPlaceholder boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
}

- (void)setMyPlaceholder:(NSString *)myPlaceholder{
    _myPlaceholder = [myPlaceholder copy];
    self.placeholderLabel.text = myPlaceholder;
    [self setNeedsLayout];
}

- (void)setMyPlaceholderColor:(UIColor *)myPlaceholderColor{
    _myPlaceholderColor = myPlaceholderColor;
    self.placeholderLabel.textColor = myPlaceholderColor;
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}
@end
