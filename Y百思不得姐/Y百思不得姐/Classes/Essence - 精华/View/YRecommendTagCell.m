//
//  YRecommendTagCell.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/17.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YRecommendTagCell.h"
#import "UIImageView+WebCache.h"

@interface YRecommendTagCell()

@property (weak, nonatomic) IBOutlet UIImageView *Image_listImageView;

@property (weak, nonatomic) IBOutlet UILabel *theme_nameLable;

@property (weak, nonatomic) IBOutlet UILabel *sub_numberLabel;

@end

@implementation YRecommendTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// set数据
- (void)setRecommendTag:(YRecommendTag *)recommendTag
{
    _recommendTag = recommendTag;
    
    // 添加数据
    [self.Image_listImageView sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list]];
    self.theme_nameLable.text = recommendTag.theme_name;
    
    if (recommendTag.sub_number > 10000) {
        self.sub_numberLabel.text = [NSString stringWithFormat:@"%0.1f万人",recommendTag.sub_number/10000.0];
    } else {
        self.sub_numberLabel.text = [NSString stringWithFormat:@"%zd人",recommendTag.sub_number];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
