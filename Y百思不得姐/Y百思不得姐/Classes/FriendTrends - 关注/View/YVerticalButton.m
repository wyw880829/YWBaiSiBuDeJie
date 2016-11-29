//
//  YVerticalButton.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/17.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YVerticalButton.h"

@implementation YVerticalButton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    // 调整图片
//    self.imageView.x = 0;
//    self.imageView.y = 0;
//
//    // 调整文字
//    self.titleLabel.x = 0;
//    self.titleLabel.y = self.imageView.height;
//    self.titleLabel.width = self.width;
//    self.titleLabel.height = self.height - self.titleLabel.y;
//}

@end
