//
//  YTagTextField.m
//  Y百思不得姐
//
//  Created by wyw on 16/7/8.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YTagTextField.h"

@implementation YTagTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
       self.placeholder = @"多个标签用逗号或换行隔开";
    }
    return self;
}

- (void)deleteBackward
{
    !self.deleteBlock ? : self.deleteBlock();
    [super deleteBackward];
}

@end
