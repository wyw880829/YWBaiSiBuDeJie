//
//  YMeCell.m
//  Y百思不得姐
//
//  Created by wyw on 16/7/4.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YMeCell.h"

@implementation YMeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgView;
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:19];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.image == nil) return;
    
    self.imageView.width = 30;
    self.imageView.height = self.imageView.width;
    self.imageView.centerY = self.contentView.frame.size.height * 0.5;
    
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + YCellMargin;
    
}

@end
