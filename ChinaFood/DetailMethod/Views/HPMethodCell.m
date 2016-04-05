//
//  HPMethodCell.m
//  全民菜谱
//
//  Created by tarena on 16/1/12.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HPMethodCell.h"
#import "UIImageView+WebCache.h"
#import "HPMethod.h"
#import "HPMethodCellFrame.h"
@interface HPMethodCell()
@property (nonatomic, strong) UIImageView *methodImage;
@property (nonatomic, strong) UILabel *methodLabel;
@end

@implementation HPMethodCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.methodImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.methodImage];
        
        self.methodLabel = [[UILabel alloc] init];
        self.methodLabel.font = [UIFont systemFontOfSize: 12];
        self.methodLabel.numberOfLines = 0;
        [self.contentView addSubview:self.methodLabel];
    }
    return self;
}

-(void)setMethodCellframe:(HPMethodCellFrame *)methodCellframe{
    _methodCellframe = methodCellframe;
    HPMethod *method = self.methodCellframe.method;
    if (method.img) {
        [self.methodImage sd_setImageWithURL:[NSURL URLWithString:method.img]];
    }else if(method.imageData){
        self.methodImage.image = [UIImage imageWithData:method.imageData];
    }
    self.methodImage.frame = _methodCellframe.imgFrame;
    
    self.methodLabel.text = method.step;
    self.methodLabel.frame = _methodCellframe.labelFrame;
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
}




@end
