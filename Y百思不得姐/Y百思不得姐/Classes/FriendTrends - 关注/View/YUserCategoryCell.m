//
//  YUserCategoryCell.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/16.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YUserCategoryCell.h"
#import "UIImageView+WebCache.h"

@interface YUserCategoryCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNamelable;
@property (weak, nonatomic) IBOutlet UILabel *fans_countLable;

@end

@implementation YUserCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUser:(YUser *)user
{
    _user = user;
    
    // 头像
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    // 昵称
    self.screenNamelable.text = user.screen_name;
    
    if (user.fans_count > 10000) {
        self.fans_countLable.text = [NSString stringWithFormat:@"%0.1f万人",user.fans_count/10000.0];
    } else {
        self.fans_countLable.text = [NSString stringWithFormat:@"%zd人",user.fans_count];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
