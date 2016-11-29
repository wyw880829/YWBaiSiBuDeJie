//
//  YTopicPictureView.m
//  Y百思不得姐
//
//  Created by wyw on 16/5/31.
//  Copyright © 2016年 qw. All rights reserved.
//

#import "YTopicPictureView.h"
#import "UIImageView+WebCache.h"
#import "YProgressView.h"
#import "YShowPictureViewController.h"

@interface YTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;

@property (weak, nonatomic) IBOutlet YProgressView *progressView;

@end

@implementation YTopicPictureView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.progressView.hidden = YES;
    // 给imageview添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
}

- (void)showPicture
{
    YShowPictureViewController *showPictureVC = [[YShowPictureViewController alloc] init];
    showPictureVC.topic = self.topic;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPictureVC animated:YES completion:nil];
}


- (void)setTopic:(YTopic *)topic
{
    _topic = topic;
    
    // 显示progress值（防止由于网速慢而显示其他图片的下载进度）
    [self.progressView setProgress:topic.pictureProgress animated:NO];
    
    // 获得扩展名
    NSString *imageExtension = [topic.large_image pathExtension];
    self.gifView.hidden = ![imageExtension.lowercaseString isEqualToString:@"gif"];
    self.seeBigButton.hidden = YES;
    // 显示放大按钮
    if (topic.largePicture) {
        self.seeBigButton.hidden = NO;
        
        // 处理过大后的图片
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
    } else {
        self.seeBigButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    // 下载图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:topic.pictureProgress animated:NO];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
        if (!self.topic.isLargePicture) return;
        
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureF.size, YES, 0);
        
        // 设置尺寸
        CGFloat width = topic.pictureF.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        // 获取图形上下文
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 关闭图形上下文
        UIGraphicsEndImageContext();  
    }];
}


@end
