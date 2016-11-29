//
//  YTopicCell.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/25.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YTopicCell.h"
#import "UIImageView+WebCache.h"
#import "YTopicPictureView.h"
#import "YTopicVoiceView.h"
#import "YTopicVideoView.h"
#import "YCommentUser.h"
#import "YComment.h"

@interface YTopicCell()

/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 文字 */
@property (weak, nonatomic) IBOutlet UILabel *text_Label;

/** 最热评论view */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
/** 最热评论Lable */
@property (weak, nonatomic) IBOutlet UILabel *topCmtLable;

/** 图片view */
@property (weak, nonatomic) YTopicPictureView *pictureView;
/** 声音view */
@property (weak, nonatomic) YTopicVoiceView *voiceView;
/** 视频view */
@property (weak, nonatomic) YTopicVideoView *videoView;



@end

@implementation YTopicCell

#pragma mark - lazy 
- (YTopicPictureView *)pictureView
{
    if (!_pictureView) {
        YTopicPictureView *pictureView = [YTopicPictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (YTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        YTopicVoiceView *voiceView = [YTopicVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (YTopicVideoView *)videoView
{
    if (!_videoView) {
        YTopicVideoView *videoView = [YTopicVideoView viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}


- (void)awakeFromNib
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = imageView;
}

// 设置数据
- (void)setTopic:(YTopic *)topic
{
    _topic = topic;

    // 设置头像
    UIImage *placeholderImage = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.profileImageView.image = image ? [image circleImage] : placeholderImage;
    }];
    self.nameLabel.text = topic.name;
    
    // 设置时间
    self.createTimeLabel.text = topic.create_time;
    
    // 设置按钮
    [self setupButton:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setupButton:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setupButton:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setupButton:self.commentButton count:topic.comment placeholder:@"评论"];
    
    // 设置文字
    self.text_Label.text = topic.text;
    
    // 类型
    if (topic.type == YTopicPicture) {
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureF;
        
        self.pictureView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        
    }  else if (topic.type == YTopicVoice) {
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceF;
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.videoView.hidden = YES;
        
    } else if (topic.type == YTopicVideo) {
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoF;
        
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        
    } else {
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    // 最热评论
    YComment *topCmt = topic.top_cmt.firstObject;
    if (topCmt) { // 假如最热评论存在
        self.topCmtView.hidden = NO;
        self.topCmtLable.text = [NSString stringWithFormat:@"%@ : %@",topCmt.user.username,topCmt.content];
        
    } else {    // 最热评论不存在
        self.topCmtView.hidden = YES;
    }
    
}

/**
 *  设置按钮上的文字
 */
- (void)setupButton:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder
{
    if (count > 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万",count/10000.0] forState:UIControlStateNormal];
    } else if (count < 10000 && count > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd",count] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

/**
 *  重写尺寸
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.x    = YCellMargin;
    frame.size.width  -= 2*YCellMargin;
    frame.size.height = self.topic.cellHeight - YCellMargin;
    frame.origin.y    += YCellMargin;

    [super setFrame:frame];
}


@end
