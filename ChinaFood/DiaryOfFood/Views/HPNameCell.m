//
//  HPNameCell.m
//  全民菜谱
//
//  Created by tarena on 16/1/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPNameCell.h"
@interface HPNameCell()

@end
@implementation HPNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textField = [[UITextField alloc] init];
//        self.textField.delegate = self;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:self.textField];
        self.textField.placeholder = @"请输入菜谱名(最多15字)";
        NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor grayColor]};
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.textField.placeholder attributes:attrs];

        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textField.frame = CGRectMake(10, 0, kScreenWidth, 44);
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//{
//    if ([string isEqualToString:@"\n"])
//    {
//        return YES;
//    }
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    
//    if (self.textField == textField)
//    {
//        if ([toBeString length] > 15) {
//            textField.text = [toBeString substringToIndex:15];
//            return NO;
//        }
//    }
//    return YES;
//}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 15) {
                textField.text = [toBeString substringToIndex:15];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 15) {
            textField.text = [toBeString substringToIndex:15];
        }  
    }  
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.textField];
}

@end
