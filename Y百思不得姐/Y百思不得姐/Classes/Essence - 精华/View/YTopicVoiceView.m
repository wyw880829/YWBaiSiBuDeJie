//
//  YTopicVoiceView.m
//  Y百思不得姐
//
//  Created by wyw on 16/6/13.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YTopicVoiceView.h"
#import "UIImageView+WebCache.h"

@interface YTopicVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *countLable;
@end


@implementation YTopicVoiceView


- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(YTopic *)topic
{
    _topic = topic;
    
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    // 点击数
    CGFloat count = topic.playcount;
    if (count > 10000) {
       self.countLable.text = [NSString stringWithFormat:@"%0.1f万播放",count / 10000];
    } else {
       self.countLable.text = [NSString stringWithFormat:@"%f播放",count];
    }
    
    //时间
    NSInteger min = topic.voicetime / 60;
    NSInteger sec = topic.voicetime % 60;
    self.timeLable.text = [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
}

@end
