//
//  YTagButton.m
//  Y百思不得姐
//
//  Created by wyw on 16/7/6.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YTagButton.h"

@implementation YTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame: frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = YTagBG;
        self.titleLabel.font = YTagFont;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
    
    self.width += 3*YTagMargin;
    self.height = YTagH;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.x = YTagMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + YTagMargin;
}

@end
