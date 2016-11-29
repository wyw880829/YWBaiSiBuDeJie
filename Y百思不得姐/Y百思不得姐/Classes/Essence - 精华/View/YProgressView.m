//
//  YProgressView.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/31.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YProgressView.h"

@implementation YProgressView

- (void)awakeFromNib
{
    self.roundedCorners = 2;
    
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:YES];
     
    NSString *text = [NSString stringWithFormat:@"%.0f%%",progress*100];
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.progressLabel.text = text;
}

@end
