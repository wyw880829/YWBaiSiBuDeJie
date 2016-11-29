//
//  YRecommendCategoryCell.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/13.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YRecommendCategoryCell.h"

@interface YRecommendCategoryCell()

@property (weak, nonatomic) IBOutlet UIView *selectecIndicator;

@end

@implementation YRecommendCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setCategory:(YCategory *)category
{
    _category = category;
    self.textLabel.text = category.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 4;
}

// 选中当前cell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // 改变指示器的显示
    self.selectecIndicator.hidden = !selected;
    // 改变文字颜色
    self.textLabel.textColor = selected ? [UIColor redColor] : [UIColor blackColor];
}

@end
