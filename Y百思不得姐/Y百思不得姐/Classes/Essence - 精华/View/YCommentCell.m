//
//  YCommentCell.m
//  Y百思不得姐
//
//  Created by wyw on 16/6/28.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YCommentCell.h"
#import "UIImageView+WebCache.h"
#import "YComment.h"
#import "YCommentUser.h"

@interface YCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLable;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end

@implementation YCommentCell

- (void)setComment:(YComment *)comment
{
    
    _comment = comment;
    // 设置头像
    UIImage *placeholderImage = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.profileImageView.image = image ? [image circleImage] : placeholderImage;
    }];
    // 用户名
    self.usernameLable.text = comment.user.username;
    // 评论
    self.contentLable.text = comment.content;
    // 点赞数量
    self.likeCountLable.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    // 性别
    self.sexView.image = [comment.user.sex isEqualToString:YCellTopcmtUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    // 语音评论
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
        self.contentLable.hidden = YES;
    } else {
        self.voiceButton.hidden = YES;
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = YCellMargin;
    frame.size.width -= 2*YCellMargin;
    
    [super setFrame:frame];
}

- (void)awakeFromNib
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = imageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
